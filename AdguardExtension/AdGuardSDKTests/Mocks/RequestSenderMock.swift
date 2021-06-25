import Foundation

enum RequestSenderMockError: Error {
    case testError
    case resultCastFailed
}

class HttpRequestServiceMock: HttpRequestServiceProtocol {
    
    var requestSender: RequestSenderProtocol
    
    init(requestSender: RequestSenderMock) {
        self.requestSender = requestSender
    }
}

class RequestSenderMock: RequestSenderProtocol {
    
    private let valueToReturn: Result<Any>
    
    init(valueToReturn: Result<Any>) {
        self.valueToReturn = valueToReturn
    }
    
    func send<Parser>(requestConfig: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void) where Parser : ParserProtocol {
        if case let .success(value) = valueToReturn {
            if let value = value as? Parser.Model {
                completionHandler(.success(value))
            } else {
                completionHandler(.error(RequestSenderMockError.testError))
            }
        }
        else if case let .error(error) = valueToReturn {
            completionHandler(.error(error))
        }
        else {
            completionHandler(.error(RequestSenderMockError.resultCastFailed))
        }
    }
}
