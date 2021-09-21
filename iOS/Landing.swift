import SwiftUI

struct Landing: View {
    @State private var query = ""
    @State private var showing = 0
    @FocusState private var focus: Bool
    
    var body: some View {
        ScrollView {
            search
            segmented
            history
        }
        .background(.ultraThickMaterial)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.primary.opacity(0.05))
                    .frame(height: 1)
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.ultraThickMaterial)
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.primary.opacity(0.05))
                    Text("\(Image(systemName: "magnifyingglass")) Search or enter website")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.leading)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
                .frame(width: 240, height: 34)
                .fixedSize()
                .padding(.vertical)
            }
            .background(.ultraThinMaterial)
        }
        .toolbar {
//            ToolbarItemGroup(placement: .bottomBar) {
//                HStack {
//                    Spacer()
//                    ZStack {
//
//                        Capsule()
//                            .fill(Color(.systemBackground))
//                            .onTapGesture {
//                                focus = true
//                            }
//                        Capsule()
//                            .strokeBorder(Color("Shades"))
//                        TextField("Search or URL", text: $query)
//                            .keyboardType(.webSearch)
//                            .textInputAutocapitalization(.none)
//                            .disableAutocorrection(true)
//                            .focused($focus)
//                            .font(.callout)
//                            .padding(.horizontal, 16)
//                            .padding(.vertical, 8)
//                            .frame(maxWidth: 300)
//                            .onSubmit(submit)
//                    }
//                    .padding(.horizontal)
//                    .fixedSize()
//                    Spacer()
//                }
//            }
            
            
//            ToolbarItemGroup(placement: .keyboard) {
//                Button {
//                    query = ""
//                    focus = false
//                } label: {
//                    Text("Cancel")
//                        .font(.footnote)
//                        .foregroundStyle(.secondary)
//                }
//
//                Button {
//                    focus = false
//                    submit()
//                } label: {
//                    Text("Search")
//                        .font(.footnote)
//                }
//                .buttonStyle(.bordered)
//                .disabled(query.isEmpty)
//            }
        }
    }
    
    private var search: some View {
        Header(title: "Search") {
            Spacer()
                .frame(height: 250)
            
            
            Spacer()
                .frame(height: 100)
        }
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
