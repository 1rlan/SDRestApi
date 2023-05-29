import Foundation
import CommonCrypto

extension String {
    public mutating func hashPassword() {
        self = getPasswordHash()
    }
    
    public func getPasswordHash() -> String {
        guard let data = data(using: .utf8) else {
            fatalError()
        }
        
        var hashData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = hashData.withUnsafeMutableBytes { hashBytes in
            data.withUnsafeBytes { passwordBytes in
                CC_SHA256(passwordBytes.baseAddress, CC_LONG(data.count), hashBytes.bindMemory(to: UInt8.self).baseAddress)
            }
        }
        
        return hashData.map { String(format: "%02hhx", $0) }.joined()
    }
}
