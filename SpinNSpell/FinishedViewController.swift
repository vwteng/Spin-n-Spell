//
//  FinishedViewController.swift
//  SpinNSpell
//
//  Created by Conrad Zimney on 12/9/15.
//  Copyright © 2015 Vivian. All rights reserved.
//

import UIKit

class FinishedViewController: UIViewController {

    var topic : NSDictionary = NSDictionary()
    var topics = [NSDictionary]()
    
    var maxLength = Int()
    var sound = Bool()
    
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        viewButton.layer.cornerRadius = 5
        viewButton.layer.borderWidth = 1
        viewButton.layer.borderColor = UIColor.blackColor().CGColor
        returnButton.layer.cornerRadius = 5
        returnButton.layer.borderWidth = 1
        returnButton.layer.borderColor = UIColor.blackColor().CGColor
        navigationController!.setNavigationBarHidden(false, animated:true)
        let infoButton:UIButton = UIButton(type: UIButtonType.Custom) as UIButton
        infoButton.addTarget(self, action: "GoToInfoSegue", forControlEvents: UIControlEvents.TouchUpInside)
        infoButton.setTitle("Help", forState: UIControlState.Normal)
        infoButton.sizeToFit()
        infoButton.setTitleColor(UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.9), forState: UIControlState.Normal)
        let myCustomInfoButtonItem:UIBarButtonItem = UIBarButtonItem(customView: infoButton)
        self.navigationItem.rightBarButtonItem = myCustomInfoButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToHomeSegue" {
            if let vc = segue.destinationViewController as? ViewController {
                vc.currentTopic = self.topic
                vc.maxLength = self.maxLength
                vc.sound = self.sound
                vc.topics = self.topics
            }
        }
    }
    
}
