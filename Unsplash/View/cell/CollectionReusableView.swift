//
//  CollectionReusableView.swift
//  Unsplash
//
//  Created by Ade Reskita on 13/09/20.
//  Copyright © 2020 Ade Reskita. All rights reserved.
//

import UIKit

class CollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    static let identifier = "LoadingCell"

    static func nib() -> UINib {
        return UINib(nibName: "LoadingCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
}
