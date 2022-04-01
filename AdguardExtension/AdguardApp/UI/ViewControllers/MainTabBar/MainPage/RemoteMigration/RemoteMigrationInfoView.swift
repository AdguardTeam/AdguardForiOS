import UIKit

protocol RemoteMigrationInfoViewDelegate : AnyObject {
    func linkTapped(for type: RemoteMigrationInfoView.TextType)
}

final class RemoteMigrationInfoView : UIView {

    weak var delegate: RemoteMigrationInfoViewDelegate?

    var textType: TextType = .infoDialog

    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = .systemFont(ofSize: isIpadTrait ? 24.0 : 14.0, weight: .regular)
        textView.linkTextAttributes = [
            .foregroundColor: UIColor.AdGuardColor.red,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        return textView
    }()

    init(textType: TextType) {
        self.textType = textType
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    func setAttributedString(_ title: String?) {
        if let title = title {
            let fontSize = isIpadTrait ? 24.0 : 16.0
            textView.setAttributedTitle(title, fontSize: fontSize, color: theme.blackTextColor)
            return
        }
        textView.attributedText = nil
    }



    private func configureUI() {
        addSubview(textView)
        textView.delegate = self

        let topBottomConst = 8.0
        let leadingTrailingConst = 16.0

        NSLayoutConstraint.activate([

            textView.topAnchor.constraint(equalTo: topAnchor, constant: topBottomConst),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingTrailingConst),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leadingTrailingConst),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topBottomConst)
        ])

        textView.setAttributedTitle(textType.title, fontSize: isIpadTrait ? 24.0 : 14.0, color: theme.backgroundColor)
    }
}

extension RemoteMigrationInfoView : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == TextType.infoDialog.link {
            delegate?.linkTapped(for: .infoDialog)
        } else if URL.absoluteString == TextType.legacyAppDialog.link {
            delegate?.linkTapped(for: .legacyAppDialog)
        }

        return false
    }
}

extension RemoteMigrationInfoView : ThemableProtocol {
    func updateTheme() {
        backgroundColor = theme.notificationWindowColor
        layer.cornerRadius = 8.0
        textView.backgroundColor = .clear
        textView.setAttributedTitle(textType.title, fontSize: isIpadTrait ? 24.0 : 14.0, color: theme.lightGrayTextColor)
        textView.textColor = theme.grayTextColor
    }
}

extension RemoteMigrationInfoView {
    enum TextType {
        case infoDialog
        case legacyAppDialog

        var title: String {
            switch self {
                case .infoDialog:
                    let formatted = String(format: String.localizedString("remote_migration_info_view_need_migration"), link)
                    return formatted
                case .legacyAppDialog:
                    let formatted = String(format: String.localizedString("remote_migration_info_view_old_app_detected"), link)
                    return formatted
            }
        }

        var link: String {
            let scheme = Bundle.main.isPro ? "adguardpro" : "adguard"
            switch self {
                case .infoDialog: return "\(scheme)://RemoteMigrationDialog"
                case .legacyAppDialog: return "\(scheme)://LegacyAppDialog"
            }
        }
    }
}
