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

import Foundation

enum StoryActionType: String, CaseIterable {
    case readChangeLog = "READ_CHANGELOG"
    case activateLicense = "ACTIVATE_LICENSE"
    case downloadAdguardVpn = "DOWNLOAD_ADGUARD_VPN"
    case moreOnDns = "MORE_ON_DNS"
    case enableAdguardDns = "ENABLE_ADGUARD_DNS"
    case enableGoogleDns = "ENABLE_GOOGLE_DNS"
    case enableCloudflareDns = "ENABLE_CLOUDFLARE_DNS"
    case addCustomDns = "ADD_CUSTOM_DNS"
}

struct StoryButtonConfig: Decodable {
    var title: String?
    var performAction: (() -> Void)?
    
    private enum CodingKeys: String, CodingKey {
        case title = "action_title"
        case performAction = "action"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let buttonTitleKey = try container.decode(String.self, forKey: .title)
        let buttonActionKey = try container.decode(String.self, forKey: .performAction)
        
        guard let actionType = StoryActionType(rawValue: buttonActionKey) else {
            return
        }
        
        self.title = String.localizedString(buttonTitleKey)
        
        let action: () -> Void
        switch actionType {
        case .readChangeLog: action = { [self] in self.readChangeLog() }
        case .activateLicense: action = { [self] in self.activateLicense() }
        case .downloadAdguardVpn: action = { [self] in self.downloadAdguardVpn() }
        case .moreOnDns: action = { [self] in self.moreOnDns() }
        case .enableAdguardDns: action = { [self] in self.enableAdguardDns() }
        case .enableGoogleDns: action = { [self] in self.enableGoogleDns() }
        case .enableCloudflareDns: action = { [self] in self.enableCloudflareDns() }
        case .addCustomDns: action = { [self] in self.addCustomDns() }
        }
        self.performAction = action
    }
    
    // MARK: - Private methods
    
    private func readChangeLog() {
        
    }

    private func activateLicense() {
        
    }
    
    private func downloadAdguardVpn() {
        
    }
    
    private func moreOnDns() {
        
    }
    
    private func enableAdguardDns() {
        
    }
    
    private func enableGoogleDns() {
        
    }
    
    private func enableCloudflareDns() {
        
    }
    
    private func addCustomDns() {
        
    }
}
