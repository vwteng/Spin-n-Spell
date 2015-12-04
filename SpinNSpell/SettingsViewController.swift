//
//  SettingsViewController.swift
//  SpinNSpell
//
//  Created by Conrad Zimney on 12/3/15.
//  Copyright © 2015 Vivian. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func updateData(data: [NSDictionary])
}

class SettingsViewController: UIViewController {
    
    var maxLength = 8
    var sound = true
    var topics = [NSDictionary]()
    var delegate : SettingsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /* Max Word Length */
    @IBOutlet weak var maxWordLength: UILabel!
    @IBOutlet weak var lengthSlider: UISlider!
    
    @IBAction func sliderChanged(sender: UISlider) {
        var currValue = Int(sender.value)
        maxLength = currValue
        maxWordLength.text = "Max Word Length: \(currValue)"
    }
    
    
    /* Sounds */
    @IBOutlet weak var soundSwitch: UISwitch!
    
    @IBAction func switchPressed(sender: UISwitch) {
        if soundSwitch.on {
            sound = true
        } else {
            sound = false
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.delegate?.updateData(self.topics)
        //print("\(topics)")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToJSONSegue" {
            if let vc = segue.destinationViewController as? JSONViewController {
                // will need to pass settings around?
                (segue.destinationViewController as! JSONViewController).delegate = self
                vc.topics = self.topics
            }
        }
    }
    
}

extension SettingsViewController: JSONViewControllerDelegate {
    func updateData(data: [NSDictionary]) {
        self.topics = data
    }
}
