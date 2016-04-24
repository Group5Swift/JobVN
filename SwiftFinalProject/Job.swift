//
//  Job.swift
//  SwiftFinalProject
//
//  Created by Dam Vu Duy on 4/7/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit
import Parse

class Job: PFObject, PFSubclassing {
    static let CLASS_STRING = "Job"
    static let NAME = "Name"
    static let DESCRIPTION = "Description"
    static let OWNER = "Owner"
    static let OWNERUSERNAME = "OwnerUsername"
    static let LOCATION = "Location"
    static let LONGTITUDE = "Longtitude"
    static let LATITUDE = "Latitude"
    static let PRICE = "Price"
    static let VIDEO = "Video"
    static let EMPLOYER = "Employer"
    static let THUMBNAIL = "Thumbnail"
    static let DATETIME = "date"
    static let ESTIMATE = "estimate"
    static let SELECTEDCATEGORY = "Category"
    
    static let JOBMODE = "JobMode"
    
    static let MODEJOB = 1
    static let MODESEEKER = 2
    
    static func parseClassName() -> String {
        return CLASS_STRING
    }
    
    var selectedCategory: String? {
        set(newValue) {
            setValue(selectedCategory, forKey: Job.SELECTEDCATEGORY)
            saveInBackgroundWithBlock { (success:Bool,err: NSError?) in
                if !success {
                    print(err?.localizedDescription)
                }
            }
        }
        get {
            let selectedCategory = valueForKey(Job.SELECTEDCATEGORY) as? String
            return selectedCategory
        }
    }
    
    var estimate: String? {
        set(newValue) {
            setValue(estimate, forKey: Job.ESTIMATE)
            saveInBackgroundWithBlock { (success:Bool, err: NSError?) in
                if !success {
                    print(err?.localizedDescription)
                }
            }
        }
        get {
            let estimate = valueForKey(Job.ESTIMATE) as? String
            return estimate
        }
    }
    
    var thumbnail: PFFile? {
        set (newValue) {
            setValue(newValue, forKey: Job.THUMBNAIL)
            saveInBackgroundWithBlock { (success: Bool, err: NSError?) in
                if !success {
                    print(err?.localizedDescription)
                }
            }
        }
        get {
            return valueForKey(Job.THUMBNAIL) as? PFFile
        }
    }
    
    var video: PFFile? {
        set (newValue) {
            setValue(newValue, forKey: Job.VIDEO)
            saveInBackgroundWithBlock { (success: Bool, err: NSError?) in
                if !success {
                    print(err?.localizedDescription)
                }
            }
        }
        get {
            let data = valueForKey(Job.VIDEO) as? PFFile
            return data
        }
    }
    
    var name: String? {
        set(newValue) {
            setValue(name, forKey: Job.NAME)
            saveInBackgroundWithBlock { (success: Bool, err: NSError?) in
                if !success {
                    print(err?.localizedDescription)
                }
            }
        }
        get{
            let name = valueForKey(Job.NAME) as? String
            return name
        }
    }
    
    var jobDescription: String? {
        set(newValue) {
            setValue(jobDescription, forKey: Job.DESCRIPTION)
            saveInBackgroundWithBlock { (success: Bool, err: NSError?) in
                if !success {
                    print(err?.localizedDescription)
                }
            }
        }
        get {
            let jobDescription = valueForKey(Job.DESCRIPTION) as? String
            return jobDescription
        }
    }
    
    var location: String? {
        set(newValue) {
            setValue(location, forKey: Job.LOCATION)
            saveInBackgroundWithBlock { (success: Bool, err: NSError?) in
                if !success {
                    print(err?.localizedDescription)
                }
            }
        }
        get {
            let location = valueForKey(Job.LOCATION) as? String
            return location
        }
    }
    
    var longtitue: String? {
        set(newValue) {
            setValue(longtitue, forKey: Job.LONGTITUDE)
            saveInBackgroundWithBlock { (success: Bool, err: NSError?) in
                if !success {
                    print(err?.localizedDescription)
                }
            }
        }
        get {
            let longtitue = valueForKey(Job.LONGTITUDE) as? String
            return longtitue
        }
    }
    
    var latitue: String? {
        set(newValue) {
            setValue(latitue, forKey: Job.LATITUDE)
            saveInBackgroundWithBlock { (success: Bool, err: NSError?) in
                if !success {
                    print(err?.localizedDescription)
                }
            }
        }
        get {
            let latitue = valueForKey(Job.LATITUDE) as? String
            return latitue
        }
    }
    
    var price: String? {
        set(newValue) {
            setValue(price, forKey: Job.PRICE)
            saveInBackgroundWithBlock { (success: Bool, err: NSError?) in
                if !success {
                    print(err?.localizedDescription)
                }
            }
        }
        get {
            let price = valueForKey(Job.PRICE) as? String
            return price
        }
    }
    
    var duetime: String? {
        set(newValue) {
            setValue(duetime, forKey: Job.DATETIME)
            saveInBackgroundWithBlock { (success: Bool, err: NSError?) in
                if !success {
                    print(err?.localizedDescription)
                }
            }
        }
        get {
            let duetime = valueForKey(Job.DATETIME) as? String
            return duetime
        }
    }
    
    var owner: User? {
        set(newValue) {
            setValue(owner, forKey: Job.OWNER)
            saveInBackgroundWithBlock { (success: Bool, err: NSError?) in
                if !success {
                    print(err?.localizedDescription)
                }
            }
        }
        get {
            let user = valueForKey(Job.OWNER) as? User
            return user
        }
    }
    
    var ownerUsername: String? {
        set(newValue) {
            setValue(duetime, forKey: Job.OWNERUSERNAME)
            saveInBackgroundWithBlock { (success: Bool, err: NSError?) in
                if !success {
                    print(err?.localizedDescription)
                }
            }
        }
        get {
            return valueForKey(Job.OWNERUSERNAME) as? String
        }
    }
}
