//
//  PurchaseStatusProtocol.swift
//  Adguard
//
//  Created by Artem Ivanov on 13.10.2021.
//  Copyright © 2021 Performiks. All rights reserved.
//

import Foundation

protocol PurchaseStatusProtocol {

    /**
     returns true if user has valid renewable subscription or valid adguard license
     */
    var isProPurchased: Bool {get}
}
