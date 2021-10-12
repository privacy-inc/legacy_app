import SwiftUI
import WebKit

struct Find: View {
    let web: Web
    @State private var search = ""
    @FocusState private var focus: Bool
    
    var body: some View {
        web
            .safeAreaInset(edge: .top) {
                VStack(spacing: 0) {
                    HStack {
                        TextField("Find on page", text: $search, prompt: Text("\(Image(systemName: "magnifyingglass")) Find on page"))
                            .textFieldStyle(.roundedBorder)
                            .focused($focus)
                            .onSubmit {
                                submit(forward: true)
                            }
                        Button("Find") {
                            submit(forward: true)
                        }
                        .font(.callout)
                        .buttonStyle(.bordered)
                        .tint(.init("Shades"))
                        .disabled(search.isEmpty)
                    }
                    .padding([.leading, .trailing, .top])

                    HStack {
                        Button("Done") {
                            
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                        
                        Spacer()
                        
                        Button {
                            submit(forward: false)
                        } label: {
                            Image(systemName: "chevron.up")
                                .padding(.top, 5)
                        }
                        .disabled(search.isEmpty)
                        .frame(width: 46, height: 52)
                        
                        Button {
                            submit(forward: true)
                        } label: {
                            Image(systemName: "chevron.down")
                                .padding(.top, 5)
                        }
                        .disabled(search.isEmpty)
                        .frame(width: 46, height: 52)
                    }
                    .padding(.horizontal)
                    .font(.callout)
                    
                    Rectangle()
                        .foregroundStyle(.quaternary)
                        .frame(height: 1)
                        .edgesIgnoringSafeArea(.horizontal)
                }
                .background(.thinMaterial)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    focus = true
                }
            }
    }
    
    @MainActor private func submit(forward: Bool) {
        web.becomeFirstResponder()
        let config = WKFindConfiguration()
        config.backwards = !forward
        
        Task {
            let result = try? await web.find(search, configuration: config)
            print(result?.matchFound)
            
            if result?.matchFound == true {
            }
        }
    }
}
