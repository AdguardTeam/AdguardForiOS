import Foundation

final class FiltersConverterServiceMock: FiltersConverterServiceProtocol {
    
    var convertFiltersCalledCount = 0
    var convertFiltersResult: [FiltersConverterResult] = []
    func convertFiltersAndUserRulesToJsons() -> [FiltersConverterResult] {
        convertFiltersCalledCount += 1
        return convertFiltersResult
    }
}
