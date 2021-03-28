## CollectionView with n images and n videos links

A sample of how to make a collectionView with images and videos in the cells.

<p><img src="https://github.com/ArtCC/CollectionMedia/blob/main/example.gif" height="600"></p>

### INSTRUCTIONS

Download the project and add the classes from the "Source" folder to your project. You can modify the code to suit your needs :)

Example:

```
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
```

Default config for collectionView:

```
var collectionBackgroundColor = UIColor.clear
var showsHorizontalScrollIndicator = false
var showsVerticalScrollIndicator = false
var layoutFlow = UICollectionViewFlowLayout() // .horizontal
```

Default config for video cell and video reproductor:

```
var avVolume: Float = Float(3)
var avBackgroundColor = UIColor.clear
var avResize = AVLayerVideoGravity.resizeAspectFill
var avShowsPlaybackControls = false
var avAllowsPictureInPicturePlayback = true
var avActionAtItemEnd = AVPlayer.ActionAtItemEnd.none
```

### LICENSE

This project is free and use <b>CC BY-NC-SA</b>.

This license lets others remix, tweak, and build upon your work without for commercial purposes, as long as they credit you and license their new creations under the identical terms.

### THANK YOU!

I hope you like it!

##### ArtCC 2019++
