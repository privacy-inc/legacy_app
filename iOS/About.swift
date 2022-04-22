import SwiftUI
import Specs

struct About: View {
    @AppStorage(Defaults.premium.rawValue) private var premium = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Layer()
                .equatable()
            
            Rectangle()
                .fill(LinearGradient(colors: [.init(white: 1, opacity: 0),
                                              .init(white: 1, opacity: 0.85),
                                              .init(white: 1, opacity: 0.95)], startPoint: .top, endPoint: .bottom))
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .trailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.primary)
                        .frame(width: 50, height: 55)
                        .contentShape(Rectangle())
                }
                Spacer()
            }
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .trailing)
            
            VStack {
                Spacer()
                    .frame(height: 150)
                
                Image("Logo")
                
                if premium {
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundStyle(.white, .blue)
                    Text("We received your support\nThank you!")
                        .multilineTextAlignment(.center)
                        .font(.footnote.weight(.medium))
                        .padding(.top, 10)
                } else {
                    Plus()
                }
                
                Spacer()
                
                HStack(spacing: 0) {
                    Text("Privacy Browser ")
                        .font(.footnote)
                    Text(verbatim: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                HStack(spacing: 0) {
                    Text("From Berlin with ")
                        .foregroundStyle(.tertiary)
                        .font(.caption)
                    Image(systemName: "heart.fill")
                        .font(.footnote)
                        .foregroundStyle(.pink)
                }
                .padding(.bottom)
            }
        }
    }
}
