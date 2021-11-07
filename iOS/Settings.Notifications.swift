import SwiftUI

extension Settings {
    struct Notifications: View {
        @Binding var presented: Bool
        @State private var requested = true
        @State private var enabled = true
        
        var body: some View {
            Section("Notifications") {
                Text(enabled ? Copy.deactivate : Copy.notifications)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.vertical)
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
            .headerProminence(.increased)
            .task {
                await check()
            }
        }
        
        private func check() async {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            if settings.authorizationStatus == .notDetermined {
                requested = false
                enabled = false
            } else if settings.alertSetting == .disabled || settings.authorizationStatus == .denied {
                enabled = false
            } else {
                enabled = true
            }
        }
    }
}
