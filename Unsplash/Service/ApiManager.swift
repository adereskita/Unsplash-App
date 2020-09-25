//
//  ApiManager.swift
//  Unsplash
//
//  Created by Ade Reskita on 10/09/20.
//  Copyright © 2020 Ade Reskita. All rights reserved.
//

import Foundation
import Alamofire

class ApiManager {
    
    // MARK: - Singleton
    static let shared = ApiManager()
    
    // MARK: - URL
    let photoUrl = "https://api.unsplash.com/search/photos?page=1&query=office"
    
    let headers: HTTPHeaders = [
    "Authorization" : "Client-ID d8a272c480b258b875d82f4062d6c52e4ae7f4b4656add778d71e9b638b2f8be"
    ]
    
    class func headers() -> HTTPHeaders {
        var headers: HTTPHeaders = [
        "Authorization" : "Client-ID d8a272c480b258b875d82f4062d6c52e4ae7f4b4656add778d71e9b638b2f8be"
        ]

        if let authToken = UserDefaults.standard.string(forKey: "auth_token") {
            headers["Authorization"] = "Token" + " " + authToken
        }

        return headers
    }
    
    // MARK: - Services
//    func requestFetchPhotos(completion: @escaping (Photos?, Error?) -> ()) {
//        let url = photoUrl
//
//        AF.request(url,
//                   method: .get,
//                   encoding: JSONEncoding.default,
//                   headers: ApiManager.headers()).responseJSON { response in
//
//            switch response.result {
//            case let .success(value):
//
//                let json = JSON(value)
//
//
//                completion(value as? Photos, nil)
//                print(value)
//
//            case let .failure(error):
//                completion(nil, error)
//                print(error.localizedDescription)
//            }
//        }
//    }

}
