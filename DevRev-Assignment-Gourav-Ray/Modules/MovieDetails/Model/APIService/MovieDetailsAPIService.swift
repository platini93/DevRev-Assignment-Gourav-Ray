import Foundation
import NetworkFramework

/// MovieDetailsAPIServiceProtocol
protocol MovieDetailsAPIServiceProtocol {
    func callMovieDetailsAPI(movieID:Int, completion: @escaping (MovieDetails?, Error?) -> Void)
}

/// MovieDetailsAPIService
class MovieDetailsAPIService: MovieDetailsAPIServiceProtocol {
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
