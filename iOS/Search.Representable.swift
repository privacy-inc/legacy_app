import SwiftUI

extension Search {
    final class Representable: UIView, UIViewRepresentable, UIKeyInput, UITextFieldDelegate {
        private var editable = true
        private let tab: () -> Void
        private let input = UIInputView(frame: .init(x: 0, y: 0, width: 0, height: 52), inputViewStyle: .keyboard)
        private weak var field: UITextField!
        override var inputAccessoryView: UIView? { input }
        override var canBecomeFirstResponder: Bool { editable }
        
        deinit {
            print("rep gone")
        }
        
        required init?(coder: NSCoder) { nil }
        init(tab: @escaping () -> Void) {
            self.tab = tab
            super.init(frame: .zero)
            
            print("rep init")
            
            let background = UIView()
            background.backgroundColor = .init(named: "Input")
            background.translatesAutoresizingMaskIntoConstraints = false
            background.isUserInteractionEnabled = false
            background.layer.cornerRadius = 12
            background.layer.borderColor = UIColor.label.withAlphaComponent(0.05).cgColor
            background.layer.borderWidth = 1
            background.layer.cornerCurve = .continuous
            input.addSubview(background)
            
            let field = UITextField()
            field.translatesAutoresizingMaskIntoConstraints = false
            field.keyboardType = .webSearch
            field.clearButtonMode = .always
            field.autocorrectionType = .no
            field.autocapitalizationType = .none
            field.spellCheckingType = .no
            field.tintColor = .label
            field.font = .preferredFont(forTextStyle: .callout)
            field.allowsEditingTextAttributes = false
            field.delegate = self
            input.addSubview(field)
            self.field = field

            background.leftAnchor.constraint(equalTo: input.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
            background.rightAnchor.constraint(equalTo: input.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
            background.centerYAnchor.constraint(equalTo: field.centerYAnchor).isActive = true
            background.heightAnchor.constraint(equalToConstant: 36).isActive = true
            
            field.centerYAnchor.constraint(equalTo: input.centerYAnchor, constant: 3).isActive = true
            field.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 16).isActive = true
            field.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -8).isActive = true
            
            DispatchQueue
                .main
                .asyncAfter(deadline: .now() + 0.3) { [weak self] in
                    self?.becomeFirstResponder()
                }
        }
        
        func textFieldDidEndEditing(_: UITextField) {
            tab()
        }
        
        func textFieldShouldReturn(_: UITextField) -> Bool {
//            let state = wrapper.session.items[state: id]
//            cloud
//                .browse(field.text!, browse: state.browse) { [weak self] in
//                    guard let id = self?.id else { return }
//                    if state.browse == $0 {
//                        if state.isError {
//                            self?.wrapper.session.tab.browse(id, $0)
//                        }
//                        self?.wrapper.session.load.send((id: id, access: $1))
//                    } else {
//                        self?.wrapper.session.tab.browse(id, $0)
//                    }
//                }
//            dismiss()
            field.resignFirstResponder()
            return true
        }
        
        func textFieldDidChangeSelection(_: UITextField) {
//            wrapper.filter = field.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        var hasText: Bool {
            get {
                field.text?.isEmpty == false
            }
            set {
                
            }
        }
        
        func textFieldShouldEndEditing(_: UITextField) -> Bool {
            editable = false
            return true
        }
        
        func insertText(_: String) {
            
        }
        
        func deleteBackward() {
            
        }
        
        func makeUIView(context: Context) -> Representable {
            self
        }
        
        func updateUIView(_: Representable, context: Context) { }
        
        @discardableResult override func becomeFirstResponder() -> Bool {
            DispatchQueue.main.async { [weak self] in
                self?.field.becomeFirstResponder()
            }
            return super.becomeFirstResponder()
        }
    }
}
