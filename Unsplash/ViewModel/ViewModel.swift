//
//  ViewModel.swift
//  Unsplash
//
//  Created by Ade Reskita on 11/09/20.
//  Copyright © 2020 Ade Reskita. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ViewModel {
    
    var searchText = "Human"
    var page = 1
    
    private var apiManager = ApiManager()
    
    // MARK: - Properties
    var photos: [Photos] = [] {
    //reload data when data set
        didSet {
            self.reloadList()
        }
    }
    
//    private var photos: Photos? {
//        //reload data when data set
//        didSet {
//            guard let p = photos else { return }
//            self.setupUI(with: p)
//            self.didFinishFetch?()
//        }
//    }
    
    var error: Error? {
        didSet { self.showAlertClosure?() }
    }
    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var reloadList = {() -> () in }
    var errorMessage = {(message : String) -> () in }
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    // MARK: - Constructor
//    init(photos: Photos) {
//        self.photos = photos
//    }
    
    // MARK: - Network call
    func fetchPhoto(page: Int) {
//        let url = apiManager.photoUrl
        let url = "https://api.unsplash.com/search/photos?page=\(page)&query=\(searchText.lowercased())"
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: ApiManager.headers()).responseJSON { response in
                    
            switch response.result {
            case let .success(value):

                let json = JSON(value)
                
                for i in 0 ..< json["results"].count{
                    let id = json["results"][i]["id"].string!
                    let title = json["results"][i]["user"]["name"].string!
                    let urls = json["results"][i]["urls"]["regular"].string!
//                    let description = json["results"][i]["alt_description"].string!
                    self.photos.append(Photos(id, title, urls))
                }
//                print(value)
                print("photoData= \(self.photos.count)")
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchSearchPhoto(page: Int, title: String) {
    //        let url = apiManager.photoUrl
        let url = "https://api.unsplash.com/search/photos?page=\(page)&query=\(title.lowercased())"
            
            AF.request(url,
                       method: .get,
                       encoding: JSONEncoding.default,
                       headers: ApiManager.headers()).responseJSON { response in
                        
                switch response.result {
                case let .success(value):

                    let json = JSON(value)
                    
                    for i in 0 ..< json["results"].count{
                        let id = json["results"][i]["id"].string!
                        let title = json["results"][i]["user"]["name"].string!
                        let urls = json["results"][i]["urls"]["regular"].string!
    //                    let description = json["results"][i]["alt_description"].string!
                        self.photos.append(Photos(id, title, urls))
                    }
    //                print(value)
                    print("photoData= \(self.photos.count)")
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
}
