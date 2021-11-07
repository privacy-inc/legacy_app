import AppKit

extension Preferences {
    final class Features: NSTabViewItem {
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init(identifier: "")
            label = "Features"
            
            let dark = Switch(title: "Force dark mode", target: self, action: #selector(dark))
            let popups = Switch(title: "Block pop-ups", target: self, action: #selector(popups))
            let ads = Switch(title: "Remove ads", target: self, action: #selector(ads))
            let screen = Switch(title: "Remove screen blockers", target: self, action: #selector(screen))
            
            let stack = NSStackView(views: [dark,
                                            Separator(mode: .horizontal),
                                            popups,
                                            Separator(mode: .horizontal),
                                            ads,
                                            Separator(mode: .horizontal),
                                            screen])
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
                        dark.control.state = settings.configuration.dark ? .on : .off
                        popups.control.state = settings.configuration.popups ? .off : .on
                        ads.control.state = settings.configuration.ads ? .off : .on
                        screen.control.state = settings.configuration.screen ? .off : .on
                    }
            }
        }
        
        @objc private func dark(_ toggle: NSSwitch) {
            let state = toggle.state == .on
            
            Task
                .detached(priority: .utility) {
                    await cloud.update(dark: state)
                }
        }
        
        @objc private func popups(_ toggle: NSSwitch) {
            let state = toggle.state == .on
            
            Task
                .detached(priority: .utility) {
                    await cloud.update(popups: !state)
                }
        }
        
        @objc private func ads(_ toggle: NSSwitch) {
            let state = toggle.state == .on
            
            Task
                .detached(priority: .utility) {
                    await cloud.update(ads: !state)
                }
        }
        
        @objc private func screen(_ toggle: NSSwitch) {
            let state = toggle.state == .on
            
            Task
                .detached(priority: .utility) {
                    await cloud.update(screen: !state)
                }
        }
    }
}
