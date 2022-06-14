import Foundation
import UIKit
import GiphyUISDK
import AVKit


var titleMenuArray = ["Photos to GIF","Video to GIF","GIF to Video","Slow Motion to GIF"]
let giphy = GiphyViewController()
var sliderImageArray = [#imageLiteral(resourceName: "photo to gif"),#imageLiteral(resourceName: "video to gif"),#imageLiteral(resourceName: "gif to video"),#imageLiteral(resourceName: "photo to gif"),#imageLiteral(resourceName: "video to gif"),#imageLiteral(resourceName: "gif to video")]
var counter = 0


func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
    if indexPath.row == 0{
        cell.leftLogo.image = #imageLiteral(resourceName: "image")
        cell.leftTitle.text = titleMenuArray[0]
        cell.leftView.backgroundColor = #colorLiteral(red: 0.9691354632, green: 0.5327283467, blue: 0.8499581263, alpha: 1)
        cell.leftBtn.tag = 0
        cell.leftBtn.addTarget(self, action: #selector(OpenScreenFromMenu), for: .touchUpInside)
        
        cell.rightLogo.image = #imageLiteral(resourceName: "videos")
        cell.rightTitle.text = titleMenuArray[1]
        cell.rightView.backgroundColor = #colorLiteral(red: 0.2385976315, green: 0.6759681106, blue: 0.9691354632, alpha: 1)
        cell.rightBtn.tag = 1
        cell.rightBtn.addTarget(self, action: #selector(OpenScreenFromMenu), for: .touchUpInside)
    }else if indexPath.row == 1{
        cell.leftLogo.image = #imageLiteral(resourceName: "gif (2)")
        cell.leftTitle.text = titleMenuArray[2]
        cell.leftView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        cell.leftBtn.tag = 3
        cell.leftBtn.addTarget(self, action: #selector(OpenScreenFromMenu), for: .touchUpInside)
        
        cell.rightLogo.image = #imageLiteral(resourceName: "slow-motion")
        cell.rightTitle.text = titleMenuArray[3]
        cell.rightView.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        cell.rightBtn.tag = 3
        cell.rightBtn.addTarget(self, action: #selector(OpenScreenFromMenu), for: .touchUpInside)
    }
}
