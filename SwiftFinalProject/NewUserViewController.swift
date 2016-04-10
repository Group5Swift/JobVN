//
//  NewUserViewController.swift
//  SwiftFinalProject
//
//  Created by Dam Vu Duy on 4/7/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit
import Parse
class NewUserViewController: UIViewController {

    var welcomeScreen: WelcomeScreenViewController!
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var retypePasswordInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCreateUser(sender: UIButton) {
        signUp()
    }
    @IBAction func onBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUp() {
        var user = PFUser()
        user.username = nameInput.text!
        user.email = emailInput.text!
        user.password = passwordInput.text!
        
        user.signUpInBackgroundWithBlock { (success, error) in
            if success {
                //print("Successfully Signed Up \(user.username) and \(user.email) and \(user.password)")
                self.showErrorAlert("Successfull", msg: "Sign up successfull with User name : \(user.username!)")
                self.performSegueWithIdentifier("SignIn", sender: nil)
                
            }else {
                //print ("Error: \(error)")
                self.showErrorAlert("Could not sign up", msg: "Please check your email and password")
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
