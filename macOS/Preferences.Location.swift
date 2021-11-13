import AppKit
import Combine
import CoreLocation

extension Preferences {
    final class Location: NSTabViewItem, CLLocationManagerDelegate {
        private var subs = Set<AnyCancellable>()
        private var status = CLAuthorizationStatus.notDetermined
        private weak var option: Option!
        private weak var badge: Image!
        private let manager = CLLocationManager()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init(identifier: "")
            label = "Location"
            
            manager.delegate = self
            
            var copy = (try? AttributedString(markdown: Copy.location, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace))) ?? .init(Copy.browser)
            copy.setAttributes(.init([
                .font: NSFont.preferredFont(forTextStyle: .body),
                .foregroundColor: NSColor.secondaryLabelColor]))
            
            let text = Text(vibrancy: true)
            text.textColor = .secondaryLabelColor
            text.font = .preferredFont(forTextStyle: .callout)
            text.attributedStringValue = .init(copy)
            
            let option = Preferences.Option(title: "", symbol: "location")
            option
                .click
                .sink { [weak self] in
                    guard let manager = self?.manager else { return }
                    switch manager.authorizationStatus {
                    case .notDetermined:
                        manager.requestWhenInUseAuthorization()
                    default:
                        NSWorkspace
                            .shared
                            .open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices")!)
                    }
                }
                .store(in: &subs)
            self.option = option
            
            let badge = Image(icon: "checkmark.circle.fill", vibrancy: false)
            badge.symbolConfiguration = .init(textStyle: .title1)
                .applying(.init(hierarchicalColor: .systemBlue))
            badge.isHidden = true
            self.badge = badge
            
            let stack = NSStackView(views: [text, badge, option])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.orientation = .vertical
            stack.spacing = 20
            view!.addSubview(stack)
            
            stack.topAnchor.constraint(equalTo: view!.topAnchor, constant: 30).isActive = true
            stack.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
            
            text.widthAnchor.constraint(lessThanOrEqualToConstant: 340).isActive = true
            
            status = manager.authorizationStatus
            update()
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            status = manager.authorizationStatus
            update()
        }
        
        func locationManager(_: CLLocationManager, didUpdateLocations: [CLLocation]) {

        }
        
        func locationManager(_: CLLocationManager, didFailWithError: Error) { }
        
        private func update() {
            switch status {
            case .notDetermined:
                option.text.stringValue = "Enable location"
                badge.isHidden = true
            case .authorizedAlways, .authorized, .authorizedWhenInUse:
                option.text.stringValue = "Open Settings"
                badge.isHidden = false
            default:
                option.text.stringValue = "Open Settings"
                badge.isHidden = true
            }
        }
    }
}



/*
 import AppKit
 import Combine
 import Sleuth

 extension Settings {
     final class Location: NSTabViewItem {
         private var subs = Set<AnyCancellable>()
         
         required init?(coder: NSCoder) { nil }
         override init() {
             super.init(identifier: "Location")
             label = "Location"
             
             let location = Option(title: "Location permission", image: "location")
             location
                 .click
                 .sink {
                     NSWorkspace
                         .shared
                         .open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices")!)
                 }
                 .store(in: &subs)
             view!.addSubview(location)
             
             let title = Text()
             title.font = .preferredFont(forTextStyle: .body)
             title.textColor = .secondaryLabelColor
             title.stringValue = """
 This app will never access your location, but may ask you to grant access if a website is requesting it.

 You can change this permission on System Preferences.
 """
             title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
             view!.addSubview(title)
             
             location.topAnchor.constraint(equalTo: view!.topAnchor, constant: 20).isActive = true
             location.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
             
             title.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 10).isActive = true
             title.leftAnchor.constraint(equalTo: view!.centerXAnchor, constant: -170).isActive = true
             title.rightAnchor.constraint(equalTo: view!.centerXAnchor, constant: 170).isActive = true
         }
     }
 }

 */
