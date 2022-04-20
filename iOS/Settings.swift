import SwiftUI

struct Settings: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                app
            }
            .symbolRenderingMode(.multicolor)
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
            NavigationLink(destination: Circle()) {
                Label("About", systemImage: "eyeglasses")
                    .allowsHitTesting(false)
            }
            
            NavigationLink(destination: Info(title: "Why In-App Purchases", text: Copy.why)) {
                Label("Why In-App Purchases", systemImage: "questionmark.app.dashed")
                    .allowsHitTesting(false)
            }
            
            NavigationLink(destination: Info(title: "Privacy Policy", text: Copy.policy)) {
                Label("Privacy Policy", systemImage: "hand.raised")
                    .allowsHitTesting(false)
            }
            
            NavigationLink(destination: Info(title: "Terms and Conditions", text: Copy.terms)) {
                Label("Terms and Conditions", systemImage: "doc.plaintext")
                    .allowsHitTesting(false)
            }
        }
        .headerProminence(.increased)
    }
}
