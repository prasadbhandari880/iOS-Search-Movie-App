//
//  MovieNetworkManager.swift
//  SearchMyMovie

import UIKit

class MovieNetworkManager: NSObject {
    static let sharedInstance = MovieNetworkManager()
    private override init() {
        super.init()
    }
    
    func makeWebRequest(urlString:String,onCompletion: @escaping ([String:Any]) -> Void, OnError: @escaping (Error)->Void){
        if let url = URL.init(string: urlString){
            let urlRequest = URLRequest.init(url: url)
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest, completionHandler: {data, response, error in
                if let d = data{
                    do{
                        let json = try JSONSerialization.jsonObject(with: d, options: .mutableLeaves)
                        if let object = json as? [String:Any]{
                            DispatchQueue.main.async {
                                onCompletion(object)
                            }
                        }
                    }catch{
                        print("Error!")
                    }
                }
                if let e = error{
                    DispatchQueue.main.async {
                        OnError(e)
                    }
                }
            })
            task.resume()
        }
    }
    
    func downloadAndCacheImage(url:String,OnCompletion: @escaping (UIImage) -> Void){
        let urlParts = url.components(separatedBy: "/")
        var fileName = ""
        if urlParts.count > 2{
            let posterSize = urlParts[urlParts.count - 2]
            if let name = urlParts.last{
                fileName = posterSize + name
            }
        }
        
        if fileName == ""{
            return
        }
        
        let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = directoryURLs.appendingPathComponent(fileName)
        let fileUrl = filePath.path
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: fileUrl){
            let image = UIImage.init(contentsOfFile: fileUrl)
            if let img = image{
                DispatchQueue.main.async {
                    OnCompletion(img)
                }
            }
        }else{
            DispatchQueue.global().async {
                if let uri = URL.init(string: url){
                    let imageData = try? Data.init(contentsOf: uri)
                    if let data = imageData{
                        if let image = UIImage.init(data: data){
                            do{
                                try data.write(to: filePath)
                            }catch{
                                print("Unable to write")
                            }
                            DispatchQueue.main.async {
                                OnCompletion(image)
                            }
                        }
                    }
                }
            }
        }
    }
}
