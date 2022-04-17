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
                    
                    Switch(icon: "textformat.size", title: "Reader", value: $reader)
                        .onChange(of: reader) {
                            web.session.reader(id: web.id, value: $0)
                        }
                    
                    Divider()
                        .padding(.horizontal, 30)
                    
                    Switch(icon: "doc.text.magnifyingglass", title: "Find on page", value: $find)
                        .onChange(of: find) {
                            web.session.find(id: web.id, value: $0)
                        }
                    
                    Divider()
                        .padding(.horizontal, 30)
                    
                    Switch(icon: "selection.pin.in.out", title: "Text selectable", value: $selectable)
                        .onChange(of: selectable) {
                            guard $0 != web.configuration.preferences.isTextInteractionEnabled else { return }
                            web.configuration.preferences.isTextInteractionEnabled = $0
                        }
                }
                
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
