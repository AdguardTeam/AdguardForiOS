import Foundation

protocol PurchaseStatusProtocol {

    /**
     returns true if user has valid renewable subscription or valid adguard license
     */
    var isProPurchased: Bool {get}
}
