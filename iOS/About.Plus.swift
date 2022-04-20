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
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.init("Shades"))
                    Text("We received your support\nThank you!")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .font(.callout)
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
                            .padding()
                    case let .products(products):
                        if let product = products.first {
                            Text(product.displayPrice)
                                .font(.body)
                                .padding(.bottom, 3)
                            Button {
                                
                            } label: {
                                Text("Purchase")
                                    .frame(minWidth: 90)
                            }
                            .foregroundColor(.white)
                            .tint(.blue)
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.capsule)
                            
                            HStack(spacing: 30) {
                                Button("Restore Purchases") {
                                    Task {
                                        await store.restore()
                                    }
                                }
                                .foregroundStyle(.secondary)
                                
                                Button("Learn More") {
                                    
                                }
                                .foregroundColor(.mint)
                            }
                            .font(.footnote)
                            .buttonStyle(.plain)
                            .padding(.top, 40)
                        }
                    }
                }
            }
            .padding(.vertical, 45)
            .onReceive(store.status) {
                state = $0
            }
            .task {
                await store.load()
            }
        }
    }
}
