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

import XCTest

class FiltersServiceTest: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }
    
    func initService(groups:[(groupId: Int, enabled: Bool)], filters: [(filterName: String, filterId: Int, groupId: Int, enabled: Bool)])->FiltersService {
        let antibanner = AntibannerMock()
        let antibannerController = AntibannerControllerMock(antibanner)
        let contentBlocker = ContentBlockerServiceMock()
        let configuration = ConfigurationServiceMock()
        let httpRequestService = HttpRequestServiceMock()
        let requestSender = httpRequestService.requestSender as! RequestSenderMock
        
        let service = FiltersService(antibannerController: antibannerController, configuration: configuration, contentBlocker: contentBlocker, resources: SharedResourcesMock(), httpRequestService: httpRequestService, filtersStorage: FiltersStorageMock())
        
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
            filter.name = filterParams.filterName
            filter.filterId = filterParams.filterId as NSNumber
            filter.groupId = filterParams.groupId as NSNumber
            filter.enabled = filterParams.enabled as NSNumber
            
            filterMetas.append(filter)
        }
        
        let metadata = ABECFilterClientMetadata()
        metadata.filters = filterMetas
        
        antibanner.storedGroups = groupMetas
        antibanner.storedFilters = filterMetas
        requestSender.result = metadata
        
        let expectation = XCTestExpectation(description: "load filters")
        service.load(refresh: false) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        
        return service
    }

    func testEnableFilter() {
        
        let service = initService(groups: [(123, false)], filters: [("filter name", 321, 123, false)])
        
        XCTAssertTrue(service.groups.count == 1)
        XCTAssertTrue(service.groups[0].filters.count == 1)
        XCTAssertTrue(service.groups[0].groupId == 123)
        XCTAssertTrue(service.groups[0].filters[0].filterId == 321)
        
        XCTAssertFalse(service.groups[0].enabled)
        service.setFilter(service.groups[0].filters[0], enabled: true)
        XCTAssertTrue(service.groups[0].enabled)
    }
    
    func testEnableGroup() {
        
        let service = initService(groups: [(123, false)], filters: [("filter name 1", 321, 123, true), ("filter name 2",456, 123, false)])
        
        XCTAssertTrue(service.groups.count == 1)
        XCTAssertTrue(service.groups[0].filters.count == 2)
        
        XCTAssertFalse(service.groups[0].enabled)
        XCTAssertTrue(service.groups[0].filters[0].enabled)
        XCTAssertFalse(service.groups[0].filters[1].enabled)
        
        service.setGroup(service.groups[0].groupId, enabled: true)
        
        XCTAssertTrue(service.groups[0].enabled)
        XCTAssertTrue(service.groups[0].filters[0].enabled)
        XCTAssertFalse(service.groups[0].filters[1].enabled)
    }
    
    func testDisableFilter(){
       
        let service = initService(groups: [(123, true)], filters: [("filter name 1", 321, 123, false), ("filter name 2", 456, 123, true)])

        XCTAssertTrue(service.groups[0].enabled)
        XCTAssertFalse(service.groups[0].filters[0].enabled)
        XCTAssertTrue(service.groups[0].filters[1].enabled)

        service.setFilter(service.groups[0].filters[1], enabled: false)

        sleep(1)

        XCTAssertTrue(service.groups[0].enabled)
        XCTAssertFalse(service.groups[0].filters[0].enabled)
        XCTAssertFalse(service.groups[0].filters[1].enabled)
    }
    
    func testDisableGroup() {
        
        let service = initService(groups: [(123, true)], filters: [("filter name 1", 321, 123, false), ("filter name 2", 456, 123, true)])
        
        XCTAssertTrue(service.groups[0].enabled)
        XCTAssertFalse(service.groups[0].filters[0].enabled)
        XCTAssertTrue(service.groups[0].filters[1].enabled)
        
        service.setGroup(service.groups[0].groupId, enabled: false)
        
        sleep(1)
        
        XCTAssertFalse(service.groups[0].enabled)
        XCTAssertFalse(service.groups[0].filters[0].enabled)
        XCTAssertTrue(service.groups[0].filters[1].enabled)
    }
    
    func testEnableMultipleGroups() {
        let service = initService(groups: [(123, false), (124, false)],
                                  filters: [("filter name 1", 321, 123, true), ("filter name 2", 456, 124, true)])
        
        XCTAssertFalse(service.groups[0].enabled)
        XCTAssertFalse(service.groups[1].enabled)
        XCTAssertTrue(service.groups[0].filters[0].enabled)
        XCTAssertTrue(service.groups[1].filters[0].enabled)
        
        service.setGroup(service.groups[0].groupId, enabled: true)
        
        // check only first group became enabled
        XCTAssertTrue(service.groups[0].enabled)
        XCTAssertFalse(service.groups[1].enabled)
        XCTAssertTrue(service.groups[0].filters[0].enabled)
        XCTAssertTrue(service.groups[1].filters[0].enabled)
    }
    
    func testEnableFilter2() {
        // disabled group with one enabled and one disabled filters
        // all filters are showed to user as disabled
        // after enabling second filter first filter must stay enabled
        let service = initService(groups: [(123, false)], filters: [("filter name 1", 321, 123, true), ("filter name 2", 456, 123, false)])
        
        XCTAssertFalse(service.groups[0].enabled)
        XCTAssertTrue(service.groups[0].filters[0].enabled)
        XCTAssertFalse(service.groups[0].filters[1].enabled)
        
        service.setFilter(service.groups[0].filters[1], enabled: true)
        
        sleep(1)
        
        XCTAssertTrue(service.groups[0].enabled)
        XCTAssertTrue(service.groups[0].filters[0].enabled)
        XCTAssertTrue(service.groups[0].filters[1].enabled)
    }
    
    func testRenameCustomFilter() {
        let filterIdToRename = 100
        let newName = "new name"
        
        let service = initService(groups: [(FilterGroupId.custom, true)], filters: [("filter name 1", 321, FilterGroupId.custom, false), ("filter name 2", filterIdToRename, FilterGroupId.custom, true)])
        
        service.renameCustomFilter(filterIdToRename, newName)
        
        let group = service.groups[0]
        let filter = group.filters[1]
        XCTAssertEqual(filter.name, newName)
    }
}
