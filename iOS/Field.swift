import SwiftUI
import Combine
import Specs

final class Field: UIView, UIViewRepresentable, UIKeyInput, UITextFieldDelegate {
    let websites = PassthroughSubject<[Website], Never>()
    private weak var field: UITextField!
    private var editable = true
    private var sub: AnyCancellable?
    private let session: Session
    private let input = UIInputView(frame: .init(x: 0, y: 0, width: 0, height: 52), inputViewStyle: .keyboard)
    private let filter = CurrentValueSubject<_, Never>("")
    
    deinit {
        print("gone")
    }
    
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        self.session = session
        super.init(frame: .zero)
        
        print("field init")
        
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
        field.textContentType = .URL
        field.clearButtonMode = .always
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.spellCheckingType = .no
        field.tintColor = .label
        field.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize + 2, weight: .regular)
        field.allowsEditingTextAttributes = false
        field.delegate = self
        input.addSubview(field)
        self.field = field
        
        background.leftAnchor.constraint(equalTo: input.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        background.rightAnchor.constraint(equalTo: input.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        background.centerYAnchor.constraint(equalTo: field.centerYAnchor).isActive = true
        background.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        field.centerYAnchor.constraint(equalTo: input.centerYAnchor, constant: 3).isActive = true
        field.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 12).isActive = true
        field.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -6).isActive = true
        
        sub = cloud
            .combineLatest(filter
                .removeDuplicates()) {
                    $0.websites(filter: $1)
                }
                .sink { [weak self] in
                    self?.websites.send($0)
                }
    }
    
    func cancel() {
        field.text = ""
        field.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_: UITextField) -> Bool {
//        searching(field.text!)
        field.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_: UITextField) {
        filter.send(field.text!)
    }
    
    var hasText: Bool {
        get {
            field.text?.isEmpty == false
        }
        set {
            
        }
    }
    
    override var inputAccessoryView: UIView? {
        input
    }
    
    override var canBecomeFirstResponder: Bool {
        editable
    }
    
    func textFieldShouldEndEditing(_: UITextField) -> Bool {
        editable = false
        return true
    }
    
    func textFieldDidEndEditing(_: UITextField) {
        editable = true
    }
    
    func insertText(_: String) {
        
    }
    
    func deleteBackward() {
        
    }
    
    func makeUIView(context: Context) -> Field {
        self
    }
    
    func updateUIView(_: Field, context: Context) { }
    
    @discardableResult override func becomeFirstResponder() -> Bool {
        DispatchQueue.main.async { [weak self] in
            self?.field.becomeFirstResponder()
        }
        return super.becomeFirstResponder()
    }
}
