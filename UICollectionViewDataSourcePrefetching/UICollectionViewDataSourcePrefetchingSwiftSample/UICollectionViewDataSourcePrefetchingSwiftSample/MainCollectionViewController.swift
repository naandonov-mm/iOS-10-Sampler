//
//  MainCollectionViewController.swift
//  UICollectionViewDataSourcePrefetchingSwiftSample
//
//  Created by Nikolay Andonov on 10/24/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

import UIKit

let CollectionViewCellPadding : CGFloat = 10.0
let NumberOfCellsPerRow : NSInteger = 2

class MainCollectionViewController: UICollectionViewController, UICollectionViewDataSourcePrefetching, UICollectionViewDelegateFlowLayout {
    
    var collectionViewCellSize = 0.0
    
    var imageURLs : [URL] = []
    var downloadImageOperationQueue = OperationQueue()
    var operations : [URL : BlockOperation] = [:]
    var images : [URL : UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        populateModel()
        collectionView?.reloadData()
    }


    func configureCollectionView() {
        
        let screenWidth = view.frame.width;
        let cellsAreaOnSingleRow = screenWidth - (CGFloat(NumberOfCellsPerRow + 1) * CollectionViewCellPadding)
        collectionViewCellSize = Double(cellsAreaOnSingleRow) / Double(NumberOfCellsPerRow);
        collectionView?.contentInset = UIEdgeInsetsMake(CollectionViewCellPadding, CollectionViewCellPadding, CollectionViewCellPadding, CollectionViewCellPadding);
        collectionView?.prefetchDataSource = self
        collectionView?.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    func populateModel() {
        
        //Simulating initial load of content
        for counter  in 0..<50 {
            
            //Simulating slow download using large images
            let imageStringAdress = "http://placehold.it/2000x2000&text=SampleImage\(counter + 1)"
            if let imageURL = URL.init(string: imageStringAdress) {
                imageURLs.append(imageURL)
            }
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageURLs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : MainCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MainCollectionViewCell
        let url = imageURLs[indexPath.row]
        if images[url] != nil {
            cell.imageView.image = images[url]
            cell.activityIndicator.stopAnimating()
        }
        else {
            executeDownloadImageOperationBlock(indexPath: indexPath)
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize {
        
        let cellSize:CGSize = CGSize(width: collectionViewCellSize, height: collectionViewCellSize)
        return cellSize
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cancelDowloandImageOperationBlock(indexPath: indexPath)
    }
    
    // MARK: UICollectionViewDataSourcePrefething
    
    // indexPaths are ordered ascending by geometric distance from the collection view
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            
            // Updating upcoming CollectionView's data source. Not assiging any direct value
            // as this operation is expensive it is performed on a private queue
            let url = imageURLs[indexPath.row]
            if images[url] == nil {
                executeDownloadImageOperationBlock(indexPath: indexPath)
                print("Prefetching data for indexPath: \(indexPath)")
            }
        }
    }
    
    // indexPaths that previously were considered as candidates for pre-fetching, but were not actually used; may be a subset of the previous call to -collectionView:prefetchItemsAtIndexPaths:
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            
            //Unloading or data load operation cancellations should happend here
            let url = imageURLs[indexPath.row]
            if operations[url] != nil {
                cancelDowloandImageOperationBlock(indexPath: indexPath)
                print("Unloading data fetch in progress for indexPath: \(indexPath)")
            }
        }
    }

    // MARK: Utilitites
    
    private func executeDownloadImageOperationBlock(indexPath: IndexPath) {
        
        let url = imageURLs[indexPath.row]
        let blockOperation = BlockOperation()
        weak var weakBlockOperation = blockOperation
        weak var weakSelf = self
        
        blockOperation .addExecutionBlock {
            
            if (weakBlockOperation?.isCancelled)! {
                weakSelf?.operations[url] = nil
                return;
            }
            
            var image : UIImage? = nil
            do {
                
                let imageData = try Data.init(contentsOf: url)
                image = UIImage.init(data: imageData)
                weakSelf?.images [url] = image
                weakSelf?.operations[url] = nil
            } catch {
            }
            
            let visibleCellIndexPaths = weakSelf?.collectionView?.indexPathsForVisibleItems
            if (visibleCellIndexPaths?.contains(indexPath))! {
                
                let cell : MainCollectionViewCell = weakSelf?.collectionView?.cellForItem(at: indexPath) as! MainCollectionViewCell
                
                DispatchQueue.main.async {
                    cell.imageView.image = image
                    cell.activityIndicator.stopAnimating()
                }
            }
        }
        downloadImageOperationQueue.addOperation(blockOperation)
        operations[url] = blockOperation
    }

    private func cancelDowloandImageOperationBlock(indexPath: IndexPath){
        
        let url = imageURLs[indexPath.row]
        if operations[url] != nil {
            let blockOperation = operations[url]
            blockOperation?.cancel()
            operations[url] = nil
        }
    }
}
