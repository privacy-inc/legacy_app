import SwiftUI
import Specs

private let size = CGFloat(24)

extension Search {
    struct Item: View {
        let field: Field
        let website: Website
        @State var counter = 0
        @StateObject private var icon = Icon()
        
        var body: some View {
            Button {
                field.cancel(clear: false)
                
                guard let url = URL(string: website.id) else { return }
                
                Task {
                    await field.session.open(url: url, index: field.index)
                }
            } label: {
                ZStack(alignment: .topLeading) {
                    if let image = icon.image {
                        text(string: "\(Image(uiImage: Self.blank)) \(website.title) \(domain)")
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                            .frame(width: size, height: size)
                            .allowsHitTesting(false)
                    } else {
                        text(string: "\(website.title) \(domain)")
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding()
            .modifier(Card(dark: field.session.dark))
            .contextMenu {
                Text(counter.formatted() + "\nTrackers prevented")
                    .font(.callout)
                Divider()
                Button {
                    UIPasteboard.general.string = website.id
                    Task {
                        await UNUserNotificationCenter.send(message: "Link copied!")
                    }
                } label: {
                    Label("Copy Link", systemImage: "link")
                }
                Button {
                    guard let url = URL(string: website.id) else { return }
                    UIApplication.shared.share(url)
                } label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                Divider()
                Button {
                    Task {
                        await cloud.delete(url: website.id)
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
            .onReceive(cloud) {
                counter = $0.tracking.count(domain: website.id.domain)
            }
            .task {
                await icon.load(website: .init(string: website.id))
            }
        }
        
        private var domain: Text {
            Text(verbatim: website.id.domain)
                .foregroundColor(.secondary)
        }
        
        private func text(string: LocalizedStringKey) -> some View {
            Text(string)
                .font(.footnote)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
        }
        
        private static let blank: UIImage = {
            UIGraphicsBeginImageContext(.init(width: size, height: size))
            let image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return image
        } ()
    }
}
