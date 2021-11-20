import AppKit

extension NSAttributedString {
    class func make(transform: (NSMutableAttributedString) -> Void) -> NSAttributedString {
        let mutable = NSMutableAttributedString()
        transform(mutable)
        return mutable
    }
    
    class func make(alignment: NSTextAlignment, transform: (NSMutableAttributedString) -> Void) -> NSAttributedString {
        let mutable = NSMutableAttributedString()
        transform(mutable)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        mutable.addAttribute(.paragraphStyle, value: paragraph, range: .init(location: 0, length: mutable.length))
        return mutable
    }
    
    class func make(lineBreak: NSLineBreakMode, transform: (NSMutableAttributedString) -> Void) -> NSAttributedString {
        let mutable = NSMutableAttributedString()
        transform(mutable)
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = lineBreak
        mutable.addAttribute(.paragraphStyle, value: paragraph, range: .init(location: 0, length: mutable.length))
        return mutable
    }
    
    class func make(_ string: String, attributes: [NSAttributedString.Key : Any]) -> Self {
        .init(string: string, attributes: attributes)
    }
    
    class func make(_ string: String, attributes: [NSAttributedString.Key : Any], alignment: NSTextAlignment) -> Self {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        var attributes = attributes
        attributes[.paragraphStyle] = paragraph
        return .init(string: string, attributes: attributes)
    }
    
    class func make(_ string: String, attributes: [NSAttributedString.Key : Any], lineBreak: NSLineBreakMode) -> Self {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = lineBreak
        var attributes = attributes
        attributes[.paragraphStyle] = paragraph
        return .init(string: string, attributes: attributes)
    }
    
    class func with(markdown: String, attributes: [NSAttributedString.Key : Any]) -> NSAttributedString {
        do {
            let string = try NSMutableAttributedString(markdown: markdown, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace))
            string.addAttributes(attributes, range: .init(location: 0, length: string.length))
            return string
        } catch {
            return .init(string: markdown, attributes: attributes)
        }
    }
    
    func height(for width: CGFloat) -> CGFloat {
        CTFramesetterSuggestFrameSizeWithConstraints(
            CTFramesetterCreateWithAttributedString(self),
            CFRange(),
            nil,
            .init(width: width,
                  height: .greatestFiniteMagnitude),
            nil)
            .height
    }
    
    func width(for height: CGFloat) -> CGFloat {
        CTFramesetterSuggestFrameSizeWithConstraints(
            CTFramesetterCreateWithAttributedString(self),
            CFRange(),
            nil,
            .init(width: .greatestFiniteMagnitude,
                  height: height),
            nil)
            .width
    }
}
