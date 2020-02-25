import Foundation

class TestableDateMock: TestableDateProtocol {
    
    lazy var now: Date = { return Date() }()
    
    var currentDate: Date {
        return now
    }
}
