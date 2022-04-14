//import SwiftUI
//import Specs
//
//struct Recover: View {
//    let error: Err?
//    let tabs: () -> Void
//    let search: () -> Void
//    let dismiss: () -> Void
//    let retry: () -> Void
//    
//    var body: some View {
//        VStack {
//            Spacer()
//            Image(systemName: "exclamationmark.triangle.fill")
//                .font(.largeTitle)
//                .symbolRenderingMode(.hierarchical)
//                .foregroundColor(.pink)
//            Text(verbatim: error?.url.absoluteString ?? "")
//                .font(.callout.weight(.light))
//                .foregroundColor(.secondary)
//                .frame(maxWidth: 320)
//                .lineLimit(1)
//                .padding(.top)
//            Text(verbatim: error?.description ?? "")
//                .font(.body)
//                .foregroundColor(.primary)
//                .multilineTextAlignment(.center)
//                .frame(maxWidth: 260)
//                .fixedSize(horizontal: false, vertical: true)
//                .padding(.bottom)
//            Button(action: retry) {
//                Image(systemName: "arrow.clockwise")
//            }
//            .buttonStyle(.bordered)
//            .tint(.init("Shades"))
//            Spacer()
//        }
//        .frame(maxWidth: .greatestFiniteMagnitude)
//        .background(.ultraThickMaterial)
//        .safeAreaInset(edge: .bottom, spacing: 0) {
//            Bar(search: search) {
//                Button(action: dismiss) {
//                    Image(systemName: "chevron.backward")
//                        .symbolRenderingMode(.hierarchical)
//                        .font(.title3)
//                        .frame(width: 70)
//                        .allowsHitTesting(false)
//                }
//                
//                Spacer()
//            } trailing: {
//                Spacer()
//                
//                Button(action: tabs) {
//                    Image(systemName: "square.on.square.dashed")
//                        .symbolRenderingMode(.hierarchical)
//                        .font(.callout)
//                        .frame(width: 70)
//                        .allowsHitTesting(false)
//                }
//            }
//        }
//    }
//}
