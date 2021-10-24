import SwiftUI
import Specs

struct Window: View {
    @State private var status = Status()
    @State private var froob = false
    
    var body: some View {
        Navigation(status: $status)
            .animation(.none, value: status.flow)
            .sheet(isPresented: $froob, content: Froob.init)
            .onOpenURL { url in
                switch url.scheme {
                case "privacy":
                    status.flow = .search
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
                if let created = Defaults.wasCreated {
                    let days = Calendar.current.dateComponents([.day], from: created, to: .init()).day!
                    if !Defaults.hasRated && days > 6 {
                        UIApplication.shared.review()
                        Defaults.hasRated = true
                    } else if Defaults.hasRated && !Defaults.isPremium && days > 8 {
                        froob = true
                    }
                } else {
                    Defaults.wasCreated = .init()
                }
                
                await cloud.migrate()
            }
    }
}
