//
//  SearchResultViewController.swift
//  SearchMyMovie


import UIKit

let movieCellId = "MovieDetailsTableViewCell"
class SearchResultViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var model: MovieSearchResultModel!
    var keyword: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.hidesWhenStopped = true
        registerCells()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func registerCells(){
        self.mainTableView.dataSource = self
        self.mainTableView.register(UINib.init(nibName: movieCellId, bundle: nil), forCellReuseIdentifier: movieCellId)
    }
    
    func getNextPageData(){
        let page = self.model.page! + 1
        if page >= self.model.totalPage!{
            return
        }
        weak var weakSelf = self
        self.activityIndicator.startAnimating()
        MovieSearchNetworkWrapper.sharedInstance.getQueryData(With: keyword, page: page, OnCompletion: {model in
            weakSelf?.activityIndicator.stopAnimating()
            weakSelf?.updateCurrentModel(model: model)
        }, OnError: {error in
            
        })
    }
    
    func updateCurrentModel(model:MovieSearchResultModel){
        self.model.page = model.page
        self.model.totalPage = model.totalPage
        self.model.allMovies.append(contentsOf: model.allMovies)
        self.mainTableView.reloadData()
    }
}

extension SearchResultViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.allMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.model.allMovies.count - 2{
            self.getNextPageData()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: movieCellId, for: indexPath) as! MovieDetailsTableViewCell
        cell.setData(model: self.model.allMovies[indexPath.row])
        return cell
    }
}
