import SwiftUI

struct Bar: View {
    let leading: Item
    let center: Item
    let trailing: Item
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .ignoresSafeArea(edges: .horizontal)
            HStack(spacing: 0) {
                leading
                Spacer()
                center
                Spacer()
                trailing
            }
            .foregroundStyle(.secondary)
            .padding(.horizontal)
            .padding(.vertical, 7)
        }
        .background(.ultraThinMaterial)
    }
}
