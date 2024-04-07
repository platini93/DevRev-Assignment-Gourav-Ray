import Foundation

/// View Protocol
protocol MovieDetailsViewProtocol {
   func showActIndicator()
   func hideActIndicator()
   func showAlertView(title:String, message:String, noNetwork:Bool)
}

/// View Model Proocol
protocol MovieDetailsViewModelProtocol: AnyObject {
    var bindViewModelToController:(() -> ()) { get set }
    func fetchMovieDetails(movieID:Int)
    func getMovieDetails() -> MovieDetails?
    func getPosterImageURL(path:String) -> URL?
    func getLowResPosterImageURL(path:String) -> URL?
    func getBackdropImageURL(path:String) -> URL?
    func getLowResBackdopImageURL(path:String) -> URL?
}

/// View Model
class MovieDetailsViewModel: MovieDetailsViewModelProtocol {
    
    var appCoordinator:AppCoordinator?
    var group: DispatchGroup
    var queue: DispatchQueue
    
    var view: MovieDetailsViewProtocol?
    private var apiService:MovieDetailsAPIServiceProtocol
    var bindViewModelToController:(() -> ()) = {}
    
    private(set) var movieDetails:MovieDetails? {
        didSet { 
            self.bindViewModelToController()
        }
    }
    
    init(view: MovieDetailsViewProtocol, apiService: MovieDetailsAPIServiceProtocol) {
        self.view = view
        self.apiService = apiService
        self.group = DispatchGroup()
        self.queue = DispatchQueue(label: "com.demo.api", attributes: .concurrent)
    }
    
    /// fetchMovieDetails
    /// - Parameter movieID: movieID
    func fetchMovieDetails(movieID:Int) {
        guard InternetConnectionManager.shared.isConnectedToNetwork() else {
            self.view?.showAlertView(title: "Error", message: "No Network Connectivity!", noNetwork: true)
            return
        }
        self.view?.showActIndicator()
        apiService.callMovieDetailsAPI(movieID: movieID) { [weak self] (movieDetails, error) in
            self?.view?.hideActIndicator()
            if error != nil {
                self?.view?.showAlertView(title: "Error", message: error?.localizedDescription ?? "Error!", noNetwork: false)
            } else if movieDetails != nil {
                self?.movieDetails = movieDetails
            }
        }
    }
    
    func getMovieDetails() -> MovieDetails? {
        return movieDetails
    }
    
    func getPosterImageURL(path:String) -> URL? {
        let configData = CacheManager.retrieve(objectType: Configuration.self, forKey: AppConstants.UDKeys.configurationResponse.value)
        guard let base_url = configData?.images?.secureBaseUrl else { return nil }
        let posterSize = configData?.images?.posterSizes?.last ?? "original"
        let urlString = base_url + posterSize + path
        guard let url = URL(string: urlString) else { return nil }
        return url
    }
    
    func getLowResPosterImageURL(path:String) -> URL? {
        let configData = CacheManager.retrieve(objectType: Configuration.self, forKey: AppConstants.UDKeys.configurationResponse.value)
        guard let base_url = configData?.images?.secureBaseUrl else { return nil }
        let posterSize = configData?.images?.posterSizes?.first ?? "original"
        let urlString = base_url + posterSize + path
        guard let url = URL(string: urlString) else { return nil }
        return url
    }
    
    func getBackdropImageURL(path:String) -> URL? {
        let configData = CacheManager.retrieve(objectType: Configuration.self, forKey: AppConstants.UDKeys.configurationResponse.value)
        guard let base_url = configData?.images?.secureBaseUrl else { return nil }
        let posterSize = configData?.images?.backdropSizes?.last ?? "original"
        let urlString = base_url + posterSize + path
        guard let url = URL(string: urlString) else { return nil }
        return url
    }
    
    func getLowResBackdopImageURL(path:String) -> URL? {
        let configData = CacheManager.retrieve(objectType: Configuration.self, forKey: AppConstants.UDKeys.configurationResponse.value)
        guard let base_url = configData?.images?.secureBaseUrl else { return nil }
        let posterSize = configData?.images?.backdropSizes?.first ?? "original"
        let urlString = base_url + posterSize + path
        guard let url = URL(string: urlString) else { return nil }
        return url
    }
}


