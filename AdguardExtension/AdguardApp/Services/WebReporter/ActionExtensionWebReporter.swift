
import SafariAdGuardSDK

/// Action extension web reporter 
final class ActionExtensionWebReporter: WebReporterProtocol {
    
    // MARK: - Private properties
    
    private let url: URL
    private let webReporterSafariFiltersWrapper: WebReporterWrapperProtocol
    private let reportUrl = "https://reports.adguard.com/new_issue.html" // TODO: - It should be TDS link
    
    // MARK: - Init
    
    init(url: URL, safariProtection: SafariProtectionProtocol) {
        self.url = url
        self.webReporterSafariFiltersWrapper = WebReporterSafariFiltersWrapper(safariProtection: safariProtection)
    }
    
    // MARK: - Public methods
    
    func createUrl() -> URL {
        var params: [String: String] = [
            "url": url.absoluteString,
            "product_type": "iOS",
            "product_version": ADProductInfo().version(),
            "browser": "Safari"
        ]
        
        let safariFiltersParams = webReporterSafariFiltersWrapper.collectParams()
        assembleParams(result: &params, params: safariFiltersParams)
        
        let paramString = ABECRequest.createString(fromParameters: params)
        let url = "\(reportUrl)?\(paramString)"
        
        return URL(string: url)!
    }
    
    // MARK: - Private methods
    
    private func assembleParams(result: inout [String: String], params: [String: String]) {
        for key in params.keys {
            if let param = params[key] {
                result[key] = param
            }
        }
    }
}
