import SwiftUI
import StoreKit
import Specs

extension About {
    struct Plus: View {
        @State private var status = Store.Status.loading
        @State private var learn = false
        
        var body: some View {
            VStack(spacing: 12) {
                Spacer()
                
                switch status {
                case .loading:
                    Image(systemName: "hourglass")
                        .font(.system(size: 30, weight: .ultraLight))
                        .foregroundColor(.init("Dawn"))
                    Spacer()
                case let .error(error):
                    Text(error)
                        .font(.callout.weight(.medium))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: 280)
                    Spacer()
                case let .products(products):
                    if let product = products.first {
                        HStack(spacing: 0) {
                            Text("Privacy ")
                                .font(.body.weight(.medium))
                            Image(systemName: "plus")
                                .font(.body.weight(.light))
                        }
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 2)
                        
                        Text("Sponsor research\nand development of\nPrivacy Browser.")
                            .font(.body.weight(.medium))
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Button {
                            Task {
                                await store.purchase(product)
                            }
                        } label: {
                            Text("Support Now")
                                .font(.callout.weight(.semibold))
                                .frame(minWidth: 260)
                                .frame(minHeight: 28)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                        .foregroundColor(.white)
                        
                        Text("1 time only " + product.displayPrice + " purchase.")
                            .font(.footnote)
                        
                        Spacer()
                        
                        HStack(spacing: 0) {
                            Button("Restore Purchases") {
                                Task {
                                    await store.restore()
                                }
                            }
                            .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Button("Learn More") {
                                learn = true
                            }
                            .foregroundColor(.blue)
                            .sheet(isPresented: $learn) {
                                NavigationView {
                                    Settings.Info(title: "Why In-App Purchases", text: Copy.why)
                                        .toolbar {
                                            ToolbarItem(placement: .navigationBarTrailing) {
                                                Button {
                                                    learn = false
                                                } label: {
                                                    Image(systemName: "xmark")
                                                        .font(.system(size: 12, weight: .regular))
                                                        .padding(6)
                                                        .padding(.leading)
                                                        .foregroundStyle(.secondary)
                                                        .contentShape(Rectangle())
                                                }
                                            }
                                        }
                                }
                                .navigationViewStyle(.stack)
                            }
                        }
                        .font(.footnote.weight(.medium))
                        .buttonStyle(.plain)
                        .padding([.horizontal, .bottom], 30)
                    }
                }
            }
            .onReceive(store.status) {
                status = $0
            }
            .task {
                await store.load()
            }
        }
    }
}
