//
//  JobDetailViewController.swift
//  SwiftFinalProject
//
//  Created by Dam Vu Duy on 4/7/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit
import MapKit
import Parse
import Social
class JobDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var byUserLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var job: Job?
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if let job = job {
            titleLabel.text = job.name ?? "Baby sitter"
            byUserLabel.text = job.ownerUsername ?? "Anomymous"
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
        if let currentUser = PFUser.currentUser() {
            let relation = currentUser.relationForKey(User.SAVES)
            relation.addObject(job!)
            currentUser.saveInBackground()
        }
        let phoneNumber = user?.phone ?? "01689722989"
        if let url = NSURL(string: "tel://\(phoneNumber)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        if let currentUser = PFUser.currentUser() {
            let relation = currentUser.relationForKey(User.LOVEDJOB)
            relation.addObject(job!)
            currentUser.saveInBackground()
        }
    }
    
    @IBAction func shareOnFacebook(sender: UIButton) {
        let shareToFacebook : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        shareToFacebook.setInitialText("\(titleLabel.text!)")
        shareToFacebook.setInitialText("\(descriptionLabel.text!)")
        self.presentViewController(shareToFacebook, animated: true, completion: nil)
    }
    
}

