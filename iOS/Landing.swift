import SwiftUI

struct Landing: View {
    @State private var search = ""
    @FocusState private var focus: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Button {
                        
                    } label: {
                        Label("Bookmarks", systemImage: "bookmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.footnote)
                            .imageScale(.large)
                    }
                    .buttonStyle(.bordered)
                    .tint(.init("Shades"))
                    
                    Button {
                        
                    } label: {
                        Label("Tabs", systemImage: "square.dashed.inset.filled")
                            .symbolRenderingMode(.hierarchical)
                            .font(.footnote)
                            .imageScale(.large)
                    }
                    .buttonStyle(.bordered)
                    .tint(.init("Shades"))
                    
                    Button {
                        
                    } label: {
                        Label("History", systemImage: "list.bullet.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.footnote)
                            .imageScale(.large)
                    }
                    .buttonStyle(.bordered)
                    .tint(.init("Shades"))
                }
                .padding(.top, 200)
                Spacer()
            }
            ZStack {
                Capsule()
                    .fill(.ultraThickMaterial)
                    .onTapGesture {
                        focus = true
                    }
                TextField("Search or URL", text: $search)
                    .keyboardType(.webSearch)
                    .textInputAutocapitalization(.none)
                    .disableAutocorrection(true)
                    .focused($focus)
                    .font(.callout)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .frame(maxWidth: 300)
                    .onSubmit(submit)
            }
            .padding(.horizontal)
            .fixedSize()
        }
        .ignoresSafeArea(.keyboard)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button {
                    search = ""
                    focus = false
                } label: {
                    Text("Cancel")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                
                Button {
                    focus = false
                    submit()
                } label: {
                    Text("Search")
                        .font(.footnote)
                }
                .buttonStyle(.bordered)
                .disabled(search.isEmpty)
            }
        }
    }
    
    private func submit() {
        
    }
}
