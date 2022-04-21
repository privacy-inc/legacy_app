import SwiftUI
import Specs

extension About {
    struct Plus: View {
        @State private var state = Store.Status.loading
        @State private var learn = false
        
        var body: some View {
            VStack(spacing: 0) {
                if Defaults.isPremium {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.init("Shades"))
                    Text("We received your support\nThank you!")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                        .padding(.top, 10)
                } else {
                    switch state {
                    case .loading:
                        Image(systemName: "hourglass")
                            .font(.system(size: 40, weight: .ultraLight))
                            .foregroundColor(.init("Dawn"))
                    case let .error(error):
                        Text(error)
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: 280)
                    case let .products(products):
                        if let product = products.first {
                            Text(product.displayPrice)
                                .font(.body)
                                .padding(.bottom, 6)
                            Button {
                                Task {
                                    await store.purchase(product)
                                }
                            } label: {
                                Text("Purchase")
                                    .font(.callout.weight(.medium))
                                    .frame(minWidth: 90)
                            }
                            .foregroundColor(.white)
                            .tint(.blue)
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.capsule)
                            
                            HStack(spacing: 60) {
                                Button("Restore Purchases") {
                                    Task {
                                        await store.restore()
                                    }
                                }
                                .foregroundStyle(.secondary)
                                .frame(width: 130, alignment: .trailing)
                                
                                Button("Learn more") {
                                    learn = true
                                }
                                .foregroundColor(.mint)
                                .frame(width: 130, alignment: .leading)
                                .sheet(isPresented: $learn) {
                                    NavigationView {
                                        Settings.Info(title: "Why In-App Purchases", text: Copy.why)
                                            .toolbar {
                                                ToolbarItem(placement: .navigationBarTrailing) {
                                                    Button {
                                                        learn = false
                                                    } label: {
                                                        Image(systemName: "xmark")
                                                            .font(.system(size: 16, weight: .light))
                                                            .padding(4)
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
                            .font(.footnote)
                            .buttonStyle(.plain)
                            .padding(.top, 20)
                        }
                    }
                }
            }
            .padding(.vertical, 60)
            .onReceive(store.status) {
                state = $0
            }
            .task {
                await store.load()
            }
        }
    }
}
