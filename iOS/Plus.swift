import SwiftUI
import StoreKit
import Specs

struct Plus: View {
    @State private var state = Store.Status.loading
    
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    Banner()
                        .equatable()
                        .frame(width: 250, height: 250)
                    Spacer()
                }
            }
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden)
            .listRowBackground(Color.clear)
            
            title
            
            if Defaults.isPremium {
                isPremium
            } else {
                notPremium
            }
            
            disclaimer
        }
        .listStyle(.insetGrouped)
        .symbolRenderingMode(.hierarchical)
        .animation(.easeInOut(duration: 0.3), value: state)
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(store.status) {
            state = $0
        }
        .task {
            await store.load()
        }
    }
    
    private var title: some View {
        Section {
            Text("Privacy \(Image(systemName: "plus"))")
                .foregroundColor(.primary)
                .font(.largeTitle)
                .imageScale(.large)
                .frame(maxWidth: .greatestFiniteMagnitude)
        }
        .listRowSeparator(.hidden)
        .listSectionSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
    
    private var isPremium: some View {
        Section {
            Image(systemName: "checkmark.circle.fill")
                .font(.largeTitle)
                .symbolRenderingMode(.multicolor)
                .frame(maxWidth: .greatestFiniteMagnitude)
                
            Text("Thank you\nyou already supported Privacy")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .greatestFiniteMagnitude)
                .padding(.bottom)
        }
        .listRowSeparator(.hidden)
        .listSectionSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
    
    @ViewBuilder private var notPremium: some View {
        Section {
            switch state {
            case .loading:
                Image(systemName: "hourglass")
                    .font(.largeTitle.weight(.light))
                    .symbolRenderingMode(.multicolor)
                    .frame(maxWidth: .greatestFiniteMagnitude)
            case let .error(error):
                Text(verbatim: error)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
            case let .products(products):
                if let product = products.first {
                    item(product: product)
                } else {
                    Text(Copy.noPurchases)
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
        }
        .listRowSeparator(.hidden)
        .listSectionSeparator(.hidden)
        .listRowBackground(Color.clear)
        
        Section("Already supporting Privacy?") {
            Button {
                
            } label: {
                HStack {
                    Text("Restore purchases")
                    Spacer()
                    Image(systemName: "leaf.arrow.triangle.circlepath")
                }
            }
        }
        .font(.footnote)
    }
    
    private var disclaimer: some View {
        Section {
            NavigationLink(destination: Circle()) {
                Label("Why In-App Purchases", systemImage: "questionmark.app.dashed")
            }
            NavigationLink(destination: Circle()) {
                Label("Alternatives", systemImage: "arrow.triangle.branch")
            }
        }
        .font(.footnote)
    }
    
    private func item(product: Product) -> some View {
        VStack {
            Text(verbatim: product.description)
                .foregroundColor(.secondary)
                .font(.callout)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: 240)
                .padding(.bottom)
            HStack {
                Text(verbatim: product.displayPrice)
                    .font(.body.monospacedDigit())
            }
            .padding(.top)
            Button {
                Task {
                    await store.purchase(product)
                }
            } label: {
                Text("Purchase")
                    .font(.callout)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .tint(.blue)
            .padding(.bottom)
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
    }
}
