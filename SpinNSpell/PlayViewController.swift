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
    private var words: [String] = [String]()
    private var images: [UIImage] = [UIImage]()
    private var currentRow:Int = 0
    
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
        for item in topic["words"] as! NSDictionary {
            let word = item.key as! String
            let imageURL = NSURL(string: item.value as! String)
            let data = NSData(contentsOfURL: imageURL!)
            let image = UIImage(data: data!)
            
            images.append(image!)
            words.append(word)
        }
        // End: UI Setup
    }
    
    // How many selectors we want
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // How many options we need
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return topic["words"]!.count
    }
    
    // What each row will show
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let image = images[row]
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: picker.frame.width, height: picker.frame.height)
        imageView.contentMode = .ScaleAspectFit
        
        return imageView
    }
    
    // Size of each Row
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return picker.frame.height
    }
}

