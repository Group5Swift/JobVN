//
//  JobDetailViewController.swift
//  SwiftFinalProject
//
//  Created by Dam Vu Duy on 4/7/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit
import MapKit

class JobDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var byUserLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var job: Job?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let job = job {
            titleLabel.text = job.name ?? "Baby sitter"
            
            if let owner = job.owner {
                do {
                    try owner.fetchIfNeeded()
                    if let name = owner.username {
                        byUserLabel.text = name
                    } else {
                        byUserLabel.text = "Anonymus"
                    }
                } catch let err as NSError {
                    print (err)
                }
            }
            else {
                byUserLabel.text = "Anonymus"
            }
            priceLabel.text = job.price ?? "infinite"
            descriptionLabel.text = job.jobDescription ?? ""
            locationLabel.text = job.location ?? ""
            
            MapHelper.inflateMap(mapView, address: job.location ?? "", delegate: MapHelperDelegate(), onComplete: { (map) in

            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onback(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onTakeThisJob(sender: AnyObject) {
    }
}

