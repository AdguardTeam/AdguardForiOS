//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import Foundation

/// This protocol is needed to ask `LicensePageViewController` to perform actions
protocol FreeLicenseStateTableViewPresentor: AnyObject {
    func showError(title: String?, message: String?)
    func showPurchaseOptions(options: [(id: String, title: String)])
    func showAlertAndDismiss(title: String?, message: String?)
    func purchaseStatusChanged()
}

protocol FreeLicenseStateTableViewModelProtocol: LicenseProductChoiceCellDelegate {
    var tableView: FreeLicenseStateTableViewProtocol? { get set }
    var presentor: FreeLicenseStateTableViewPresentor? { get set }

    var selectedProductPrice: String? { get }
    var selectedProductPeriod: String? { get }
    var trialIsAvailable: Bool { get }
    var selectedProductIsSubscription: Bool { get }

    func selectProduct(with id: String)
    func getSubscriptionsTermsText() -> NSAttributedString?
    func getTrialDescriptionText() -> String?
}

final class FreeLicenseStateTableViewModel: FreeLicenseStateTableViewModelProtocol {

    // MARK: - Public properties

    weak var tableView: FreeLicenseStateTableViewProtocol?
    weak var presentor: FreeLicenseStateTableViewPresentor?

    var selectedProductPrice: String? { selectedProduct?.price }

    var selectedProductPeriod: String? {
        if let product = selectedProduct {
            return getSubscriptionPeriodString(for: product)
        }
        return nil
    }

    var trialIsAvailable: Bool {
        if let selectedProduct = selectedProduct, selectedProduct.type != .lifetime {
            return selectedProduct.trialPeriod != nil
        }
        return false
    }

    var selectedProductIsSubscription: Bool {
        if let selectedProduct = selectedProduct {
            return selectedProduct.type != .lifetime
        }
        return true
    }

    // MARK: - Private properties

    private let purchaseService: PurchaseServiceProtocol
    private let productInfo: ADProductInfoProtocol

    private var purchaseObserver: NotificationToken?

    private var selectedProduct: Product?

    // MARK: - Public methods

    init(purchaseService: PurchaseServiceProtocol, productInfo: ADProductInfoProtocol) {
        self.purchaseService = purchaseService
        self.productInfo = productInfo
        selectedProduct = purchaseService.standardProduct

        purchaseObserver = NotificationCenter.default.observe(name: Notification.Name(PurchaseAssistant.kPurchaseServiceNotification), object: nil, queue: .main) { [weak self] note in
            if let info = note.userInfo {
                self?.processNotification(info: info)
                self?.presentor?.purchaseStatusChanged()
            }
        }
    }

    func selectProduct(with id: String) {
        let newProduct = purchaseService.products.first(where: { $0.productId == id })
        if newProduct?.productId != selectedProduct?.productId {
            selectedProduct = newProduct
            tableView?.updateSubscriptionInfo()
        }
    }

    func getSubscriptionsTermsText() -> NSAttributedString? {
        let stringKey = selectedProduct?.type == .some(.lifetime) ? "lifetime_purchase_description_format" : "purchase_description_format"
        let format = String.localizedString(stringKey)
        let privacy = UIApplication.shared.adguardUrl(action: "privacy", from: "license", buildVersion: productInfo.buildVersion())
        let eula = UIApplication.shared.adguardUrl(action: "eula", from: "license", buildVersion: productInfo.buildVersion())

        let htmlString = String(format: format, privacy, eula)
        guard
            let data = htmlString.data(using: .utf8),
            let attributedString = try? NSMutableAttributedString(
                data: data,
                options: [
                    NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: NSNumber(value:String.Encoding.utf8.rawValue)
                ],
                documentAttributes: nil
            )
        else {
            return nil
        }
        return attributedString
    }

    func getTrialDescriptionText() -> String? {
        guard
            let selectedProduct = selectedProduct,
            selectedProduct.type != .lifetime,
            let period = selectedProduct.trialPeriod
        else {
            return nil
        }

        let formatString: String
        switch period.unit {
        case .day:
            formatString = String.localizedString("trial_description_days")
        case .week:
            if period.numberOfUnits == 1 {
                formatString = String.localizedString("trial_description_days")
                return String.localizedStringWithFormat(formatString, 7)
            }
            formatString = String.localizedString("trial_description_weeks")
        case .month:
            formatString = String.localizedString("trial_description_months")
        case .year:
            formatString = String.localizedString("trial_description_years")
        }

        let resultString : String = String.localizedStringWithFormat(formatString, period.numberOfUnits)
        return resultString
    }

    func productChoiceButtonTapped() {
        if purchaseService.products.isEmpty {
            presentor?.showError(title: nil, message: String.localizedString("upgrade_missing_purchase_message"))
            return
        }

        let options: [(String, String)] = purchaseService.products.map {
            let title = "\(getSubscriptionPeriodString(for: $0)) - \($0.price)"
            return ($0.productId, title)
        }
        presentor?.showPurchaseOptions(options: options)
    }

    func subscribeButtonTapped() {
        tableView?.setLoading(true)
        if let product = selectedProduct {
            purchaseService.requestPurchase(productId: product.productId)
        }
    }

    func restorePurchaseButtonTapped() {
        tableView?.setLoading(true)
        purchaseService.requestRestore()
    }

    // MARK: - Private methods

    private func getSubscriptionPeriodString(for product: Product) -> String {
        if product.type == .lifetime {
            return String.localizedString("permanent_subscription_title")
        }

        guard let period = product.period else {
            return ""
        }

        switch period.unit {
        case .month: return String.localizedString("one_month_subscription_title")
        case .year: return String.localizedString("one_year_subscription_title")
        default: return ""
        }
    }

    private func processNotification(info: [AnyHashable: Any]) {
        let type = info[PurchaseAssistant.kPSNotificationTypeKey] as? String

        switch type {
        case PurchaseAssistant.kPSNotificationPurchaseSuccess:
            presentor?.showAlertAndDismiss(title: nil, message: String.localizedString("purchase_success_message"))
        case PurchaseAssistant.kPSNotificationPurchaseFailure:
            tableView?.setLoading(false)
            presentor?.showError(title: nil, message: String.localizedString("purchase_failure_message"))
        case PurchaseAssistant.kPSNotificationRestorePurchaseSuccess:
            presentor?.showAlertAndDismiss(title: nil, message: String.localizedString("restore_success_message"))
        case PurchaseAssistant.kPSNotificationRestorePurchaseNothingToRestore:
            tableView?.setLoading(false)
            presentor?.showError(title: nil, message: String.localizedString("nothing_to_restore_message"))
        case PurchaseAssistant.kPSNotificationRestorePurchaseFailure:
            tableView?.setLoading(false)
            presentor?.showError(title: nil, message: String.localizedString("restore_purchases_failure_message"))
        case PurchaseAssistant.kPSNotificationReadyToPurchase:
            selectedProduct = purchaseService.standardProduct
            tableView?.updateSubscriptionInfo()
            tableView?.setLoading(false)
        case PurchaseAssistant.kPSNotificationCanceled:
            tableView?.setLoading(false)
        default:
            break
        }
    }
}
