//
//  ViewController.swift
//  Unsplash
//
//  Created by Ade Reskita on 10/09/20.
//  Copyright © 2020 Ade Reskita. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
//    var viewModel: ViewModel?
    var viewModel = ViewModel()

    var loadingView: CollectionReusableView?
    var isLoading = false
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.fetchPhoto(page: viewModel.page)
        closureSetUp()
        setupUI()
    }
    
    // MARK: - closure initialize
    func closureSetUp()  {
        viewModel.reloadList = { [weak self] ()  in
            //UI chnages in main tread
            DispatchQueue.main.async {
                self?.collView.reloadData()
            }
        }
        viewModel.errorMessage = { [weak self] (message)  in
            DispatchQueue.main.async {
                print(message)
//                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    func setupUI() {
        self.collView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
        //loading view
        let loadingReusableView = UINib(nibName: "CollectionReusableView", bundle: nil)
        self.collView.register(loadingReusableView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionReusableView.identifier)

        //keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        //prevent uicollection size bug
        let layout = collView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = .zero
        
        ///pinterest Layout
//        if let pinterestLayout = collView.collectionViewLayout as? PinterestLayout {
//            pinterestLayout.delegate = self
//        }
        
        collView.delegate = self
        collView.dataSource = self
        searchBar.delegate = self
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().async {
                // Fake background loading task for 2 seconds
                sleep(2)
                // Download more data here
                self.viewModel.fetchPhoto(page: self.viewModel.page)
                self.closureSetUp()
                
                DispatchQueue.main.async {
                    print("page= \(self.viewModel.page)")
                    self.collView.reloadData()
                    
                    self.isLoading = false
                }
            }
        }
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell

        let photosObj = viewModel.photos[indexPath.row]

        cell.setImage(withViewModel: photosObj)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastPhotos = viewModel.photos.count - 1
        if indexPath.row == lastPhotos && !self.isLoading {
            self.viewModel.page += 1
//            // load more images
            loadMoreData()
        }
    }
    
    
    // MARK: - Mengatur Layout Size Cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//         Lebar & tinggil cell
        let bounds = collectionView.bounds

        if indexPath.item % 2 == 0 {
            return CGSize(width: bounds.width/2.15, height: bounds.height/2)
        } else {
            return CGSize(width: bounds.width/2.15, height: bounds.height/1.5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    
    // MARK: - Mengatur Layout Loading Cell

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 82)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionReusableView.identifier, for: indexPath) as! CollectionReusableView
            loadingView = aFooterView
            loadingView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.startAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isSearching = false
            self.viewModel.page = 1
            viewModel.photos = []
            viewModel.searchText = "Human"
            viewModel.fetchSearchPhoto(page: self.viewModel.page, title: viewModel.searchText)
        }
        else {
            //search data
            isSearching = true
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        self.viewModel.page = 1
        viewModel.photos = []
        viewModel.searchText = searchBar.text!
        viewModel.fetchSearchPhoto(page: self.viewModel.page, title: searchBar.text!)
        self.collView.reloadData()
        view.endEditing(true)
    }
    
    
}

// MARK: - Mengatur Layout Pinterest Cell Style
//extension ViewController: PinterestLayoutDelegate {
//    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
//        let rand = CGFloat(arc4random_uniform(3) + 1)
//        let bounds = collectionView.bounds
//        let height = bounds.height/3.5
//
//        return CGFloat(rand * height)
//    }
//
//
//}
