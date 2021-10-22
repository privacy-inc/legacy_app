import SwiftUI

@main struct App: SwiftUI.App {
    @Environment(\.scenePhase) private var phase
    @WKExtensionDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            TabView {
                Activity()
                Trackers()
                Forget()
            }
            .onAppear {
                cloud.pull.send()
            }
        }
        .onChange(of: phase) {
            if $0 == .active {
                cloud.pull.send()
            }
        }
    }
}
