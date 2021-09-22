import SwiftUI

extension Landing {
    struct History: View {
        @State private var items = [[Model]]()
        @Environment(\.verticalSizeClass) private var vertical
        
        var body: some View {
            Header("History") {
                HStack(alignment: .top) {
                    ForEach(0 ..< items.count, id: \.self) { index in
                        VStack {
                            ForEach(items[index], content: Item.init)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                update(with: vertical)
            }
            .onChange(of: vertical, perform: update(with:))
        }
        
        private func update(with vertical: UserInterfaceSizeClass?) {
            items = (vertical == .compact ? 3 : 2)
                .columns(with: 3)
                .reduce(into: .init()) { result, position in
                    if history.count > position.index {
                        if position.row == 0 {
                            result.append(.init())
                        }
                        result[position.col].append(history[position.index])
                    }
                }
        }
    }
    
    private struct Item: View {
        let model: Model
        
        var body: some View {
            Button {
                
            } label: {
                Text("\(Image(model.icon)) \(Text(model.title))\n\(Text(model.domain).foregroundColor(.secondary).font(.caption2))")
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding()
                    .modifier(Card())
            }
        }
    }
}

private let history = [
    Model(title: "Alan Moore - Wikipedia", domain: "wikipedia.org"),
    .init(title: "Alan Moore - Google", domain: "google.com"),
    .init(title: "Reuters", domain: "reuters.com"),
    .init(title: "Alan Moore - Wikipedia lorem ipsum hello world lorem ipsum lorem lorem lorem ipsum hello hello lorem ipsum", domain: "wikipedia.org"),
    .init(title: "The Guardian", domain: "guardian.com"),
    .init(title: "b", domain: "a.com"),
    .init(title: "bdasdas", domain: "qeqwdasdas"),
    .init(title: "bd", domain: "adad"),
    .init(title: "bdasdas asdksja", domain: "dasdsadsafasdasdsaasda"),
    .init(title: "bds dsadas asd", domain: "fjdasjdas"),
    .init(title: "b sdaas asdd asd sad a", domain: "ad.com"),
    .init(title: "bd", domain: "asas.com"),
    .init(title: "bss", domain: "aasddsadas.com"),
    .init(title: "bdassa", domain: "afads.com"),
    .init(title: "b das das dsa", domain: "asad.com"),
    .init(title: "b dasldmala adslmaslm", domain: "aadsdjaskdfajfdjdksjb.com"),]

private struct Model: Identifiable {
    let id = UUID()
    let icon = "favicon"
    let title: String
    let domain: String
}
