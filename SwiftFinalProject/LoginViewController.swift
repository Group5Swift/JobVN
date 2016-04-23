//
//  LoginViewController.swift
//  SwiftFinalProject
//
//  Created by Dam Vu Duy on 4/7/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit
import Parse
class LoginViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    var welcomeScreen: WelcomeScreenViewController!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailInput.layer.cornerRadius = 8
        passwordInput.layer.cornerRadius = 8
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImage.bounds
        
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        backgroundImage.addSubview(blurEffectView)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        // Sets shadow (line below the bar) to a blank image
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // Sets the translucent background color
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        self.navigationController?.navigationBar.translucent = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(sender: UIButton) {
        login()
    }

    @IBAction func onBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)

        
    }
    
    func login() {
        
        let user = PFUser()
        
        user.username = emailInput.text
        user.password = passwordInput.text
        
        if (emailInput.text == "" || passwordInput.text == "") {
            SCLAlertView().showError("Could not login", subTitle: "Please input required fields")
        }else {
            PFUser.logInWithUsernameInBackground(emailInput.text!, password: passwordInput.text!) { (User: PFUser?, error: NSError?) in
                
                if error == nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        NSUserDefaults.standardUserDefaults().setValue(SEGUE_LOGGED_IN, forKey: KEY_UID)
                        self.performSegueWithIdentifier("GoToMainScreen", sender: nil)
                    })
                    
                }else {
                    
                    SCLAlertView().showError("Could not login", subTitle: "Please check your email and password")
                    
                }
                
            }
        }
    }

    
    @IBAction func onTapOutside(sender: AnyObject) {
        view.endEditing(true)
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
