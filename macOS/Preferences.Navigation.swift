import AppKit
import Combine

extension Preferences {
    final class Navigation: NSVisualEffectView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .init(origin: .zero, size: .init(width: 580, height: 320)))
            
            let engine = Segmented(symbol: "magnifyingglass", title: "Search engine", labels: ["Google", "Ecosia"])
            engine
                .change
                .sink { selected in
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
                .store(in: &subs)
            
            let autoplay = Segmented(symbol: "play.rectangle", title: "Autoplay", labels: ["None", "Audio", "Video", "All"])
            autoplay
                .change
                .sink { selected in
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
                .store(in: &subs)
            
            let http = Switch(title: "Allow insecure connections (http)")
            http
                .change
                .sink { value in
                    Task
                        .detached(priority: .utility) {
                            await cloud.update(http: value)
                        }
                }
                .store(in: &subs)
            
            let stack = NSStackView(views: [engine, autoplay, http])
            stack.orientation = .vertical
            stack.alignment = .leading
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.setCustomSpacing(20, after: autoplay)
            addSubview(stack)
            
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
            stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 130).isActive = true
            
            cloud
                .first()
                .map(\.settings)
                .sink { settings in
                    engine.control.selectedSegment = settings.search == .google ? 0 : 1
                    http.control.state = settings.configuration.http ? .on : .off
                    
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
                .store(in: &subs)
        }
    }
}
