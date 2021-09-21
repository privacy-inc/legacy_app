import SwiftUI

extension Landing {
    struct Bookmarks: View {
        var body: some View {
            Header("Bookmarks") {
                HStack(alignment: .top) {
                    ForEach(0 ..< bookmarks.count, id: \.self) { index in
                        VStack {
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
                    Image(model.icon)
                        .padding(8)
                        .modifier(Card())
                    Text(verbatim: model.title)
                        .frame(maxWidth: .greatestFiniteMagnitude)
                        .font(.caption)
                    Spacer()
                }
                .frame(height: 110)
            }
        }
    }
}

private let bookmarks = [
    [
        Model(title: "Alan Moore - Wikipedia"),
        Model(title: "Alan Moore - Google"),
        Model(title: "Reuters")
    ],
    [
        Model(title: "A"),
        Model(title: "Alan Moore - Google"),
        Model(title: "Reuters")
    ],
    [
        Model(title: "Alan Moore - Wikipedia"),
        Model(title: "Alan Moore - Google"),
        Model(title: "Reuters")
    ],
    [
        Model(title: "Alan Moore - Wikipedia lorem ips"),
        Model(title: "The Guardian"),
        Model(title: "b")
    ]]

private struct Model: Identifiable {
    let id = UUID()
    let icon = "favicon"
    let title: String
}
