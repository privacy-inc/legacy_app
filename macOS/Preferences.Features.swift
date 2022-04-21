import AppKit
import Combine

extension Preferences {
    final class Features: NSVisualEffectView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .init(origin: .zero, size: .init(width: 580, height: 340)))
            
            let dark = Switch(title: "Force dark mode")
            dark
                .change
                .sink { value in
                    Task
                        .detached(priority: .utility) {
                            await cloud.update(dark: value)
                        }
                }
                .store(in: &subs)
            
            let screen = Switch(title: "Remove cookie notices")
            screen
                .change
                .sink { value in
                    Task
                        .detached(priority: .utility) {
                            await cloud.update(screen: !value)
                        }
                }
                .store(in: &subs)
            
            let scripts = Switch(title: "Enable JavaScript")
            scripts
                .change
                .sink { value in
                    Task
                        .detached(priority: .utility) {
                            await cloud.update(javascript: value)
                        }
                }
                .store(in: &subs)
            
            let stop = Switch(title: "Stop scripts after loaded")
            stop
                .change
                .sink { value in
                    Task
                        .detached(priority: .utility) {
                            await cloud.update(timers: !value)
                        }
                }
                .store(in: &subs)
            
            let stack = NSStackView(views: [dark, screen, scripts, stop])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.orientation = .vertical
            stack.alignment = .leading
            addSubview(stack)
            
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
            stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 190).isActive = true
            
            cloud
                .first()
                .map(\.settings)
                .sink { settings in
                    dark.control.state = settings.configuration.dark ? .on : .off
                    screen.control.state = settings.configuration.screen ? .off : .on
                    scripts.control.state = settings.configuration.javascript ? .on : .off
                    stop.control.state = settings.configuration.timers ? .off : .on
                }
                .store(in: &subs)
        }
    }
}
