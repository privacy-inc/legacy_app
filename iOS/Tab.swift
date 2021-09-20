import SwiftUI

struct Tab: View {
    let id: UUID
    
    var body: some View {
        ScrollView {
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                }
                
                Spacer()
                
                NavigationLink(destination: Tabs()) {
                    Image(systemName: "app")
                        .font(.callout)
                }
            }
        }
        .task {
            print("tab")
        }
    }
}
