
import Foundation

protocol FiltersStorageProtocol {
    
    func downloadFilter(identifier: Int, completion:@escaping (Error?)->Void)
    func updateFilter(identifier: Int, completion:@escaping (Error?)->Void)
    func getFilters(identifiers:[Int])->[Int: String]
    func saveFilter(identifier: Int, content: String)->Error?
}

class FiltersStorage: FiltersStorageProtocol {
    
    func downloadFilter(identifier: Int, completion: @escaping (Error?) -> Void) {
        guard let url = urlForFilter(identifier), let saveUrl = fileUrlForFilter(identifier) else {
            DDLogError("FiltersStorage downloadFilter - can not generate urls for filter with id: \(identifier)")
            return
        }
        
        DispatchQueue(label: "download filter").async {
            do {
                let content = try String(contentsOf: url)
                try content.write(to: saveUrl, atomically: true, encoding: .utf8)
                completion(nil)
            }
            catch {
                DDLogError("FiltersStorage downloadFilter - download error: \(error)")
                completion(error)
            }
        }
    }
    
    func updateFilter(identifier: Int, completion:@escaping (Error?)->Void) {
        downloadFilter(identifier: identifier, completion: completion)
    }
    
    func getFilters(identifiers:[Int])->[Int: String] {
        var result = [Int: String]()
        for id in identifiers {
            guard let fileUrl = fileUrlForFilter(id) else {
                DDLogError("FiltersStorage getFilters error. Can not generate url for filter with id: \(id)")
                continue
            }
            guard let content = try? String.init(contentsOf: fileUrl, encoding: .utf8) else {
                DDLogError("FiltersStorage getFilters error. Can not rea filter with url: \(fileUrl)")
                continue
            }
            result[id] = content
        }
        return result
    }
    
    func saveFilter(identifier: Int, content: String) -> Error? {
        guard let url = fileUrlForFilter(identifier) else { return NSError(domain: "com.adguard.FiltersStorage", code: 0, userInfo: nil)}
        
        do {
            try content.write(to: url, atomically: true, encoding: .utf8)
        }
        catch {
            return error
        }
        
        return nil
    }
    
    // MARK: - private methods
    
    private func urlForFilter(_ identifier: Int)->URL? {
        let url = "https://filters.adtidy.org/ios/filters/\(identifier)_optimized.txt"
        return URL(string: url)
    }
    
    private func fileUrlForFilter(_ identifier: Int)->URL? {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDir = urls.first
        let fileUrl = documentDir?.appendingPathComponent("\(identifier).txt")
        return fileUrl
    }
}
