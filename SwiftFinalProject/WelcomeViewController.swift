//
//  ViewController.swift
//  SwiftFinalProject
//
//  Created by Dam Vu Duy on 4/6/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit

class WelcomeScreenViewController: UIViewController {

   override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
        else if PFUser.currentUser()?.username != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }

    @IBAction func onLoginWithFacebook(sender: UIButton) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"]) { (facebookResult: FBSDKLoginManagerLoginResult!,facebookError: NSError!) in
            if facebookError != nil {
                print("Facebook login failed. Error\(facebookError)")
            }else if facebookResult.isCancelled {
                print("Facebook login was cancelled")
            }else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Successfully logged in with facebook. \(accessToken)")
                
                
                
                FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large)"]).startWithCompletionHandler { (connection, facebookResult, error) -> Void in
                    let strFirstName: String = (facebookResult.objectForKey("first_name") as? String)!
                    let strLastName: String = (facebookResult.objectForKey("last_name") as? String)!
                    let strPictureURL: String = (facebookResult.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                    let name = "Welcome, \(strFirstName) \(strLastName)"
                    //self.ivUserProfileImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: strPictureURL)!)!)
                    }
                
                NSUserDefaults.standardUserDefaults().setValue(SEGUE_LOGGED_IN, forKey: KEY_UID)
                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                //self.performSegueWithIdentifier("GoToMainScreen", sender: nil)
            }
            
        }
    }

    @IBAction func onCreateNewUser(sender: UIButton) {
        performSegueWithIdentifier("CreateNewUser", sender: self)
    }
    
    @IBAction func onLoginWithAccount(sender: UIButton) {
        performSegueWithIdentifier("LoginWithAccount", sender: self)
    }
    
    func onLoginComplete() {
        performSegueWithIdentifier("GoToMainScreen", sender: self)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "LoginWithAccount" {
//            let loginVC = (segue.destinationViewController as! UINavigationController).viewControllers[0] as! LoginViewController
//            loginVC.welcomeScreen = self
//        }
    }
    
}

