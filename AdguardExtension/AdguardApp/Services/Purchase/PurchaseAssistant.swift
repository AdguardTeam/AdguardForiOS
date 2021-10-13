import Foundation

class PurchaseAssistant {

    /// NSNotificationCenter notification name
    static let kPurchaseServiceNotification = "kPurchaseServiceNotification"

    /// notification user data keys
    static let kPSNotificationTypeKey = "kPSNotificationTypeKey"
    static let kPSNotificationErrorKey = "kPSNotificationErrorKey"
    static let kPSNotificationPremiumExpiredKey = "kPSNotificationPremiumExpiredKey"

    /// notification types
    static let kPSNotificationPurchaseSuccess = "kPSNotificationPurchaseSuccess"
    static let kPSNotificationPurchaseFailure = "kPSNotificationPurchaseFailure"
    static let kPSNotificationRestorePurchaseSuccess = "kPSNotificationRestorePurchaseSuccess"
    static let kPSNotificationRestorePurchaseFailure = "kPSNotificationRestorePurchaseFailure"
    static let kPSNotificationSilentRestoreSuccess = "kPSNotificationSilentRestoreSuccess"
    static let kPSNotificationRestorePurchaseNothingToRestore = "kPSNotificationRestorePurchaseNothingToRestore"
    static let kPSNotificationLoginSuccess = "kPSNotificationLoginSuccess"
    static let kPSNotificationLoginFailure = "kPSNotificationLoginFailure"
    static let kPSNotificationLoginPremiumExpired = "kPSNotificationLoginPremiumExpired"
    static let kPSNotificationLoginNotPremiumAccount = "kPSNotificationLoginNotPremiumAccount"
    static let kPSNotificationLoginUserNotFound = "kPSNotificationLoginUserNotFound"
    static let kPSNotificationReadyToPurchase = "kPSNotificationReadyToPurchase"
    static let kPSNotificationPremiumExpired = "kPSNotificationPremiumExpired"

    /// Cancel button tapped notification
    static let kPSNotificationCanceled = "kPSNotificationCanceled"

    static let kPSNotificationPremiumStatusChanged = "kPSNotificationPremiumStatusChanged"

    static let kPSNotificationOauthSucceeded = "kPSNotificationOauthSucceeded"

    /// errors
    static let AEPurchaseErrorDomain = "AEPurchaseErrorDomain"

//    static let AEPurchaseErrorAuthFailed = -1 FIXME is that should be removed?
    static let AEConfirmReceiptError = -2
}
