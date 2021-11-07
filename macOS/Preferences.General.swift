import AppKit

extension Preferences {
    final class General: NSTabViewItem {
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init(identifier: "")
            label = "General"
            
            let stack = NSStackView(views: [Notifications(), Separator(mode: .vertical), Browser()])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.spacing = 40
            stack.alignment = .top
            view!.addSubview(stack)
            
            stack.topAnchor.constraint(equalTo: view!.topAnchor, constant: 30).isActive = true
            stack.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
        }
    }
}
