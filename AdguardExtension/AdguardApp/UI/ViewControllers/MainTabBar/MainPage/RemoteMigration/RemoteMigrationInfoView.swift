import UIKit

protocol RemoteMigrationInfoViewDelegate : AnyObject {
    func linkTapped(for type: RemoteMigrationInfoView.ContentType)
    func closeButtonTapped()
}

/// View that inform user about remote migration in old and new AdGuard Apps
final class RemoteMigrationInfoView : UIView {

    weak var delegate: RemoteMigrationInfoViewDelegate?

    private var contentType: ContentType = .infoDialog

    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationServiceProtocol = ServiceLocator.shared.getService()!

    private var newAppLicensePurchased: Bool { configuration.proStatus && Bundle.main.isAslApp }

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = .systemFont(ofSize: isIpadTrait ? 24.0 : 14.0, weight: .regular)
        textView.linkTextAttributes = [
            .foregroundColor: contentType.linkColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        return textView
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "cross_original"), for: .normal)
        return button
    }()

    init(contentType: ContentType) {
        self.contentType = contentType
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }



    private func configureUI() {
        prepareConstraints()
        textView.delegate = self
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        updateTheme()
    }

    private func prepareConstraints() {
        addSubview(textView)
        addSubview(closeButton)

        let topBottomConst = 8.0
        let leadingTrailingConst = 16.0
        let heightWidthConst = isIpadTrait ? 32.0 : 24.0

        /// Activate common constraints
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: topBottomConst),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingTrailingConst),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topBottomConst),

            closeButton.leadingAnchor.constraint(equalTo: textView.trailingAnchor, constant: leadingTrailingConst),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leadingTrailingConst),
            closeButton.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: heightWidthConst),
            closeButton.widthAnchor.constraint(equalToConstant: heightWidthConst)
        ])
    }

    @objc
    private func closeButtonTapped() {
        delegate?.closeButtonTapped()
    }

    private func setupText() {
        let fontSize = isIpadTrait ? 24.0 : 14.0
        if newAppLicensePurchased {
            textView.text = nil
            textView.text = contentType.licensePurchasedTitle
            textView.textColor = theme.grayTextColor
            textView.font = .systemFont(ofSize: fontSize, weight: .regular)
        } else {
            textView.attributedText = nil
            textView.setAttributedTitle(contentType.title, fontSize: fontSize, color: theme.grayTextColor)
        }
    }
}

extension RemoteMigrationInfoView : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == ContentType.infoDialog.link {
            delegate?.linkTapped(for: .infoDialog)
        } else if URL.absoluteString == ContentType.legacyAppDialog.link {
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
        setupText()
    }
}

extension RemoteMigrationInfoView {
    enum ContentType {
        case infoDialog
        case legacyAppDialog

        var title: String {
            switch self {
                case .infoDialog:
                    let formatted = String(format: titleCommonString, link)
                    return formatted
                case .legacyAppDialog:
                    let formattedLink = String(format: String.localizedString("remote_migration_info_view_learn_more"), link)
                    let formatted = String(format: titleCommonString, formattedLink)
                    return formatted
            }
        }

        var licensePurchasedTitle: String {
            switch self {
                case .infoDialog: return ""
                case .legacyAppDialog:
                    return String.localizedString("remote_migration_info_view_delete_suggestion")
            }
        }

        var link: String {
            let scheme = Bundle.main.isPro ? "adguardpro" : "adguard"
            switch self {
                case .infoDialog: return "\(scheme)://RemoteMigrationDialog"
                case .legacyAppDialog: return "\(scheme)://LegacyAppDialog"
            }
        }

        var linkColor: UIColor {
            switch self {
                case .infoDialog: return UIColor.AdGuardColor.red
                case .legacyAppDialog: return UIColor.AdGuardColor.green
            }
        }

        private var titleCommonString: String {
            switch self {
                case .infoDialog: return String.localizedString("remote_migration_info_view_need_migration")
                case .legacyAppDialog: return String.localizedString("remote_migration_info_view_old_app_detected")
            }
        }
    }
}
