import SwiftUI
import Specs

struct About: View {
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    VStack {
                        Image("Logo")
                        Text(verbatim: "Privacy")
                            .foregroundStyle(.primary)
                        Text(verbatim: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")
                            .font(.callout.monospacedDigit().bold())
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 70)
                    Spacer()
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            
            Section {
                Link(destination: URL(string: "https://goprivacy.app")!) {
                    HStack {
                        Text("goprivacy.app")
                            .font(.callout)
                        Spacer()
                        Image(systemName: "link")
                            .font(.title3)
                    }
                }
                
                Button {
                    UIApplication.shared.review()
                    Defaults.rated = true
                } label: {
                    HStack {
                        Text("Rate on the App Store")
                            .font(.callout)
                        Spacer()
                        Image(systemName: "star")
                            .font(.title3)
                    }
                }
            }
            
            Section {
                HStack(spacing: 0) {
                    Spacer()
                    Text("From Berlin with ")
                    Image(systemName: "heart")
                    Spacer()
                }
            }
            .font(.caption)
            .foregroundColor(.secondary)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .symbolRenderingMode(.multicolor)
        .listStyle(.insetGrouped)
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.large)
    }
}
