
import Foundation

protocol RuleDetailsControllerDelegate {
    func removeRule(rule: RuleInfo)
    func changeRule(rule: RuleInfo, newText: String)
}

class RuleDetailsController : BottomAlertController, UITextViewDelegate {
    
    let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    let enabledLineColor = UIColor(hexString: "#4D4D4D")
    let disabledLineColor = UIColor(hexString: "#D8D8D8")

    var blacklist = false
    var rule: RuleInfo?
    var delegate : RuleDetailsControllerDelegate?
    
    // MARK: IB outlets
    
    @IBOutlet weak var ruleTextView: UITextView!
    @IBOutlet weak var textUnderline: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ruleTextView.text = rule?.rule
        saveButton.isEnabled = false
        
        ruleTextView.textContainer.lineFragmentPadding = 0
        ruleTextView.textContainerInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        
        ruleTextView.keyboardType = blacklist ? .default : .URL
        
        updateTheme()
    }
    
    // MARK: - Actions
    @IBAction func saveAction(_ sender: Any) {
        
        let ruleText = ruleTextView.text ?? ""
        rule!.rule = ruleText
        delegate?.changeRule(rule: rule!, newText: ruleText)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeAction(_ sender: Any) {
        
        delegate?.removeRule(rule: rule!)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITExtViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        updateButtons()
    }
    
    // MARK: - private methods
    
    func updateButtons() {
        saveButton.isEnabled = !(ruleTextView.text?.isEmpty ?? true) && ruleTextView.text != rule?.rule
    }
    
    func updateTheme() {
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupPopupLabels(themableLabels)
        theme.setupTextView(ruleTextView)
    }
}
