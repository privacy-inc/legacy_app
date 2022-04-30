import SwiftUI
import Specs

extension Forget {
    struct Content: View {
        @Binding var items: [[Session.Item]]
        let session: Session
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 0) {
                    Text("Forget Everything")
                        .font(.title.weight(.medium))
                        .padding(.top)
                    Spacer()
                    Image(systemName: "flame.fill")
                        .font(.system(size: 50, weight: .ultraLight))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.init("Dawn"))
                    Spacer()
                    Button {
                        session.items = []
                        items = []
                        
                        Task
                            .detached(priority: .utility) {
                                await Webview.clear()
                                await favicon.clear()
                                await cloud.forget()
                                
                                try? FileManager.default.removeItem(at: .init(fileURLWithPath: NSTemporaryDirectory()))
                                
                                await UNUserNotificationCenter.send(message: "Forgot everything!")
                                
                                await MainActor.run {
                                    session.objectWillChange.send()
                                    dismiss()
                                    
                                    if Defaults.rate {
                                        UIApplication.shared.review()
                                    }
                                }
                            }
                    } label: {
                        Text("Forget")
                            .font(.callout.weight(.semibold))
                            .frame(maxWidth: .greatestFiniteMagnitude)
                            .frame(minHeight: 30)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .foregroundColor(.white)
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.callout)
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .padding(.top, 20)
                }
                .padding(30)
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 16, weight: .regular))
                        .padding(22)
                        .foregroundStyle(.secondary)
                        .contentShape(Rectangle())
                }
            }
        }
    }
}
