
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
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet weak var domainOrRuleLabel: ThemableLabel!
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        domainOrRuleLabel.text = getEditCaptionText()

        
        ruleTextView.text = rule?.rule
        
        ruleTextView.textContainer.lineFragmentPadding = 0
        ruleTextView.textContainerInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        
        ruleTextView.keyboardType = type == .safariUserfilter ? .default : .URL
        
        updateTheme()
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
    
    func textViewDidChange(_ textView: UITextView) {
        updateButtons()
    }
    
    // MARK: - private methods
    
    private func updateButtons() {
        saveButton.isEnabled = !(ruleTextView.text?.isEmpty ?? true) && ruleTextView.text != rule?.rule
    }
    
    private func updateTheme() {
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupPopupLabels(themableLabels)
        theme.setupTextView(ruleTextView)
    }
    
    private func getEditCaptionText() -> String {
        switch type {
        case .safariUserfilter:
            return ACLocalizedString("add_blacklist_rule_caption", nil)
        case .systemBlacklist:
            return ACLocalizedString("add_whitelist_domain_caption", nil)
        case .systemWhitelist:
            return ACLocalizedString("add_whitelist_domain_caption", nil)
        case .safariWhitelist:
            return ACLocalizedString("add_whitelist_domain_caption", nil)
        case .invertedSafariWhitelist:
            return ACLocalizedString("add_whitelist_domain_caption", nil)
        }
    }
}
