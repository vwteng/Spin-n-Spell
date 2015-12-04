//
//  SettingsViewController.swift
//  SpinNSpell
//
//  Created by Conrad Zimney on 12/3/15.
//  Copyright © 2015 Vivian. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var maxLength = 8
    var sound = true

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
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? ViewController {
            // will need to pass settings around?
        }
    }
    
}
