//
//  UserDetailViewController.swift
//  SwiftFinalProject
//
//  Created by Dam Vu Duy on 4/7/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit
import Parse

class UserDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
//        // Sets shadow (line below the bar) to a blank image
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        // Sets the translucent background color
//        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
//        // Set translucent. (Default value is already true, so this can be removed if desired.)
//        self.navigationController?.navigationBar.translucent = true
        
        
        
        user.fetchIfNeededInBackground()
        
        userAvatar.clipsToBounds = true
//        userAvatar.layer.cornerRadius = userAvatar.frame.size.height / 2
        
        userDescription.text = (user.valueForKey(User.DESCRIPTION) as? String) ?? userDescription.text
        
        userDescription.sizeToFit()
        
        username.text = user.username ?? username.text
        
        userDescription.sizeToFit()
        
        rating.text = "\((user.valueForKey(User.RATING) as? Float) ?? 4.5)/5"
        
        let createdRela = user.relationForKey(User.POSTEDJOB)
        let lovedRela = user.relationForKey(User.LOVEDJOB)
        let takedRela = user.relationForKey(User.SAVES)
        
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
        //        avatar.
        if let avatar = avatar {
            avatar.getDataInBackgroundWithBlock { (data: NSData?, err: NSError?) in
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
        }
        
        imagePicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(loadPicker(_:)))
        tap.numberOfTapsRequired = 1
        userAvatar.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
//    @IBAction func changeAvatarFromSource(sender: UIButton) {
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//        imagePicker.allowsEditing = false
//        self.presentViewController(imagePicker, animated: true, completion: nil)
//    }
//    
//    @IBAction func changeAvatar(sender: AnyObject) {
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//        imagePicker.allowsEditing = false
//        self.presentViewController(imagePicker, animated: true, completion: nil)
//    }
    
    func loadPicker(gesture: UITapGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        userAvatar.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func saveChanged(sender: UIBarButtonItem) {
        
        if userAvatar.image == nil {
            SCLAlertView().showError("Error", subTitle: "Image not uploaded")
        }else {
            let imageData = UIImagePNGRepresentation(self.userAvatar.image!)
            let avatar = PFFile(data: imageData!)
            avatar?.saveInBackgroundWithBlock({ (success: Bool, err: NSError?) in
                if err == nil {
                    self.user.setValue(avatar, forKey: User.AVATAR)
                    self.user.saveInBackground()
                    SCLAlertView().showSuccess("Success", subTitle: "Image uploaded")
                }else {
                    print("error: \(err)")
                }
                }, progressBlock: { (percent: Int32) in
                    print("Percent \(percent)")
            })
            
        }
        
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let imagenow = info[UIImagePickerControllerOriginalImage] as? UIImage
        userAvatar.image = resizeImage(imagenow!, newWidth: 200)
        self.dismissViewControllerAnimated(true, completion: nil)
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
