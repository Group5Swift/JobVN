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
        query.findObjectsInBackgroundWithBlock(complete)
    }
}