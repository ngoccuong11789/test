//
//  TwitterDetailViewController.swift
//  Twitter
//
//  Created by mac on 3/26/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class TwitterDetailViewController: UIViewController {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imageUrl: UIImageView!
    @IBOutlet weak var reweetsCount: UILabel!
    @IBOutlet weak var favoritesCount: UILabel!
    var tweets : [Tweet]!
    var detailContent: Tweet!
    override func viewDidLoad() {
        super.viewDidLoad()
        TwitterClient.sharedInstance.homeTimeLine({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            //print("Detail Content: \(self.detailContent.screenName)")
            self.screenName.text = self.detailContent.screenName! as String
            self.userName.text = self.detailContent.username! as String
            self.comment.text = self.detailContent.text! as String
            self.imageUrl.setImageWithURL(self.detailContent.profileImageUrl!)
            self.time.text = timeAgoSinceDate(self.detailContent.timestamp, numericDates: true)
            self.reweetsCount.text = String(self.detailContent.retweetCount)
            self.favoritesCount.text = String(self.detailContent.favoritesCount)
            print("favoritesCount\(self.detailContent.favoritesCount)")
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })
    }

    @IBAction func backHome(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
