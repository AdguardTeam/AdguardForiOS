///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
///

import Foundation
import AdGuardSDK_mac
import Zip

let fileManager = FileManager.default
var productPath = fileManager.currentDirectoryPath

print(CommandLine.arguments)

if CommandLine.arguments.count == 3 {
    productPath = CommandLine.arguments[2]
}

print("Product path = " + productPath)

try fileManager.createDirectory(atPath: productPath, withIntermediateDirectories: true, attributes: nil)
print("Directory for product path was created")

let url = URL(fileURLWithPath: productPath)
let sdkBuilder = AdGuardSDKBuilder(filtersStorageUrl: url, dbUrl: URL(string: productPath)!)

do {
    try sdkBuilder.loadAll()
    print("Successfully downloaded and added filters to default.db")
} catch {
    print("Failed to load filters with error: \(error)")
    exit(-1)
}

let dbUrl = url.appendingPathComponent(Constants.Files.defaultDbFileName)

do {
    // Zip default.db
    let zipepdUrl = try Zip.quickZipFiles([dbUrl], fileName: Constants.Files.defaultDbFileName)

    // Zip filters files
    let filePaths = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: [], options: [])
    let filtersFilesUrls = filePaths.compactMap { $0.pathExtension == "txt" ? $0 : nil }
    let filtersZippedUrl = try Zip.quickZipFiles(filtersFilesUrls, fileName: Constants.Files.filtersZipFileName)

    try fileManager.copyItem(at: zipepdUrl, to: url.appendingPathComponent(Constants.Files.defaultDbZipFileName))
    try fileManager.copyItem(at: filtersZippedUrl, to: url.appendingPathComponent(Constants.Files.filtersZipFileName))
    print("Successfully zipped default.db and filters")
    exit(0)
} catch {
    print("Failed to zip default.db or filters with error: \(error)")
    exit(-1)
}
