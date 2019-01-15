//
//  CoreDataWrapper.swift
//  SearchMyMovie
//


import UIKit
import CoreData

class CoreDataWrapper: NSObject {
    static let sharedInstance = CoreDataWrapper()
    let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private override init() {
        super.init()
    }
    
    //Get All Search History
    func getSerachHistory() -> [SearchedMovies]{
        var events = [SearchedMovies]()
        let request : NSFetchRequest = SearchedMovies.fetchRequest()
        do{
            events = try context.fetch(request)
        }catch{
            print("Unable to fetch data")
        }
        return events
    }

    //Add Search Keyword
    func addToSearch(_ keyword:String){
        let allSearch = getSerachHistory()
        if allSearch.contains(where: {model in return model.keyword?.lowercased() == keyword.lowercased()}){
            return
        }
        if allSearch.count >= 10{
            if let first = allSearch.first{
                self.removeSearch(first)
            }
        }
        self.saveKeyword(keyword)
    }

    private func saveKeyword(_ keyword:String){
        let search = SearchedMovies(context: context)
        search.keyword = keyword
        APP_DELEGATE.saveContext()
    }

    //Remove Search Keyword
    func removeSearch(_ object:SearchedMovies){
        context.delete(object)
        APP_DELEGATE.saveContext()
    }
    
}
