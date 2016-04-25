//
//  JobService.swift
//  SwiftFinalProject
//
//  Created by hvmark on 4/17/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import Foundation
import Parse

class JobService {
    static func getJobs(complete: (objects: [PFObject]?, error: NSError?) -> ()) {
        let query = Job.query()!
        query.whereKey(Job.JOBMODE, equalTo: Job.MODEJOB)
        query.findObjectsInBackgroundWithBlock(complete)
        
    }
    
    static func getSeekers(complete: (objects: [PFObject]?, error: NSError?) -> ()) {
        let query = Job.query()!
        query.whereKey(Job.JOBMODE, equalTo: Job.MODESEEKER)
        query.findObjectsInBackgroundWithBlock(complete)
    }
    
    static func getSavedJobs(complete: (objects: [PFObject]?, error: NSError?) -> ()) {
        let currentUser = PFUser.currentUser()
        if let savedJobRelation = currentUser?.relationForKey(User.SAVES) {
            savedJobRelation.query().findObjectsInBackgroundWithBlock(complete)
        }
    }
}