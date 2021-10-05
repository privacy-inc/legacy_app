import SwiftUI
import Specs

struct Sidebar: View {
    @Binding var presented: Bool
    let access: (AccessType) -> Void
    let history: (UInt16) -> Void
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
                        presented = false
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
            NavigationLink(destination: Circle()) {
                Label("Trackers", systemImage: "shield.lefthalf.filled")
                    .allowsHitTesting(false)
            }
            
            NavigationLink(destination: Circle()) {
                Label("Activity", systemImage: "chart.xyaxis.line")
                    .allowsHitTesting(false)
            }
        }
        .headerProminence(.increased)
    }
    
    private var websites: some View {
        Section("Websites") {
            NavigationLink(destination: Bookmarks(presented: $presented, select: access)) {
                Label("Bookmarks", systemImage: "bookmark")
                    .allowsHitTesting(false)
            }
            
            NavigationLink(destination: History(presented: $presented, select: history)) {
                Label("History", systemImage: "clock")
                    .allowsHitTesting(false)
            }
        }
        .headerProminence(.increased)
    }
    
    private var app: some View {
        Section("App") {
            NavigationLink(destination: Settings(presented: $presented)) {
                Label("Settings", systemImage: "gear")
                    .allowsHitTesting(false)
            }
            
            NavigationLink(destination: Circle()) {
                Label("Privacy +", systemImage: "plus.viewfinder")
                    .allowsHitTesting(false)
            }
            
            NavigationLink(destination: Circle()) {
                Label("About", systemImage: "eyeglasses")
                    .allowsHitTesting(false)
            }
        }
        .headerProminence(.increased)
    }
}
