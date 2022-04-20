import SwiftUI

extension Detail {
    struct Content: View {
        @ObservedObject var status: Browser.Status
        let session: Session
        let index: Int
        @State private var selectable = true
        @Environment(\.dismiss) private var dismiss

        var body: some View {
            VStack(spacing: 0) {
                Header(status: status, web: session.items[index].web!)

                if !status.small {
                    Spacer()
                        .frame(height: 30)
                }
                
                Switch(value: $status.reader, icon: "textformat.size", title: "Reader", divider: true)
                    .onChange(of: status.reader) {
                        session.items[index].reader = $0
                    }
                    .frame(height: status.small ? 0 : nil)
                    .opacity(status.small ? 0 : 1)
                
                Switch(value: $status.find, icon: "doc.text.magnifyingglass", title: "Find on page", divider: true)
                    .onChange(of: status.find) {
                        session.items[index].find = $0
                    }
                    .frame(height: status.small ? 0 : nil)
                    .opacity(status.small ? 0 : 1)
                
                Switch(value: $selectable, icon: "selection.pin.in.out", title: "Text selectable", divider: false)
                    .onChange(of: selectable) {
                        guard $0 != session.items[index].web!.configuration.preferences.isTextInteractionEnabled else { return }
                        session.items[index].web!.configuration.preferences.isTextInteractionEnabled = $0
                    }
                    .frame(height: status.small ? 0 : nil)
                    .opacity(status.small ? 0 : 1)
                
                if status.small {
                    Spacer()
                } else {
                    Spacer()
                        .frame(height: 60)
                }
                
                HStack(spacing: 0) {
                    Spacer()
                    
                    Action(title: "Pause", icon: "pause") {
                        Task {
                            await session.items[index].web!.pauseAllMediaPlayback()
                            await UNUserNotificationCenter.send(message: "Media paused!")
                            dismiss()
                        }
                    }
                    
                    Spacer()
                    
                    Action(title: "Bookmark", icon: "bookmark") {
                        
                    }
                    
                    Spacer()
                    
                    if status.small {
                        Action(title: "More", icon: "ellipsis") {
                            status.features.send()
                            status.small = false
                        }
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Navigation(web: session.items[index].web!)
            }
            .background(.thinMaterial)
            .task {
                selectable = session.items[index].web!.configuration.preferences.isTextInteractionEnabled
            }
        }
    }
}
