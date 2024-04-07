import Foundation

struct APIVersion {
    static let v3 = "3"
}

struct EnvironmentTypeUrl {
    static let Https = "https"
    static let ProdURL = "api.themoviedb.org/"
}

struct API {
    static let scheme = EnvironmentTypeUrl.Https
    static let seprator = "://"
    static let host = EnvironmentTypeUrl.ProdURL
    static let apiVersion = APIVersion.v3
    static let baseUrl = scheme + seprator + host + apiVersion
}

protocol Endpoint {
    var path: String { get }
}

enum Endpoints {
    
    enum BaseURL: Endpoint {
        case configuration
        
        public var path:String {
            switch self {
            case .configuration: return "/configuration"
            }
        }
    }
    
    enum Movie: Endpoint {
        case latest
        case popular
        case details
        case genres

        public var path: String {
            switch self {
            case .latest: return "/movie/now_playing" // ?language=en-US&page=1
            case .popular: return "/movie/popular" // ?language=en-US&page=1
            case .details: return "/movie/" // {movie_id} ?language=en-US
            case .genres: return "/genre/movie/list" // ?language=en
            }
        }
    }
    
}

class APIConfig {
    private init() {}
    class func getBaseUrl(path: String, queryParams:[String:Any]? = nil) -> String {
        if let qp = queryParams {
            let params:String = qp.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
            return "\(API.baseUrl)\(path)?\(params)"
        }
        return "\(API.baseUrl)\(path)"
    }
}
