//
//  ComposeViewController.swift
//  Twitter
//
//  Created by mac on 3/26/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var imageUrl: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var txtTest: UITextField!
    
    var user : User!
    override func viewDidLoad() {
        super.viewDidLoad()
        TwitterClient.sharedInstance.currentAccount({(user: User) in
            self.user = user
            self.txtView.text = ""
            self.name.text = user.name as? String
            self.screenName.text = user.screenname as? String
            self.imageUrl.setImageWithURL(user.profileUrl!)
            
            
            
            print("User name: \(user.name!)")
            print("Screen name: \(user.screenname!)")
            print("Profile url: \(user.profileUrl!)")
            
            
        }) { (error: NSError) -> () in
            print(error.localizedDescription)
        }
        
    }

    
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func composeTweet(sender: AnyObject) {
        let textView = txtView.text
        let param : [String: AnyObject] = ["status" : textView]
        TwitterClient.sharedInstance.updateTweet(param, success: { (tweets: Tweet?) in
            
        }) { (error: NSError) in
                print(error.localizedDescription)
        }
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
