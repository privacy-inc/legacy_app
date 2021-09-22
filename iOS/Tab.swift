import SwiftUI

struct Tab: View {
    let index: Int
    
    var body: some View {
        VStack {
            
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "app")
                        .font(.callout)
                }
            }
        }
    }
}
