import SwiftUI
import Specs

struct Settings: View {
    @Binding var presented: Bool
    @State private var requested = true
    @State private var enabled = true
    
//    @AppStorage(Defaults._authenticate.rawValue) private var authenticate = false
//    @AppStorage(Defaults._tools.rawValue) private var tools = true
//    @AppStorage(Defaults._spell.rawValue) private var spell = true
//    @AppStorage(Defaults._correction.rawValue) private var correction = false
    
    var body: some View {
        List {
            notifications
        }
        .symbolRenderingMode(.multicolor)
        .toggleStyle(SwitchToggleStyle(tint: .orange))
        .listStyle(.grouped)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await check()
        }
    }
    
    private func check() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        if settings.authorizationStatus == .notDetermined {
            requested = false
        } else if settings.alertSetting == .disabled {
            enabled = false
        }
    }
    
    private var notifications: some View {
        Section("Notifications") {
            Text(enabled ? Copy.deactivate : Copy.notifications)
                .font(.footnote)
                .padding(.bottom)
                .foregroundStyle(.secondary)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .allowsHitTesting(false)
            Action(title: enabled ? "Open Settings" : "Activate notifications", symbol: "app.badge") {
                if enabled || requested {
                    presented = false
                    UIApplication.shared.settings()
                } else {
                    Task {
                        _ = await UNUserNotificationCenter.request()
                        requested = true
                        await check()
                    }
                }
            }
        }
    }
}
