import Foundation

/// View Protocol
protocol MoviesListViewProtocol {
   func showActIndicator()
   func hideActIndicator()
   func showAlertView(title:String, message:String, noNetwork:Bool)
   func updateUI()
}

/// View Model Proocol
protocol MoviesListViewModelProtocol: AnyObject {
    var group:DispatchGroup { get set }
    var queue:DispatchQueue { get set }
    var view: MoviesListViewProtocol { get set }
    var internetConnectionManager:InternetConnectionManagerProtocol { get set }
    var bindViewModelToController:(() -> ()) { get set }
    func fetchMasterData()
    func fetchConfigurationData()
    func fetchGenresMasterData()
    func fetchLatestMoviesList()
    func fetchPopularMoviesList()
    func fetchMovieDetails(movieID:Int)
    func getConfigData() -> Configuration?
    func getMovieGenresData() -> GenreResponse?
    func getLatestMoviesList() -> MovieResponse?
    func getPopularMoviesList() -> MovieResponse?
    func getMovieDetails() -> MovieDetails?
    func getPosterImageURL(path:String) -> URL?
    func getLowResPosterImageURL(path:String) -> URL?
    func goToMovieDetailScreen(details:MovieDetails)
}

extension MoviesListViewModelProtocol {
    /// fetchMasterData
    func fetchMasterData() {
        guard internetConnectionManager.isConnectedToNetwork() else {
            self.view.showAlertView(title: "Error", message: "No Network Connectivity", noNetwork: true)
            return
        }
        group.enter()
        queue.async(group: group) { [weak self] in
            self?.fetchConfigurationData()
        }
        
        group.enter()
        queue.async(group: group) { [weak self] in
            self?.fetchGenresMasterData()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.bindViewModelToController()
        }
    }
}

/// View Model
class MoviesListViewModel: MoviesListViewModelProtocol {
    
    var internetConnectionManager:InternetConnectionManagerProtocol
    var appCoordinator:AppCoordinator?
    var group: DispatchGroup
    var queue: DispatchQueue
    
    var view: MoviesListViewProtocol
    private var apiService:MoviesListAPIServiceProtocol
    var bindViewModelToController:(() -> ()) = {}
    
    private(set) var configData:Configuration?
    private(set) var movieGenres:GenreResponse?
    private(set) var latestMovies:MovieResponse? {
        didSet { 
            self.bindViewModelToController()
        }
    }
    private(set) var popularMovies:MovieResponse? {
        didSet {
            self.bindViewModelToController()
        }
    }
    private(set) var movieDetails:MovieDetails? {
        didSet {
            self.bindViewModelToController()
        }
    }
    
    init(view: MoviesListViewProtocol, apiService: MoviesListAPIServiceProtocol, connectionManager: InternetConnectionManagerProtocol) {
        self.view = view
        self.apiService = apiService
        self.group = DispatchGroup()
        self.queue = DispatchQueue(label: "com.demo.apiQueue", attributes: .concurrent)
        self.internetConnectionManager = connectionManager
    }
    
    /// fetchConfigurationData
    func fetchConfigurationData() {
        guard internetConnectionManager.isConnectedToNetwork() else {
            self.view.showAlertView(title: "Error", message: "No Network Connectivity", noNetwork: true)
            group.leave()
            return
        }
        self.view.showActIndicator()
        apiService.callConfigurationAPI() { [weak self] (config, error) in
            defer {
                self?.group.leave()
            }
            self?.view.hideActIndicator()
            if error != nil {
                self?.view.showAlertView(title: "Error", message: error?.localizedDescription ?? "Error!", noNetwork: false)
            } else if config != nil {
                self?.configData = config
            }
        }
    }
    
    /// fetchGenresMasterData
    func fetchGenresMasterData() {
        guard internetConnectionManager.isConnectedToNetwork() else {
            self.view.showAlertView(title: "Error", message: "No Network Connectivity", noNetwork: true)
            group.leave()
            return
        }
        self.view.showActIndicator()
        apiService.callMovieGenresAPI() { [weak self] (genres, error) in
            defer {
                self?.group.leave()
            }
            self?.view.hideActIndicator()
            if error != nil {
                self?.view.showAlertView(title: "Error", message: error?.localizedDescription ?? "Error!", noNetwork: false)
            } else if genres != nil {
                self?.movieGenres = genres
            }
        }
    }
    
    /// fetchLatestMoviesList
    func fetchLatestMoviesList() {
        guard internetConnectionManager.isConnectedToNetwork() else {
            self.view.showAlertView(title: "Error", message: "No Network Connectivity", noNetwork: true)
            return
        }
        self.view.showActIndicator()
        apiService.callLatestMoviesAPI() { [weak self] (movies, error) in
            self?.view.hideActIndicator()
            if error != nil {
                self?.view.showAlertView(title: "Error", message: error?.localizedDescription ?? "Error!", noNetwork: false)
            } else if movies != nil {
                self?.latestMovies = movies
            }
        }
    }
    
    /// fetchPopularMoviesList
    func fetchPopularMoviesList() {
        guard internetConnectionManager.isConnectedToNetwork() else {
            self.view.showAlertView(title: "Error", message: "No Network Connectivity", noNetwork: true)
            return
        }
        self.view.showActIndicator()
        apiService.callPopularMoviesAPI() { [weak self] (movies, error) in
            self?.view.hideActIndicator()
            if error != nil {
                self?.view.showAlertView(title: "Error", message: error?.localizedDescription ?? "Error!", noNetwork: false)
            } else if movies != nil {
                self?.popularMovies = movies
                LogsManager.consoleLog(self?.popularMovies as Any)
            }
        }
    }
    
    /// fetchMovieDetails
    /// - Parameter movieID: movieID
    func fetchMovieDetails(movieID:Int) {
        guard internetConnectionManager.isConnectedToNetwork() else {
            self.view.showAlertView(title: "Error", message: "No Network Connectivity", noNetwork: true)
            return
        }
        self.view.showActIndicator()
        apiService.callMovieDetailsAPI(movieID: movieID) { [weak self] (movieDetails, error) in
            self?.view.hideActIndicator()
            if error != nil {
                self?.view.showAlertView(title: "Error", message: error?.localizedDescription ?? "Error!", noNetwork: false)
            } else if movieDetails != nil {
                self?.movieDetails = movieDetails
            }
        }
    }
    
    /// goToMovieDetailScreen
    func goToMovieDetailScreen(details:MovieDetails) {
        appCoordinator?.goToMovieDetailsScreen(details)
    }
    
    func getConfigData() -> Configuration? {
        return configData
    }
    
    func getMovieGenresData() -> GenreResponse? {
        return movieGenres
    }
    
    func getLatestMoviesList() -> MovieResponse? {
        return latestMovies
    }
    
    func getPopularMoviesList() -> MovieResponse? {
        return popularMovies
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
}


