import AppKit

extension Landing {
    final class Trackers: Section {
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init()
            header.stringValue = "Trackers"
            
            bottomAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        }
    }
}
