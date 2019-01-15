//
//  MovieAppUrls.swift
//  SearchMyMovie


import UIKit

class MovieAppUrls: NSObject {
    static let apiKey = "77911d33235fd5eed6502494044935c3"
    class var coreUrl: String{
        return "http://api.themoviedb.org/3"
    }
    
    class var movieSearchApi: String{
        return "/search/movie"
    }
    
    class var imageBaseUrl: String{
        return "http://image.tmdb.org/t/p"
    }
    
    //Small size poster base url
    class var smallPosterUrl: String{
        return self.imageBaseUrl + "/w92"
    }
}

