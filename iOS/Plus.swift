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
                        .frame(width: 250, height: 250)
                    Spacer()
                }
            }
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden)
            .listRowBackground(Color.clear)
            
            if Defaults.isPremium {
                isPremium
            } else {
                notPremium
            }
            
            disclaimer
        }
        .listStyle(.insetGrouped)
        .symbolRenderingMode(.hierarchical)
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(store.status) {
            state = $0
        }
        .task {
            await store.load()
        }
    }
    
    private var isPremium: some View {
        Section {
            
        }
    }
    
    @ViewBuilder private var notPremium: some View {
        Section {
            switch state {
            case .loading:
                Image(systemName: "hourglass")
                    .font(.largeTitle.weight(.light))
                    .symbolRenderingMode(.multicolor)
                    .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
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
            Group {
                Text(verbatim: product.displayName)
                    .foregroundColor(.primary)
                    .font(.largeTitle)
                + Text(verbatim: "\n" + product.description)
                    .foregroundColor(.secondary)
                    .font(.callout)
            }
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: 240)
            .padding(.vertical)
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


/*
 import SwiftUI
 import StoreKit
 import Secrets

 extension Purchases {
     struct Item: View {
         let product: Product
         
         var body: some View {
             VStack {
                 Image(product.id)
                 Group {
                     Text(verbatim: product.displayName)
                         .foregroundColor(.primary)
                         .font(.title)
                     + Text(verbatim: "\n" + product.description)
                         .foregroundColor(.secondary)
                         .font(.callout)
                 }
                 .multilineTextAlignment(.center)
                 .fixedSize(horizontal: false, vertical: true)
                 .frame(maxWidth: 200)
                 .padding(.bottom)
                 HStack {
                     Text(verbatim: product.displayPrice)
                         .font(.body.monospacedDigit())
                     if product.id != Purchase.one.rawValue, let percent = Purchase(rawValue: product.id)?.save {
                         Group {
                             Text("Save ")
                             + Text(percent, format: .percent)
                         }
                         .foregroundColor(.orange)
                         .font(.callout.bold())
                     }
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
                 .padding(.bottom)
             }
         }
     }
 }

 */
