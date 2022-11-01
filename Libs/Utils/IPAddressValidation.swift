import Foundation

// About inet_pton - https://man7.org/linux/man-pages/man3/inet_pton.3.html

extension String {

    /// Returns true if address is valid IPv4/IPv6 with/without  port
    func isValidIPAddress() -> Bool { isValidIPv4Address() || isValidIPv6Address() }



    /* ========================= */
    /* IPv4 validation functions */
    /* ========================= */



    /// Returns true if address is valid IPv4 or if address is valid IPv4 with valid port
    func isValidIPv4Address() -> Bool { isValidIPv4AddressOnly() || isValidIPv4AddressWithPort() }

    /// Returns true if address is valid IPv4.
    /// Warning! this function checks only IPv4 not IPv4 with port.
    func isValidIPv4AddressOnly() -> Bool {
        var ipv4SocketAddress = sockaddr_in()
        return self.withCString({ string in inet_pton(AF_INET, string, &ipv4SocketAddress.sin_addr) }) == 1
    }

    /// Returns true if address is valid IPv4 with valid port
    func isValidIPv4AddressWithPort() -> Bool {
        /// Validation checks:
        ///  - Check if port separator is exists
        ///  - Check if port separator is number
        ///  - Check if port separator is number in valid range
        ///  - Check if IP address is valid IPv4 without port

        guard let portSeparatorRange = range(of: ":"),
              let _ = UInt16(self[portSeparatorRange.upperBound..<endIndex]) else { return false }

        return String(self[startIndex..<portSeparatorRange.lowerBound]).isValidIPv4AddressOnly()
    }



    /* ========================= */
    /* IPv6 validation functions */
    /* ========================= */



    /// Returns true if address is valid IPv6 or if address is valid IPv6 with valid port
    func isValidIPv6Address() -> Bool { isValidIPv6AddressOnly() || isValidIPv6AddressWithPort() }

    /// Returns true if address is valid IPv6.
    /// Warning! this function checks only IPv6 not IPv6 with port.
    func isValidIPv6AddressOnly() -> Bool {
        var ipv6SocketAddress = sockaddr_in6()
        return self.withCString({ string in inet_pton(AF_INET6, string, &ipv6SocketAddress.sin6_addr) }) == 1
    }

    /// Returns true if address is valid IPv6 with valid port
    func isValidIPv6AddressWithPort() -> Bool {
        /// Validation checks:
        ///  - Check if open bracket is exists
        ///  - Check if close bracket is exists
        ///  - Check if port separator is exists
        ///  - Check if port separator is number
        ///  - Check if port separator is number in valid range
        ///  - Check if IP address is valid IPv6 without port

        guard let openBracketRange = range(of: "["),
              let closeBracketRange = range(of: "]"),
              let portSeparatorIndex = index(closeBracketRange.upperBound, offsetBy: 1, limitedBy: endIndex),
              let _ = UInt16(self[portSeparatorIndex..<endIndex]) else { return false }

        return String(self[openBracketRange.upperBound..<closeBracketRange.lowerBound]).isValidIPv6AddressOnly()
    }
}
