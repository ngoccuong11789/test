//
//  StatusTwitterViewCell.swift
//  Twitter
//
//  Created by mac on 3/26/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

@objc protocol TweetCellFavoriteDelegate {
    optional func favorite(statusTwitterViewCell: StatusTwitterViewCell)
}

class StatusTwitterViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    var isFavorited : Bool!
    var idTweet: NSNumber!
    var test: Bool?
    var favoriteDelegate : TweetCellFavoriteDelegate!
    var user: User! {
        didSet {
            nameLabel.text = user.name as? String
            profileImage.setImageWithURL(user.profileUrl!)
            screenNameLabel.text = user.screenname as? String
        }
    }
    var tweet: Tweet! {
        didSet {
            commentLabel.text = tweet.text as? String
            nameLabel.text = tweet.username as? String
            screenNameLabel.text = tweet.screenName as? String
            profileImage.setImageWithURL(tweet.profileImageUrl!)
            timeLabel.text = timeAgoSinceDate(tweet.timestamp, numericDates: true)
            favoritesCountLabel.text = String(tweet.favoritesCount)
            retweetCount.text = String(tweet.retweetCount)
            isFavorited = tweet.favoriteStatus
            idTweet = tweet.idTweet
            
            
            if isFavorited == true {
                favoriteButton.setImage(UIImage(named: "like-action-on-pressed.png"), forState: UIControlState.Normal)
            }else {
                favoriteButton.setImage(UIImage(named: "like-action.png"), forState: UIControlState.Normal)
            }
        }
    }
    
//            thumbImageView.setImageWithURL(business.imageURL!)
//            categorisLabel.text = business.categories
//            addressLabel.text = business.address
//            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
//            ratingImageView.setImageWithURL(business.ratingImageURL!)
//            distanceLabel.text = business.distance
//

    @IBAction func onFavorite(sender: AnyObject) {
        //favoriteDelegate!.favorite!(self)
        favoriteDelegate.favorite!(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = 5
        profileImage.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
