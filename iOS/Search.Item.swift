import SwiftUI
import Specs

extension Search {
    struct Item: View {
        let complete: Complete
        let action: () -> Void
        @State private var publisher: Favicon.Pub?
        
        var body: some View {
            Button(action: action) {
                HStack {
                    if let publisher = publisher {
                        ZStack(alignment: .topLeading) {
                            Icon(access: complete.access, publisher: publisher)
                        }
                    }
                    Text("\(Text(verbatim: complete.title).foregroundColor(.primary)) \(complete.domain ?? "") : \(complete.location.rawValue)")
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .font(.footnote)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
                .padding(.vertical, 5)
            }
            .task {
                publisher = await favicon.publisher(for: complete.access)
            }
        }
    }
}
