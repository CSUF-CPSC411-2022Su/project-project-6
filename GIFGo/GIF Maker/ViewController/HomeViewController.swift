import Foundation
import UIKit
import GiphyUISDK
import AVKit

var titleMenuArray = ["Photos to GIF","Video to GIF","GIF to Video","Slow Motion to GIF"]
let giphy = GiphyViewController()
var sliderImageArray = [ imageLiteral(resourceName: "photo to gif"), imageLiteral(resourceName: "video to gif"), imageLiteral(resourceName: "gif to video"), imageLiteral(resourceName: "photo to gif"), imageLiteral(resourceName: "video to gif"), imageLiteral(resourceName: "gif to video")]
var counter = 0

override func viewDidLoad() {
    super.viewDidLoad()
    setNavigationBar()
    self.title = "GIF Maker"
    btnMoreHover.layer.cornerRadius = self.btnMoreHover.layer.bounds.height / 2.0
    
    let btn1 = UIButton()
    btn1.setImage(UIImage(named: "settings"),for: .normal)
    btn1.imageView?.sizeToFit()
    btn1.frame =  CGRect(x: 0, y: 0, width: 20, height: 20)
    btn1.addTarget(self, action: #selector(self.Setting), for: .touchUpInside)
    btn1.tintColor = .label
    self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: btn1), animated: true);
}


