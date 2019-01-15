//
//  MovieSearchNetworkWrapper.swift
//  SearchMyMovie


import UIKit

class MovieSearchNetworkWrapper: NSObject {
    static let sharedInstance = MovieSearchNetworkWrapper()
    private override init() {
        super.init()
    }
    
    func getQueryData(With keyword:String, page:Int, OnCompletion: @escaping (MovieSearchResultModel)-> Void, OnError: @escaping (Error)->Void){
        let url = MovieAppUrls.coreUrl + MovieAppUrls.movieSearchApi + "?api_key=" + MovieAppUrls.apiKey + "&query=" + keyword + "&page=" + "\(page)"
        
        MovieNetworkManager.sharedInstance.makeWebRequest(urlString: url, onCompletion: {object in
            let model = MovieSearchResultModel.init(With: object)
            OnCompletion(model)
        }, OnError: {error in
            OnError(error)
        })
    }
}
