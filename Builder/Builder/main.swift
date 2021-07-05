
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
    
let url = URL(fileURLWithPath: productPath)
let sdkBuilder = AdGuardSDKBuilder(filtersStorageUrl: url, dbUrl: URL(string: productPath)!)

if sdkBuilder.loadAll() {
    let dbUrl = url.appendingPathComponent("default.db")
    
    let gzipepdUrl = try? Zip.quickZipFiles([dbUrl], fileName: "default.db")
    if gzipepdUrl != nil {
        try? fileManager.copyItem(at: gzipepdUrl!, to: url.appendingPathComponent("default.db.gz"))
        exit(0)
    }
    else {
        exit(-2)
    }
}
else {
    exit(-1)
}
