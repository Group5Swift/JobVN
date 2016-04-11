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
    
    var welcomeScreen: WelcomeScreenViewController!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
//        dismissViewControllerAnimated(true) {
//        self.welcomeScreen.onLoginComplete()
//        }
        
    }
    
    func login() {
        
        let user = PFUser()
        
        user.username = emailInput.text
        user.password = passwordInput.text
        
        if (emailInput.text == "" || passwordInput.text == "") {
            self.showErrorAlert("Error Sign in", msg: "Please input required fields")
        }else {
            PFUser.logInWithUsernameInBackground(emailInput.text!, password: passwordInput.text!) { (User: PFUser?, error: NSError?) in
                
                if error == nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        //                    var Storyboard = UIStoryboard(name: "Main", bundle: nil)
                        //                    var MainVC : UIViewController = Storyboard.instantiateViewControllerWithIdentifier("MainVC") as! UIViewController
                        //                    self.presentViewController(MainVC, animated: true, completion: nil)
                        //self.performSegueWithIdentifier("successLogin", sender: nil)
                        //self.showErrorAlert("Success", msg: "Login Successful")
                        
                        self.performSegueWithIdentifier("GoToMainScreen", sender: nil)
                    })
                }else {
                    //print ("Error: \(error)")
                    self.showErrorAlert("Could not login", msg: "Please check your email and password")
                    
                }
                
            }
        }
        
        
        
    }
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
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
