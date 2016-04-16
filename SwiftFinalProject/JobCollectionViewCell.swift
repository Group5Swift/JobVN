//
//  JobCollectionViewCell.swift
//  SwiftFinalProject
//
//  Created by Dam Vu Duy on 4/10/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit
import AVFoundation
import ParseUI

class JobCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var byUser: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var defaultImageView: UIImageView!
    @IBOutlet weak var videoView: PlayerView!
    @IBOutlet weak var detailView: UIView!
    
    func playVideo() {
//        print("play video \(card?.videoUrl)")
        videoView.player?.play()
        videoView.hidden = false
        detailView.hidden = true
    }
    
    func stopVideo() {
        print("stop video")
        videoView.player?.stopAndRewind()
        videoView.hidden = true
        detailView.hidden = false
    }
    
    func createAVPlayer(urlString: String) -> EAVPlayer {
        let steamingURL:NSURL = NSURL(string:urlString)!
        let player = EAVPlayer(URL: steamingURL)
        
        return player
    }
    
    var job: Job? {
        didSet {
            if let _job = job {
                
                _job.thumbnail?.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) in
                    if error == nil {
                        let image = UIImage(data: data!)
                        self.defaultImageView.image = image
                    }
                    
                })
                
                defaultImageView.contentMode = UIViewContentMode.ScaleAspectFill
                videoView.hidden = true
                
//                if let image = EAVPlayer.createThumbnailFromVideo((_job.videoUrl)!) {
//                    defaultImageView.image = image
//                    defaultImageView.contentMode = UIViewContentMode.ScaleAspectFill
//                }
//                AVPlayerItem(
//                EAVPlayer(playerItem: <#T##AVPlayerItem#>)
                
                var url = "http://lzd.hvmark.com/square.mp4"
                if _job.video != nil {
                    url = (_job.video?.url)!
                }
                
                videoView.player = createAVPlayer(url)
                videoView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(JobCollectionViewCell.playerDidFinishPlaying), name: AVPlayerItemDidPlayToEndTimeNotification, object: videoView.player!.currentItem)
            }
        }
    }
    
//    var card: Card? {
//        didSet {
//            if let _card = card {
//                defaultImageView.image = UIImage(named: (_card.mainImageUrl)!)
//                videoView.hidden = true
//                
//                if let image = EAVPlayer.createThumbnailFromVideo((_card.videoUrl)!) {
//                    defaultImageView.image = image
//                    defaultImageView.contentMode = UIViewContentMode.ScaleAspectFill
//                }
//                
//                videoView.player = createAVPlayer(_card.videoUrl!)
//                videoView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
//                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(JobCollectionViewCell.playerDidFinishPlaying), name: AVPlayerItemDidPlayToEndTimeNotification, object: videoView.player!.currentItem)
//            }
//        }
//    }
    
    @IBAction
    func playerDidFinishPlaying() {
        print("ending of video")
        stopVideo()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
}
