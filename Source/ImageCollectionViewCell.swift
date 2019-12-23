//
//  ImageCollectionViewCell.swift
//  CollectionMedia
//
//  Created by Arturo Carretero Calvo on 23/12/2019.
//  Copyright © 2019 Arturo Carretero Calvo. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var imageUrl: URL? = nil {
        didSet {
            if let url = self.imageUrl {
                self.loading.isHidden = false
                self.loading.startAnimating()
                self.infoImageView.load(url: url) { (end) in
                    if end {
                        self.loading.isHidden = true
                    }
                }
            }
        }
    }
}

// MARK: Extension for utils
extension UIImageView {
    func load(url: URL, callback:@escaping(_ end: Bool) -> Void) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        callback(true)
                    }
                }
            }
        }
    }
}
