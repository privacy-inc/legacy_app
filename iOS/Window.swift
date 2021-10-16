import SwiftUI

struct Window: View {
    @State private var status = Status()
    
    var body: some View {
        Navigation(status: $status)
            .onOpenURL { url in
                switch url.scheme {
                case "privacy":
                    status.flow = .search
                default:
                    UIApplication.shared.hide()
                    Task
                        .detached(priority: .utility) {
                            await status.url(url)
                        }
                }
            }
    }
}
