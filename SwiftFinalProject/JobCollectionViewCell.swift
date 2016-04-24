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
    
    @IBOutlet weak var byUserValue: UILabel!
    @IBOutlet weak var timeValue: UILabel!
    @IBOutlet weak var priceValue: UILabel!
    
    @IBOutlet weak var defaultImageView: UIImageView!
    @IBOutlet weak var videoView: PlayerView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var categoryImage: UIImageView!
    
    var jobsView: JobsViewController?
    
    
    
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
                setupDetailView()
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
                self.defaultImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
            }
        })
    }
    
    func setupVideo() {

        if job!.video != nil {
            let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            let fileName = NSURL(fileURLWithPath: job!.video!.url!).lastPathComponent ?? "temp_video.mp4"
            let filePath = documentsURL.URLByAppendingPathComponent(fileName, isDirectory: false)
            
            if !NSFileManager().fileExistsAtPath(filePath.path!) {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                    self.job!.video?.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) in
                        data?.writeToURL(filePath, atomically: true)
                        self.setupVideoPlayer(filePath)
                    })
                })
            } else {
                self.setupVideoPlayer(filePath)
            }

            videoView.hidden = true
        } else {
            setupMap()
        }
    }

    func setupMap() {

    }

    @IBAction func onDetailButton(sender: AnyObject) {
        if let job = job {
            jobsView?.openJobDetailView(job)
        }
    }
    
    func setupDetailView() {
        if let job = job {
            title.text = job.name ?? "Baby sitter"
            byUserValue.text = job.getOwnerName()
            priceValue.text = job.price ?? "infinite"
            timeValue.text = job.duetime ?? "30 April"
            
            if let selectedCategory = job.selectedCategory {
                categoryImage.image = UIImage(named: selectedCategory)
            }
            
            priceValue.sizeToFit()
            priceValue.layer.cornerRadius = 10.0
            priceValue.backgroundColor = UIColor(red: 20/255, green: 206/255, blue: 104/255, alpha: 1)
            priceValue.clipsToBounds = true
            priceValue.textAlignment = NSTextAlignment.Center
            priceValue.layoutIfNeeded()
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
