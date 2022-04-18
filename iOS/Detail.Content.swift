import SwiftUI

extension Detail {
    struct Content: View {
        @ObservedObject var status: Browser.Status
        let session: Session
        let index: Int
        @State private var selectable = true

        var body: some View {
            VStack(spacing: 0) {
                Header(web: session.items[index].web!)

                Spacer()
                
                HStack {
                    Action(title: "Pause", icon: "pause") {
                        
                    }
                    
                    Spacer()
                    
                    Action(title: "Bookmark", icon: "bookmark") {
                        
                    }
                }
                .padding(.horizontal)
                
                if !status.small {
                    Spacer()
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
