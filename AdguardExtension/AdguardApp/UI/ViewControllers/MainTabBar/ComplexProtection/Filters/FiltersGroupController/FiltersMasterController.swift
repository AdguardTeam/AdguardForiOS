/**
       This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
       Copyright © Adguard Software Limited. All rights reserved.
 
       Adguard for iOS is free software: you can redistribute it and/or modify
       it under the terms of the GNU General Public License as published by
       the Free Software Foundation, either version 3 of the License, or
       (at your option) any later version.
 
       Adguard for iOS is distributed in the hope that it will be useful,
       but WITHOUT ANY WARRANTY; without even the implied warranty of
       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
       GNU General Public License for more details.
 
       You should have received a copy of the GNU General Public License
       along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
 */

import UIKit
import SafariAdGuardSDK

class FiltersMasterController: UIViewController {
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var groupsContainerView: UIView!
    
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var searchButton: UIBarButtonItem!
    
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configurationService: ConfigurationService = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let safariProtection: SafariProtectionProtocol = ServiceLocator.shared.getService()!
    
    weak var searchDelegate: FilterMasterControllerDelegate?
    weak var groupsDelegate: FilterMasterControllerDelegate?
    
    private let searchFiltersSegue = "searchFilterSegue"
    private let groupsControllerSegue = "groupsControllerSegue"
    private var viewModel: FiltersAndGroupsViewModelProtocol? = nil
    
    // MARK: - Initializer
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = FiltersAndGroupsViewModel(configurationService: configurationService, resources: resources, safariProtection: safariProtection)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [searchButton]
        
        searchContainerView.alpha = 0.0
        setupBackButton()
        showGroupsContainerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTheme()
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        navigationItem.setHidesBackButton(true, animated:true)
        searchDelegate?.searchButtonTapped()
        groupsDelegate?.searchButtonTapped()
        showSearchContainerView()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationItem.setHidesBackButton(false, animated:true)
        searchDelegate?.cancelButtonTapped()
        groupsDelegate?.cancelButtonTapped()
        showGroupsContainerView()
        viewModel?.cancelSearch()
        view.endEditing(true)
    }
    
    //MARK: - Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == searchFiltersSegue {
            if let destinationVC = segue.destination as? SearchFilterController{
                searchDelegate = destinationVC
                destinationVC.viewModel = viewModel
            }
        } else if segue.identifier == groupsControllerSegue {
            if let destinationVC = segue.destination as? GroupsController{
                groupsDelegate = destinationVC
                destinationVC.viewModel = viewModel
            }
        }
    }
    
    
    private func showSearchContainerView(){
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            self?.searchContainerView.isHidden = false
            self?.searchContainerView.alpha = 1.0
            self?.groupsContainerView.alpha = 0.0
            self?.navigationItem.title = String.localizedString("navigation_item_filters_title")
            self?.navigationItem.rightBarButtonItems = [self?.cancelButton ?? UIBarButtonItem()]
        }) {[weak self] (success) in
            if success{
                self?.groupsContainerView.isHidden = true
            }
        }
    }
    
    private func showGroupsContainerView(){
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            self?.groupsContainerView.isHidden = false
            self?.groupsContainerView.alpha = 1.0
            self?.searchContainerView.alpha = 0.0
            self?.navigationItem.title = nil
            self?.navigationItem.rightBarButtonItems = [self?.searchButton ?? UIBarButtonItem()]
        }) {[weak self] (success) in
            if success{
                self?.searchContainerView.isHidden = true
            }
        }
    }
}

protocol FilterMasterControllerDelegate: AnyObject {
    func cancelButtonTapped()
    func searchButtonTapped()
}

extension FiltersMasterController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setubBarButtonItem(searchButton)
        theme.setubBarButtonItem(cancelButton)
    }
}
