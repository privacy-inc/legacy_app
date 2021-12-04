import SwiftUI
import Specs

struct Window: View {
    @State private var status = Status()
    @State private var modal: Modal?
    @Environment(\.colorScheme) private var scheme
    
    var body: some View {
        Navigation(status: $status)
            .animation(.none, value: status.flow)
            .onChange(of: scheme) {
                status.dark = $0 == .dark
            }
            .sheet(item: $modal) {
                switch $0 {
                case .froob:
                    Froob()
                }
            }
            .onOpenURL { url in
                cloud
                    .ready
                    .notify(queue: .main) {
                        switch url.scheme {
                        case "privacy":
                            status.flow = .search
                        default:
                            UIApplication.shared.hide()
                            status.flow = .tabs
                            Task
                                .detached(priority: .utility) {
                                    await status.url(url: url)
                                }
                        }
                    }
            }
            .task {
                status.dark = scheme == .dark
                
                switch Defaults.action {
                case .rate:
                    UIApplication.shared.review()
                case .froob:
                    modal = .froob
                case .none:
                    break
                }
            }
    }
}
