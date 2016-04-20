//
//  UserDetailViewController.swift
//  SwiftFinalProject
//
//  Created by Dam Vu Duy on 4/7/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit
import Parse

class UserDetailViewController: UIViewController {

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var takedJobCount: UILabel!
    @IBOutlet weak var jobDoneCount: UILabel!
    @IBOutlet weak var savedJobCount: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var userDescription: UILabel!
    
    var createdJobNumber: Int = 0
    var lovedJobNumber: Int = 0
    var takedJobNumber: Int = 0
    var user: PFUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userAvatar.layer.cornerRadius = userAvatar.frame.size.height / 2
        
        userDescription.text = user.valueForKey(User.DESCRIPTION) as? String
        rating.text = "\(user.valueForKey(User.RATING) as? Float)"
        
        let createdRela = user.relationForKey(User.POSTEDJOB)
        let lovedRela = user.relationForKey(User.LOVEDJOB)
        let takedRela = user.relationForKey(User.TAKES)
        
        createdRela.query().findObjectsInBackgroundWithBlock { (data: [PFObject]?, err: NSError?) in
            if err == nil {
                if data == nil {
                    return
                }
                self.createdJobNumber = (data?.count)!
                self.jobDoneCount.text = "\(self.createdJobNumber)"
            } else {
                print (err?.localizedDescription)
            }
        }
        
        lovedRela.query().findObjectsInBackgroundWithBlock { (data: [PFObject]?, err: NSError?) in
            if err == nil {
                if data == nil {
                    return
                }
                self.lovedJobNumber = (data?.count)!
                self.savedJobCount.text = "\(self.lovedJobNumber)"
            } else {
                print (err?.localizedDescription)
            }
        }
        
        takedRela.query().findObjectsInBackgroundWithBlock { (data: [PFObject]?, err: NSError?) in
            if err == nil {
                if data == nil {
                    return
                }
                self.takedJobNumber = (data?.count)!
                self.takedJobCount.text = "\(self.takedJobNumber)"
            } else {
                print (err?.localizedDescription)
            }
        }
        
        let avatar = user.valueForKey(User.AVATAR) as? PFFile
        avatar?.getDataInBackgroundWithBlock { (data: NSData?, err: NSError?) in
            if err == nil {
                if data == nil {
                    return
                }
                let image = UIImage(data: data!)
                self.userAvatar.image = image
            } else {
                print (err?.localizedDescription)
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
