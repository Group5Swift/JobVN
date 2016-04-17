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
        job?.video?.getDataInBackgroundWithBlock({ (data: NSData?, err: NSError?) in
            if err == nil {
                let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                var filePath = documentsURL.URLByAppendingPathComponent("tempVideoToPlay", isDirectory: false)
                filePath = filePath.URLByAppendingPathExtension("mp4")
                let mananger = NSFileManager()
                if mananger.fileExistsAtPath(filePath.path!) {
                    try! mananger.removeItemAtPath(filePath.path!)
                }
                data?.writeToURL(filePath, atomically: true)
                self.videoView.player = EAVPlayer(URL: filePath)
                self.videoView.player?.play()
                self.videoView.hidden = false
                self.detailView.hidden = true
            }
            else {
                print(err?.localizedDescription)
            }
            }, progressBlock: { (percent: Int32) in
                print("Downloading \(percent)")
        })
    }
    
    func stopVideo() {
        print("stop video")
        videoView.player?.stopAndRewind()
        videoView.hidden = true
        detailView.hidden = false
    }
    
    func createAVPlayer(urlString: String) -> EAVPlayer {
        let steamingURL = NSURL(string: urlString)!
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
                
                
//                    print(_job.video?.url)
                
//                    _job.video?.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) in
//                        let steamingURL = NSURL(dataRepresentation: data!, relativeToURL: nil)
//                        let player = EAVPlayer(URL: steamingURL)
//                        self.videoView.player = player
//                        self.videoView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
////                        self.playVideo()
//                        print(123123);
//                        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(JobCollectionViewCell.playerDidFinishPlaying), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.videoView.player!.currentItem)
//                    })
                
                
//                    let url = (_job.video?.url)!
//                    let url = "aaa://lzd.hvmark.com/tour"
                    let url = "http://lzd.hvmark.com/square.mp4"
//                    let steamingURL = NSURL(string: url)
//                    let urlAsset = AVURLAsset(URL: steamingURL!)
//                    
//                    urlAsset.resourceLoader.setDelegate(self, queue:dispatch_get_main_queue())
//                
////                    print(_job.video)
////                    print(url)
////                    let steamingURL = NSURL(string: url)
//                    let avPlayerItem = AVPlayerItem(asset: urlAsset)
////                    let player = EAVPlayer(URL: steamingURL!)
//                    let player = EAVPlayer(playerItem: avPlayerItem)
//                
//                    videoView.player = player
                
                videoView.player = createAVPlayer(url)
                
                videoView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(JobCollectionViewCell.playerDidFinishPlaying), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.videoView.player!.currentItem)
                
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

extension JobCollectionViewCell: AVAssetResourceLoaderDelegate {
    
    func resourceLoader(resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
//        loadingRequest.request = NSMutableURLRequest()
        loadingRequest.contentInformationRequest?.contentType = "video/mp4"
//        loadingRequest.request.setValue("video/mp4", forKey: "Content-Type")
        
        return true
    }
    
}
