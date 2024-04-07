import Foundation

class CacheManager {
    private init() {}
    static func save<T: Codable>(object: T, forKey key: String) {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(object)
            UserDefaults.standard.set(encodedData, forKey: key)
        } catch {
            LogsManager.consoleLog(message: "Encoding error : \(error)")
        }
    }
    
    static func retrieve<T: Codable>(objectType: T.Type, forKey key: String) -> T? {
        if let encodedData = UserDefaults.standard.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(objectType, from: encodedData)
                return object
            } catch {
                LogsManager.consoleLog(message: "Decoding error : \(error)")
                return nil
            }
        }
        return nil
    }
    
    static func removeObject(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    /// isCachedConfigDataAvailable
    /// - Returns: Bool
    static func isCachedConfigDataAvailable() -> Bool {
        if let _ = retrieve(objectType: Configuration.self, forKey: AppConstants.UDKeys.configurationResponse.value), let _ = retrieve(objectType: Genre.self, forKey: AppConstants.UDKeys.genresResponse.value) {
            return true
        }
        return false
    }
}

