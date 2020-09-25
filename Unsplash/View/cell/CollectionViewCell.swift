//
//  CollectionViewCell.swift
//  Unsplash
//
//  Created by Ade Reskita on 10/09/20.
//  Copyright © 2020 Ade Reskita. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
        
    static let identifier = "CollectionViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "CollectionViewCell", bundle: nil)
    }
    
    @IBOutlet weak var CollViewCell: UIImageView!
    @IBOutlet weak var cellActivityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        CollViewCell.clipsToBounds = true
        CollViewCell.layer.cornerRadius = 10
        
//        self.cellActivityIndicator = UIActivityIndicatorView(style: .gray)
//        self.cellActivityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        self.cellActivityIndicator.hidesWhenStopped = true
//
//        view.addSubview(self.cellActivityIndicator)
    }
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    func setImage(withViewModel viewModel: Photos) {
        
        self.cellActivityIndicator.startAnimating()
        
        var imageUrlString: String?
        
        imageUrlString = viewModel.urls!

        //set image
        guard let imageURL = URL(string: viewModel.urls!) else { return }
        // just to not cause a deadlock in UI
        
        /// agar image nya tidak berubah saat scrolling
        self.CollViewCell.image = nil
        
        if let imageFromCache = imageCache.object(forKey: viewModel.urls as AnyObject) as? UIImageView {
            
            self.CollViewCell = imageFromCache
            return
        }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            DispatchQueue.main.async {
                let imageToCache = UIImage(data: imageData)
                
                self.cellActivityIndicator.stopAnimating()
                
                
                if imageUrlString == viewModel.urls! {
                    self.CollViewCell.image = imageToCache
                }
                
                self.imageCache.setObject(imageToCache!, forKey: viewModel.urls as AnyObject)

                self.CollViewCell.image = imageToCache
            }
        }
    }

}
