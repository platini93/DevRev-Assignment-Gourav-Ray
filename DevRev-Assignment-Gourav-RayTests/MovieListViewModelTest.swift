//
//  MovieListViewModelTest.swift
//  DevRev-assignment-Gourav_RayTests
//
//  Created by Gourav Ray on 07/04/24.
//

import XCTest
@testable import DevRev_Assignment_Gourav_Ray

class MovieListViewModelTests: XCTestCase {
    
    class MockMoviesListAPIService: MoviesListAPIServiceProtocol {
        func callLatestMoviesAPI(completion: @escaping (DevRev_Assignment_Gourav_Ray.MovieResponse?, Error?) -> Void) {
            let mockMovieResponse = MovieResponse(
                dates: DateRange(maximum: "2024-04-07", minimum: "2024-04-01"),
                page: 1,
                results: [
                    Movie(
                        adult: false,
                        backdropPath: "/backdrop_path_1.jpg",
                        genreIds: [1, 2, 3],
                        id: 1,
                        originalLanguage: "en",
                        originalTitle: "Movie Title 1",
                        overview: "Overview of Movie 1",
                        popularity: 123.45,
                        posterPath: "/poster_path_1.jpg",
                        releaseDate: "2024-04-01",
                        title: "Movie Title 1",
                        video: false,
                        voteAverage: 7.8,
                        voteCount: 100
                    ),
                    Movie(
                        adult: false,
                        backdropPath: "/backdrop_path_2.jpg",
                        genreIds: [4, 5],
                        id: 2,
                        originalLanguage: "en",
                        originalTitle: "Movie Title 2",
                        overview: "Overview of Movie 2",
                        popularity: 67.89,
                        posterPath: "/poster_path_2.jpg",
                        releaseDate: "2024-04-02",
                        title: "Movie Title 2",
                        video: true,
                        voteAverage: 6.5,
                        voteCount: 50
                    )
                ],
                totalPages: 1,
                totalResults: 2
            )
            completion(mockMovieResponse,nil)
        }
        
        func callPopularMoviesAPI(completion: @escaping (DevRev_Assignment_Gourav_Ray.MovieResponse?, Error?) -> Void) {}
        
        func callMovieDetailsAPI(movieID: Int, completion: @escaping (DevRev_Assignment_Gourav_Ray.MovieDetails?, Error?) -> Void) {}
        
        func callConfigurationAPI(completion: @escaping (DevRev_Assignment_Gourav_Ray.Configuration?, Error?) -> Void) {}
        
        func callMovieGenresAPI(completion: @escaping (DevRev_Assignment_Gourav_Ray.GenreResponse?, Error?) -> Void) {}
    }
    
    class MockMoviesListViewController: MoviesListViewProtocol {
        var isShowActIndicator:Bool = false
        var isHideActIndicator:Bool = false
        var isShowAlertView:Bool = false
        var isUpdateUI:Bool = false
        
        func showActIndicator() {
            self.isShowActIndicator = true
        }
        
        func hideActIndicator() {
            self.isShowActIndicator = false
        }
        
        func showAlertView(title: String, message: String, noNetwork: Bool) {
            self.isShowAlertView = true
        }
        
        func updateUI() {
            self.isUpdateUI = true
        }
    }
    
    class MockInternetConnectionManager: InternetConnectionManagerProtocol {
        var isConnected:Bool
        init(isConnected: Bool) {
            self.isConnected = isConnected
        }
        func isConnectedToNetwork() -> Bool {
            return isConnected
        }
    }
    
    var viewModel: MoviesListViewModel?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        self.viewModel = nil
        super.tearDown()
    }
    
    // Success test
    func test_fetchLatestMoviesList_Success() {
        let mockAPIService:MoviesListAPIServiceProtocol = MockMoviesListAPIService()
        let mockViewController:MoviesListViewProtocol = MockMoviesListViewController()
        let mockInternetManager:InternetConnectionManagerProtocol = MockInternetConnectionManager(isConnected: true)
        self.viewModel = MoviesListViewModel(view: mockViewController, apiService: mockAPIService, connectionManager: mockInternetManager)
        self.viewModel?.fetchLatestMoviesList()
        XCTAssertNotNil(self.viewModel?.latestMovies)
        XCTAssertEqual(self.viewModel?.latestMovies?.results?.first?.title, "Movie Title 1")
        XCTAssertEqual(self.viewModel?.latestMovies?.results?.count, 2)
    }
    
    // Failure test
    func test_fetchLatestMoviesList_Failure() {
        let mockAPIService:MoviesListAPIServiceProtocol = MockMoviesListAPIService()
        let mockViewController:MoviesListViewProtocol = MockMoviesListViewController()
        let mockInternetManager:InternetConnectionManagerProtocol = MockInternetConnectionManager(isConnected: false)
        self.viewModel = MoviesListViewModel(view: mockViewController, apiService: mockAPIService, connectionManager: mockInternetManager)
        self.viewModel?.fetchLatestMoviesList()
        XCTAssertNotNil(self.viewModel?.latestMovies)
    }
    
    // Success test
    func test_fetchLatestMoviesList_NoNetwork() {
        let mockAPIService:MoviesListAPIServiceProtocol = MockMoviesListAPIService()
        let mockViewController:MoviesListViewProtocol = MockMoviesListViewController()
        let mockInternetManager:InternetConnectionManagerProtocol = MockInternetConnectionManager(isConnected: false)
        self.viewModel = MoviesListViewModel(view: mockViewController, apiService: mockAPIService, connectionManager: mockInternetManager)
        self.viewModel?.fetchLatestMoviesList()
        XCTAssertNil(self.viewModel?.latestMovies)
    }
    
}
