//
//  CategoryViewController.swift
//  SwiftFinalProject
//
//  Created by Dam Vu Duy on 4/7/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    var categoryIndexChoosed: [Int] = []
    
    @IBOutlet weak var catagoryTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        catagoryTable.delegate = self
        catagoryTable.dataSource = self
        // Do any additional setup after loading the view.
        
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
    
    @IBAction func onDone(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        if settings!.types == .None {
            let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }
        
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 10)
        notification.alertBody = "Hey dude! There are new jobs about Worker, please check them!"
        notification.alertAction = "be awesome!"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["CustomField1": "w00t"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
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

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as! CategoryTableViewCell
        if categoryIndexChoosed.contains(indexPath.row) {
            cell.cellMode = CheckCellState.Checked
        }
        else {
            cell.cellMode = CheckCellState.Uncheck
        }
        cell.contentLabel.text = categories[indexPath.row]["name"]
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.3, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
            },completion: { finished in
                UIView.animateWithDuration(0.5, animations: {
                    cell.layer.transform = CATransform3DMakeScale(1,1,1)
                })
        })
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CategoryTableViewCell
        
        if cell.cellMode == CheckCellState.Checked {
            cell.cellMode = CheckCellState.Uncheck
        }
        else {
            cell.cellMode = CheckCellState.Checked
        }
        
        if !categoryIndexChoosed.contains(indexPath.row) {
            categoryIndexChoosed.append(indexPath.row)
        }
        else {
            var tempCateIndex = [Int]()
            for value in categoryIndexChoosed {
                if value != indexPath.row {
                    tempCateIndex.append(value)
                }
            }
            self.categoryIndexChoosed = tempCateIndex
        }
    }
}

let categories = [["name" : "Baby Keeper", "code": "baby"],
                  ["name": "Tutor", "code": "teach"],
                  ["name": "Housework", "code": "housework"],
                  ["name": "Cleaning", "code": "clean"],
                  ["name": "Worker", "code": "worker"],
                  ["name": "Food & Cook", "code": "cook"],
                  ["name": "Mechanism fix", "code": "fix"],
                  ["name": "Hospital", "code": "nurse"],
                  ["name": "Old people Care", "code": "old"],
                  ["name": "Disable people care", "code": "disable"],
                  ["name": "Deliver", "code": "deliver"],
                  ["name": "Other", "code": "Other"]]