//
//  ViewController.swift
//  CollectionMedia
//
//  Created by Arturo Carretero Calvo on 23/12/2019.
//  Copyright © 2019 Arturo Carretero Calvo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    fileprivate let imageCollection = ["https://www.adventuresinpoortaste.com/wp-content/uploads/2019/02/batman0-1.jpg",
                                       "https://assets1.ignimgs.com/2015/12/09/untitled-br-hpng-c7335b_1280w.png"]
    fileprivate let videoCollection = ["https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4"]
    
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let collectionMediaView = CollectionMediaView.instanceFromNib()
        collectionMediaView.frame = self.view.frame
        collectionMediaView.delegate = self
        collectionMediaView.create(imageCollection: self.imageCollection,
                                   videoCollection: self.videoCollection,
                                   layout: nil)
        self.view.addSubview(collectionMediaView)
    }
}

// MARK: Extension for CollectionMediaViewProtocol
extension ViewController: CollectionMediaViewProtocol {
    
    func didSelect(url: String) {
        print("URL: \(url)")
    }
}
