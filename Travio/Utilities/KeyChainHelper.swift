

import Foundation
import Security

struct KeychainHelper {
    private static let accessTokenKey = "access-token"
    private static let refreshTokenKey = "refresh-token"
        
    @discardableResult
    static func saveRefreshToken(_ token: String) -> Bool {
        return saveString(refreshTokenKey, value: token)
    }

    static func loadRefreshToken() -> String? {
        return loadString(refreshTokenKey)
    }

    @discardableResult
    static func deleteRefreshToken() -> Bool {
        return deleteString(refreshTokenKey)
    }
    
    @discardableResult
    static func saveAccessToken(_ token: String) -> Bool {
        return saveString(accessTokenKey, value: token)
    }
    
    static func loadAccessToken() -> String? {
        return loadString(accessTokenKey)
    }
    
    @discardableResult
    static func deleteAccessToken() -> Bool {
        return deleteString(accessTokenKey)
    }
    
    private static func saveString(_ key: String, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    private static func loadString(_ key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: kCFBooleanTrue!
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess, let data = dataTypeRef as? Data, let loadedString = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return loadedString
    }
    
    private static func deleteString(_ key: String) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
