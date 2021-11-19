import AppKit

extension NSMutableAttributedString {
    func newLine() {
        append(.init(string: "\n"))
    }
}
