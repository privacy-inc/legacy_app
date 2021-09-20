import SwiftUI

struct Landing: View {
    @State private var query = ""
    @State private var showing = 0
    @FocusState private var focus: Bool
    
    var body: some View {
        List {
            search
            segmented
            if showing == 0 {
                bookmarks
            } else {
                history
            }
        }
        .listStyle(.insetGrouped)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button {
                    query = ""
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
                .disabled(query.isEmpty)
            }
        }
    }
    
    private var search: some View {
        Section {
            Spacer()
                .frame(height: 250)
            
            HStack {
                Spacer()
                ZStack {
                    
                    Capsule()
                        .fill(Color(.systemBackground))
                        .onTapGesture {
                            focus = true
                        }
                    Capsule()
                        .strokeBorder(Color("Shades"))
                    TextField("Search or URL", text: $query)
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
                Spacer()
            }
            Spacer()
                .frame(height: 100)
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
    
    private var segmented: some View {
        Section {
            Picker("Showing", selection: $showing) {
                Text("Bookmarks")
                    .tag(0)
                Text("History")
                    .tag(1)
            }
            .labelsHidden()
            .pickerStyle(.segmented)
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
    
    private var bookmarks: some View {
        Section {
            ForEach(0 ..< 5, id: \.self) { _ in
                Bookmark()
            }
        }
    }
    
    private var history: some View {
        Section {
            ForEach(100 ..< 200, id: \.self) { _ in
                History()
            }
        }
    }
    
    private func submit() {
        
    }
}
