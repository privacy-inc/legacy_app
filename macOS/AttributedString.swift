import AppKit

extension AttributedString {
    static let newLine = Self("\n")
    
    static func with(markdown: String, attributes: AttributeContainer) -> Self {
        do {
            var string = try AttributedString(markdown: markdown, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace))
            string.setAttributes(attributes)
            return string
        } catch {
            return .init(markdown, attributes: attributes)
        }
    }
    
    func with(truncating: NSLineBreakMode) -> Self {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = truncating
        
        var string = self
        string.paragraphStyle = style
        return string
    }
    
    func with(alignment: NSTextAlignment) -> Self {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        
        var string = self
        string.paragraphStyle = style
        return string
    }
}
