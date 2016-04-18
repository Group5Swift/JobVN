//
//  EUILabel.swift
//  SwiftFinalProject
//
//  Created by hvmark on 4/18/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit

class EUILabel: UILabel {
    let top: Float = 3
    let bottom: Float = 6
    let left: Float = 5
    let right: Float = 5
    
    override func drawTextInRect(rect: CGRect) {
        let insets = UIEdgeInsets.init(top: CGFloat(self.top), left: CGFloat(self.left), bottom: CGFloat(self.bottom), right: CGFloat(self.right))
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
}
