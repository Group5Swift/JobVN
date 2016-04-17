//
//  Card.swift
//  SwiftFinalProject
//
//  Created by hvmark on 4/16/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit

class Card {
    init(mainImageUrl: String, videoUrl: String) {
        self.mainImageUrl = mainImageUrl
        self.videoUrl = videoUrl
    }
    
    var mainImageUrl: String?
    var videoUrl: String?
    var thumbnailImage: UIImage?
}