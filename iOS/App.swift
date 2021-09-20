import SwiftUI

@main struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            Navigation(flow: .tab(.init()))
        }
    }
}
