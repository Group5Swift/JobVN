//
//  MainViewController.swift
//  SwiftFinalProject
//
//  Created by Dam Vu Duy on 4/7/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit
import Parse

enum FetchDataMode {
    case Job // job created by employer
    case Seeker // job created by employee
    case Saved // saved jobs
    case Favorited // favorited jobs
}

class JobsViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var mainTabar: UITabBar!
    @IBOutlet weak var backgroundImage: UIImageView!

    var dataMode: FetchDataMode = .Job

    var selectedCell: JobCollectionViewCell?

    var jobs: [Job] = []

    override func viewDidLoad() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self

        print("Current user \(PFUser.currentUser()!)")

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.getJobs()
        }

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        // Sets shadow (line below the bar) to a blank image
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // Sets the translucent background color
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        self.navigationController?.navigationBar.translucent = true
        
        super.viewDidLoad()
    }
    
    func getJobs() {
        let completeHandler = {(objects: [PFObject]?, error: NSError?) -> Void in
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
        }
        
        switch dataMode {
        case .Job:
            JobService.getJobs(completeHandler)
        case .Saved:
            JobService.getSavedJobs(completeHandler)
        default:
            JobService.getJobs(completeHandler)
        }
        
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
        NSNotificationCenter.defaultCenter().postNotificationName(User.USER_DID_LOGOUT_NOTIFICATION, object: nil)
    }


    @IBAction func onChooseCategory(sender: AnyObject) {
        performSegueWithIdentifier("CategoryView", sender: self)
    }

    @IBAction func onPostNewJob(sender: AnyObject) {
        performSegueWithIdentifier("PostNewJob", sender: nil)
    }
    
    func openJobDetailView(job: Job) {
        performSegueWithIdentifier("ViewJobDetail", sender: job)
    }

    func setThumbnailBackgroundImage(index: Int) {
        do {
            backgroundImage.image = try UIImage(data: (self.jobs[index].thumbnail?.getData())!)
        } catch let e as NSError {
            print(e.localizedDescription)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ViewJobDetail" {
            let vc = (segue.destinationViewController as! UINavigationController).viewControllers[0] as! JobDetailViewController
            vc.job = sender as? Job
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
        cell.jobsView = self

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

//        if Int(roundedIndex) < self.jobs.count {
//            setThumbnailBackgroundImage(Int(roundedIndex))
//        }

        targetContentOffset.memory = offset
    }

}
