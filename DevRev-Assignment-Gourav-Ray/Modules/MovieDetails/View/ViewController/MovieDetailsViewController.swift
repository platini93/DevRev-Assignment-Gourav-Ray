import UIKit
import Kingfisher

class MovieDetailsViewController: UIViewController {

    var movieDetailsViewModel:MovieDetailsViewModelProtocol?
    var movieDetails:MovieDetails?
    var bgImageView:UIImageView?
    
    var tableView:UITableView = {
        var tableVw = UITableView()
        tableVw.register(UINib(nibName: AppConstants.TableViewCells.movieDetailsTop.value, bundle: nil), forCellReuseIdentifier: AppConstants.TableViewCells.movieDetailsTop.value)
        tableVw.register(UINib(nibName: AppConstants.TableViewCells.movieDetailsBottom.value, bundle: nil), forCellReuseIdentifier: AppConstants.TableViewCells.movieDetailsBottom.value)
        tableVw.separatorStyle = .none
        tableVw.showsVerticalScrollIndicator = false
        return tableVw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.isHidden = false
        title = "Movie Details"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bgImageVw()
        addTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bgImageView?.removeFromSuperview()
    }
    
    func bgImageVw() {
        let bgImage = UIImage(named: AppConstants.Images.background.value)
        let bgImageVw = UIImageView(image: bgImage)
        bgImageVw.frame = UIScreen.main.bounds
        bgImageVw.contentMode = .scaleAspectFill
        bgImageVw.alpha = 0.5
        bgImageView = bgImageVw
        view.addSubview(bgImageVw)
        view.bringSubviewToFront(bgImageVw)
        setUpBackdropImage()
    }
    
    func setUpBackdropImage() {
        let bgImageUrl = movieDetailsViewModel?.getBackdropImageURL(path: movieDetails?.backdropPath ?? "")
        let processor = DownsamplingImageProcessor(size: bgImageView?.bounds.size ?? UIScreen.main.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 0)
        bgImageView?.kf.indicatorType = .activity
        KF.url(bgImageUrl)
            .placeholder(UIImage(named: AppConstants.Images.background.value))
          .setProcessor(processor)
          .loadDiskFileSynchronously()
          .cacheMemoryOnly()
          .fade(duration: 0.3)
          .onProgress { receivedSize, totalSize in  }
          .onSuccess { result in LogsManager.consoleLog(message: "image success") }
          .onFailure { error in LogsManager.consoleLog(message: "image error") }
          .set(to: bgImageView!)
    }
    
    func addTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black.withAlphaComponent(0.4)
        tableView.frame = view.bounds
        view.addSubview(tableView)
        view.bringSubviewToFront(tableView)
        tableView.reloadData()
    }
}

//MARK: MovieDetailsViewProtocol
extension MovieDetailsViewController: MovieDetailsViewProtocol {
    func showActIndicator() {
        DispatchQueue.main.async {
            self.showActivityIndicator()
        }
    }
    
    func hideActIndicator() {
        DispatchQueue.main.async {
            self.hideActivityIndicator()
        }
    }
    
    func showAlertView(title: String, message: String, noNetwork: Bool) {
        showAlert(title: title, message: message)
    }
}

//MARK: MovieDetailsViewController
extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.TableViewCells.movieDetailsTop.value, for: indexPath) as! MovieDetailsTop
            setPosterImage(imageView: cell.posterImage)
            cell.voteAvg = movieDetails?.voteAverage ?? 0.0
            cell.titleLbl.text = movieDetails?.title
            cell.dateTimeLbl.text = "\(convertDateFormat(dateString: movieDetails?.releaseDate ?? "1999-12-23") ?? "") | \(movieDetails?.runtime ?? 0) m"
            cell.genresLbl.text = "\((movieDetails?.genres?.map{$0.name} as? [String])?.joined(separator: ", ") ?? "")"
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.TableViewCells.movieDetailsBottom.value, for: indexPath) as! MovieDetailsBottom
            cell.taglineLbl.text = movieDetails?.tagline
            cell.overviewLbl.text = truncateStringIfNeeded(movieDetails?.overview ?? "")
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 600.0
        } else {
            return 300.0
        }
    }
    func setPosterImage(imageView:UIImageView){
        let posterUrl = movieDetailsViewModel?.getPosterImageURL(path: movieDetails?.posterPath ?? "")
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 20.0)
        imageView.kf.indicatorType = .activity
        KF.url(posterUrl)
            .placeholder(UIImage(named: AppConstants.Images.placeholder.value))
          .setProcessor(processor)
          .loadDiskFileSynchronously()
          .cacheMemoryOnly()
          .fade(duration: 0.25)
          .onProgress { receivedSize, totalSize in  }
          .onSuccess { result in LogsManager.consoleLog(message: "image success") }
          .onFailure { error in LogsManager.consoleLog(message: "image error") }
          .set(to: imageView)
    }
}

