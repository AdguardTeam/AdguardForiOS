import XCTest

class DnsResolverTest: XCTestCase {
    
    var testCases: [String: DnsResolverProtocol.DnsResolverResult] = [
        "sdns://AAcAAAAAAAAADDk0LjE0MC4xNC4xNA": ("94.140.14.14:53", .dns),
        "sdns://AAcAAAAAAAAAE1syYTEwOjUwYzA6OmFkMTpmZl0" : ("[2a10:50c0::ad1:ff]:53", .dns),
        "sdns://AQIAAAAAAAAAFDE3Ni4xMDMuMTMwLjEzMDo1NDQzINErR_JS3PLCu_iZEIbq95zkSV2LFsigxDIuUso_OQhzIjIuZG5zY3J5cHQuZGVmYXVsdC5uczEuYWRndWFyZC5jb20": ("sdns://AQIAAAAAAAAAFDE3Ni4xMDMuMTMwLjEzMDo1NDQzINErR_JS3PLCu_iZEIbq95zkSV2LFsigxDIuUso_OQhzIjIuZG5zY3J5cHQuZGVmYXVsdC5uczEuYWRndWFyZC5jb20", .dnsCrypt),
        "sdns://AQIAAAAAAAAAGVsyYTAwOjVhNjA6OmFkMjowZmZdOjU0NDMggdAC02pMpQxHO3R5ZQ_hLgKzIcthOFYqII5APf3FXpQiMi5kbnNjcnlwdC5kZWZhdWx0Lm5zMi5hZGd1YXJkLmNvbQ": ("sdns://AQIAAAAAAAAAGVsyYTAwOjVhNjA6OmFkMjowZmZdOjU0NDMggdAC02pMpQxHO3R5ZQ_hLgKzIcthOFYqII5APf3FXpQiMi5kbnNjcnlwdC5kZWZhdWx0Lm5zMi5hZGd1YXJkLmNvbQ", .dnsCrypt),
        "sdns://AgcAAAAAAAAAAAAPZG5zLmFkZ3VhcmQuY29tCi9kbnMtcXVlcnk": ("https://dns.adguard.com/dns-query", .doh),
        "sdns://AwAAAAAAAAAAAAAVdGxzOi8vZG5zLmFkZ3VhcmQuY29t": ("tls://dns.adguard.com", .dot),
        "sdns://AwAAAAAAAAAAAAATdGxzOi8vMTQ5LjExMi4xMTIuOQ": ("tls://149.112.112.9", .dot),
        "sdns://AgEAAAAAAAAAAAANZG5zLnF1YWQ5Lm5ldAovZG5zLXF1ZXJ5": ("https://dns.quad9.net/dns-query", .doh),
        "sdns://AAAAAAAAAAAACDkuOS45LjEw": ("9.9.9.10:53", .dns),
        "sdns://AAAAAAAAAAAADVsyNjIwOmZlOjoxMF0": ("[2620:fe::10]:53", .dns),
        "sdns://AQMAAAAAAAAADTkuOS45LjEwOjg0NDMgZ8hHuMh1jNEgJFVDvnVnRt803x2EwAuMRwNo34Idhj4ZMi5kbnNjcnlwdC1jZXJ0LnF1YWQ5Lm5ldA": ("sdns://AQMAAAAAAAAADTkuOS45LjEwOjg0NDMgZ8hHuMh1jNEgJFVDvnVnRt803x2EwAuMRwNo34Idhj4ZMi5kbnNjcnlwdC1jZXJ0LnF1YWQ5Lm5ldA", .dnsCrypt),
        "sdns://AQMAAAAAAAAAFVsyNjIwOmZlOjpmZToxMF06ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0": ("sdns://AQMAAAAAAAAAFVsyNjIwOmZlOjpmZToxMF06ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0", .dnsCrypt),
        "sdns://BAcAAAAAAAAADDk0LjE0MC4xNC4xNAAPZG5zLmFkZ3VhcmQuY29t": ("quic://dns.adguard.com", .doq)
    ]
    
    func testResolver() {
        for (upstream, result) in testCases {
            let parserResult = DnsResolver.resolve(upstream: upstream)
            XCTAssertEqual(parserResult.dnsServer, result.dnsServer)
            XCTAssertEqual(parserResult.dnsProtocol, result.dnsProtocol)
        }
    }
}
