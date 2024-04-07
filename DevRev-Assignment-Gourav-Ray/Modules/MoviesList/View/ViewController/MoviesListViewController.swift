import UIKit
import Toast_Swift
import Kingfisher

class MoviesListViewController: UIViewController {
   
    @IBOutlet weak var segmentedControlView: UIView!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    var sgControl = SegmentedControl(items: [AppConstants.SegmentNames.latest.value, AppConstants.SegmentNames.popular.value])
    var selectedSegment = AppConstants.SelectedSegment.latest
    
    var moviesListViewModel:MoviesListViewModelProtocol?
    private var latestMovies:[Movie]?
    private var popularMovies:[Movie]?
    private var dataSource:[Movie]?
    private var movieDetails:MovieDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMasterData()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .black
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        if #available(iOS 15.0, *) {
            navigationController?.navigationBar.compactScrollEdgeAppearance = navBarAppearance
        }
        title = "Movies List"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpSegmentedControl()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func configureUI() {
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.prefetchDataSource = self
        movieCollectionView.register(UINib(nibName: AppConstants.CollectionViewCells.moviesList.value, bundle: nil), forCellWithReuseIdentifier: AppConstants.CollectionViewCells.moviesList.value)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width*0.75, height: movieCollectionView.bounds.size.height)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        movieCollectionView.collectionViewLayout = flowLayout
    }
    
    func setupUI() {
        let gradientColors: [UIColor] = [ColorConstants.bgGrey, ColorConstants.bgGreen, ColorConstants.bgGrey]
        let imageSize = CGSize(width: movieCollectionView.bounds.size.width, height: movieCollectionView.bounds.size.height)
        let gradientImage = UIImage.verticalGradientImage(colors: gradientColors, size: imageSize)
        movieCollectionView.backgroundColor = UIColor(patternImage: gradientImage!)
    }
    
    func setUpSegmentedControl() {
        let cyan = UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20.0)]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: cyan, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20.0)]
        sgControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        sgControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        sgControl.frame = CGRect(origin: segmentedControlView.frame.origin, size: segmentedControlView.frame.size)
        sgControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        view.addSubview(sgControl)
        view.bringSubviewToFront(sgControl)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        LogsManager.consoleLog(message: "Selected segment index: \(sender.selectedSegmentIndex)")
        let selection = AppConstants.SelectedSegment.init(rawValue: sender.selectedSegmentIndex)
        guard selection != selectedSegment else { return }
        if selection == AppConstants.SelectedSegment.latest {
            selectedSegment = AppConstants.SelectedSegment.latest
            fetchLatestMoviesList()
        } else if selection == AppConstants.SelectedSegment.popular {
            selectedSegment = AppConstants.SelectedSegment.popular
            fetchPopularMoviesList()
        }
    }
    
    func fetchMasterData() {
        moviesListViewModel?.bindViewModelToController = { [weak self] in
            self?.updateUI()
        }
        moviesListViewModel?.fetchMasterData()
    }
    
    func updateUI() {
        if selectedSegment == AppConstants.SelectedSegment.latest {
            fetchLatestMoviesList(reloadAnimation: false)
        } else if selectedSegment == AppConstants.SelectedSegment.popular {
            fetchPopularMoviesList(reloadAnimation: false)
        }
    }
    
    func fetchLatestMoviesList(reloadAnimation:Bool=true) {
        guard CacheManager.isCachedConfigDataAvailable() else {
            fetchMasterData()
            return
        }
        moviesListViewModel?.bindViewModelToController = { [weak self] in
            self?.populateCollectionWithLatestMovies(reloadAnimation: reloadAnimation)
        }
        moviesListViewModel?.fetchLatestMoviesList()
    }
    
    func fetchPopularMoviesList(reloadAnimation:Bool=true) {
        guard CacheManager.isCachedConfigDataAvailable() else {
            fetchMasterData()
            return
        }
        moviesListViewModel?.bindViewModelToController = { [weak self] in
            self?.populateCollectionWithPopularMovies(reloadAnimation: reloadAnimation)
        }
        moviesListViewModel?.fetchPopularMoviesList()
    }
    
    func populateCollectionWithLatestMovies(reloadAnimation:Bool=true) {
        latestMovies = moviesListViewModel?.getLatestMoviesList()?.results
        DispatchQueue.main.async { [weak self] in
            self?.dataSource = self?.latestMovies
            self?.reloadData(withAnimation: reloadAnimation)
            self?.movieCollectionView.backgroundView = nil
        }
    }
    
    func populateCollectionWithPopularMovies(reloadAnimation:Bool=true) {
        popularMovies = moviesListViewModel?.getPopularMoviesList()?.results
        DispatchQueue.main.async { [weak self] in
            self?.dataSource = self?.popularMovies
            self?.reloadData(withAnimation: reloadAnimation)
            self?.movieCollectionView.backgroundView = nil
        }
    }
    
    func fetchMovieDetails(withID id: Int) {
        moviesListViewModel?.bindViewModelToController = { [weak self] in
            self?.processMovieDetails()
        }
        moviesListViewModel?.fetchMovieDetails(movieID: id)
    }
    
    func processMovieDetails() {
        DispatchQueue.main.async { [weak self] in
            self?.movieDetails = self?.moviesListViewModel?.getMovieDetails()!
            self?.executeAfter(delay: 0.2, execute: { [weak self] in
                self?.moviesListViewModel?.goToMovieDetailScreen(details: (self?.movieDetails)!)
            })
        }
    }
    
    func reloadData(withAnimation animation:Bool=true) {
        DispatchQueue.main.async { [weak self] in
            guard animation == true else {
                self?.movieCollectionView.reloadData()
                return
            }
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.movieCollectionView.alpha = 0.2
            }) {[weak self] _ in
                self?.movieCollectionView.reloadData()
                UIView.animate(withDuration: 0.3) {
                    self?.movieCollectionView.alpha = 1.0
                }
            }
        }
    }
}

