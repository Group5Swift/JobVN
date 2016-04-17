//
//  PostJobViewController.swift
//  SwiftFinalProject
//
//  Created by Dam Vu Duy on 4/7/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import AVFoundation

class PostJobViewController: UIViewController {

    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var jobDescription: UITextView!
    
    let job = PFObject(className: Job.CLASS_STRING)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for auto get location suggest
        locationLabel.delegate = self
        
        // Do any additional setup after loading the view.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PostJobViewController.onTapAnywhere(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onRecordVideo(sender: AnyObject) {
        performSegueWithIdentifier("RecordNewVideo", sender: self)
    }
    
    @IBAction func onPost(sender: AnyObject) {
        let title = self.titleLabel.text
        let price = self.price.text
        let location = self.locationLabel.text
        let description = self.jobDescription.text
        let owner = PFUser.currentUser()
        
        job.setValue(title!, forKey: Job.NAME)
        job.setValue(price!, forKey: Job.PRICE)
        job.setValue(location!, forKey: Job.LOCATION)
        job.setValue(description!, forKey: Job.DESCRIPTION)
        job.setValue(owner!, forKey: Job.OWNER)
        
        job.saveInBackgroundWithBlock { (success: Bool, err: NSError?) in
            if err != nil {
                self.showErrLog(err!)
            }
            else {
                print("New JOB posted with title: \(title!), price: \(price!), location: \(location!), description: \(description!)")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        
    }
    
    func showErrLog(err: NSError) {
        let alert = UIAlertController(title: "Oops!", message: err.localizedDescription, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func onTapAnywhere(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        // TODO
        
        let target = (segue.destinationViewController as! UINavigationController).viewControllers[0] as! RecordJobViewController
        target.delegate = self
        
    }

}

extension PostJobViewController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        print("on change text: \(string)")
        
        return true
    }
}

extension PostJobViewController: RecordVideoCompleteDelegate {
    func onRecordComplete(output: NSURL) {
        dismissViewControllerAnimated(true, completion: nil)
        do {
            
            
            let file = try PFFile(name: "Video.mp4", data: NSData(contentsOfURL: output)!, contentType: "video/mp4")
            
//            let file = try PFFile(name: "Video", contentsAtPath: output.path!)
//            let t = PFFile(name: <#T##String?#>, data: <#T##NSData#>, contentType: <#T##String?#>)

            file.saveInBackgroundWithBlock({ (success: Bool, err: NSError?) in
                if err != nil {
                    print(err)
                } else {
                    print("Save video complete")
                }
            }, progressBlock: { (percent: Int32) in
                    print("Save percent: \(percent)")
            })
            
            let asset = AVURLAsset(URL: NSURL(fileURLWithPath: output.path!), options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            let cgImage = try imgGenerator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil)
            let uiImage = UIImage(CGImage: cgImage)
            let imageData = UIImagePNGRepresentation(uiImage)
            let thumbnail = PFFile(data: imageData!)
            
            thumbnail?.saveInBackground()
            
            print(thumbnail?.url)
            
            job.setValue(thumbnail, forKey: Job.THUMBNAIL)
            
            job.setValue(file, forKey: Job.VIDEO)
        } catch let e as NSError {
            print(e)
        }
    }
}

