import SwiftUI

@main struct App: SwiftUI.App {
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup(content: Window.init)
            .onChange(of: phase) {
                switch $0 {
                case .active:
                    cloud.pull.send()
                default:
                    break
                }
            }
    }
}
