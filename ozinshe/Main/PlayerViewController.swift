//
//  PlayerViewController.swift
//  ozinshe
//
//  Created by Rinat Zaripov on 25.12.2023.
//

import UIKit
import youtube_ios_player_helper
class PlayerViewController: UIViewController {

    @IBOutlet weak var playerView: YTPlayerView!
    var videoId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playerView.load(withVideoId: videoId)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
