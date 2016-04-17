//
//  PlayerView.swift
//  testvideo
//
//  Created by hvmark on 4/15/16.
//  Copyright © 2016 hvmark. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerView: UIView {
    
    var player: EAVPlayer? {
        get {
            return playerLayer.player as? EAVPlayer
        }
        
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    override class func layerClass() -> AnyClass {
        return AVPlayerLayer.self
    }
}