//
//  FinishedViewController.swift
//  SpinNSpell
//
//  Created by Conrad Zimney on 12/9/15.
//  Copyright © 2015 Vivian. All rights reserved.
//

import UIKit

class FinishedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        
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
    
}
