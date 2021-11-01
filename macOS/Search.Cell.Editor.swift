import AppKit

extension Search.Cell {
    final class Editor: NSTextView {
        override init(frame: NSRect, textContainer: NSTextContainer?) {
            super.init(frame: frame, textContainer: textContainer)
        }
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            allowsUndo = true
            isFieldEditor = true
            isRichText = false
            isContinuousSpellCheckingEnabled = false
            isAutomaticTextCompletionEnabled = false
            insertionPointColor = .labelColor
            
        }
        
        override func willOpenMenu(_ menu: NSMenu, with: NSEvent) {
            menu
                .discard {
                    $0.identifier?.rawValue.contains("search") == true
                }
                .discard {
                    $0.identifier?.rawValue.contains("openLink") == true
                }
        }
        
        override func drawInsertionPoint(in rect: NSRect, color: NSColor, turnedOn: Bool) {
            var rect = rect
            rect.size.width = 2
            super.drawInsertionPoint(in: rect, color: color, turnedOn: turnedOn)
        }
        
        override func setNeedsDisplay(_ rect: NSRect, avoidAdditionalLayout: Bool) {
            var rect = rect
            rect.size.width += 1
            super.setNeedsDisplay(rect, avoidAdditionalLayout: avoidAdditionalLayout)
        }
        
        override func paste(_ sender: Any?) {
            let clean = {
                $0
                    .replacingOccurrences(of: "\n", with: " ")
                    .replacingOccurrences(of: "\r", with: " ")
                    .replacingOccurrences(of: "\t", with: " ")
                    .replacingOccurrences(of: "  ", with: " ")
            } ((NSPasteboard.general.string(forType: .string) ?? "")
                .trimmingCharacters(in: .whitespacesAndNewlines))
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(clean, forType: .string)
            super.paste(sender)
        }
        
        override func performTextFinderAction(_ sender: Any?) {
            window?.performTextFinderAction(sender)
        }
        
        override func becomeFirstResponder() -> Bool {
            selectedTextAttributes[.backgroundColor] = NSColor.tertiaryLabelColor
            return super.becomeFirstResponder()
        }
    }
}
