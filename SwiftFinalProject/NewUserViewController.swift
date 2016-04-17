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

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    var welcomeScreen: WelcomeScreenViewController!
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var retypePasswordInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        emailInput.layer.cornerRadius = 8
        nameInput.layer.cornerRadius = 8
        passwordInput.layer.cornerRadius = 8
        retypePasswordInput.layer.cornerRadius = 8
        createButton.layer.cornerRadius = createButton.frame.size.height / 2
        
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
        
        if (retypePasswordInput.text == passwordInput.text) {
            if (nameInput.text == "" || emailInput.text == "" || passwordInput.text == "" || retypePasswordInput.text == "") {
                self.showErrorAlert("Error input", msg: "Please input require fields")
            }else {
                user.signUpInBackgroundWithBlock { (success, error) in
                    if success {
                        //print("Successfully Signed Up \(user.username) and \(user.email) and \(user.password)")
                        self.showErrorAlert("Successfull", msg: "Sign up successfull with User name : \(user.username!)")
                        self.performSegueWithIdentifier("GoToMainScreen", sender: nil)
                        
                    }else {
                        //print ("Error: \(error)")
                        self.showErrorAlert("Could not sign up", msg: "Please check your email and password")
                    }
                }
            }
            
        }else {
            self.showErrorAlert("Error input", msg: "Retype password is not match")
        }
        
        
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
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
