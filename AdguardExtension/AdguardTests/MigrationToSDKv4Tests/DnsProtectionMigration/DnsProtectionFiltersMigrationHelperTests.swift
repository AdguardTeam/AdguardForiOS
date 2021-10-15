import XCTest
import struct DnsAdGuardSDK.DnsFilter
import enum SharedAdGuardSDK.CommonError

/// Tests for `DnsProtectionFiltersMigrationHelper`
class DnsProtectionFiltersMigrationHelperTests: XCTestCase {

    var resources: SharedResourcesMock!
    var dnsFiltersMigration: DnsProtectionFiltersMigrationHelperProtocol!

    override func setUp() {
        SDKMigrationsDirectoriesManager.clear()
        SDKMigrationsDirectoriesManager.createFolders()

        resources = SharedResourcesMock()

        dnsFiltersMigration = DnsProtectionFiltersMigrationHelper(
            oldDnsFiltersContainerFolderUrl: SDKMigrationsDirectoriesManager.rootUrl,
            newDnsFiltersContainerFolderUrl: SDKMigrationsDirectoriesManager.subfolderUrl,
            resources: resources
        )
    }

    // MARK: - Test getDnsFiltersMeta

    func testGetDnsFiltersMetaWithNoData() {
        resources.sharedDefaults().removeObject(forKey: "kSharedDefaultsDnsFiltersMetaKey")
        let oldMeta = dnsFiltersMigration.getDnsFiltersMeta()
        XCTAssert(oldMeta.isEmpty)
    }

    func testGetDnsFiltersMetaWithEmptyData() {
        createAndSaveObsoleteDnsFiltersData(from: [])
        let oldMeta = dnsFiltersMigration.getDnsFiltersMeta()
        XCTAssert(oldMeta.isEmpty)
    }

    func testGetDnsFiltersMetaWithMultipleDnsFiltersMeta() {
        let meta1 = SDKDnsMigrationObsoleteDnsFilter(
            id: 3,
            subscriptionUrl: URL(string: "https://url1")!,
            name: "name1",
            updateDate: Date(),
            enabled: true,
            desc: "desc1",
            version: "1.1",
            rulesCount: 20,
            homepage: "homepage1"
        )

        let meta2 = SDKDnsMigrationObsoleteDnsFilter(
            id: 3,
            subscriptionUrl: URL(string: "https://url2")!,
            name: "name2",
            updateDate: nil,
            enabled: false,
            desc: nil,
            version: nil,
            rulesCount: 30,
            homepage: nil
        )

        let metasToSave = [meta1, meta2]
        createAndSaveObsoleteDnsFiltersData(from: metasToSave)
        let oldMetas = dnsFiltersMigration.getDnsFiltersMeta()
        XCTAssertEqual(oldMetas.count, 2)

        for i in 0..<metasToSave.count {
            XCTAssertEqual(metasToSave[i].id, oldMetas[i].id)
            XCTAssertEqual(metasToSave[i].subscriptionUrl, oldMetas[i].subscriptionUrl)
            XCTAssertEqual(metasToSave[i].name, oldMetas[i].name)
            XCTAssertEqual(metasToSave[i].updateDate, oldMetas[i].updateDate)
            XCTAssertEqual(metasToSave[i].enabled, oldMetas[i].enabled)
            XCTAssertEqual(metasToSave[i].desc, oldMetas[i].desc)
            XCTAssertEqual(metasToSave[i].version, oldMetas[i].version)
            XCTAssertEqual(metasToSave[i].rulesCount, oldMetas[i].rulesCount)
            XCTAssertEqual(metasToSave[i].homepage, oldMetas[i].homepage)
        }
    }

    // MARK: - Test saveDnsFiltersToSDK

    func testSaveDnsFiltersToSDKWithZeroFilters() {
        try! dnsFiltersMigration.saveDnsFiltersToSDK([])
        let filtersFromNewStorage = getDnsFiltersFromSdkStorage()
        XCTAssert(filtersFromNewStorage.isEmpty)
    }

    func testSaveDnsFiltersToSDKWithMultipleFilters() {
        let meta1 = SDKDnsMigrationObsoleteDnsFilter(
            id: 3,
            subscriptionUrl: URL(string: "https://url1")!,
            name: "name1",
            updateDate: Date(),
            enabled: true,
            desc: "desc1",
            version: "1.1",
            rulesCount: 20,
            homepage: "homepage1"
        )

        let meta2 = SDKDnsMigrationObsoleteDnsFilter(
            id: 3,
            subscriptionUrl: URL(string: "https://url2")!,
            name: "name2",
            updateDate: nil,
            enabled: false,
            desc: nil,
            version: nil,
            rulesCount: 30,
            homepage: nil
        )
        let metasToSave = [meta1, meta2]
        try! dnsFiltersMigration.saveDnsFiltersToSDK(metasToSave)

        let filtersFromNewStorage = getDnsFiltersFromSdkStorage()
        for i in 0..<metasToSave.count {
            XCTAssertEqual(metasToSave[i].id, filtersFromNewStorage[i].filterId)
            XCTAssertEqual(metasToSave[i].subscriptionUrl, filtersFromNewStorage[i].subscriptionUrl)
            XCTAssertEqual(metasToSave[i].name, filtersFromNewStorage[i].name)
            XCTAssertEqual(metasToSave[i].updateDate, filtersFromNewStorage[i].lastUpdateDate)
            XCTAssertEqual(metasToSave[i].enabled, filtersFromNewStorage[i].isEnabled)
            XCTAssertEqual(metasToSave[i].desc, filtersFromNewStorage[i].description)
            XCTAssertEqual(metasToSave[i].version, filtersFromNewStorage[i].version)
            XCTAssertEqual(metasToSave[i].rulesCount, filtersFromNewStorage[i].rulesCount)
            XCTAssertEqual(metasToSave[i].homepage, filtersFromNewStorage[i].homePage)
        }
    }

