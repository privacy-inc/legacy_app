import SwiftUI

extension Detail {
    struct Content: View {
        @ObservedObject var status: Status
        let web: Web
        @State private var selectable = true
        @State private var reader = true
        @State private var find = true

        var body: some View {
            ScrollView(showsIndicators: false) {
                Header(web: web)

                HStack {
                    Action(title: "Pause", icon: "pause") {
                        
                    }
                    
                    Spacer()
                    
                    Action(title: "Bookmark", icon: "bookmark") {
                        
                    }
                }
                .padding(.horizontal)
                
//                ZStack {
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(Color(.tertiarySystemBackground))
//                    VStack(spacing: 0) {
//                        Action(title: "Share", icon: "square.and.arrow.up") {
//                            
//                        }
//                        
//                        Divider()
//                        
//                        Action(title: "Bookmark", icon: "bookmark") {
//                            
//                        }
//                        
//                        Divider()
//                        
//                        Action(title: "Pause all media", icon: "pause") {
//                            
//                        }
//                    }
//                    .padding(.horizontal, 20)
//                }
//                .padding(.horizontal)
                
                ZStack {
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(.thickMaterial)
                    VStack(spacing: 0) {
                        Switch(icon: "textformat.size", title: "Reader", value: $reader)
                            .onChange(of: reader) {
                                web.session.reader(id: web.id, value: $0)
                            }
                        
                        Divider()
                            .padding(.horizontal)
                        
                        Switch(icon: "doc.text.magnifyingglass", title: "Find on page", value: $find)
                            .onChange(of: find) {
                                web.session.find(id: web.id, value: $0)
                            }
                        
                        Divider()
                            .padding(.horizontal)
                        
                        Switch(icon: "selection.pin.in.out", title: "Text selectable", value: $selectable)
                            .onChange(of: selectable) {
                                guard $0 != web.configuration.preferences.isTextInteractionEnabled else { return }
                                web.configuration.preferences.isTextInteractionEnabled = $0
                            }
                    }
                    .padding(.horizontal, 20)
                    .toggleStyle(SwitchToggleStyle(tint: .secondary))
                }
                .padding(.horizontal)
                .padding(.top, 30)
                .opacity(status.small ? 0 : 1)
                
                Spacer()
                    .frame(height: 30)
            }
            .clipped()
            .safeAreaInset(edge: .bottom, spacing: 0) {
                if status.small {
                    Navigation(web: web)
                }
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
