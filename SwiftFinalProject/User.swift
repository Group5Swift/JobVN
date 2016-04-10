//
//  User.swift
//  SwiftFinalProject
//
//  Created by Dam Vu Duy on 4/7/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit
import Parse

class User: PFUser {
    static let CLASS_STRING = "User"
    static let NAME = "UserName"
    static let PHONE = "Phone"
    static let DESCRIPTION = "Description"
    static let RATING = "Rating"
    static let LOVEDJOB = "LovedJob"
    static let POSTEDJOB = "PostedJob"
    static let AVATAR = "Avatar"
    
    var isNeedSaveData = true;
    
    override static func parseClassName() -> String {
        return CLASS_STRING
    }
    
    var avatar: PFFile {
        set (newValue) {
            setValue(newValue, forKey: User.AVATAR)
            saveInBackgroundWithBlock { (success: Bool, err: NSError?) in
                if !success {
                    print(err?.localizedDescription)
                }
            }
        }
        get {
            let file = valueForKey(User.AVATAR) as! PFFile
            return file
        }
    }
    
    var name: String {
        set(newValue) {
//            self.name = newValue
            setValue(name, forKey: User.NAME)
            saveInBackgroundWithBlock { (success: Bool, err: NSError?) in
                if !success {
                    print(err?.localizedDescription)
                }
            }
        }
        get {
            let name = valueForKey(Job.NAME) as! String
            return name
        }
    }
    
    var phone: String {
        set(newValue) {
//            self.phone = newValue
            setValue(phone, forKey: User.PHONE)
            saveInBackgroundWithBlock { (success: Bool, err: NSError?) in
                if !success {
                    print(err?.localizedDescription)
                }
            }
        }
        get {
            let phone = valueForKey(User.PHONE) as! String
            return phone
        }
    }
    
    var userDescription: String {
        set(newValue) {
//            self.userDescription = newValue
            setValue(userDescription, forKey: User.DESCRIPTION)
            saveInBackgroundWithBlock { (success: Bool, err: NSError?) in
                if !success {
                    print(err?.localizedDescription)
                }
            }
        }
        get {
            let userDescription = valueForKey(User.DESCRIPTION) as! String
            return userDescription
        }
    }
    
    var rating: Float {
        set(newValue) {
//            self.rating = newValue
            setValue(rating, forKey: User.RATING)
            saveInBackgroundWithBlock { (success: Bool, err: NSError?) in
                if !success {
                    print(err?.localizedDescription)
                }
            }
        }
        get {
            let rating = valueForKey(User.RATING) as! Float
            return rating
        }
    }
    
    var lovedJob: [Job] {
        get {
            let jobs = valueForKey(User.LOVEDJOB) as! [Job]
            return jobs
        }
        set(newValue) {
//            self.lovedJob = newValue
            setValue(newValue, forKey: User.LOVEDJOB)
            saveInBackgroundWithBlock { (success: Bool, err: NSError?) in
                if !success {
                    print(err?.localizedDescription)
                }
            }
        }
    }
    
    var postedJob: [Job] {
        get {
            let postedJob = valueForKey(User.POSTEDJOB) as! [Job]
            return postedJob
        }
        set(newValue) {
//            self.postedJob = newValue
            setValue(newValue, forKey: User.POSTEDJOB)
            saveInBackgroundWithBlock { (success: Bool, err: NSError?) in
                if !success {
                    print(err?.localizedDescription)
                }
            }
        }
    }
    
    func setData(name: String, phone: String, description: String, rating: Float) {
        self.name = name
        self.phone = phone
        self.userDescription = description
        self.rating = rating
    }
}
