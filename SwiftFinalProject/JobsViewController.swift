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
    
    var cards: [Card] = [
        Card(mainImageUrl: "r1", videoUrl: "http://lzd.hvmark.com/test.mp4"),
        Card(mainImageUrl: "r2", videoUrl: "http://lzd.hvmark.com/square.mp4"),
        Card(mainImageUrl: "r3", videoUrl: "http://lzd.hvmark.com/food.mp4"),
        Card(mainImageUrl: "r4", videoUrl: "http://lzd.hvmark.com/tour.mp4"),
        Card(mainImageUrl: "r5", videoUrl: "http://lzd.hvmark.com/test.mp4")
    ]
    
    var jobs: [Job] = []
    
    override func viewDidLoad() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        JobService.getJobs({(objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [Job] {
                    self.jobs = objects
                    self.mainCollectionView.reloadData()
                }
            }
        })
        
        super.viewDidLoad()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        // Sets shadow (line below the bar) to a blank image
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // Sets the translucent background color
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        self.navigationController?.navigationBar.translucent = true
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            let loginManager: FBSDKLoginManager = FBSDKLoginManager()
            loginManager.logOut()
            NSUserDefaults.standardUserDefaults().setValue(nil, forKey: KEY_UID)
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            print("perform logout")
            PFUser.logOut()
            NSUserDefaults.standardUserDefaults().setValue(nil, forKey: KEY_UID)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    
    @IBAction func onChooseCategory(sender: AnyObject) {
        performSegueWithIdentifier("CategoryView", sender: self)
    }
    
    @IBAction func onPostNewJob(sender: AnyObject) {
        performSegueWithIdentifier("PostNewJob", sender: nil)
    }
}

extension JobsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return cards.count
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
//        print(x)
        offset = CGPoint(x: x, y: scrollView.contentInset.top)
        if Int(roundedIndex) < self.cards.count {
        
        backgroundImage.image = UIImage(named: (self.cards[Int(roundedIndex)].mainImageUrl)!)
        }
        
        targetContentOffset.memory = offset
    }
    
}
