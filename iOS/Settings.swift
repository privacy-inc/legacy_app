import SwiftUI
import Specs

struct Settings: View {
    @State private var about = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                app
                help
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
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
    
    private var app: some View {
        Section("App") {
            Button {
                about = true
            } label: {
                HStack {
                    Text("About")
                        .font(.callout)
                    Spacer()
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                }
            }
            .sheet(isPresented: $about, content: About.init)
            
            Button {
                UIApplication.shared.review()
                Defaults.hasRated = true
            } label: {
                HStack {
                    Text("Rate on the App Store")
                        .font(.callout)
                    Spacer()
                    Image(systemName: "star")
                        .symbolRenderingMode(.multicolor)
                        .font(.title3)
                }
            }
            
            Link(destination: .init(string: "privacy://goprivacy.app")!) {
                HStack {
                    Text("goprivacy.app")
                    Spacer()
                    Image(systemName: "link")
                        .symbolRenderingMode(.multicolor)
                        .font(.title3)
                }
            }
        }
        .headerProminence(.increased)
    }
    
    private var help: some View {
        Section {
            NavigationLink(destination: Info(title: "Why In-App Purchases", text: Copy.why)) {
                Label("Why In-App Purchases", systemImage: "questionmark.app.dashed")
                    .symbolRenderingMode(.multicolor)
            }
            
            NavigationLink(destination: Info(title: "Privacy Policy", text: Copy.policy)) {
                Label("Privacy Policy", systemImage: "hand.raised")
                    .symbolRenderingMode(.multicolor)
            }
            
            NavigationLink(destination: Info(title: "Terms and Conditions", text: Copy.terms)) {
                Label("Terms and Conditions", systemImage: "doc.plaintext")
                    .symbolRenderingMode(.multicolor)
            }
        }
    }
}
