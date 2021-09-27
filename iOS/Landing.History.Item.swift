import SwiftUI
import Combine
import Specs

extension Landing.History {
    struct Item: View {
        let item: History
        @State private var image: UIImage?
        @State private var sub: AnyCancellable?
        
        var body: some View {
            Button {
                
            } label: {
                Text("\(icon) \(title) \(subtitle)")
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                    .modifier(Card())
            }
            .task {
                if let domain = (item.website.access as? Access.Remote)?.domain {
                    await sub = favicon
                        .publisher(for: domain)
                        .sink {
                            print("sync image")
                            image = $0
                        }
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
            if let domain = (item.website.access as? Access.Remote)?.domain {
                return Text(verbatim: ": " + domain)
                    .foregroundColor(.secondary)
            } else {
                return Text(verbatim: "")
            }
        }
    }
}
