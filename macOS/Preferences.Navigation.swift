import AppKit
import Combine

extension Preferences {
    final class Navigation: NSTabViewItem {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init(identifier: "General")
            label = "General"
            
            let engineTitle = Text()
            engineTitle.font = .preferredFont(forTextStyle: .callout)
            engineTitle.textColor = .labelColor
            engineTitle.stringValue = "Search engine"
            view!.addSubview(engineTitle)
            
            let engine = NSSegmentedControl(labels: ["Google", "Ecosia"], trackingMode: .selectOne, target: self, action: #selector(self.engine))
            engine.segmentStyle = .texturedRounded
            engine.translatesAutoresizingMaskIntoConstraints = false
            switch cloud.archive.value.settings.engine {
            case .google:
                engine.selectedSegment = 0
            case .ecosia:
                engine.selectedSegment = 1
            }
            view!.addSubview(engine)
            
            let browserTitle = Text()
            browserTitle.font = .preferredFont(forTextStyle: .callout)
            browserTitle.textColor = .secondaryLabelColor
            browserTitle.stringValue = """
You can make this app your default browser and all websites will open automatically on Privacy.
"""
            browserTitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            view!.addSubview(browserTitle)

            engineTitle.topAnchor.constraint(equalTo: view!.topAnchor, constant: 20).isActive = true
            engineTitle.leftAnchor.constraint(equalTo: engine.leftAnchor).isActive = true
            
            engine.topAnchor.constraint(equalTo: engineTitle.bottomAnchor, constant: 10).isActive = true
            engine.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
            engine.widthAnchor.constraint(equalToConstant: 280).isActive = true
            
            browserTitle.topAnchor.constraint(equalTo: engine.bottomAnchor, constant: 80).isActive = true
            browserTitle.leftAnchor.constraint(equalTo: engine.leftAnchor).isActive = true
            browserTitle.rightAnchor.constraint(equalTo: engine.rightAnchor).isActive = true
            
            if isDefault {
                let browser = Text()
                browser.stringValue = "Default Browser"
                browser.font = .font(style: .callout, weight: .medium)
                browser.textColor = .secondaryLabelColor
                view!.addSubview(browser)
                
                let icon = Image(icon: "checkmark.circle.fill")
                icon.symbolConfiguration = .init(textStyle: .title3)
                icon.contentTintColor = .controlAccentColor
                view!.addSubview(icon)
                
                browser.centerYAnchor.constraint(equalTo: icon.centerYAnchor).isActive = true
                browser.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 5).isActive = true
                
                icon.leftAnchor.constraint(equalTo: engine.leftAnchor).isActive = true
                icon.bottomAnchor.constraint(equalTo: browserTitle.topAnchor, constant: -10).isActive = true
            } else {
                let browser = Option(title: "Make default browser", image: "magnifyingglass")
                browser
                    .click
                    .sink { [weak self] in
                        LSSetDefaultHandlerForURLScheme(URL.Scheme.http.rawValue as CFString, "incognit" as CFString)
                        LSSetDefaultHandlerForURLScheme(URL.Scheme.https.rawValue as CFString, "incognit" as CFString)
                        self?.view?.window?.close()
                    }
                    .store(in: &subs)
                view!.addSubview(browser)
                
                browser.bottomAnchor.constraint(equalTo: browserTitle.topAnchor, constant: -10).isActive = true
                browser.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
            }
        }
        
        private var isDefault: Bool {
            NSWorkspace
                .shared
                .urlForApplication(toOpen: URL(string: URL.Scheme.http.rawValue + "://")!)
                .map {
                    $0.lastPathComponent == Bundle.main.bundleURL.lastPathComponent
                }
                ?? false
        }
        
        @objc private func engine(_ segmented: NSSegmentedControl) {
            switch segmented.selectedSegment {
            case 0:
                cloud.engine(.google)
            default:
                cloud.engine(.ecosia)
            }
        }
    }
}
