//
//  CollectionMediaView.swift
//  CollectionMediaView
//
//  Created by Arturo Carretero Calvo on 23/12/2019.
//  Copyright © 2019 Arturo Carretero Calvo. All rights reserved.
//

import UIKit

class CollectionMediaView: UIView {
    
    // MARK: Properties
    @IBOutlet weak var pageControl: UIPageControl!
    
    fileprivate var imageCollection: [String] = []
    fileprivate var videoCollection: [String] = []
    fileprivate var collectionView: UICollectionView?
    fileprivate var visibleIP: IndexPath = IndexPath.init(row: 0, section: 0)
    fileprivate var aboutToBecomeInvisibleCell = -1
    fileprivate var stringForCurrentPageImageName = ""
    fileprivate let sections = 2
    fileprivate let imageCell = "ImageCollectionViewCell"
    fileprivate let videoCell = "VideoCollectionViewCell"
    
    var collectionBackgroundColor = UIColor.clear
    var showsHorizontalScrollIndicator = false
    var showsVerticalScrollIndicator = false
    var layoutFlow = UICollectionViewFlowLayout() // .horizontal
    
    weak var delegate: CollectionMediaViewProtocol?
    
    // MARK: - Init
    static func instanceFromNib() -> CollectionMediaView {
        guard let view =  Bundle.main.loadNibNamed("CollectionMediaView", owner: self, options: nil)![0] as? CollectionMediaView else {
            return CollectionMediaView()
        }
        return view
    }
    
    // MARK: Public functions
    func create(imageCollection: [String], videoCollection: [String], layout: UICollectionViewFlowLayout?) {
        self.imageCollection = imageCollection
        self.videoCollection = videoCollection
        if let customLayout = layout {
            self.layoutFlow = customLayout
        } else {
            self.layoutFlow.scrollDirection = .horizontal
        }
        self.setupCollection()
        self.setupPageControl()
    }
}

// MARK: Extension for private functions
private extension CollectionMediaView {
    
    func setupCollection() {
        self.collectionView = UICollectionView.init(frame: self.frame, collectionViewLayout: self.layoutFlow)
        if let collectionMedia = self.collectionView {
            collectionMedia.register(UINib(nibName: self.imageCell, bundle: nil),
                                     forCellWithReuseIdentifier: self.imageCell)
            collectionMedia.register(UINib(nibName: self.videoCell, bundle: nil),
                                     forCellWithReuseIdentifier: self.videoCell)
            collectionMedia.backgroundColor = self.collectionBackgroundColor
            collectionMedia.showsHorizontalScrollIndicator = self.showsHorizontalScrollIndicator
            collectionMedia.showsVerticalScrollIndicator = self.showsVerticalScrollIndicator
            collectionMedia.isPrefetchingEnabled = true
            collectionMedia.isPagingEnabled = true
            collectionMedia.isScrollEnabled = true
            collectionMedia.delegate = self
            collectionMedia.dataSource = self
            collectionMedia.reloadData()
            self.insertSubview(collectionMedia, belowSubview: self.pageControl)
        }
    }
    
    func setupPageControl() {
        let total = self.imageCollection.count + self.videoCollection.count
        if total < 2 {
            self.pageControl.isHidden = true
        } else {
            self.pageControl.numberOfPages = total
            self.pageControl.currentPage = 0
            self.showCurrentPageIndicator(index: 0)
        }
    }
    
    func showCurrentPageIndicator(index: Int) {
        self.pageControl.currentPage = index
    }
}

// MARK: Extension for UICollectionView functions
extension CollectionMediaView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width,
                      height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.imageCollection.count
        case 1:
            return self.videoCollection.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else {
                return UICollectionViewCell()
            }
            if let url = URL(string: self.imageCollection[indexPath.row]) {
                cell.imageUrl = url
                cell.infoImageView.contentMode = .scaleAspectFill
            }
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as? VideoCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.videoUrl = self.videoCollection[indexPath.row]
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.delegate?.didSelect(url: self.imageCollection[indexPath.row])
        case 1:
            self.delegate?.didSelect(url: self.videoCollection[indexPath.row])
        default:
            break
        }
    }
}

// MARK: Extension for UIScrollViewDelegate
extension CollectionMediaView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let collection = self.collectionView {
            let visibleIndexPaths = collection.indexPathsForVisibleItems
            if visibleIndexPaths.count > 0 {
                var indexPathVissibled : Bool = false
                for indexPath in visibleIndexPaths {
                    if let videoCell = collection.cellForItem(at: indexPath) as? VideoCollectionViewCell {
                        if collection.bounds.contains(videoCell.frame) && !indexPathVissibled {
                            videoCell.startPlayback()
                            self.visibleIP = indexPath
                            indexPathVissibled = true
                        } else {
                            aboutToBecomeInvisibleCell = indexPath.item
                            videoCell.stopPlayback()
                        }
                    }
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let collection = self.collectionView {
            let page = collection.contentOffset.x / collection.frame.size.width
            self.showCurrentPageIndicator(index: Int(page))
        }
    }
}
