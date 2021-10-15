import Foundation

/**
 Special class to provide an empty implemtation of the [PurchaseStatusProtocol].
 We do it because there is no need to know about the account state in  `AdGuardTodayExtension`.
 So, in the Future, if you want to use the account state in `AdGuardTodayExtension`, please use the [PurchaseService].
 */
class EmptyPurchaseStatusService : PurchaseStatusProtocol {
    var isProPurchased = false
}