    // MARK: - Test replaceFilesForDnsFilters

    func testReplaceFilesForDnsFiltersWithSuccess() {
        let filterId1 = 3
        let filterId2 = 5

        let filterUrl1 = SDKMigrationsDirectoriesManager.rootUrl.appendingPathComponent("dns_filter_\(filterId1).txt")
        let filterUrl2 = SDKMigrationsDirectoriesManager.rootUrl.appendingPathComponent("dns_filter_\(filterId2).txt")

        FileManager.default.createFile(atPath: filterUrl1.path, contents: nil, attributes: nil)
        FileManager.default.createFile(atPath: filterUrl2.path, contents: nil, attributes: nil)

        XCTAssert(FileManager.default.fileExists(atPath: filterUrl1.path))
        XCTAssert(FileManager.default.fileExists(atPath: filterUrl2.path))

        try! dnsFiltersMigration.replaceFilesForDnsFilters(with: [filterId1, filterId2])

        XCTAssertFalse(FileManager.default.fileExists(atPath: filterUrl1.path))
        XCTAssertFalse(FileManager.default.fileExists(atPath: filterUrl2.path))

        let newFilterUrl1 = SDKMigrationsDirectoriesManager.subfolderUrl.appendingPathComponent("\(filterId1).txt")
        let newFilterUrl2 = SDKMigrationsDirectoriesManager.subfolderUrl.appendingPathComponent("\(filterId2).txt")

        XCTAssert(FileManager.default.fileExists(atPath: newFilterUrl1.path))
        XCTAssert(FileManager.default.fileExists(atPath: newFilterUrl2.path))
    }

    func testReplaceFilesForDnsFiltersWithMissingFile() {
        let filterId = 3
        let filterUrl = SDKMigrationsDirectoriesManager.rootUrl.appendingPathComponent("dns_filter_\(filterId).txt")
        XCTAssertFalse(FileManager.default.fileExists(atPath: filterUrl.path))

        XCTAssertThrowsError(try dnsFiltersMigration.replaceFilesForDnsFilters(with: [filterId])) { error in
            if case CommonError.missingFile(filename: _) = error {}
            else {
                XCTFail()
            }
        }

        XCTAssertFalse(FileManager.default.fileExists(atPath: filterUrl.path))
        let newFilterUrl = SDKMigrationsDirectoriesManager.subfolderUrl.appendingPathComponent("\(filterId).txt")
        XCTAssertFalse(FileManager.default.fileExists(atPath: newFilterUrl.path))
    }

    // MARK: - Test removeDnsFiltersDataFromOldStorage

    func testRemoveDnsFiltersDataFromOldStorage() {
        let meta = SDKDnsMigrationObsoleteDnsFilter(
            id: 3,
            subscriptionUrl: URL(string: "https://url1")!,
            name: "name1",
            updateDate: Date(),
            enabled: true,
            desc: "desc1",
            version: "1.1",
            rulesCount: 20,
            homepage: "homepage1"
        )
        createAndSaveObsoleteDnsFiltersData(from: [meta])

        dnsFiltersMigration.removeDnsFiltersDataFromOldStorage()
        let data = resources.sharedDefaults().data(forKey: "kSharedDefaultsDnsFiltersMetaKey")
        XCTAssertNil(data)
    }

    // MARK: - Private helper methods

    private func createAndSaveObsoleteDnsFiltersData(from filters: [SDKDnsMigrationObsoleteDnsFilter]) {
        NSKeyedArchiver.setClassName("DnsFilter", for: SDKDnsMigrationObsoleteDnsFilter.self)
        NSKeyedUnarchiver.setClass(SDKDnsMigrationObsoleteDnsFilter.self, forClassName: "DnsFilter")
        let dataToSave = filters.map { NSKeyedArchiver.archivedData(withRootObject: $0) }
        resources.sharedDefaults().set(dataToSave, forKey: "kSharedDefaultsDnsFiltersMetaKey")
    }

    private func getDnsFiltersFromSdkStorage() -> [DnsFilter] {
        let decoder = JSONDecoder()
        let dataToDecode = resources.sharedDefaults().data(forKey: "DnsAdGuardSDK.dnsFiltersKey")!
        return try! decoder.decode([DnsFilter].self, from: dataToDecode)
    }
}
