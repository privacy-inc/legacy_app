import SwiftUI

extension Tabs {
    struct Item: View {
        let index: Int
        
        var body: some View {
            NavigationLink(destination: Tab(id: .init())) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.regularMaterial)
                    Text(verbatim: "\(index)")
                }
                .frame(width: 200, height: 300)
            }
        }
    }
}
