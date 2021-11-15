import AppKit
import Combine

extension Preferences {
    final class Bar: NSView {
        private var sub: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            
            let navigation = Text(vibrancy: true)
            navigation.font = .preferredFont(forTextStyle: .title3)
            navigation.textColor = .secondaryLabelColor
            navigation.stringValue = "Preferences"
            addSubview(navigation)
            
            let icon = Image(vibrancy: true)
            icon.symbolConfiguration = .init(textStyle: .title3)
            icon.contentTintColor = .secondaryLabelColor
            icon.image = .init(systemSymbolName: "gear", accessibilityDescription: nil)
            addSubview(icon)
            
            let option = Promotion()
            sub = option
                .click
                .sink {
                    NSApp.showPrivacyPlus()
                }
            addSubview(option)
            
            navigation.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            navigation.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 5).isActive = true
            
            icon.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            option.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            option.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }
}
