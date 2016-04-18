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
    
    var job: Job? {
        didSet {
            if let _job = job {
                _job.thumbnail?.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) in
                    if error == nil {
                        let image = UIImage(data: data!)
                        self.defaultImageView.image = image
                        self.defaultImageView.contentMode = UIViewContentMode.ScaleAspectFill
                    }
                    
                })
            
                _job.video?.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) in
                    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                    let fileName = NSURL(fileURLWithPath: _job.video!.url!).lastPathComponent ?? "temp_video.mp4"
                    let filePath = documentsURL.URLByAppendingPathComponent(fileName, isDirectory: false)
                    
                    if !NSFileManager().fileExistsAtPath(filePath.path!) {
                        data?.writeToURL(filePath, atomically: true)
                        //try! mananger.removeItemAtPath(filePath.path!)
                    }
                    
                    self.videoView.player = EAVPlayer(URL: filePath)
                    self.videoView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill

                    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(JobCollectionViewCell.playerDidFinishPlaying), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.videoView.player!.currentItem)
                })
                
                videoView.hidden = true
            }
        }
    }
    
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
