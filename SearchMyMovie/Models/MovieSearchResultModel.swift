//
//  MovieSearchResultModel.swift
//  SearchMyMovie


import UIKit

let PosterPathKey   = "poster_path"
let OverviewKey     = "overview"
let ReleaseDateKey  = "release_date"
let OrginalTitleKey = "original_title"
let ResultsKey      = "results"
let PageKey         = "page"
let TotalPageKey    = "total_pages"

class MovieDetailModel: NSObject{
    var moviePosterUrl: String?
    var movieName: String?
    var movieDescription: String?
    var movieReleaseDate: String?
    init(With dict:[String:Any]) {
        super.init()
        if let nodeValue = dict[PosterPathKey] as? String{
            self.moviePosterUrl = MovieAppUrls.smallPosterUrl + nodeValue
        }
        if let nodeValue = dict[OverviewKey]{
            self.movieDescription = nodeValue as? String
        }
        if let nodeValue = dict[ReleaseDateKey]{
            self.movieReleaseDate = nodeValue as? String
        }
        if let nodeValue = dict[OrginalTitleKey]{
            self.movieName = nodeValue as? String
        }
    }
}

class MovieSearchResultModel: NSObject {
    var allMovies = [MovieDetailModel]()
    var page: Int?
    var totalPage: Int?
    init(With dict:[String:Any]) {
        super.init()
        if let nodeValue = dict[ResultsKey] as? [Any]{
            for node in nodeValue{
                if let object = node as? [String:Any]{
                    let model = MovieDetailModel.init(With: object)
                    allMovies.append(model)
                }
            }
        }
        if let nodeValue = dict[PageKey]{
            self.page = (nodeValue as? NSNumber)?.intValue
        }
        if let nodeValue = dict[TotalPageKey]{
            self.totalPage = (nodeValue as? NSNumber)?.intValue
        }
    }
}
