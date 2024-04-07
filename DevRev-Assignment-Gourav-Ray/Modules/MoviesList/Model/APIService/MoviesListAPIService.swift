import Foundation
import NetworkFramework

/// MoviesListAPIServiceProtocol
protocol MoviesListAPIServiceProtocol {
    func callConfigurationAPI(completion: @escaping (_ responseObject:Configuration?, Error?) -> Void)
    func callMovieGenresAPI(completion: @escaping (_ responseObject:GenreResponse?, Error?) -> Void)
    func callLatestMoviesAPI(completion: @escaping (MovieResponse?, Error?) -> Void)
    func callPopularMoviesAPI(completion: @escaping (MovieResponse?, Error?) -> Void)
    func callMovieDetailsAPI(movieID:Int, completion: @escaping (MovieDetails?, Error?) -> Void)
}

/// MoviesListAPIService
class MoviesListAPIService: MoviesListAPIServiceProtocol {
    
    /// callConfigurationAPI
    func callConfigurationAPI(completion: @escaping (_ responseObject:Configuration?, Error?) -> Void) {
        NetworkRequest.shared.genericGETRequest(urlString: APIConfig.getBaseUrl(path: Endpoints.BaseURL.configuration.path), token: AppConstants.APIConstants.apiReadAccessToken.value, logs: .disabled, cachePolicy: .reloadIgnoringLocalCacheData) { (responseObject:Configuration?, error) in
            if let responseObject = responseObject {
                //TODO: cache configuration api response
                CacheManager.save(object: responseObject, forKey: AppConstants.UDKeys.configurationResponse.value)
                completion(responseObject, nil)
            } else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    /// callMovieGenresAPI
    func callMovieGenresAPI(completion: @escaping (GenreResponse?, Error?) -> Void) {
        NetworkRequest.shared.genericGETRequest(urlString: APIConfig.getBaseUrl(path: Endpoints.Movie.genres.path, queryParams: ["language":"en"]), token: AppConstants.APIConstants.apiReadAccessToken.value, logs: .disabled, cachePolicy: .reloadIgnoringLocalCacheData) { (responseObject:GenreResponse?, error) in
            if let responseObject = responseObject {
                //TODO: cache genres api response
                CacheManager.save(object: responseObject, forKey: AppConstants.UDKeys.genresResponse.value)
                completion(responseObject, nil)
            } else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    /// callLatestMoviesAPI
    func callLatestMoviesAPI(completion: @escaping (MovieResponse?, Error?) -> Void) {
        NetworkRequest.shared.genericGETRequest(urlString: APIConfig.getBaseUrl(path: Endpoints.Movie.latest.path, queryParams: ["language":"en-US", "page":1]), token: AppConstants.APIConstants.apiReadAccessToken.value, logs: .disabled, cachePolicy: .reloadIgnoringLocalCacheData) { (responseObject:MovieResponse?, error) in
            if let responseObject = responseObject {
                completion(responseObject, nil)
            } else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    /// callPopularMoviesAPI
    func callPopularMoviesAPI(completion: @escaping (MovieResponse?, Error?) -> Void) {
        NetworkRequest.shared.genericGETRequest(urlString: APIConfig.getBaseUrl(path: Endpoints.Movie.popular.path, queryParams: ["language":"en-US", "page":1]), token: AppConstants.APIConstants.apiReadAccessToken.value, logs: .disabled, cachePolicy: .reloadIgnoringLocalCacheData) { (responseObject:MovieResponse?, error) in
            if let responseObject = responseObject {
                completion(responseObject, nil)
            } else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    /// callMovieDetailsAPI
    func callMovieDetailsAPI(movieID:Int, completion: @escaping (MovieDetails?, Error?) -> Void) {
        // {movie_id} ?language=en-US
        NetworkRequest.shared.genericGETRequest(urlString: APIConfig.getBaseUrl(path: Endpoints.Movie.details.path.appending("\(movieID)"), queryParams: ["language":"en-US"]), token: AppConstants.APIConstants.apiReadAccessToken.value, logs: .disabled, cachePolicy: .reloadIgnoringLocalCacheData) { (responseObject:MovieDetails?, error) in
            if let responseObject = responseObject {
                completion(responseObject, nil)
            } else if let error = error {
                completion(nil, error)
            }
        }
    }
}
