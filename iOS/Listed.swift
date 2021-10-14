import SwiftUI
import Specs

struct Listed: View {
    let item: Website
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            switch item.access {
            case let remote as Access.Remote:
                Remote(title: item.title, access: remote)
                    .allowsHitTesting(false)
            case let local as Access.Local:
                Circle()
            default:
                EmptyView()
            }
        }
        .font(.caption)
    }
}
