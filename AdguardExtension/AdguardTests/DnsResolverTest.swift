import XCTest

class DnsResolverTest: XCTestCase {
    
    var testCases: [String: DnsResolverProtocol.DnsResolverResult] = [
        // dot servers
        "sdns://AwMAAAAAAAAAAAAPZG5zLmFkZ3VhcmQuY29t": ("tls://dns.adguard.com", .dot),
        "sdns://AwcAAAAAAAAAAAAaZG5zLXVuZmlsdGVyZWQuYWRndWFyZC5jb20": ("tls://dns-unfiltered.adguard.com", .dot),
        "sdns://AwAAAAAAAAAAAAAjZmFtaWx5LWZpbHRlci1kbnMuY2xlYW5icm93c2luZy5vcmc": ("tls://family-filter-dns.cleanbrowsing.org", .dot),
        "sdns://AwAAAAAAAAAAAAAKZG5zLmdvb2dsZQ": ("tls://dns.google", .dot),
        "sdns://AwAAAAAAAAAAAAAPb25lLm9uZS5vbmUub25l": ("tls://one.one.one.one", .dot),
        "sdns://AwAAAAAAAAAAAAANZG5zLnF1YWQ5Lm5ldA": ("tls://dns.quad9.net", .dot),
        
        // doh servers
        "sdns://AgcAAAAAAAAAAAAPZG5zLmFkZ3VhcmQuY29tCi9kbnMtcXVlcnk": ("https://dns.adguard.com/dns-query", .doh),
        "sdns://AgcAAAAAAAAAAAAaZG5zLXVuZmlsdGVyZWQuYWRndWFyZC5jb20KL2Rucy1xdWVyeQ": ("https://dns-unfiltered.adguard.com/dns-query", .doh),
        "sdns://AgUAAAAAAAAAAAAPZG9oLm9wZW5kbnMuY29tCi9kbnMtcXVlcnk": ("https://doh.opendns.com/dns-query", .doh),
        "sdns://AgcAAAAAAAAAGVsyNjA2OjQ3MDA6NDcwMDo6MTExMV06NTOgENk8mGSlIfMGXMOlIlCcKvq7AVgcrZxtjon911-ep0cg63Ul-I8NlFj4GplQGb_TTLiczclX57DvMV8Q-JdjgRgSZG5zLmNsb3VkZmxhcmUuY29tCi9kbnMtcXVlcnk": ("https://dns.cloudflare.com:53/dns-query", .doh),
        "sdns://AgAAAAAAAAAAAAANZG5zLmNvbXNzLm9uZQovZG5zLXF1ZXJ5": ("https://dns.comss.one/dns-query", .doh),
        "sdns://AgEAAAAAAAAAAAAecHJpdmF0ZS5jYW5hZGlhbnNoaWVsZC5jaXJhLmNhCi9kbnMtcXVlcnk": ("https://private.canadianshield.cira.ca/dns-query", .doh),
        
        // dns servers
        "sdns://AAcAAAAAAAAADDk0LjE0MC4xNC4xNA": ("94.140.14.14", .dns),
        "sdns://AAcAAAAAAAAAE1syYTEwOjUwYzA6OmFkMTpmZl0": ("2a10:50c0::ad1:ff", .dns),
        "sdns://AAAAAAAAAAAABzguOC44Ljg": ("8.8.8.8", .dns),
        "sdns://AAAAAAAAAAAADVsyNjIwOmZlOjpmZV0": ("2620:fe::fe", .dns),
        "sdns://AAAAAAAAAAAADTkyLjIyMy4xMDkuMzE": ("92.223.109.31", .dns),
        "sdns://AAAAAAAAAAAAEVsyNjIwOjc0OjFiOjoxOjFd": ("2620:74:1b::1:1", .dns),
        
        // dnscrypt servers
        "sdns://AQIAAAAAAAAAFDE3Ni4xMDMuMTMwLjEzMDo1NDQzINErR_JS3PLCu_iZEIbq95zkSV2LFsigxDIuUso_OQhzIjIuZG5zY3J5cHQuZGVmYXVsdC5uczEuYWRndWFyZC5jb20": ("sdns://AQIAAAAAAAAAFDE3Ni4xMDMuMTMwLjEzMDo1NDQzINErR_JS3PLCu_iZEIbq95zkSV2LFsigxDIuUso_OQhzIjIuZG5zY3J5cHQuZGVmYXVsdC5uczEuYWRndWFyZC5jb20", .dnsCrypt),
        "sdns://AQIAAAAAAAAAGlsyYTAwOjVhNjA6OmJhZDI6MGZmXTo1NDQzIIwhF6nrwVfW-2QFbwrbwRxdg2c0c8RuJY2bL1fU7jUfITIuZG5zY3J5cHQuZmFtaWx5Lm5zMi5hZGd1YXJkLmNvbQ": ("sdns://AQIAAAAAAAAAGlsyYTAwOjVhNjA6OmJhZDI6MGZmXTo1NDQzIIwhF6nrwVfW-2QFbwrbwRxdg2c0c8RuJY2bL1fU7jUfITIuZG5zY3J5cHQuZmFtaWx5Lm5zMi5hZGd1YXJkLmNvbQ", .dnsCrypt),
        "sdns://AQMAAAAAAAAAFDE4NS4yMjguMTY4LjE2ODo4NDQzILysMvrVQ2kXHwgy1gdQJ8MgjO7w6OmflBjcd2Bl1I8pEWNsZWFuYnJvd3Npbmcub3Jn": ("sdns://AQMAAAAAAAAAFDE4NS4yMjguMTY4LjE2ODo4NDQzILysMvrVQ2kXHwgy1gdQJ8MgjO7w6OmflBjcd2Bl1I8pEWNsZWFuYnJvd3Npbmcub3Jn", .dnsCrypt),
        "sdns://AQMAAAAAAAAAElsyNjIwOmZlOjpmZV06ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0": ("sdns://AQMAAAAAAAAAElsyNjIwOmZlOjpmZV06ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0", .dnsCrypt),
        "sdns://AQMAAAAAAAAAFVsyNjIwOmZlOjpmZToxMF06ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0": ("sdns://AQMAAAAAAAAAFVsyNjIwOmZlOjpmZToxMF06ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0", .dnsCrypt),
        "sdns://AQMAAAAAAAAAHFsyYTAxOjRmOTpjMDEwOjQzY2U6OjFdOjg0NDMgU4ToFEMUKT5W3RsUCh7xcq1HvboXmciVcpSVPQNOtccbMi5kbnNjcnlwdC1jZXJ0LmJsYWhkbnMuY29t": ("sdns://AQMAAAAAAAAAHFsyYTAxOjRmOTpjMDEwOjQzY2U6OjFdOjg0NDMgU4ToFEMUKT5W3RsUCh7xcq1HvboXmciVcpSVPQNOtccbMi5kbnNjcnlwdC1jZXJ0LmJsYWhkbnMuY29t", .dnsCrypt),
        
        // doq servers
        "sdns://BAcAAAAAAAAADDk0LjE0MC4xNC4xNAAPZG5zLmFkZ3VhcmQuY29t": ("quic://dns.adguard.com", .doq),
        "sdns://BAAAAAAAAAAAAAAQZG9oLnRpYXIuYXBwOjc4Mw": ("quic://doh.tiar.app:783", .doq)
    ]
    
    func testResolver() {
        for (upstream, result) in testCases {
            let parserResult = DnsResolver.resolve(upstream: upstream)
            XCTAssertEqual(parserResult.dnsServer, result.dnsServer)
            XCTAssertEqual(parserResult.dnsProtocol, result.dnsProtocol)
        }
    }
}
