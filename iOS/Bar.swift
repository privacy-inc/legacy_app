import SwiftUI

struct Bar: View {
    let items: [Item]
    let bottom: Bool
    let material: Material
    
    var body: some View {
        VStack(spacing: 0) {
            if bottom {
                Divider()
            }
            
            HStack(spacing: 0) {
                ForEach(items, id: \.self.icon) {
                    $0
                    if $0.icon != items.last?.icon {
                        Spacer()
                    }
                }
            }
            .foregroundStyle(.secondary)
            .padding(.horizontal)
            .padding(.vertical, 7)
            
            if !bottom {
                Divider()
            }
        }
        .background(material)
    }
}
