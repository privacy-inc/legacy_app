import AppKit
import Combine

extension Preferences {
    final class Bar: NSVisualEffectView {
        private var sub: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            material = .sidebar
            state = .active
            
            let vibrant = Vibrant(layer: false)
            vibrant.translatesAutoresizingMaskIntoConstraints = false
            addSubview(vibrant)
            
            let navigation = Text(vibrancy: true)
            navigation.font = .preferredFont(forTextStyle: .title3)
            navigation.textColor = .secondaryLabelColor
            navigation.stringValue = "Preferences"
            vibrant.addSubview(navigation)
            
            let icon = Image()
            icon.symbolConfiguration = .init(textStyle: .title3)
                .applying(.init(hierarchicalColor: .secondaryLabelColor))
            icon.image = .init(systemSymbolName: "gear", accessibilityDescription: nil)
            vibrant.addSubview(icon)
            
            let option = Promotion()
            sub = option
                .click
                .sink {
//                    NSApp.showPrivacyPlus()
                }
            addSubview(option)
            
            vibrant.topAnchor.constraint(equalTo: topAnchor).isActive = true
            vibrant.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            vibrant.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            vibrant.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            
            navigation.centerYAnchor.constraint(equalTo: vibrant.centerYAnchor).isActive = true
            navigation.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 6).isActive = true
            
            icon.leftAnchor.constraint(equalTo: vibrant.leftAnchor, constant: 5).isActive = true
            icon.centerYAnchor.constraint(equalTo: vibrant.centerYAnchor).isActive = true
            
            option.rightAnchor.constraint(equalTo: vibrant.rightAnchor, constant: -10).isActive = true
            option.centerYAnchor.constraint(equalTo: vibrant.centerYAnchor).isActive = true
        }
    }
}
