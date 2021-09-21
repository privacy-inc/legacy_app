import SwiftUI

extension Landing {
    struct Bookmarks: View {
        var body: some View {
            Header("Bookmarks") {
                HStack(alignment: .top) {
                    ForEach(0 ..< bookmarks.count, id: \.self) { index in
                        VStack(spacing: 20) {
                            ForEach(bookmarks[index], content: Item.init)
                        }
                    }
                }
            }
        }
    }
    
    private struct Item: View {
        let model: Model
        
        var body: some View {
            Button {
                
            } label: {
                VStack {
                    Image("favicon")
                        .padding(8)
                        .modifier(Card())
                    Text(verbatim: model.title)
                        .frame(maxWidth: .greatestFiniteMagnitude)
                        .font(.footnote)
                }
            }
        }
    }
}

private let bookmarks = [
    [
        Model(icon: "app", title: "Alan Moore - Wikipedia", domain: "wikipedia.org"),
        Model(icon: "ellipsis", title: "Alan Moore - Google", domain: "google.com"),
        Model(icon: "faceid", title: "Reuters", domain: "reuters.com")
    ],
    [
        Model(icon: "app", title: "Alan Moore - Wikipedia", domain: "wikipedia.org"),
        Model(icon: "ellipsis", title: "Alan Moore - Google", domain: "google.com"),
        Model(icon: "faceid", title: "Reuters", domain: "reuters.com")
    ],
    [
        Model(icon: "app", title: "Alan Moore - Wikipedia", domain: "wikipedia.org"),
        Model(icon: "ellipsis", title: "Alan Moore - Google", domain: "google.com"),
        Model(icon: "faceid", title: "Reuters", domain: "reuters.com")
    ],
    [
        Model(icon: "app", title: "Alan Moore - Wikipedia lorem ipsum hello world lorem ipsum lorem lorem lorem ipsum hello hello lorem ipsum", domain: "wikipedia.org"),
        Model(icon: "shield", title: "The Guardian", domain: "guardian.com"),
        Model(icon: "faceid", title: "b", domain: "a.com")
    ]]

private struct Model: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let domain: String
}
