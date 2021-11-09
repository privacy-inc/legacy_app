import AppKit

extension NSAttributedString {
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
}
