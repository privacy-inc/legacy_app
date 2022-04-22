import SwiftUI
import Specs

struct Window: View {
    @StateObject private var session = Session()
    @Environment(\.colorScheme) private var scheme
    
    var body: some View {
        Navigation(session: session)
            .onChange(of: scheme) {
                session.dark = $0 == .dark
            }
            .onOpenURL {
                UIApplication.shared.hide()
                guard let url = URL(string: $0.absoluteString.replacingOccurrences(of: "privacy://", with: "https://")) else { return }
                
                cloud
                    .ready
                    .notify(queue: .main) {
                        Task {
                            if let current = session.current,
                               session.items[current].web == nil {
                                await session.open(url: url, index: current)
                            } else {
                                await session.open(url: url, change: true)
                            }
                        }
                    }
            }
            .task {
                cloud.ready.notify(queue: .main) {
                    cloud.pull.send()
                }
                
                session.dark = scheme == .dark
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    switch Defaults.action {
                    case .rate:
                        UIApplication.shared.review()
                    case .froob:
                        session.froob = true
                    case .none:
                        break
                    }
                    
                    Task {
                        _ = await UNUserNotificationCenter.request()
                    }
                }
            }
    }
}
