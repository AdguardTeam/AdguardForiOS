
import Foundation

protocol RuleDetailsControllerDelegate {
    func removeRule(rule: RuleInfo)
    func changeRule(rule: RuleInfo, newText: String)
}

class RuleDetailsController : BottomAlertController {
    
    let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    let enabledLineColor = UIColor(hexString: "#4D4D4D")
    let disabledLineColor = UIColor(hexString: "#D8D8D8")

    var blacklist = false
    var rule: RuleInfo?
    var delegate : RuleDetailsControllerDelegate?
    
    // MARK: IB outlets
    
    @IBOutlet weak var domainTextField: UITextField!
    @IBOutlet weak var textUnderline: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        domainTextField.text = rule?.rule
        domainTextField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        saveButton.isEnabled = false
        
        updateTheme()
    }
    
    // MARK: - UITextField
    
    @IBAction func editingChanged(_ sender: UITextField) {
        
        saveButton.isEnabled = sender.text != rule?.rule
    }
    
    // MARK: - Actions
    @IBAction func saveAction(_ sender: Any) {
        
        rule!.rule = domainTextField.text ?? ""
        delegate?.changeRule(rule: rule!, newText: domainTextField.text ?? "")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeAction(_ sender: Any) {
        
        delegate?.removeRule(rule: rule!)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - private methods
    
    func updateButtons() {
        
        textUnderline.backgroundColor = domainTextField.isEditing ? enabledLineColor : disabledLineColor
        saveButton.isEnabled = !(domainTextField.text?.isEmpty ?? true) && domainTextField.text != rule?.rule
    }
    
    func updateTheme() {
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupPopupLabels(themableLabels)
        theme.setupTextField(domainTextField)
    }
}
