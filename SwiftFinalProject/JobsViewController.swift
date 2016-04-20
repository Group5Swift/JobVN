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
    @IBOutlet weak var backgroundImage: UIImageView!


    var selectedCell: JobCollectionViewCell?

    var jobs: [Job] = []

    override func viewDidLoad() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self

        print("Current user \(PFUser.currentUser()!)")
        JobService.getJobs({(objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [Job] {
                    self.jobs = objects
                    self.mainCollectionView.reloadData()
                    // load thumbnail of first job
                    self.jobs[0].thumbnail?.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) in
                        self.setThumbnailBackgroundImage(0)
                    })

                }
            }
        })

//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
//        // Sets shadow (line below the bar) to a blank image
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        // Sets the translucent background color
//        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
//        // Set translucent. (Default value is already true, so this can be removed if desired.)
//        self.navigationController?.navigationBar.translucent = true
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    @IBAction func onLogout(sender: AnyObject) {
//        if PFUser.currentUser() != nil {
//            PFUser.logOutInBackgroundWithBlock() { (error: NSError?) -> Void in if error != nil {
//                print("logout fail \(error)")
//            } else {
//                NSUserDefaults.standardUserDefaults().setValue(nil, forKey: KEY_UID)
//                
//                self.dismissViewControllerAnimated(true, completion: nil)
//                }
//            }
//            
//        }else {
//            Facebook.logout()
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }
        NSNotificationCenter.defaultCenter().postNotificationName(User.USER_DID_LOGOUT_NOTIFICATION, object: nil)
    }


    @IBAction func onChooseCategory(sender: AnyObject) {
        performSegueWithIdentifier("CategoryView", sender: self)
    }

    @IBAction func onPostNewJob(sender: AnyObject) {
        performSegueWithIdentifier("PostNewJob", sender: nil)
    }

    func setThumbnailBackgroundImage(index: Int) {
        do {
            if let data = try self.jobs[index].thumbnail?.getData() {
                backgroundImage.image = UIImage(data: data)
            }
        } catch let e as NSError {
            print(e.localizedDescription)
        }
    }
}

extension JobsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobs.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = mainCollectionView.dequeueReusableCellWithReuseIdentifier("JobCollectionCell", forIndexPath: indexPath) as! JobCollectionViewCell

        cell.job = jobs[indexPath.row]

        return cell
    }

    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    }

    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = mainCollectionView.cellForItemAtIndexPath(indexPath) as! JobCollectionViewCell

        if cell != selectedCell {
            selectedCell?.stopVideo()
        }
        if cell.videoView.player?.isStopped() == true {
            cell.playVideo()
        }

        selectedCell = cell
    }
}

extension JobsViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let width = UIScreen.mainScreen().bounds.size.width

        let layout = self.mainCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing

        var offset = targetContentOffset.memory

        let index = (offset.x - scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)

        let x = roundedIndex * cellWidthIncludingSpacing - (width - layout.itemSize.width) / 2 + layout.minimumLineSpacing;

        offset = CGPoint(x: x, y: scrollView.contentInset.top)

        if Int(roundedIndex) < self.jobs.count {
            setThumbnailBackgroundImage(Int(roundedIndex))
        }

        targetContentOffset.memory = offset
    }

}
