//
//  Facebook.swift
//  SwiftFinalProject
//
//  Created by hvmark on 4/16/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import Foundation
import Parse
class Facebook {
    static func logout() {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        PFUser.logOut()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: KEY_UID)
    }
}