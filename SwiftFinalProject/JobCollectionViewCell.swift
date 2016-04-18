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
            if job != nil {
                setupThumbnail()
                setupVideo()
            }
        }
    }
    
    func setupVideoPlayer(filePath: NSURL) {
        videoView.player = EAVPlayer(URL: filePath)
        videoView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(JobCollectionViewCell.playerDidFinishPlaying), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.videoView.player!.currentItem)
    }
    
    func setupThumbnail() {
        job!.thumbnail?.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) in
            if error == nil {
                let image = UIImage(data: data!)
                self.defaultImageView.image = image
                self.defaultImageView.contentMode = UIViewContentMode.ScaleAspectFill
            }
            
        })
    }
    
    func setupVideo() {
        if job!.video != nil {
            let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            let fileName = NSURL(fileURLWithPath: job!.video!.url!).lastPathComponent ?? "temp_video.mp4"
            let filePath = documentsURL.URLByAppendingPathComponent(fileName, isDirectory: false)
            
            if !NSFileManager().fileExistsAtPath(filePath.path!) {
                job!.video?.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) in
                    print(1111);
                    data?.writeToURL(filePath, atomically: true)
                    self.setupVideoPlayer(filePath)
                })
            } else {
                self.setupVideoPlayer(filePath)
            }
            
            videoView.hidden = true
        }
    }
    
    func setupDetailView() {
        
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
