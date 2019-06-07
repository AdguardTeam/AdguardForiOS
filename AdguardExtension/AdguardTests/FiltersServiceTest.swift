
import XCTest

class FiltersServiceTest: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }
    
    func initService(groups:[(groupId: Int, enabled: Bool)], filters: [(filterId: Int, groupId: Int, enabled: Bool)])->FiltersService {
        let antibanner = AntibannerMock()
        let contentBlocker = ContentBlockerServiceMock()
        let configuration = ConfigurationServiceMock()
        
        let service = FiltersService(antibanner: antibanner, configuration: configuration, contentBlocker: contentBlocker)
        
        var groupMetas = [ASDFilterGroup]()
        
        for groupParams in groups {
            let group = ASDFilterGroup()
            group.groupId = groupParams.groupId as NSNumber
            group.enabled = groupParams.enabled as NSNumber
            
            groupMetas.append(group)
        }
        
        var filterMetas = [ASDFilterMetadata]()
        
        for filterParams in filters {
            let filter = ASDFilterMetadata()
            filter.filterId = filterParams.filterId as NSNumber
            filter.groupId = filterParams.groupId as NSNumber
            filter.enabled = filterParams.enabled as NSNumber
            
            filterMetas.append(filter)
        }
        
        let metadata = ABECFilterClientMetadata()
        metadata.filters = filterMetas
        
        antibanner.storedGroups = groupMetas
        antibanner.storedFilters = filterMetas
        antibanner.metadata = metadata
        
        let expectation = XCTestExpectation(description: "load filters")
        service.load(refresh: false) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        
        return service
    }

    func testEnableFilter() {
        
        let service = initService(groups: [(123, false)], filters: [(321, 123, false)])
        
        XCTAssertTrue(service.groups.count == 1)
        XCTAssertTrue(service.groups[0].filters.count == 1)
        XCTAssertTrue(service.groups[0].groupId == 123)
        XCTAssertTrue(service.groups[0].filters[0].filterId == 321)
        
        XCTAssertFalse(service.groups[0].enabled)
        service.setFilter(service.groups[0].filters[0], enabled: true)
        XCTAssertTrue(service.groups[0].enabled)
    }
    
    func testEnableGroup() {
        
        let service = initService(groups: [(123, false)], filters: [(321, 123, true), (456, 123, false)])
        
        XCTAssertTrue(service.groups.count == 1)
        XCTAssertTrue(service.groups[0].filters.count == 2)
        
        XCTAssertFalse(service.groups[0].enabled)
        XCTAssertFalse(service.groups[0].filters[0].enabled)
        XCTAssertFalse(service.groups[0].filters[1].enabled)
        
        service.setGroup(service.groups[0], enabled: true)
        
        XCTAssertTrue(service.groups[0].enabled)
        XCTAssertFalse(service.groups[0].filters[0].enabled)
        XCTAssertFalse(service.groups[0].filters[1].enabled)
    }
    
    func testDisableFilter(){
       
        let service = initService(groups: [(123, true)], filters: [(321, 123, false), (456, 123, true)])
        
        XCTAssertTrue(service.groups[0].enabled)
        XCTAssertFalse(service.groups[0].filters[0].enabled)
        XCTAssertTrue(service.groups[0].filters[1].enabled)
        
        service.setFilter(service.groups[0].filters[1], enabled: false)
        
        sleep(1)
        
        XCTAssertFalse(service.groups[0].enabled)
        XCTAssertFalse(service.groups[0].filters[0].enabled)
        XCTAssertFalse(service.groups[0].filters[1].enabled)
    }
    
    func testDisableGroup() {
        
        let service = initService(groups: [(123, true)], filters: [(321, 123, false), (456, 123, true)])
        
        XCTAssertTrue(service.groups[0].enabled)
        XCTAssertFalse(service.groups[0].filters[0].enabled)
        XCTAssertTrue(service.groups[0].filters[1].enabled)
        
        service.setGroup(service.groups[0], enabled: false)
        
        sleep(1)
        
        XCTAssertFalse(service.groups[0].enabled)
        XCTAssertFalse(service.groups[0].filters[0].enabled)
        XCTAssertTrue(service.groups[0].filters[1].enabled)
    }
    
    func testEnableMultipleGroups() {
        let service = initService(groups: [(123, false), (124, false)],
                                  filters: [(321, 123, true), (456, 124, true)])
        
        // all disabled before
        XCTAssertFalse(service.groups[0].enabled)
        XCTAssertFalse(service.groups[1].enabled)
        XCTAssertFalse(service.groups[0].filters[0].enabled)
        XCTAssertFalse(service.groups[1].filters[0].enabled)
        
        service.setGroup(service.groups[0], enabled: true)
        
        // check only first group became enabled
        XCTAssertTrue(service.groups[0].enabled)
        XCTAssertFalse(service.groups[1].enabled)
        XCTAssertFalse(service.groups[0].filters[0].enabled)
        XCTAssertFalse(service.groups[1].filters[0].enabled)
    }
    
    func testEnableFilter2() {
        // disabled group with one enabled and one disabled filters
        // all filters showed to user as disabled
        // after enabling second( true disabled) filter first filter must become disabled
        let service = initService(groups: [(123, false)], filters: [(321, 123, true), (456, 123, false)])
        
        XCTAssertFalse(service.groups[0].enabled)
        XCTAssertFalse(service.groups[0].filters[0].enabled)
        XCTAssertFalse(service.groups[0].filters[1].enabled)
        
        service.setFilter(service.groups[0].filters[1], enabled: true)
        
        sleep(1)
        
        XCTAssertTrue(service.groups[0].enabled)
        XCTAssertFalse(service.groups[0].filters[0].enabled)
        XCTAssertTrue(service.groups[0].filters[1].enabled)
    }
}
