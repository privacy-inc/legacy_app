import SwiftUI
import Specs

struct Settings: View {
    @State private var engine = Specs.Search.google
    @State private var autoplay = Specs.Settings.Autoplay.none
    @State private var http = false
    @State private var about = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                search
                insecure
                options
                play
                privacy
                browser
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
                            .font(.system(size: 12, weight: .regular))
                            .padding(6)
                            .padding(.leading)
                            .foregroundStyle(.secondary)
                            .contentShape(Rectangle())
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .onReceive(cloud) {
            engine = $0.settings.search
            autoplay = $0.settings.configuration.autoplay
            http = $0.settings.configuration.http
        }
    }
    
    private var search: some View {
        Section("Search engine") {
            Picker("Search engine", selection: $engine) {
                Text(verbatim: "Google")
                    .tag(Specs.Search.google)
                Text(verbatim: "Ecosia")
                    .tag(Specs.Search.ecosia)
            }
            .pickerStyle(.segmented)
        }
        .headerProminence(.increased)
        .onChange(of: engine) { update in
            Task
                .detached(priority: .utility) {
                    await cloud.update(search: update)
                }
        }
    }
    
    private var insecure: some View {
        Section {
            Toggle("Allow \(Text("insecure").font(.callout.weight(.medium)))\nconnections (http)", isOn: $http)
                .toggleStyle(SwitchToggleStyle(tint: .mint))
                .font(.callout.weight(.light))
                .padding(.vertical, 6)
        }
        .onChange(of: http) { update in
            Task
                .detached(priority: .utility) {
                    await cloud.update(http: update)
                }
        }
    }
    
    private var play: some View {
        Section("Autoplay") {
            Picker("Autoplay media", selection: $autoplay) {
                Text(verbatim: "None")
                    .tag(Specs.Settings.Autoplay.none)
                Text(verbatim: "Audio")
                    .tag(Specs.Settings.Autoplay.audio)
                Text(verbatim: "Video")
                    .tag(Specs.Settings.Autoplay.video)
                Text(verbatim: "All")
                    .tag(Specs.Settings.Autoplay.all)
            }
            .pickerStyle(.segmented)
        }
        .headerProminence(.increased)
        .onChange(of: autoplay) { update in
            Task
                .detached(priority: .utility) {
                    await cloud.update(autoplay: update)
                }
        }
    }
    
    private var options: some View {
        Section {
            NavigationLink(destination: Features.init) {
                Label("Features", systemImage: "switch.2")
                    .symbolRenderingMode(.multicolor)
                    .font(.callout)
            }
            NavigationLink(destination: Blocker.init) {
                Label("Blocker", systemImage: "bolt.shield")
                    .symbolRenderingMode(.multicolor)
                    .font(.callout)
            }
        }
    }
    
    private var privacy: some View {
        Section {
            Button {
                UIApplication.shared.settings()
            } label: {
                HStack {
                    Text("Notifications")
                        .font(.callout)
                    Spacer()
                    Image(systemName: "app.badge")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 16, weight: .light))
                        .frame(width: 24)
                }
            }
            Button {
                UIApplication.shared.settings()
            } label: {
                HStack {
                    Text("Location access")
                        .font(.callout)
                    Spacer()
                    Image(systemName: "location")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 16, weight: .light))
                        .frame(width: 24)
                }
            }
        }
    }
    
    private var browser: some View {
        Section {
            Button {
                UIApplication.shared.settings()
            } label: {
                HStack {
                    Text("Make \(Text("Privacy Browser").font(.callout.weight(.medium)))\nyour default")
                        .font(.callout.weight(.light))
                        .padding(.vertical, 6)
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .light))
                        .frame(width: 24)
                }
            }
        }
    }
    
    private var app: some View {
        Section {
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
                        .font(.system(size: 16, weight: .light))
                        .frame(width: 24)
                }
            }
            
            Link(destination: .init(string: "privacy://goprivacy.app")!) {
                HStack {
                    Text("goprivacy.app")
                        .font(.callout)
                    Spacer()
                    Image(systemName: "link")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 16, weight: .light))
                        .frame(width: 24)
                }
            }
        }
    }
    
    private var help: some View {
        Section {
            NavigationLink(destination: Info(title: "Why In-App Purchases", text: Copy.why)) {
                Label("Why In-App Purchases", systemImage: "questionmark.app.dashed")
                    .symbolRenderingMode(.multicolor)
                    .font(.callout)
            }
            
            NavigationLink(destination: Info(title: "Privacy Policy", text: Copy.policy)) {
                Label("Privacy Policy", systemImage: "hand.raised")
                    .symbolRenderingMode(.multicolor)
                    .font(.callout)
            }
            
            NavigationLink(destination: Info(title: "Terms and Conditions", text: Copy.terms)) {
                Label("Terms and Conditions", systemImage: "doc.plaintext")
                    .symbolRenderingMode(.multicolor)
                    .font(.callout)
            }
        }
    }
}
