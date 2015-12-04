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
    var currentTopic : NSDictionary = NSDictionary()
    
    @IBOutlet weak var currentTopicLabel: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        currentTopicLabel.text = "Current Topic: \(currentTopic["topic"])"
        print("\(topics)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTopicLabel.text = "Current Topic: \(currentTopic["topic"])"
        print("\(topics)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToSettingsSegue" {
            if let vc = segue.destinationViewController as? SettingsViewController {
                (segue.destinationViewController as! SettingsViewController).delegate = self
                vc.topics = self.topics
            }
        }
        if segue.identifier == "GoToPlaySegue" {
            if let vc = segue.destinationViewController as? PlayViewController {
                vc.topic = self.currentTopic
            }
        }
        if segue.identifier == "GoToChangeSegue" {
            if let vc = segue.destinationViewController as? ChangeTopicViewController {
                (segue.destinationViewController as! ChangeTopicViewController).delegate = self
                vc.topics = self.topics
            }
        }
        
    }
    
    
    
}

extension ViewController: SettingsViewControllerDelegate, ChangeTopicViewControllerDelegate {
    func updateData(data: [NSDictionary]) {
        self.topics = data
    }
    func updateCurrentTopic(topic: NSDictionary) {
        self.currentTopic = topic
    }
}



