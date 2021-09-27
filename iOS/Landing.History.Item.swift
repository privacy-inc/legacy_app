import SwiftUI
import Combine
import Specs

extension Landing.History {
    struct Item: View {
        let item: History
        @State private var domain: String?
        @State private var pub: Favicon.Pub?
        @State private var image: UIImage?
        
        var body: some View {
            Button {
                
            } label: {
                if let pub = pub {
                    Text("\(icon) \(title) \(subtitle)")
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                        .onReceive(pub) {
                            image = $0
                        }
                } else {
                    title
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
            }
            .font(.caption)
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .modifier(Card())
            .task {
                domain = (item.website.access as? Access.Remote)?.domain
                if domain != nil {
                    pub = await favicon.publisher(for: domain!)
                }
            }
        }
        
        private var icon: Image {
            if let image = image {
                return Image(uiImage: image)
            } else {
                return Image(systemName: "app")
            }
        }
        
        private var title: Text {
            Text(verbatim: item.website.title)
        }
        
        private var subtitle: Text {
            Text(verbatim: ": " + domain!)
                .foregroundColor(.secondary)
        }
    }
}
