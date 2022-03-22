import UIKit

enum MigrationDialogType {
    case detectedAdGuard
    case detectedAdGuardPro
    case migrationDone
    case processMigration
}

final class NewAppMigrationDialog : BottomAlertController {

    let type: MigrationDialogType

    // TODO: make puller like custom view
    private lazy var puller: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.numberOfLines = 0
        // FIXME: Set font and text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.numberOfLines = 0
        // FIXME: Set font and text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var primatyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        // FIXME: Set font and text
        return button
    }()

    private lazy var neutralButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        // FIXME: Set font and text
        return button
    }()

    private lazy var _contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(type: MigrationDialogType) {
        self.type = type
        super.init()
    }


    private func configureUI() {
        self.contentView = contentView
        view.addSubview(contentView)
        contentView.addSubview(puller)
        contentView.addSubview(titleLabel)


        let pullerWidth = isIpadTrait ? 64.0 : 32.0
        let pullerHeight = isIpadTrait ? 4.0 : 2.0
        let topConst = 24.0
        let leadingTrailingConst = 16.0

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: topConst),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            puller.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            puller.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            puller.widthAnchor.constraint(equalToConstant: pullerWidth),
            puller.heightAnchor.constraint(equalToConstant: pullerHeight),

            titleLabel.topAnchor.constraint(equalTo: puller.bottomAnchor, constant: topConst),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingTrailingConst),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -leadingTrailingConst),
        ])






    }


    private func attachUIElements() {
        switch type {
            case .detectedAdGuard:

            case .detectedAdGuardPro:

            case .migrationDone:

            case .processMigration:

        }
    }

    private func createUIForDetectedAdGuard() {

    }

    private func attachDescriptionLabel() {
        let topConst = 24.0
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: topConst),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
    }

    private func attachPrimaryButton(to view: UIButton) {
        let topConst = 24.0
        contentView.addSubview(primatyButton)
        NSLayoutConstraint.activate([
            primatyButton.topAnchor.constraint(equalTo: view.topAnchor, constant: topConst),
            primatyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            primatyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func attachNeutralButton() {
        let topConst = 24.0
        let bottomConst = 40.0
        contentView.addSubview(neutralButton)
        NSLayoutConstraint.activate([
            neutralButton.topAnchor.constraint(equalTo: primatyButton.bottomAnchor, constant: topConst),
            neutralButton.leadingAnchor.constraint(equalTo: primatyButton.leadingAnchor),
            neutralButton.trailingAnchor.constraint(equalTo: primatyButton.trailingAnchor),
            neutralButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: bottomConst)
        ])
    }
}
