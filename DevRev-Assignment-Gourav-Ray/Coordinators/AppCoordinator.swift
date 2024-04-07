
import Foundation
import UIKit

/// Coordinator
protocol Coordinator {
    var parent:Coordinator? { get set }
    var children:[Coordinator] { get set }
    var navigationController:UINavigationController { get set }
    func start()
}

/// AppCoordinator
class AppCoordinator: Coordinator {
    var navigationController:UINavigationController
    var parent: Coordinator?
    var children: [Coordinator] = []
    
    let storyboard = AppConstants.Storyboards.main.value
    
    init(navControl: UINavigationController) {
        self.navigationController = navControl
    }
    
    func start() {
        goToMoviesListScreen()
    }
    
    func goToMoviesListScreen(){
        let moviesListViewController = storyboard.instantiateViewController(withIdentifier: AppConstants.ViewControllers.movieLists.value) as! MoviesListViewController
        let moviesListViewModel = MoviesListViewModel(view: moviesListViewController, apiService: MoviesListAPIService(), connectionManager: InternetConnectionManager.shared)
        moviesListViewModel.appCoordinator = self
        moviesListViewController.moviesListViewModel = moviesListViewModel
        navigationController.pushViewController(moviesListViewController, animated: false)
    }
    
    func goToMovieDetailsScreen(_ details:MovieDetails){
        let movieDetailsVC = storyboard.instantiateViewController(withIdentifier: AppConstants.ViewControllers.movieDetails.value) as! MovieDetailsViewController
        let movieDetailsViewModel = MovieDetailsViewModel(view: movieDetailsVC, apiService: MovieDetailsAPIService())
        movieDetailsViewModel.appCoordinator = self
        movieDetailsVC.movieDetailsViewModel = movieDetailsViewModel
        movieDetailsVC.movieDetails = details
        navigationController.pushViewController(movieDetailsVC, animated: true)
    }
}
