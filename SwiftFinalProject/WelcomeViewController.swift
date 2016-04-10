//
//  ViewController.swift
//  SwiftFinalProject
//
//  Created by Dam Vu Duy on 4/6/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit
import Parse


class WelcomeScreenViewController: UIViewController {

   override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLoginWithFacebook(sender: UIButton) {
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
        if segue.identifier == "LoginWithAccount" {
            let loginVC = (segue.destinationViewController as! UINavigationController).viewControllers[0] as! LoginViewController
            loginVC.welcomeScreen = self
        }
    }
    
}

