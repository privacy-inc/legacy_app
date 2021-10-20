import SwiftUI
import Specs

struct Sidebar: View {
    @Binding var presented: Bool
    let clear: () -> Void
    let access: (AccessType) -> Void
    let history: (UInt16) -> Void
    @State private var forget = false
    
    var body: some View {
        NavigationView {
            List {
                report
                websites
                app
                help
            }
            .symbolRenderingMode(.multicolor)
            .listStyle(.insetGrouped)
            .imageScale(.large)
            .font(.callout)
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
                            .frame(height: 34)
                            .allowsHitTesting(false)
                            .contentShape(Rectangle())
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        forget = true
                    } label: {
                        HStack {
                            Image(systemName: "flame.fill")
                                .font(.callout)
                                .foregroundColor(.init("Dawn"))
                            Text("Forget")
                                .font(.footnote)
                        }
                        .allowsHitTesting(false)
                    }
                    .confirmationDialog("Forget", isPresented: $forget) {
                        Button("Cache", action: Forget.cache)
                        Button("History") {
                            Forget.history()
                            clear()
                        }
                        Button("Activity", action: Forget.activity)
                        Button("Everything", role: .destructive) {
                            Forget.everything()
                            clear()
                        }
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private var report: some View {
        Section("Report") {
            NavigationLink(destination: Trackers()) {
                Label("Trackers", systemImage: "shield.lefthalf.filled")
                    .allowsHitTesting(false)
            }
            
            NavigationLink(destination: Activity()) {
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
            
            NavigationLink(destination: Plus()) {
                Label("Privacy +", systemImage: "plus.viewfinder")
                    .allowsHitTesting(false)
            }
            
            NavigationLink(destination: About()) {
                Label("About", systemImage: "eyeglasses")
                    .allowsHitTesting(false)
            }
        }
        .headerProminence(.increased)
    }
    
    private var help: some View {
        Section("Help") {
            NavigationLink(destination: Info(title: "Policy", text: Copy.policy)) {
                Label("Privacy policy", systemImage: "hand.raised")
                    .allowsHitTesting(false)
            }
            
            NavigationLink(destination: Info(title: "Terms and conditions", text: Copy.terms)) {
                Label("Terms and conditions", systemImage: "doc.plaintext")
                    .allowsHitTesting(false)
            }
        }
        .headerProminence(.increased)
    }
}
