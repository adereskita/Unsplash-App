//
//  File.swift
//  Unsplash
//
//  Created by Ade Reskita on 11/09/20.
//  Copyright © 2020 Ade Reskita. All rights reserved.
//

import Foundation
import Alamofire

struct Photos: Codable {

    var id : String?
    var title : String?
    var urls : String?
//    var width : Int?
//    var height : Int?
    var desc : String?
    
    init(_ id:String, _ title:String, _ urls:String){
        self.id = id
        self.title = title
        self.urls = urls
//        self.width = width
//        self.height = height
//        self.desc = desc
    }
}

