import SwiftUI

extension Search {
    final class Representable: UIView, UIViewRepresentable {
        func makeUIView(context: Context) -> Representable {
            self
        }
        
        func updateUIView(_: Representable, context: Context) { }
    }
}
