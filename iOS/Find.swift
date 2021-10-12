import SwiftUI
import WebKit

struct Find: View {
    let web: Web
    @State private var search = ""
    @FocusState private var focus: Bool
    
    var body: some View {
        web
            .safeAreaInset(edge: .top) {
                VStack {
                    HStack(spacing: 0) {
                        Button {
                            
                        } label: {
                            Text("Done")
                                .font(.callout.weight(.medium))
                                .frame(width: 76)
                        }
                        
                        TextField("Find on page", text: $search, prompt: Text("\(Image(systemName: "magnifyingglass"))"))
                            .textFieldStyle(.roundedBorder)
                            .focused($focus)
                            .onSubmit {
                                submit(forward: true)
                            }
                        
                        Button {
                            submit(forward: false)
                        } label: {
                            Image(systemName: "chevron.up")
                                .padding(.leading, 6)
                                .font(.title2.weight(.light))
                        }
                        .disabled(search.isEmpty)
                        .frame(width: 46, height: 40)
                        
                        Button {
                            submit(forward: true)
                        } label: {
                            Image(systemName: "chevron.down")
                                .padding(.trailing, 14)
                                .font(.title2.weight(.light))
                        }
                        .disabled(search.isEmpty)
                        .frame(width: 46, height: 40)
                    }
                    .padding(.top)
                    
                    Rectangle()
                        .foregroundStyle(.quaternary)
                        .frame(height: 1)
                        .edgesIgnoringSafeArea(.horizontal)
                }
                .background(.regularMaterial)
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
