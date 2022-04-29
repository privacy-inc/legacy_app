import SwiftUI

extension Settings {
    struct Features: View {
        @State private var dark = true
        @State private var screen = true
        @State private var javascript = true
        @State private var timers = true
        
        var body: some View {
            List {
                Section {
                    Toggle("Dark mode", isOn: $dark)
                        .onChange(of: dark) { update in
                            Task
                                .detached(priority: .utility) {
                                    await cloud.update(dark: update)
                                }
                        }
                    Toggle("Remove cookie notices", isOn: $screen)
                        .onChange(of: screen) { update in
                            Task
                                .detached(priority: .utility) {
                                    await cloud.update(screen: !update)
                                }
                        }
                    Toggle("Enable JavaScript", isOn: $javascript)
                        .onChange(of: javascript) { update in
                            Task
                                .detached(priority: .utility) {
                                    await cloud.update(javascript: update)
                                }
                        }
                    Toggle("Stop scripts after loaded", isOn: $timers)
                        .onChange(of: timers) { update in
                            Task
                                .detached(priority: .utility) {
                                    await cloud.update(timers: !update)
                                }
                        }
                }
                .font(.callout)
                .toggleStyle(SwitchToggleStyle(tint: .mint))
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Features")
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(cloud) {
                dark = $0.settings.configuration.dark
                screen = !$0.settings.configuration.screen
                javascript = $0.settings.configuration.javascript
                timers = !$0.settings.configuration.timers
            }
        }
    }
}
