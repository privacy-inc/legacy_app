//import AppKit
//import Combine
//
//extension Bar {
//    final class Thumbnail: Control {
//        private var subs = Set<AnyCancellable>()
//        private let id: UUID
//        private let session: Session
//        
//        required init?(coder: NSCoder) { nil }
//        init(session: Session, id: UUID, icon: Icon) {
//            self.id = id
//            self.session = session
//            
//            super.init(layer: true)
//            layer!.cornerRadius = 5
//            addSubview(icon)
//            menu = NSMenu()
//            menu!.items = [.child("Close", #selector(close)) {
//                $0.target = self
//                $0.image = .init(systemSymbolName: "xmark", accessibilityDescription: nil)
//            }]
//            
//            let text = Text()
//            text.textColor = .tertiaryLabelColor
//            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//            addSubview(text)
//            
//            cloud
//                .archive
//                .combineLatest(session
//                                .tab
//                                .items
//                                .map {
//                                    $0[state: id]
//                                        .browse
//                                }
//                                .compactMap {
//                                    $0
//                                })
//                .map {
//                    $0.0
//                        .page($0.1)
//                        .access
//                        .short
//                }
//                .removeDuplicates()
//                .sink {
//                    text.stringValue = $0
//                }
//                .store(in: &subs)
//            
//            click
//                .sink {
//                    session
//                        .current
//                        .send(id)
//                }
//                .store(in: &subs)
//            
//            heightAnchor.constraint(equalToConstant: 28).isActive = true
//            rightAnchor.constraint(lessThanOrEqualTo: text.rightAnchor, constant: 5).isActive = true
//            rightAnchor.constraint(greaterThanOrEqualTo: icon.rightAnchor, constant: 5).isActive = true
//            
//            let rightText = rightAnchor.constraint(equalTo: text.rightAnchor, constant: 5)
//            rightText.priority = .defaultLow
//            rightText.isActive = true
//            
//            let rightIcon = rightAnchor.constraint(greaterThanOrEqualTo: icon.rightAnchor, constant: 5)
//            rightIcon.priority = .defaultLow
//            rightIcon.isActive = true
//            
//            icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//            icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
//            
//            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//            text.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 5).isActive = true
//        }
//        
//        override func update() {
//            super.update()
//            
//            switch state {
//            case .pressed, .highlighted:
//                layer!.backgroundColor = NSColor.quaternaryLabelColor.cgColor
//            default:
//                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.025).cgColor
//            }
//        }
//        
//        override var allowsVibrancy: Bool {
//            true
//        }
//        
//        @objc private func close() {
//            session
//                .close
//                .send(id)
//        }
//    }
//}
