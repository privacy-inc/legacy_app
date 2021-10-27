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
                case .report:
                    Report()
                }
            }
            .onOpenURL { url in
                switch url.scheme {
                case "privacy":
                    switch url.host {
                    case "report":
                        modal = .report
                    default:
                        status.flow = .search
                    }
                default:
                    UIApplication.shared.hide()
                    status.flow = .tabs
                    Task
                        .detached(priority: .utility) {
                            await status.url(url)
                        }
                }
            }
            .task {
                status.dark = scheme == .dark
                if let created = Defaults.wasCreated {
                    let days = Calendar.current.dateComponents([.day], from: created, to: .init()).day!
                    if !Defaults.hasRated && days > 6 {
                        UIApplication.shared.review()
                        Defaults.hasRated = true
                    } else if Defaults.hasRated && !Defaults.isPremium && days > 8 {
                        modal = .froob
                    }
                } else {
                    Defaults.wasCreated = .init()
                }
                
                await cloud.migrate()
            }
    }
}
