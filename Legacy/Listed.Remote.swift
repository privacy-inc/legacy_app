//import SwiftUI
//import Specs
//
//extension Listed {
//    struct Remote: View {
//        let title: String
//        let access: Access.Remote
//        
//        var body: some View {
//            HStack {
//                Icon(icon: access.icon)
//                Text("\(title) \(domain)")
//                    .lineLimit(2)
//                    .truncationMode(.middle)
//            }
//            .padding(.vertical, 8)
//        }
//        
//        private var domain: Text {
//            Text(verbatim: access.domain.minimal)
//                .foregroundColor(.secondary)
//        }
//    }
//}
