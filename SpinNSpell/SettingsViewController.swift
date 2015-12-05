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
    func updateSettings(sound: Bool, maxLength: Int)
}

class SettingsViewController: UIViewController {
    
    var maxLength = 8
    var sound = true
    var topics = [NSDictionary]()
    var delegate : SettingsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /* Max Word Length */
    @IBOutlet weak var maxWordLength: UILabel!
    @IBOutlet weak var lengthSlider: UISlider!
    
    @IBAction func sliderChanged(sender: UISlider) {
        var currValue = Int(sender.value)
        maxLength = currValue
        maxWordLength.text = "Max Word Length: \(currValue)"
        self.delegate?.updateSettings(sound, maxLength: maxLength)
    }
    
    
    /* Sounds */
    @IBOutlet weak var soundSwitch: UISwitch!
    
    @IBAction func switchPressed(sender: UISwitch) {
        if soundSwitch.on {
            sound = true
        } else {
            sound = false
        }
        self.delegate?.updateSettings(sound, maxLength: maxLength)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.delegate?.updateData(self.topics)
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
