//
//  HambrgerViewController.swift
//  Twitter
//
//  Created by mac on 4/1/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class HambrgerViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    var originalLeftMargin: CGFloat!
    var tweetMenuViewController : UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(tweetMenuViewController.view)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
