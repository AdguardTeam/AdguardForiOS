import Foundation

class HttpRequestServiceMock: HttpRequestServiceProtocol {
    var requestSender: RequestSenderProtocol
    
    init(result: Any? = nil) {
        self.requestSender = RequestSenderMock(result: result)
    }
}

class RequestSenderMock: RequestSenderProtocol {
    
    var result: Any?
    var sendCalled = false
    
    func send<Parser>(requestConfig: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void) where Parser : ParserProtocol {
        DispatchQueue(label: "").async { [unowned self] in
            self.sendCalled = true
            if let typedResult = self.result as? Parser.Model {
                completionHandler(.success(typedResult))
            }
            else {
                completionHandler(.error(RequestSenderMockError()))
            }
        }
    }
    
    init(result: Any? = nil) {
        self.result = result
    }
}

class RequestSenderMockError : Error {
}
