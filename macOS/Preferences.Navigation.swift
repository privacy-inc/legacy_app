import AppKit

extension Preferences {
    final class Navigation: NSTabViewItem {
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init(identifier: "")
            label = "Navigation"
            
            let engine = Segmented(title: "Search engine", labels: ["Google", "Ecosia"], target: self, action: #selector(self.engine))
            let level = Segmented(title: "Privacy level", labels: ["Block trackers", "Standard"], target: self, action: #selector(self.level))
            let connection = Segmented(title: "Connection encryption", labels: ["Enforce https", "Allow http"], target: self, action: #selector(self.connection))
            let cookies = Segmented(title: "Cookies", labels: ["Block all", "Accept"], target: self, action: #selector(self.cookies))
            let autoplay = Segmented(title: "Autoplay", labels: ["None", "Audio", "Video", "All"], target: self, action: #selector(self.autoplay))
            
            let stack = NSStackView(views: [engine,
                                            level,
                                            connection,
                                            cookies,
                                            autoplay])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.orientation = .vertical
            stack.spacing = 20
            view!.addSubview(stack)
            
            stack.topAnchor.constraint(equalTo: view!.topAnchor, constant: 20).isActive = true
            stack.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
            
            Task {
                let settings = await cloud.model.settings
                await MainActor
                    .run {
                        engine.control.selectedSegment = settings.search.engine == .google ? 0 : 1
                        level.control.selectedSegment = settings.policy.level == .secure ? 0 : 1
                        connection.control.selectedSegment = settings.configuration.http ? 1 : 0
                        cookies.control.selectedSegment = settings.configuration.cookies ? 1 : 0
                        
                        switch settings.configuration.autoplay {
                        case .none:
                            autoplay.control.selectedSegment = 0
                        case .audio:
                            autoplay.control.selectedSegment = 1
                        case .video:
                            autoplay.control.selectedSegment = 2
                        case .all:
                            autoplay.control.selectedSegment = 3
                        }
                    }
            }
        }
        
        @objc private func engine(_ segmented: NSSegmentedControl) {
            let selected = segmented.selectedSegment
            
            Task
                .detached(priority: .utility) {
                    switch selected {
                    case 0:
                        await cloud.update(search: .google)
                    default:
                        await cloud.update(search: .ecosia)
                    }
                }
        }
        
        @objc private func level(_ segmented: NSSegmentedControl) {
            let selected = segmented.selectedSegment
            
            Task
                .detached(priority: .utility) {
                    switch selected {
                    case 0:
                        await cloud.update(policy: .secure)
                    default:
                        await cloud.update(policy: .standard)
                    }
                }
        }
        
        @objc private func connection(_ segmented: NSSegmentedControl) {
            let selected = segmented.selectedSegment
            
            Task
                .detached(priority: .utility) {
                    switch selected {
                    case 0:
                        await cloud.update(http: false)
                    default:
                        await cloud.update(http: true)
                    }
                }
        }
        
        @objc private func cookies(_ segmented: NSSegmentedControl) {
            let selected = segmented.selectedSegment
            
            Task
                .detached(priority: .utility) {
                    switch selected {
                    case 0:
                        await cloud.update(cookies: false)
                    default:
                        await cloud.update(cookies: true)
                    }
                }
        }
        
        @objc private func autoplay(_ segmented: NSSegmentedControl) {
            let selected = segmented.selectedSegment
            
            Task
                .detached(priority: .utility) {
                    switch selected {
                    case 0:
                        await cloud.update(autoplay: .none)
                    case 1:
                        await cloud.update(autoplay: .audio)
                    case 2:
                        await cloud.update(autoplay: .video)
                    default:
                        await cloud.update(autoplay: .all)
                    }
                }
        }
    }
}
