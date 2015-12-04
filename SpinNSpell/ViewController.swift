//
//  ViewController.swift
//  SpinNSpell
//
//  Created by Vivian on 11/30/15.
//  Copyright © 2015 Vivian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var topics : [NSDictionary] = [NSDictionary]()
    
    override func viewDidAppear(animated: Bool) {
        print("\(topics)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(topics)")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToSettingsSegue" {
            if let vc = segue.destinationViewController as? SettingsViewController {
                (segue.destinationViewController as! SettingsViewController).delegate = self
                vc.topics = self.topics
            }
        }
    }
    
}

extension ViewController: SettingsViewControllerDelegate {
    func updateData(data: [NSDictionary]) {
        self.topics = data
    }
}

