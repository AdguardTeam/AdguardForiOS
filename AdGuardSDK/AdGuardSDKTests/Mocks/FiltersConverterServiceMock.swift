import Foundation

final class FiltersConverterServiceMock: FiltersConverterServiceProtocol {
    
    var convertFiltersCalledCount = 0
    var convertFiltersResult: Result<[FiltersConverter.Result]> = .success([])
    func convertFiltersAndUserRulesToJsons() throws -> [FiltersConverter.Result] {
        convertFiltersCalledCount += 1
        switch convertFiltersResult {
        case .success(let result): return result
        case .error(let error): throw error
        }
    }
}
