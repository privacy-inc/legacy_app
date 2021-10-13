import SwiftUI
import Specs

struct Recover: View {
    let url: String
    let description: String
    let tabs: () -> Void
    let search: () -> Void
    let dismiss: () -> Void
    let retry: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.pink)
            Text(verbatim: url)
                .font(.footnote)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top)
            Text(verbatim: description)
                .font(.callout)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom)
            Button(action: retry) {
                Image(systemName: "arrow.clockwise")
            }
            .buttonStyle(.bordered)
            .tint(.init("Shades"))
            Spacer()
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
        .background(.ultraThickMaterial)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Bar(search: search) {
                Button(action: dismiss) {
                    Image(systemName: "chevron.backward")
                        .symbolRenderingMode(.hierarchical)
                        .font(.title3)
                        .frame(width: 70)
                        .allowsHitTesting(false)
                }
                
                Spacer()
            } trailing: {
                Spacer()
                
                Button(action: tabs) {
                    Image(systemName: "square.on.square.dashed")
                        .symbolRenderingMode(.hierarchical)
                        .font(.callout)
                        .frame(width: 70)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}
