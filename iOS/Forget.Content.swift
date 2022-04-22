import SwiftUI

extension Forget {
    struct Content: View {
        @Binding var items: [[Session.Item]]
        let session: Session
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 0) {
                    Text("Forget history, cache, trackers and cookies.")
                        .font(.title2.weight(.medium))
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top)
                    Spacer()
                    Image(systemName: "flame.fill")
                        .font(.system(size: 60, weight: .light))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.init("Dawn"))
                    Spacer()
                    Spacer()
                    Button {
                        session.items = []
                        items = []
                        
                        Task
                            .detached(priority: .utility) {
                                await Webview.clear()
                                await favicon.clear()
                                await cloud.forget()
                                await UNUserNotificationCenter.send(message: "Forgot everything!")
                                
                                await MainActor.run {
                                    session.objectWillChange.send()
                                    dismiss()
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
                    Image(systemName: "xmark.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 26, weight: .light))
                        .padding(16)
                        .foregroundStyle(.secondary)
                        .contentShape(Rectangle())
                }
            }
        }
    }
}
