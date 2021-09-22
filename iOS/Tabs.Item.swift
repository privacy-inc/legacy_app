import SwiftUI

extension Tabs {
    struct Item: View {
        let status: Navigation.Status
        
        var body: some View {
            Button {
                
            } label: {
                Snap(image: status.image, size: 150)
            }
        }
    }
}
