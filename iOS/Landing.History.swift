import SwiftUI

extension Landing {
    struct History: View {
        var body: some View {
            Header("History") {
                HStack(alignment: .top) {
                    VStack {
                        ForEach(history[0], content: Item.init)
                    }
                    VStack {
                        ForEach(history[1], content: Item.init)
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
                Text("\(Image("favicon")) \(Text(model.title))\n\(Text(model.domain).foregroundColor(.secondary).font(.caption))")
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .font(.footnote)
                    .padding()
                    .modifier(Card())
            }
        }
    }
}

private let history = [
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
