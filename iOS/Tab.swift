import SwiftUI

struct Tab: View {
    let id: UUID
    let tabs: () -> Void
    
    var body: some View {
        ScrollView {
            
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                }
                .foregroundStyle(.primary)
                
                Spacer()
                
                Button(action: tabs) {
                    Image(systemName: "app")
                        .font(.callout)
                }
                .foregroundStyle(.primary)
            }
        }
    }
}
