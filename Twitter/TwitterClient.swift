//
//  TwitterClient.swift
//  Twitter
//
//  Created by mac on 3/24/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "QnNPAni2N2wJrD05vOM3fdCI4", consumerSecret: "HjgJ0nzCw2pl6mhIud3I4i6tQQU4b0pR0OEJyhZgisIG0Fm5RT")
    
    var loginSuccess : (() -> ())?
    var loginFailure : ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        self.loginSuccess = success
        self.loginFailure = failure
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo1://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            }) {(error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    
    
    func handleOpenUrl (url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                }, failure:{ (error: NSError) -> () in
                    (self.loginFailure?(error))!
            })
            
            
//            print("I got the access token!")
//            
//            client.homeTimeLine({ (tweets: [Tweet]) -> () in
//                for tweet in tweets {
//                    print(tweet.text)
//                }
//                }, failure: { (error: NSError) -> () in
//                    print(error.localizedDescription)
//            })
//            client.currentAccount()
//            
//            
            
            
            }) {(error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    func updateTweet(params: NSDictionary?,success: (Tweet?) -> (), failure: (NSError) -> ()) {
        POST("1.1/statuses/update.json", parameters: params, progress: nil, success: {(task: NSURLSessionDataTask, response: AnyObject?)-> Void in
            
            }, failure: {(task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func homeTimeLine(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: {(task: NSURLSessionDataTask, response: AnyObject?)-> Void in
            
            let dictionaries  = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            
            success(tweets)
//            for tweet in tweets {
//                print("Text : \(tweet.text)!")
//                //print("Location : \(tweet["user"]!["location"]!)")
//            }
            
            //print("\(response!)")
            
            }, failure: {(task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()){
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: {(task: NSURLSessionDataTask, response: AnyObject?)-> Void in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            //print("\(response!)")
            //print ("user: \(user)")
//            print ("name: \(user.name)")
//            print ("screen name: \(user.screenname)")
//            print ("Profile Image: \(user.profileUrl)")
//            print ("Description: \(user.tagline)")
            //print("Screen name: \(user["screen_name"]!)")
            
            
            }, failure: {(task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })

    }
    
    func favoriteTweet(idTweet: NSNumber?, success: (AnyObject?) -> (), failure: (NSError) -> ()) {
        var parameters = [String : AnyObject]()
        
        if idTweet != nil {
            parameters["id"] = idTweet
        }
        
        POST("1.1/favorites/create.json", parameters: parameters, progress: nil, success: { (task: NSURLSessionTask, response: AnyObject?) -> Void in
            success(response)
            
            }, failure: { (task: NSURLSessionTask?, error: NSError) -> Void in
                failure(error)
        })
        
    }
    
    func deFavoriteTweet(idTweet: NSNumber?, success: (AnyObject?) -> (), failure: (NSError) -> ()) {
        var parameters = [String : AnyObject]()
        
        if idTweet != nil {
            parameters["id"] = idTweet
        }
        
        POST("1.1/favorites/destroy.json", parameters: parameters, progress: nil, success: { (task: NSURLSessionTask, response: AnyObject?) -> Void in
            success(response)
            
            }, failure: { (task: NSURLSessionTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
}
