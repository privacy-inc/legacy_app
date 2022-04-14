//import SwiftUI
//import Specs
//
//extension Settings {
//    struct Navigation: View {
//        @State private var engine = Specs.Search.Engine.google
//        @State private var autoplay = Specs.Settings.Configuration.Autoplay.none
//        @State private var policy = Policy.secure
//        @State private var http = false
//        @State private var cookies = false
//
//        var body: some View {
//            Section("Navigation") {
//                Text("Search engine")
//                    .font(.footnote)
//                    .foregroundStyle(.secondary)
//                    .padding(.top)
//                    .allowsHitTesting(false)
//                Picker("Search engine", selection: $engine) {
//                    Text(verbatim: "Google")
//                        .tag(Specs.Search.Engine.google)
//                        .allowsHitTesting(false)
//                    Text(verbatim: "Ecosia")
//                        .tag(Specs.Search.Engine.ecosia)
//                        .allowsHitTesting(false)
//                }
//
//                Text("Privacy level")
//                    .font(.footnote)
//                    .foregroundStyle(.secondary)
//                    .padding(.top)
//                    .allowsHitTesting(false)
//                Picker("Privacy level", selection: $policy) {
//                    Text(verbatim: "Block trackers")
//                        .tag(Policy.secure)
//                        .allowsHitTesting(false)
//                    Text(verbatim: "Standard")
//                        .tag(Policy.standard)
//                        .allowsHitTesting(false)
//                }
//
//                Text("Connection encryption")
//                    .font(.footnote)
//                    .foregroundStyle(.secondary)
//                    .padding(.top)
//                    .allowsHitTesting(false)
//                Picker("Connection encryption", selection: $http) {
//                    Text(verbatim: "Enforce https")
//                        .tag(false)
//                        .allowsHitTesting(false)
//                    Text(verbatim: "Allow http")
//                        .tag(true)
//                        .allowsHitTesting(false)
//                }
//
//                Text("Cookies")
//                    .font(.footnote)
//                    .foregroundStyle(.secondary)
//                    .padding(.top)
//                    .allowsHitTesting(false)
//                Picker("Cookies", selection: $cookies) {
//                    Text(verbatim: "Block all")
//                        .tag(false)
//                        .allowsHitTesting(false)
//                    Text(verbatim: "Accept")
//                        .tag(true)
//                        .allowsHitTesting(false)
//                }
//
//                Text("Autoplay")
//                    .font(.footnote)
//                    .foregroundStyle(.secondary)
//                    .padding(.top)
//                    .allowsHitTesting(false)
//                Picker("Autoplay", selection: $autoplay) {
//                    Text(verbatim: "None")
//                        .tag(Specs.Settings.Configuration.Autoplay.none)
//                        .allowsHitTesting(false)
//                    Text(verbatim: "Audio")
//                        .tag(Specs.Settings.Configuration.Autoplay.audio)
//                        .allowsHitTesting(false)
//                    Text(verbatim: "Video")
//                        .tag(Specs.Settings.Configuration.Autoplay.video)
//                        .allowsHitTesting(false)
//                    Text(verbatim: "All")
//                        .tag(Specs.Settings.Configuration.Autoplay.all)
//                        .allowsHitTesting(false)
//                }
//            }
//            .headerProminence(.increased)
//            .listRowBackground(Color.clear)
//            .listRowSeparator(.hidden)
//            .onChange(of: engine) { update in
//                Task
//                    .detached(priority: .utility) {
//                        await cloud.update(search: update)
//                    }
//            }
//            .onChange(of: policy) { update in
//                Task
//                    .detached(priority: .utility) {
//                        await cloud.update(policy: update)
//                    }
//            }
//            .onChange(of: http) { update in
//                Task
//                    .detached(priority: .utility) {
//                        await cloud.update(http: update)
//                    }
//            }
//            .onChange(of: cookies) { update in
//                Task
//                    .detached(priority: .utility) {
//                        await cloud.update(cookies: update)
//                    }
//            }
//            .onChange(of: autoplay) { update in
//                Task
//                    .detached(priority: .utility) {
//                        await cloud.update(autoplay: update)
//                    }
//            }
//            .onReceive(cloud) {
//                engine = $0.settings.search.engine
//                policy = $0.settings.policy.level
//                http = $0.settings.configuration.http
//                cookies = $0.settings.configuration.cookies
//                autoplay = $0.settings.configuration.autoplay
//            }
//        }
//    }
//}
