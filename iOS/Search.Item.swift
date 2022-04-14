//import SwiftUI
//import Specs
//
//extension Search {
//    struct Item: View {
//        let complete: Complete
//        let action: () -> Void
//        
//        var body: some View {
//            Button(action: action) {
//                HStack {
//                    Icon(icon: complete.access.icon)
//                    Text("\(title) \(domain): \(complete.location.rawValue)")
//                        .lineLimit(2)
//                        .truncationMode(.middle)
//                        .multilineTextAlignment(.leading)
//                        .font(.footnote)
//                        .foregroundStyle(.tertiary)
//                        .fixedSize(horizontal: false, vertical: true)
//                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
//                }
//                .padding(.vertical, 5)
//            }
//        }
//        
//        private var title: Text {
//            Text(verbatim: complete.title)
//                .foregroundColor(.primary)
//        }
//        
//        private var domain: Text {
//            Text(verbatim: complete.domain.map { "\($0) " } ?? "")
//                .foregroundColor(.secondary)
//        }
//    }
//}
