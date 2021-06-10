import Foundation

class HttpRequestServiceMock: HttpRequestServiceProtocol {
    var requestSender: RequestSenderProtocol
    
    // [tagId: [lang: GroupLocalization]]
    var tags = [
        1: ["en" : ExtendedFiltersMetaLocalizations.TagLocalization(name: "tag1", description: "tagDescription1")],
        2: ["en" : ExtendedFiltersMetaLocalizations.TagLocalization(name: "tag2", description: "tagDescription2")],
        3: ["en" : ExtendedFiltersMetaLocalizations.TagLocalization(name: "tag3", description: "tagDescription3")],
        4: ["en" : ExtendedFiltersMetaLocalizations.TagLocalization(name: "tag4", description: "tagDescription4")],
        5: ["en" : ExtendedFiltersMetaLocalizations.TagLocalization(name: "tag5", description: "tagDescription5")],
        6: ["en" : ExtendedFiltersMetaLocalizations.TagLocalization(name: "tag6", description: "tagDescription6")],
        7: ["en" : ExtendedFiltersMetaLocalizations.TagLocalization(name: "tag7", description: "tagDescription7")],
        8: ["en" : ExtendedFiltersMetaLocalizations.TagLocalization(name: "tag8", description: "tagDescription8")]
    ]
    
    // [filterId: [lang: GroupLocalization]]
    var filters = [
        1: ["en": ExtendedFiltersMetaLocalizations.FilterLocalization(name: "filter1", description: "filterDescription1")],
        2: ["en": ExtendedFiltersMetaLocalizations.FilterLocalization(name: "filter2", description: "filterDescription2")],
        3: ["en": ExtendedFiltersMetaLocalizations.FilterLocalization(name: "filter3", description: "filterDescription3")],
        4: ["en": ExtendedFiltersMetaLocalizations.FilterLocalization(name: "filter4", description: "filterDescription4")],
        5: ["en": ExtendedFiltersMetaLocalizations.FilterLocalization(name: "filter5", description: "filterDescription5")],
        6: ["en": ExtendedFiltersMetaLocalizations.FilterLocalization(name: "filter6", description: "filterDescription6")],
        7: ["en": ExtendedFiltersMetaLocalizations.FilterLocalization(name: "filter7", description: "filterDescription7")],
        8: ["en": ExtendedFiltersMetaLocalizations.FilterLocalization(name: "filter8", description: "filterDescription8")],
    ]
    
    // [groupId: [lang: GroupLocalization]]
    var groups = [
        1: ["en": ExtendedFiltersMetaLocalizations.GroupLocalization(name: "group1")],
        2: ["en": ExtendedFiltersMetaLocalizations.GroupLocalization(name: "group2")],
        3: ["en": ExtendedFiltersMetaLocalizations.GroupLocalization(name: "group3")],
        4: ["en": ExtendedFiltersMetaLocalizations.GroupLocalization(name: "group4")],
        5: ["en": ExtendedFiltersMetaLocalizations.GroupLocalization(name: "group5")],
        6: ["en": ExtendedFiltersMetaLocalizations.GroupLocalization(name: "group6")],
        7: ["en": ExtendedFiltersMetaLocalizations.GroupLocalization(name: "group7")],
        101: ["en": ExtendedFiltersMetaLocalizations.GroupLocalization(name: "group101")]
    ]
    
    init(loadFiltersMetadataResult: Any? = nil, sendFeedbackResult: Any? = nil) {
        let loadFiltersLocalizationsResult = ExtendedFiltersMetaLocalizations(groups: groups, tags: tags, filters: filters)
        self.requestSender = RequestSenderMock(loadFiltersLocalizationsResult: loadFiltersLocalizationsResult,
                                               loadFiltersMetadataResult: loadFiltersMetadataResult,
                                               sendFeedbackResult: sendFeedbackResult)
    }
}

class RequestSenderMock: RequestSenderProtocol {
    
    var loadFiltersLocalizationsResult: Any?
    var loadFiltersMetadataResult: Any?
    var sendFeedbackResult: Any?
    
    func send<Parser>(requestConfig: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void) where Parser : ParserProtocol {
        DispatchQueue(label: "").async { [unowned self] in
            if let typedResult = self.loadFiltersMetadataResult as? Parser.Model {
                completionHandler(.success(typedResult))
            } else if let typedResult = self.loadFiltersLocalizationsResult as? Parser.Model {
                completionHandler(.success(typedResult))
            } else if let typedResult = self.sendFeedbackResult as? Parser.Model {
                completionHandler(.success(typedResult))
            } else {
                completionHandler(.error(RequestSenderMockError()))
            }
        }
    }
    
    init(loadFiltersLocalizationsResult: Any? = nil, loadFiltersMetadataResult: Any? = nil, sendFeedbackResult: Any? = nil) {
        self.loadFiltersLocalizationsResult = loadFiltersLocalizationsResult
        self.loadFiltersMetadataResult = loadFiltersMetadataResult
        self.sendFeedbackResult = sendFeedbackResult
    }
}

class RequestSenderMockError : Error {
}
