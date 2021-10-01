import SwiftUI

struct Sidebar: View {
    @Environment(\.dismiss) private var dismiss
    @State private var forget = false
    
    var body: some View {
        NavigationView {
            List {
                report
                websites
                app
            }
            .symbolRenderingMode(.multicolor)
            .listStyle(.insetGrouped)
            .imageScale(.large)
            .font(.footnote)
            .navigationTitle("Menu")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .font(.callout)
                            .foregroundColor(.init("Shades"))
                            .padding(.leading)
                            .allowsHitTesting(false)
                            .contentShape(Rectangle())
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        forget = true
                    } label: {
                        Text("Forget \(Image(systemName: "flame.fill"))")
                            .font(.footnote)
                            .imageScale(.large)
                            .allowsHitTesting(false)
                    }
                    .confirmationDialog("Forget", isPresented: $forget) {
                        Button("Cache") {
                            
                        }
                        Button("History") {
                            
                        }
                        Button("Activity") {
                            
                        }
                        Button("Trackers") {
                            
                        }
                        Button("Everything", role: .destructive) {

                        }
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private var report: some View {
        Section("Report") {
            NavigationLink(destination: Settings.init) {
                Label("Trackers", systemImage: "shield.lefthalf.filled")
                    .allowsHitTesting(false)
            }
            
            NavigationLink(destination: Settings.init) {
                Label("Activity", systemImage: "chart.xyaxis.line")
                    .allowsHitTesting(false)
            }
        }
        .headerProminence(.increased)
    }
    
    private var websites: some View {
        Section("Websites") {
            NavigationLink(destination: Settings.init) {
                Label("Bookmarks", systemImage: "bookmark")
                    .allowsHitTesting(false)
            }
            
            NavigationLink(destination: Settings.init) {
                Label("History", systemImage: "clock")
                    .allowsHitTesting(false)
            }
        }
        .headerProminence(.increased)
    }
    
    private var app: some View {
        Section("App") {
            NavigationLink(destination: Settings.init) {
                Label("Settings", systemImage: "gear")
                    .allowsHitTesting(false)
            }
            
            NavigationLink(destination: Settings.init) {
                Label("Privacy +", systemImage: "plus.viewfinder")
                    .allowsHitTesting(false)
            }
            
            NavigationLink(destination: Settings.init) {
                Label("About", systemImage: "eyeglasses")
                    .allowsHitTesting(false)
            }
        }
        .headerProminence(.increased)
    }
}
