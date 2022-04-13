import AppKit
import Combine

extension Preferences {
    final class Blocker: NSVisualEffectView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .init(origin: .zero, size: .init(width: 580, height: 390)))
            
            let trackers = Switch(title: "Block trackers")
            trackers
                .change
                .sink { value in
                    Task
                        .detached(priority: .utility) {
                            await cloud.update(policy: value ? .secure : .standard)
                        }
                }
                .store(in: &subs)
            
            let cookies = Switch(title: "Block cookies")
            cookies
                .change
                .sink { value in
                    Task
                        .detached(priority: .utility) {
                            await cloud.update(cookies: !value)
                        }
                }
                .store(in: &subs)
            
            let ads = Switch(title: "Block ads")
            ads
                .change
                .sink { value in
                    Task
                        .detached(priority: .utility) {
                            await cloud.update(ads: !value)
                        }
                }
                .store(in: &subs)
            
            let popups = Switch(title: "Block pop-ups")
            popups
                .change
                .sink { value in
                    Task
                        .detached(priority: .utility) {
                            await cloud.update(popups: !value)
                        }
                }
                .store(in: &subs)
            
            let third = Switch(title: "Block third-party scripts")
            third
                .change
                .sink { value in
                    Task
                        .detached(priority: .utility) {
                            await cloud.update(third: !value)
                        }
                }
                .store(in: &subs)
            
            let stack = NSStackView(views: [trackers, cookies, ads, popups, third])
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
                    trackers.control.state = settings.policy == .secure ? .on : .off
                    cookies.control.state = settings.configuration.cookies ? .off : .on
                    ads.control.state = settings.configuration.ads ? .off : .on
                    popups.control.state = settings.configuration.popups ? .off : .on
                    third.control.state = settings.configuration.third ? .off : .on
                }
                .store(in: &subs)
        }
    }
}
