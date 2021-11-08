import AppKit

extension AttributedString {
    static let newLine = Self("\n")
    
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
