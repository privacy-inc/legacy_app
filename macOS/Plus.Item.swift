import AppKit
import StoreKit
import Combine

extension Plus {
    final class Item: NSView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(product: Product) {
            super.init(frame: .zero)
            
            let text = Text(vibrancy: true)
            text.attributedStringValue = .make {
                $0.append(.make(product.description, attributes: [
                    .font: NSFont.preferredFont(forTextStyle: .title3),
                    .foregroundColor: NSColor.secondaryLabelColor],
                                alignment: .center))
                $0.newLine()
                $0.newLine()
                $0.append(.make(product.displayPrice, attributes: [
                    .font: NSFont.monospacedDigitSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .regular),
                    .foregroundColor: NSColor.labelColor],
                                alignment: .center))
            }
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(text)
            
            let action = Action(title: "Purchase", color: .systemBlue, foreground: .white)
            addSubview(action)
            action
                .click
                .sink {
                    Task {
                        await store.purchase(product)
                    }
                }
                .store(in: &subs)
            
            let already = Text(vibrancy: true)
            already.stringValue = "Already supporting Privacy?"
            already.textColor = .secondaryLabelColor
            already.font = .preferredFont(forTextStyle: .footnote)
            addSubview(already)
            
            let restore = Option(title: "Restore purchases", image: "leaf.arrow.triangle.circlepath")
            addSubview(restore)
            restore
                .click
                .sink {
                    Task {
                        await store.restore()
                    }
                }
                .store(in: &subs)
         
            text.topAnchor.constraint(equalTo: topAnchor).isActive = true
            text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            text.widthAnchor.constraint(equalToConstant: 245).isActive = true
            
            action.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 10).isActive = true
            action.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            
            already.bottomAnchor.constraint(equalTo: restore.topAnchor, constant: -5).isActive = true
            already.leftAnchor.constraint(equalTo: restore.leftAnchor).isActive = true
            
            restore.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            restore.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
    }
}
