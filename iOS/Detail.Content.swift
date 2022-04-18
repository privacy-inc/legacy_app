import SwiftUI

extension Detail {
    struct Content: View {
        @ObservedObject var status: Status
        let web: Web
        @State private var selectable = true
        @State private var reader = true
        @State private var find = true

        var body: some View {
            VStack(spacing: 0) {
                Header(web: web)

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
                
                Switch(value: $reader, icon: "textformat.size", title: "Reader", divider: true)
                    .onChange(of: reader) {
                        web.session.reader(id: web.id, value: $0)
                    }
                    .frame(height: status.small ? 0 : nil)
                    .opacity(status.small ? 0 : 1)
                
                Switch(value: $find, icon: "doc.text.magnifyingglass", title: "Find on page", divider: true)
                    .onChange(of: find) {
                        web.session.find(id: web.id, value: $0)
                    }
                    .frame(height: status.small ? 0 : nil)
                    .opacity(status.small ? 0 : 1)
                
                Switch(value: $selectable, icon: "selection.pin.in.out", title: "Text selectable", divider: false)
                    .onChange(of: selectable) {
                        guard $0 != web.configuration.preferences.isTextInteractionEnabled else { return }
                        web.configuration.preferences.isTextInteractionEnabled = $0
                    }
                    .frame(height: status.small ? 0 : nil)
                    .opacity(status.small ? 0 : 1)
                
                Spacer()
                Navigation(web: web)
            }
            .background(.thinMaterial)
            .task {
                selectable = web.configuration.preferences.isTextInteractionEnabled
                let item = web.session.item(for: web.id)
                reader = item.reader
                find = item.find
            }
        }
    }
}