//MARK: MoviesListViewProtocol
extension MoviesListViewController: MoviesListViewProtocol {
    func showActIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.showActivityIndicator()
        }
    }
    
    func hideActIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.hideActivityIndicator()
        }
    }

    func showAlertView(title: String, message: String, noNetwork: Bool) {
        showAlert(title: title, message: message)
        guard noNetwork else { return }
        DispatchQueue.main.async { [weak self] in
            self?.dataSource?.removeAll()
            self?.reloadData(withAnimation: false)
            self?.movieCollectionView.addBackgroundLabel(withText: "No Network Connectivity")
        }
    }
}

//MARK: UICollectionViewDelegate
extension MoviesListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.CollectionViewCells.moviesList.value, for: indexPath) as! MoviesListCollectionViewCell
        let data = dataSource?[indexPath.row]
        let image_url = moviesListViewModel?.getPosterImageURL(path: data?.posterPath ?? "")
        let processor = DownsamplingImageProcessor(size: cell.posterImage.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 20)
        cell.posterImage.kf.indicatorType = .activity
        KF.url(image_url)
            .placeholder(UIImage(named: AppConstants.Images.placeholder.value))
          .setProcessor(processor)
          .loadDiskFileSynchronously()
          .cacheMemoryOnly()
          .fade(duration: 0.25)
          .onProgress { receivedSize, totalSize in  }
          .onSuccess { result in LogsManager.consoleLog(message: "image success") }
          .onFailure { error in LogsManager.consoleLog(message: "image error") }
          .set(to: cell.posterImage)
        cell.voteAvg = data?.voteAverage ?? 0.0
        cell.titleLbl.text = data?.title
        cell.releaseDataLbl.text = convertDateFormat(dateString: data?.releaseDate ?? "1999-12-23")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        let movieID = dataSource?[indexPath.row].id ?? 0
        fetchMovieDetails(withID: movieID)
    }
}

//MARK: UICollectionViewDataSourcePrefetching
extension MoviesListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        var image_urls:[URL] = []
        indexPaths.forEach { indexPath in
            if let url = moviesListViewModel?.getPosterImageURL(path: dataSource?[indexPath.row].posterPath ?? "") {
                image_urls.append(url)
            }
        }
        let prefetcher = ImagePrefetcher(urls: image_urls) {
            skippedResources, failedResources, completedResources in
            LogsManager.consoleLog(message: "prefetched: \(completedResources)")
            LogsManager.consoleLog(message: "error: \(failedResources)")
            LogsManager.consoleLog(message: "skipped: \(skippedResources)")
        }
        prefetcher.start()
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        var image_urls:[URL] = []
        indexPaths.forEach { indexPath in
            if let url = moviesListViewModel?.getPosterImageURL(path: dataSource?[indexPath.row].posterPath ?? "") {
                image_urls.append(url)
            }
        }
        ImagePrefetcher(urls: image_urls).stop()
    }
}



