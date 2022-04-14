//import SwiftUI
//import CoreLocation
//
//extension Settings {
//    struct Location: View {
//        @Binding var presented: Bool
//        
//        var body: some View {
//            Section("Location") {
////                Text(Copy.location)
////                    .font(.footnote)
////                    .foregroundStyle(.secondary)
////                    .padding(.vertical)
////                    .allowsHitTesting(false)
//                Action(title: "Open Settings", symbol: location ? "location" : "location.slash") {
//                    presented = false
//                    UIApplication.shared.settings()
//                }
//            }
//            .headerProminence(.increased)
//        }
//        
//        private var location: Bool {
//            CLLocationManager().authorizationStatus == .authorizedWhenInUse
//        }
//    }
//}
