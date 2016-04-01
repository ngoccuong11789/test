//
//  Tweet.swift
//  Twitter
//
//  Created by mac on 3/24/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var text: NSString?
    var timestamp: NSDate!
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var username: NSString?
    var screenName: NSString?
    var profileImageUrl: NSURL?
    var nameArray: NSDictionary?
    //var imageUrl: String?
    var idTweet: NSNumber?
    var favoriteStatus: Bool?
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
//        nameArray = dictionary["user"] as? NSDictionary
//        username = nameArray!["name"] as? String
        username = dictionary["user"]!["name"] as? String
        screenName = dictionary["user"]!["screen_name"] as? String
        idTweet = dictionary["id"] as? NSNumber
        let timestampString = dictionary["created_at"] as? String
        
        let imageURLString = dictionary["user"]!["profile_image_url_https"] as? String
        favoriteStatus = dictionary["favorited"] as? Bool
        //imageUrl = imageURLString!
        if imageURLString != nil {
            profileImageUrl = NSURL(string: imageURLString!)!
        } else {
            profileImageUrl = nil
        }
        
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
    }
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
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
    
}
