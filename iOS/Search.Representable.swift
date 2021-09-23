import SwiftUI

extension Search {
    final class Representable: UIView, UIViewRepresentable {
//        var hasText = false
//
//        func insertText(_ text: String) {
//
//        }
//
//        func deleteBackward() {
//
//        }
        
//        let input = UIInputView(frame: .init(x: 0, y: 0, width: 330, height: 48), inputViewStyle: .keyboard)
//        override var inputAccessoryView: UIView? { input }
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
//            backgroundColor = .red
            
            let background = UIView()
            background.backgroundColor = .systemBackground.withAlphaComponent(0.2)
            background.translatesAutoresizingMaskIntoConstraints = false
            background.isUserInteractionEnabled = false
            background.layer.cornerRadius = 13
            background.layer.borderColor = UIColor.label.withAlphaComponent(0.1).cgColor
            background.layer.borderWidth = 1
            background.layer.cornerCurve = .continuous
            addSubview(background)
            
            
            
            let field = UITextField(frame: .init(x: 80, y: 0, width: 240, height: 50))
//            field.translatesAutoresizingMaskIntoConstraints = false
            field.clearButtonMode = .always
            field.autocorrectionType = .no
            field.autocapitalizationType = .none
            field.spellCheckingType = .no
//            field.backgroundColor = .clear
            field.tintColor = .label
            field.font = .preferredFont(forTextStyle: .callout)
            field.allowsEditingTextAttributes = false
//            field.delegate = self
            field.borderStyle = .none
            addSubview(field)
//            self.field = field
            
            
            
            background.leftAnchor.constraint(equalTo: field.leftAnchor, constant: -16).isActive = true
            background.rightAnchor.constraint(equalTo: field.rightAnchor, constant: 8).isActive = true
            background.centerYAnchor.constraint(equalTo: field.centerYAnchor).isActive = true
            background.heightAnchor.constraint(equalToConstant: 38).isActive = true
            
            
            
            
            
            
            
            
            
            
            
//            let input = UIInputView(frame: .init(x: 0, y: 0, width: 300, height: 48), inputViewStyle: .keyboard)
//            input.translatesAutoresizingMaskIntoConstraints = false
//            self.inputAccessoryView = input
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
//            addSubview(input)
            
//            input.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
//            input.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//            input.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        }
        
        func makeUIView(context: Context) -> Representable {
            self
        }
        
        func updateUIView(_: Representable, context: Context) { }
    }
}
