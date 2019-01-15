//
//  ViewController.swift
//  SearchMyMovie


import UIKit

let searchedKeywordCellId = "PastSearchedKeywordTableViewCell"
let searchVCId = "searchResultVC"

class HomeViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    var searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var searchedMovies = [SearchedMovies]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        self.activityIndicator.hidesWhenStopped = true
        registerCells()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchedMovies = CoreDataWrapper.sharedInstance.getSerachHistory()
        self.mainTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureSearchController() {
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search Movie"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        self.mainTableView.tableHeaderView = searchController.searchBar
    }
    
    func registerCells(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.register(UINib.init(nibName: searchedKeywordCellId, bundle: nil), forCellReuseIdentifier: searchedKeywordCellId)
    }
    
    func searchMovieFor(keyword: String,previoslySearched:Bool = true){
        weak var weakSelf = self
        self.activityIndicator.startAnimating()
        MovieSearchNetworkWrapper.sharedInstance.getQueryData(With: keyword, page: 1, OnCompletion: {model in
            weakSelf?.activityIndicator.stopAnimating()
            weakSelf?.checkForModelDetails(model: model,previoslySearched: previoslySearched,keyword: keyword)
        }, OnError: {error in
            
        })
    }
    
    func checkForModelDetails(model:MovieSearchResultModel,previoslySearched:Bool,keyword:String){
        if model.allMovies.count > 0{
            self.goToSearchResult(model: model,keyword: keyword)
            if !previoslySearched{
                CoreDataWrapper.sharedInstance.addToSearch(keyword)
            }
        }else{
            self.showAlertWith(message: "Sorry! No Movie Found")
        }
    }
    
    private func goToSearchResult(model:MovieSearchResultModel,keyword:String){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: searchVCId) as? SearchResultViewController{
            vc.model = model
            vc.keyword = keyword
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keyword = searchBar.text{
            print(keyword)
            searchController.isActive = false
            self.searchMovieFor(keyword: keyword,previoslySearched: false)
        }
    }
}

extension HomeViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = searchedMovies.count - 1 - indexPath.row
        let object = self.searchedMovies[index]
        self.searchMovieFor(keyword: object.keyword!)
    }
}

extension HomeViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchedKeywordCellId, for: indexPath) as! PastSearchedKeywordTableViewCell
        let index = searchedMovies.count - 1 - indexPath.row
        let object = self.searchedMovies[index]
        cell.setData(keyword: object.keyword!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.searchedMovies.count > 0{
        return "Previously Searched Movies"
        }
        return nil
    }
}
