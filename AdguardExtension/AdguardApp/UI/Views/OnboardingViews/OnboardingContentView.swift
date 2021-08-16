import UIKit

final class OnboardingContentView: UIView {
    enum OnboardingType: Int {
        case withAdvancedProtection
        case withoutAdvancedProtection
    }
    
    var onboardingType: OnboardingType = .withoutAdvancedProtection {
        didSet {
            setup(with: onboardingType)
        }
    }
    
    //MARK: - Services
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    //MARK: - Properties
    private let contentBlockers = ["AdGuard — Custom", "AdGuard — General", "AdGuard — Other"]
    private let cellsAlpha = [1.0, 0.6, 0.2]
    private let cellReuseId = "OnboardingContentBlockerCell"

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isUserInteractionEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let advancedProtectionView: OnboardingAdvancedProtectionView = {
       let view = OnboardingAdvancedProtectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(with: onboardingType)
    }
    
    init(onboardingType: OnboardingType) {
        super.init(frame: .zero)
        setup(with: onboardingType)
    }
    
    private func setup(with type: OnboardingType) {
        switch type {
        case .withAdvancedProtection:
            tableView.removeFromSuperview()
            setupWithAdvancedProtection()
        case .withoutAdvancedProtection:
            advancedProtectionView.removeFromSuperview()
            setupWithoutAdvancedProtection()
        }
    }
    
    private func setupWithAdvancedProtection() {
        self.addSubview(advancedProtectionView)
        applyConstraints(to: advancedProtectionView)
        advancedProtectionView.labelString = String.localizedString("onboarding_fours_step_text")
    }
    
    private func setupWithoutAdvancedProtection() {
        tableView.register(OnboardingContentBlockerCell.self, forCellReuseIdentifier: cellReuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        self.addSubview(tableView)
        applyConstraints(to: tableView)
    }
    
    private func applyConstraints(to view: UIView) {
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}

extension OnboardingContentView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentBlockers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId) as? OnboardingContentBlockerCell {
            let isLastCell = indexPath.row == contentBlockers.count - 1
            cell.titleString = contentBlockers[indexPath.row]
            cell.separator.isHidden = isLastCell
            cell.contentView.alpha = cellsAlpha[indexPath.row]
            themeService.setupTableCell(cell)
            themeService.setupSeparator(cell.separator)
            cell.titleLabelTextColor = configuration.darkTheme ? .white : .black
            return cell
        }
        return UITableViewCell()
    }
}

extension OnboardingContentView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension OnboardingContentView: ThemableProtocol {
    func updateTheme() {
        self.backgroundColor = themeService.backgroundColor
        

        switch onboardingType {
        case .withAdvancedProtection:
            advancedProtectionView.updateTheme()
        case .withoutAdvancedProtection:
            themeService.setupTable(tableView)
            tableView.backgroundColor = themeService.backgroundColor
            tableView.reloadData()
        }
    }
}
