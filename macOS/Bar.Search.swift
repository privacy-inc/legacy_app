//import AppKit
//import Combine
//
//extension Bar {
//    final class Search: NSView {
//        private var subs = Set<AnyCancellable>()
//        
//        required init?(coder: NSCoder) { nil }
//        init(session: Session, id: UUID, background: Background, icon: Icon) {
//            super.init(frame: .zero)
//            translatesAutoresizingMaskIntoConstraints = false
//            
//            let back = Squircle(icon: "chevron.left", size: 15)
//            back
//                .click
//                .sink {
//                    session.back.send(id)
//                }
//                .store(in: &subs)
//            
//            let forward = Squircle(icon: "chevron.right", size: 15)
//            forward
//                .click
//                .sink {
//                    session.forward.send(id)
//                }
//                .store(in: &subs)
//            
//            let ellipsis = Button(icon: "ellipsis")
//            ellipsis
//                .click
//                .sink {
//                    Menu(session: session, id: id, origin: ellipsis)
//                        .show(relativeTo: ellipsis.bounds, of: ellipsis, preferredEdge: .minY)
//                }
//                .store(in: &subs)
//            
//            let field = Field(session: session, id: id)
//            
//            [background, back, icon, field, forward, ellipsis]
//                .forEach {
//                    addSubview($0)
//                    $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//                }
//            
//            let backOff = background.leftAnchor.constraint(equalTo: leftAnchor, constant: 5)
//            let backOn = background.leftAnchor.constraint(equalTo: back.rightAnchor, constant: 5)
//            let forwardOff = rightAnchor.constraint(equalTo: background.rightAnchor, constant: 5)
//            let forwardOn = rightAnchor.constraint(equalTo: forward.rightAnchor, constant: 5)
//            
//            session
//                .tab
//                .items
//                .map {
//                    $0[state: id].isNew
//                }
//                .removeDuplicates()
//                .sink {
//                    ellipsis.state = $0 ? .off : .on
//                    ellipsis.isHidden = $0
//                }
//                .store(in: &subs)
//            
//            session
//                .tab
//                .items
//                .map {
//                    $0[state: id].isBrowse && $0[back: id]
//                }
//                .removeDuplicates()
//                .sink { [weak self] in
//                    back.state = $0 ? .on : .off
//                    back.isHidden = !$0
//                    if $0 {
//                        backOff.isActive = false
//                        backOn.isActive = true
//                    } else {
//                        backOn.isActive = false
//                        backOff.isActive = true
//                    }
//                    
//                    self?.animate()
//                }
//                .store(in: &subs)
//            
//            session
//                .tab
//                .items
//                .map {
//                    $0[state: id].isBrowse && $0[forward: id]
//                }
//                .removeDuplicates()
//                .sink { [weak self] in
//                    forward.state = $0 ? .on : .off
//                    forward.isHidden = !$0
//                    
//                    if $0 {
//                        forwardOff.isActive = false
//                        forwardOn.isActive = true
//                    } else {
//                        forwardOn.isActive = false
//                        forwardOff.isActive = true
//                    }
//                    
//                    self?.animate()
//                }
//                .store(in: &subs)
//            
//            topAnchor.constraint(equalTo: field.topAnchor).isActive = true
//            bottomAnchor.constraint(equalTo: field.bottomAnchor).isActive = true
//            widthAnchor.constraint(equalToConstant: 280).isActive = true
//
//            background.heightAnchor.constraint(equalTo: field.heightAnchor).isActive = true
//
//            icon.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 5).isActive = true
//            
//            ellipsis.rightAnchor.constraint(equalTo: background.rightAnchor).isActive = true
//            
//            field.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 20).isActive = true
//            field.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -20).isActive = true
//            
//            back.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
//            forward.leftAnchor.constraint(equalTo: background.rightAnchor, constant: 5).isActive = true
//        }
//        
//        private func animate() {
//            NSAnimationContext.runAnimationGroup {
//                $0.duration = 0.3
//                $0.allowsImplicitAnimation = true
//                layoutSubtreeIfNeeded()
//            }
//        }
//    }
//}
