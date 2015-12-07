//
//  PlayViewController.swift
//  SpinNSpell
//
//  Created by Joshua Malters on 12/4/15.
//  Copyright © 2015 Vivian. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {
    private let letters: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    private var words: [String] = [String]()
    private var currentWord: String = ""
    private var images: [UIImage] = [UIImage]()
    private var lastValue: Int = 0
    
    var topic : NSDictionary = NSDictionary()
    
    var maxLength = Int()
    
    @IBOutlet weak var arrowUIView: UIImageView!
    @IBOutlet weak var spinUIButton: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var wordHSLayout: UIStackView!
    @IBOutlet weak var topKeyStack: UIStackView!
    @IBOutlet weak var bottomKeyStack: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start: UI Setup
        arrowUIView.image = UIImage(named: "arrow")
        spinUIButton.backgroundColor = UIColor.clearColor()
        spinUIButton.layer.cornerRadius = 30
        spinUIButton.layer.borderWidth = 1
        spinUIButton.layer.borderColor = UIColor.blackColor().CGColor
        // *** Load Topics ***
        for item in topic["words"] as! NSDictionary {
            let word = item.key as! String
            if word.characters.count <= maxLength {
                let imageURL = NSURL(string: item.value as! String)
                let data = NSData(contentsOfURL: imageURL!)
                let image = UIImage(data: data!)
                
                images.append(image!)
                words.append(word.uppercaseString)
            }
        }
        // End: UI Setup
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        // SetUp Words
        lastValue = Int(arc4random_uniform(UInt32(images.count)))
        picker.selectRow(lastValue, inComponent: 0, animated: false)
        picker.reloadComponent(0)
        setUpWord(lastValue)
        setUpKeyBoard()
    }
    
    @IBAction func spin(sender: AnyObject) {
        // Disable Spinner clear labels and reset screen
        spinUIButton.enabled = false
        
        // Select new value
        var newValue = Int(arc4random_uniform(UInt32(images.count)))
        while lastValue == newValue {
            newValue = Int(arc4random_uniform(UInt32(images.count)))
        }
        lastValue = newValue
        
        // Set Picker
        picker.selectRow(newValue, inComponent: 0, animated: true)
        picker.reloadComponent(0)
        
        // Set Non-Picker UI
        setUpWord(newValue)
        setUpKeyBoard()
        
        spinUIButton.enabled = true
    }
    
    // Updates the word display area with new value
    private func setUpWord(value: Int) {
        for view in wordHSLayout.subviews {
            wordHSLayout.removeArrangedSubview(view)
        }
        
        let word = words[value]
        currentWord = word
        
        for char in word.characters {
            let label = UILabel()
            label.text = String(char)
            label.textAlignment = .Center
            label.textColor = UIColor.whiteColor()
            wordHSLayout.addArrangedSubview(label)
        }
    }
    
    // Updates the keyboard
    private func setUpKeyBoard() {
        // remove previous keyboard
        for view in topKeyStack.subviews {
            topKeyStack.removeArrangedSubview(view)
        }
        for view in bottomKeyStack.subviews {
            bottomKeyStack.removeArrangedSubview(view)
        }
        
        // create new random options
        var keyboardChars = currentWord
        let curWordLength = currentWord.characters.count
        let lettersLength = UInt32(letters.characters.count)
        for (var i = 0; i < curWordLength; i++) {
            let char = letters.startIndex.advancedBy(Int(arc4random_uniform(lettersLength)))
            keyboardChars.append(letters[char])
        }
        
        // fill out top row
        for (var i = 0; i < curWordLength * 2; i++) {
            let index = Int(arc4random_uniform(UInt32(keyboardChars.characters.count)))
            let char = keyboardChars.startIndex.advancedBy(index)
            
            // Create keyboard key
            let button = UIButton()
            button.setTitle(String(keyboardChars[char]), forState: .Normal)
            button.setTitleColor(UIColor.blueColor(), forState: .Normal)
            button.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.blackColor().CGColor
            
            button.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
            
            if i < curWordLength {
                topKeyStack.addArrangedSubview(button)
            } else {
                bottomKeyStack.addArrangedSubview(button)
            }
            
            keyboardChars.removeAtIndex(char)
        }
        
    }
    
    // Button pressed handler
    func pressed(sender: UIButton!) {
        sender.enabled = false
        let letter = sender.titleLabel?.text!
        
        for view in wordHSLayout.subviews {
            let label = view as! UILabel
            if label.textColor !=  UIColor.blackColor() {
                label.text = letter
                label.textColor = UIColor.blackColor()
                break
            }
        }
    }
    
    // How many selectors we want
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // How many options we need
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       // return topic["words"]!.count
        return words.count
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

