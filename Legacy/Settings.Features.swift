//import SwiftUI
//
//extension Settings {
//    struct Features: View {
//        @State private var dark = true
//        @State private var popups = true
//        @State private var ads = true
//        @State private var screen = true
//        
//        var body: some View {
//            Section("Features") {
//                Toggle("Force dark mode", isOn: $dark)
//                Toggle("Block pop-ups", isOn: $popups)
//                Toggle("Remove ads", isOn: $ads)
//                Toggle("Remove screen blockers", isOn: $screen)
//            }
//            .headerProminence(.increased)
//            .onChange(of: dark) { update in
//                Task
//                    .detached(priority: .utility) {
//                        await cloud.update(dark: update)
//                    }
//            }
//            .onChange(of: popups) { update in
//                Task
//                    .detached(priority: .utility) {
//                        await cloud.update(popups: !update)
//                    }
//            }
//            .onChange(of: ads) { update in
//                Task
//                    .detached(priority: .utility) {
//                        await cloud.update(ads: !update)
//                    }
//            }
//            .onChange(of: screen) { update in
//                Task
//                    .detached(priority: .utility) {
//                        await cloud.update(screen: !update)
//                    }
//            }
//            .onReceive(cloud) {
//                dark = $0.settings.configuration.dark
//                popups = !$0.settings.configuration.popups
//                ads = !$0.settings.configuration.ads
//                screen = !$0.settings.configuration.screen
//            }
//        }
//    }
//}
