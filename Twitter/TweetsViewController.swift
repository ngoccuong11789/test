//
//  TweetsViewController.swift
//  Twitter
//
//  Created by mac on 3/25/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit
//import BDBOAuth1Manager

class TweetsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate , TweetCellFavoriteDelegate {

    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    var originalLeftMargin: CGFloat!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var tweets : [Tweet]!
    var user : User!
    let myRequest = NSURLRequest()
    var tweetMenuViewController : UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(tweetMenuViewController.view)
        }
    }
    var contentViewController : UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                oldContentViewController.willMoveToParentViewController(nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMoveToParentViewController(nil)
            }
            
            tableView.addSubview(contentViewController.view)
            UIView.animateWithDuration(0.3) { 
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func favorite(statusTwitterViewCell: StatusTwitterViewCell) {
        let thisTweet = statusTwitterViewCell.tweet! as Tweet
        if statusTwitterViewCell.isFavorited == false {
            
            TwitterClient.sharedInstance.favoriteTweet(statusTwitterViewCell.idTweet, success: { (response:AnyObject?) -> () in
                //print(response)
                statusTwitterViewCell.favoriteButton.setImage(UIImage(named: "like-action-on-pressed.png"), forState: UIControlState.Normal)
                if thisTweet.favoritesCount > 0 {
                    statusTwitterViewCell.favoritesCountLabel.text = "\(thisTweet.favoritesCount + 1)"
                } else {
                    statusTwitterViewCell.favoritesCountLabel.text = "1"
                }
                
                }, failure: { (error: NSError) -> () in
                    print(error.localizedDescription)
            })
            
        } else {
            TwitterClient.sharedInstance.deFavoriteTweet(statusTwitterViewCell.idTweet, success: { (response:AnyObject?) -> () in
                
                statusTwitterViewCell.favoriteButton.setImage(UIImage(named: "like-action.png"), forState: UIControlState.Normal)
                if thisTweet.favoritesCount > 0 {
                    statusTwitterViewCell.favoritesCountLabel.text = "\(thisTweet.favoritesCount - 1)"
                } else {
                    statusTwitterViewCell.favoritesCountLabel.text = "0"
                }
                
                }, failure: { (error: NSError) -> () in
                    print(error.localizedDescription)
            })
        }
    }
    
    var detailContent: Tweet!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        TwitterClient.sharedInstance.homeTimeLine({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            for tweet in tweets {
                print(tweet.idTweet)
                print(tweet.favoriteStatus)
                //print(tweet.text!)
                //print(tweet.nameArray!)
//                print(tweet.username!)
//                if tweet.profileImageUrl != nil {
//                    print(tweet.profileImageUrl!)
//                }
//                if tweet.timestamp != nil {
//
//                    print(tweet.timestamp)
//                
//
//                }
//                    print(tweet.screenName)
                
            }
            self.tableView.reloadData()
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
            })
        
        TwitterClient.sharedInstance.currentAccount({(user: User) in
            self.user = user
            print("User name: \(user.name!)")
        }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        
    }

    
    @IBAction func logoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }

    
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        TwitterClient.sharedInstance.homeTimeLine({ (tweets: [Tweet]) in
            self.tweets = tweets
            
            //print(tweets.count)
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
            //print(tweets.count)
            refreshControl.endRefreshing()
        }) { (error: NSError) in
                print(error.localizedDescription)
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("twitterCell", forIndexPath: indexPath) as! StatusTwitterViewCell
        //let tweet : Tweet
        
        //tweet = tweets[indexPath.row]
        cell.favoriteDelegate = self
        cell.tweet = tweets[indexPath.row]
        /*cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
         UIView.animateWithDuration(0.25, animations: {
         cell.layer.transform = CATransform3DMakeScale(1,1,1)
         })
         */
        
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(1, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
            },completion: { finished in
                UIView.animateWithDuration(0.5, animations: {
                    cell.layer.transform = CATransform3DMakeScale(1,1,1)
                })
        })
        return cell
    }
    
    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            originalLeftMargin = leftMarginConstraint.constant
        }else if sender.state == UIGestureRecognizerState.Changed {
            leftMarginConstraint.constant = originalLeftMargin + translation.x
        }else if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.3, animations: { 
                if velocity.x > 0 {
                    self.leftMarginConstraint.constant = self.view.frame.size.width - 50
                }else {
                    self.leftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
            
        }
        
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ViewDetailTweet"{
            let selectedIndex = self.tableView.indexPathForCell(sender as! StatusTwitterViewCell)
        //let selectedCell = addressArray[(selectedIndex?.row)!]
        //let selectedCell = filteredData[(selectedIndex?.row)!].address!
            let selectedCell = tweets[(selectedIndex?.row)!]
            detailContent = selectedCell
            let twitterDetailViewController = segue.destinationViewController as! TwitterDetailViewController
            twitterDetailViewController.detailContent = self.detailContent
        }
    }
    

}


