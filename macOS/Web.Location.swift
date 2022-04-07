import Foundation
import WebKit
import CoreLocation
import Specs

extension Web {
    final class Location: NSObject, WKScriptMessageHandlerWithReply, CLLocationManagerDelegate {
        private var location: CLLocation?
        private var handler: ((Any?, String?) -> Void)?
        private var manager: CLLocationManager?
        
        func userContentController(_: WKUserContentController, didReceive: WKScriptMessage, replyHandler: @escaping (Any?, String?) -> Void) {
            handler = replyHandler
            
            if manager == nil {
                manager = .init()
                manager!.delegate = self
            }
            
            manager!.requestLocation()
            
            guard didReceive.name == Script.location.method else {
                fail()
                return
            }
            
            if let location = location {
                send(location: location)
            }
        }
        
        func locationManager(_: CLLocationManager, didUpdateLocations: [CLLocation]) {
            if let location = didUpdateLocations.first {
                self.location = location
                send(location: location)
            }
        }
        
        func locationManager(_: CLLocationManager, didFailWithError: Error) {
            fail()
        }
        
        func locationManagerDidChangeAuthorization(_: CLLocationManager) {
            switch manager?.authorizationStatus {
            case .notDetermined:
                manager?.requestLocation()
            case .denied, .restricted:
                fail()
            default:
                break
            }
        }
        
        private func fail() {
            handler?(nil, "Not allowed")
            handler = nil
            manager = nil
        }
        
        private func send(location: CLLocation) {
            handler?([location.coordinate.latitude,
                      location.coordinate.longitude,
                      location.horizontalAccuracy], nil)
            handler = nil
            manager = nil
        }
    }
}
