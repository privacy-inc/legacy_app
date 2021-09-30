import SwiftUI
import Specs

struct Settings: View {
    @State private var requested = true
    @State private var enabled = true
    let tab: () -> Void
//    @AppStorage(Defaults._authenticate.rawValue) private var authenticate = false
//    @AppStorage(Defaults._tools.rawValue) private var tools = true
//    @AppStorage(Defaults._spell.rawValue) private var spell = true
//    @AppStorage(Defaults._correction.rawValue) private var correction = false
    
    var body: some View {
        NavigationView {
            List {
                notifications
            }
            .symbolRenderingMode(.multicolor)
            .toggleStyle(SwitchToggleStyle(tint: .orange))
            .listStyle(.grouped)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: tab) {
                        Text("Done")
                            .font(.callout)
                            .foregroundColor(.init("Shades"))
                            .padding(.leading)
                            .contentShape(Rectangle())
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
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
            Button {
                if enabled || requested {
                    tab()
                    UIApplication.shared.settings()
                } else {
                    Task {
                        _ = await UNUserNotificationCenter.request()
                        requested = true
                        await check()
                    }
                }
            } label: {
                HStack {
                    Text(enabled ? "Open Settings" : "Activate notifications")
                        .font(.callout)
                    Spacer()
                    Image(systemName: "app.badge")
                        .font(.title3)
                }
            }
        }
    }
}
