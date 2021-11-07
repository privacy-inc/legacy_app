import AppKit

extension Preferences {
    final class Javascript: NSTabViewItem {
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init(identifier: "")
            label = "JavaScript"
            
            let scripts = Switch(title: "Scripts enabled", target: self, action: #selector(scripts))
            let stop = Switch(title: "Stop scripts when loaded", target: self, action: #selector(stop))
            let third = Switch(title: "Block third-party scripts", target: self, action: #selector(third))
            
            let stack = NSStackView(views: [scripts,
                                            Separator(mode: .horizontal),
                                            stop,
                                            Separator(mode: .horizontal),
                                            third])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.orientation = .vertical
            stack.spacing = 8
            view!.addSubview(stack)
            
            stack.topAnchor.constraint(equalTo: view!.topAnchor, constant: 40).isActive = true
            stack.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
            
            Task {
                let settings = await cloud.model.settings
                await MainActor
                    .run {
                        scripts.control.state = settings.configuration.javascript ? .on : .off
                        stop.control.state = settings.configuration.timers ? .off : .on
                        third.control.state = settings.configuration.third ? .off : .on
                    }
            }
        }
        
        @objc private func scripts(_ toggle: NSSwitch) {
            let state = toggle.state == .on
            
            Task
                .detached(priority: .utility) {
                    await cloud.update(javascript: state)
                }
        }
        
        @objc private func stop(_ toggle: NSSwitch) {
            let state = toggle.state == .on
            
            Task
                .detached(priority: .utility) {
                    await cloud.update(timers: !state)
                }
        }
        
        @objc private func third(_ toggle: NSSwitch) {
            let state = toggle.state == .on
            
            Task
                .detached(priority: .utility) {
                    await cloud.update(third: !state)
                }
        }
    }
}
