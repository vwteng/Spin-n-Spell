//
//  PlayViewController.swift
//  SpinNSpell
//
//  Created by Joshua Malters on 12/4/15.
//  Copyright © 2015 Vivian. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {
    
    var topic : NSDictionary = NSDictionary()
    
    @IBOutlet weak var arrowUIView: UIImageView!
    @IBOutlet weak var spinUIButton: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var wordHSLayout: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start: UI Setup
        arrowUIView.image = UIImage(named: "arrow")
        spinUIButton.backgroundColor = UIColor.clearColor()
        spinUIButton.layer.cornerRadius = 30
        spinUIButton.layer.borderWidth = 1
        spinUIButton.layer.borderColor = UIColor.blackColor().CGColor
        // Load Topic
        for element in topic {
            let word = element.key as! String
            let imageURL = element.value as! String
            print("Word: \(word)")
            print("URL: \(imageURL)")
            print("")
        }
        // End: UI Setup
    }
}
