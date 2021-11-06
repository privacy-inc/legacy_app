import AppKit
import Combine

extension Preferences {
    final class Features: NSTabViewItem {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init(identifier: "Features")
            label = "Features"
//            
//            let spell = Switch(title: "Spell checking")
//            spell.value.send(Defaults.spell)
//            spell
//                .value
//                .sink {
//                    Defaults.spell = $0
//                }
//                .store(in: &subs)
//            
//            let correction = Switch(title: "Auto correction")
//            correction.value.send(Defaults.correction)
//            correction
//                .value
//                .sink {
//                    Defaults.correction = $0
//                }
//                .store(in: &subs)
//            
//            var top = view!.topAnchor
//            [spell, correction]
//                .forEach {
//                    view!.addSubview($0)
//                    
//                    $0.topAnchor.constraint(equalTo: top, constant: top == view!.topAnchor ? 40 : 10).isActive = true
//                    $0.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
//                    top = $0.bottomAnchor
//                }
        }
    }
}
