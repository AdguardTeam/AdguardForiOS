
import Foundation

protocol RuleDetailsControllerDelegate {
    func removeRule(rule: RuleInfo)
    func changeRule(rule: RuleInfo, newText: String)
}

class RuleDetailsController : BottomAlertController, UITextViewDelegate {
    
    let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    let enabledLineColor = UIColor(hexString: "#4D4D4D")
    let disabledLineColor = UIColor(hexString: "#D8D8D8")

    var rule: RuleInfo?
    var delegate : RuleDetailsControllerDelegate?
    
    var type: RulesType = .safariUserfilter
    
    // MARK: IB outlets
    
    @IBOutlet weak var ruleTextView: UITextView!
    @IBOutlet weak var textUnderline: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet var separators: [UIView]!
    @IBOutlet weak var domainOrRuleLabel: ThemableLabel!
    
    private let textViewCharectersLimit = 50
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        domainOrRuleLabel.text = getEditCaptionText()

        
        ruleTextView.text = type == .wifiExceptions ? String(rule?.rule.prefix(textViewCharectersLimit) ?? "") : rule?.rule
        
        ruleTextView.textContainer.lineFragmentPadding = 0
        ruleTextView.textContainerInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        
        if (type == .safariWhitelist || type == .invertedSafariWhitelist || type == .systemWhitelist){
            ruleTextView.keyboardType = .URL
        }
        
        if type == .safariUserfilter {
            ruleTextView.font = UIFont(name: "PTMono-Regular", size: 14.0)
            ruleTextView.sizeToFit()
        }
                
        updateTheme()
        
        saveButton.makeTitleTextUppercased()
        removeButton.makeTitleTextUppercased()
        cancelButton.makeTitleTextUppercased()
    }
    
    // MARK: - Actions
    @IBAction func saveAction(_ sender: Any) {
        
        let ruleText = ruleTextView.text ?? ""
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
    
        saveButton.isEnabled = updatedText.count > 0
        
        if type != .wifiExceptions { return true }
    
        if updatedText.count >= textViewCharectersLimit {
            textView.text = String(updatedText.prefix(textViewCharectersLimit))
            return false
        }
        return true
    }
    
    // MARK: - private methods
    
    private func updateTheme() {
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupPopupLabels(themableLabels)
        theme.setupTextView(ruleTextView)
        theme.setupSeparators(separators)
    }
    
    private func getEditCaptionText() -> String {
        switch type {
        case .safariUserfilter:
            return ACLocalizedString("add_blacklist_rule_caption", nil)
        case .systemBlacklist:
            return ACLocalizedString("add_blacklist_rule_caption", nil)
        case .systemWhitelist:
            return ACLocalizedString("add_whitelist_domain_caption", nil)
        case .safariWhitelist:
            return ACLocalizedString("add_whitelist_domain_caption", nil)
        case .invertedSafariWhitelist:
            return ACLocalizedString("add_whitelist_domain_caption", nil)
        case .wifiExceptions:
            return ACLocalizedString("add_wifi_name_caption", nil)
        }
    }
}
