import SwiftUI

extension Settings {
    struct Javascript: View {
        @State private var javascript = true
        @State private var timers = true
        @State private var third = true
        
        var body: some View {
            Section("JavaScript") {
                Toggle("Scripts enabled", isOn: $javascript)
                Toggle("Stop scripts when loaded", isOn: $timers)
                Toggle("Block third-party scripts", isOn: $third)
            }
            .headerProminence(.increased)
            .onChange(of: javascript) { update in
                Task
                    .detached(priority: .utility) {
                        await cloud.update(javascript: update)
                    }
            }
            .onChange(of: timers) { update in
                Task
                    .detached(priority: .utility) {
                        await cloud.update(timers: !update)
                    }
            }
            .onChange(of: third) { update in
                Task
                    .detached(priority: .utility) {
                        await cloud.update(third: !update)
                    }
            }
            .onReceive(cloud) {
                javascript = $0.settings.configuration.javascript
                timers = !$0.settings.configuration.timers
                third = !$0.settings.configuration.third
            }
        }
    }
}
