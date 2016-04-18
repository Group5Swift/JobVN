//
//  EAVPlayer.swift
//  testvideo
//
//  Created by hvmark on 4/15/16.
//  Copyright © 2016 hvmark. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class EAVPlayer: AVPlayer {
    
    
    func isPlaying() -> Bool {
        return self.rate != 0 && self.error == nil
    }
    
    func isStopped() -> Bool {
        return self.rate == 0
    }
    
    func stopAndRewind() {
        self.seekToTime(CMTimeMake(0, (self.currentItem?.duration.timescale)!))
        self.pause()
    }
    
    static func createThumbnailFromVideo(sourceURL: String) -> UIImage? {
        let asset = AVAsset(URL: NSURL(fileURLWithPath: sourceURL))
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        if let cgImage = try? imageGenerator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil) {
            let thumbnail = UIImage(CGImage: cgImage)
            return thumbnail
        }
        
        return nil
    }
    
    static func createAVPlayer(urlString: String) -> EAVPlayer {
        let steamingURL = NSURL(string: urlString)!
        let player = EAVPlayer(URL: steamingURL)
        
        return player
    }
}