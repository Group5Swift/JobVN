//
//  MainViewController.swift
//  SwiftFinalProject
//
//  Created by Dam Vu Duy on 4/7/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit
import Parse
class JobsViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var mainTabar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            let loginManager: FBSDKLoginManager = FBSDKLoginManager()
            loginManager.logOut()
            NSUserDefaults.standardUserDefaults().setValue(nil, forKey: KEY_UID)
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            print("perform logout")
            PFUser.logOut()
            NSUserDefaults.standardUserDefaults().setValue(nil, forKey: KEY_UID)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func onChooseCategory(sender: AnyObject) {
        performSegueWithIdentifier("CategoryView", sender: self)
    }
    
    @IBAction func onPostNewJob(sender: AnyObject) {
        performSegueWithIdentifier("PostNewJob", sender: self)
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
