import SwiftUI

extension Settings {
    struct Blocker: View {
        @State private var policy = true
        @State private var cookies = false
        @State private var ads = true
        @State private var popups = true
        @State private var third = true
        
        var body: some View {
            List {
                Section {
                    Toggle("Block trackers", isOn: $policy)
                        .onChange(of: policy) { update in
                            Task
                                .detached(priority: .utility) {
                                    await cloud.update(policy: update ? .secure : .standard)
                                }
                        }
                    Toggle("Block cookies", isOn: $cookies)
                        .onChange(of: cookies) { update in
                            Task
                                .detached(priority: .utility) {
                                    await cloud.update(cookies: !update)
                                }
                        }
                    Toggle("Block ads", isOn: $ads)
                        .onChange(of: ads) { update in
                            Task
                                .detached(priority: .utility) {
                                    await cloud.update(ads: !update)
                                }
                        }
                    Toggle("Block pop-ups", isOn: $popups)
                        .onChange(of: popups) { update in
                            Task
                                .detached(priority: .utility) {
                                    await cloud.update(popups: !update)
                                }
                        }
                    Toggle("Block third-party scripts", isOn: $third)
                        .onChange(of: third) { update in
                            Task
                                .detached(priority: .utility) {
                                    await cloud.update(third: !update)
                                }
                        }
                }
                .font(.callout)
                .toggleStyle(SwitchToggleStyle(tint: .mint))
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Blocker")
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(cloud) {
                policy = $0.settings.policy == .secure
                cookies = !$0.settings.configuration.cookies
                ads = !$0.settings.configuration.ads
                popups = !$0.settings.configuration.popups
                third = !$0.settings.configuration.third
            }
        }
    }
}
