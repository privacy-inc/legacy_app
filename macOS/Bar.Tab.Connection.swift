import AppKit
import Specs

extension Bar.Tab {
    final class Connection: NSPopover {
        required init?(coder: NSCoder) { nil }
        init(history: UInt16) {
            super.init()
            behavior = .semitransient
            contentSize = .init(width: 450, height: 130)
            contentViewController = .init()
            contentViewController!.view = .init(frame: .init(origin: .zero, size: contentSize))
            
            let icon = Image(vibrancy: true)
            icon.symbolConfiguration = .init(textStyle: .largeTitle, scale: .large)
                .applying(.init(hierarchicalColor: .secondaryLabelColor))
            contentViewController!.view.addSubview(icon)
            
            let message = Text(vibrancy: true)
            message.textColor = .secondaryLabelColor
            message.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            
            contentViewController!.view.addSubview(message)
            
            icon.centerYAnchor.constraint(equalTo: contentViewController!.view.centerYAnchor).isActive = true
            icon.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 20).isActive = true
            
            message.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 10).isActive = true
            message.centerYAnchor.constraint(equalTo: contentViewController!.view.centerYAnchor).isActive = true
            message.rightAnchor.constraint(lessThanOrEqualTo: contentViewController!.view.rightAnchor, constant: -30).isActive = true
            
            Task {
                guard
                    let access = await cloud.website(history: history)?.access,
                    let remote = access as? Access.Remote
                else { return }
                
                switch remote.url?.scheme {
                case "https":
                    icon.image = .init(systemSymbolName: "lock.fill", accessibilityDescription: nil)
                    message.attributedStringValue = .init(.init("Using an encrypted connnection to \(remote.domain.minimal)\n",
                                                                attributes: .init([
                                                                    .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .medium)]))
                                                        + .init("Encryption with a digital certificate keeps information private as it's sent to or from the https website.", attributes:
                                                                        .init([.font: NSFont.preferredFont(forTextStyle: .footnote)])))
                case "http":
                    icon.image = .init(systemSymbolName: "exclamationmark.triangle.fill", accessibilityDescription: nil)
                    message.attributedStringValue = .init(.init("Using an insecure connnection to \(remote.domain.minimal)\n",
                                                                attributes: .init([
                                                                    .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .medium)]))
                                                        + .init("Information is not private and might be compromised as it's sent to or from the http website.", attributes:
                                                                        .init([.font: NSFont.preferredFont(forTextStyle: .footnote)])))
                default:
                    break
                }
            }
        }
    }
}
