//import SwiftUI
//import WebKit
//import Specs
//
//struct Find: View {
//    let web: Web
//    let end: () -> Void
//    @State private var search = ""
//    @FocusState private var focus: Bool
//    
//    var body: some View {
//        web
//            .equatable()
//            .safeAreaInset(edge: .top, spacing: 0) {
//                VStack {
//                    HStack(spacing: 0) {
//                        Button {
//                            UIApplication.shared.hide()
//                            end()
//                        } label: {
//                            Text("Done")
//                                .font(.callout.weight(.medium))
//                                .frame(width: 76, height: 34)
//                        }
//                        
//                        TextField("Find on page", text: $search, prompt: Text("\(Image(systemName: "magnifyingglass"))"))
//                            .textInputAutocapitalization(.none)
//                            .disableAutocorrection(true)
//                            .textFieldStyle(.roundedBorder)
//                            .submitLabel(.search)
//                            .focused($focus)
//                            .onSubmit {
//                                submit(forward: true)
//                            }
//                        
//                        Button {
//                            submit(forward: false)
//                        } label: {
//                            Image(systemName: "chevron.up")
//                                .padding(.leading, 6)
//                                .font(.title2.weight(.light))
//                        }
//                        .disabled(search.isEmpty)
//                        .frame(width: 46, height: 40)
//                        
//                        Button {
//                            submit(forward: true)
//                        } label: {
//                            Image(systemName: "chevron.down")
//                                .padding(.trailing, 14)
//                                .font(.title2.weight(.light))
//                        }
//                        .disabled(search.isEmpty)
//                        .frame(width: 46, height: 40)
//                    }
//                    .padding(.top)
//                    
//                    Divider()
//                        .ignoresSafeArea(edges: .horizontal)
//                }
//                .background(.regularMaterial)
//            }
//            .onAppear {
//                DispatchQueue
//                    .main
//                    .asyncAfter(deadline: .now() + 0.5) {
//                        focus = true
//                    }
//            }
//    }
//    
//    @MainActor private func submit(forward: Bool) {
//        web.scrollView.zoomScale = 1
//        web.becomeFirstResponder()
//        let config = WKFindConfiguration()
//        config.backwards = !forward
//        
//        Task {
//            guard
//                let result = try? await web.find(search, configuration: config),
//                result.matchFound,
//                let evaluated = try? await web.evaluateJavaScript(Script.find.script),
//                let string = evaluated as? String
//            else { return }
//            var rect = NSCoder.cgRect(for: string)
//            rect.origin.x += web.scrollView.contentOffset.x
//            rect.origin.y += web.scrollView.contentOffset.y
//            web.scrollView.scrollRectToVisible(rect, animated: true)
//        }
//    }
//}
