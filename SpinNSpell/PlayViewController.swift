//
//  PlayViewController.swift
//  SpinNSpell
//
//  Created by Joshua Malters on 12/4/15.
//  Copyright © 2015 Vivian. All rights reserved.
//

import UIKit
import AudioToolbox

class PlayViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    private let letters: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    private var words: [String] = [String]()
    private var currentWord: String = ""
    private var speltWord: String = ""
    private var images: [UIImage] = [UIImage]()
    private var lastValue: Int = 0
    
    private var numCorrect: Int = 0
    private var numCorrectConsecutive: Int = 0
    
    private var spinSound: SystemSoundID = 0
    private var correctSound: SystemSoundID = 0
    
    var topic : NSDictionary = NSDictionary()
    
    var maxLength = Int()
    var sound = Bool()
    
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
        
        navigationController!.setNavigationBarHidden(false, animated:true)
        let infoButton:UIButton = UIButton(type: UIButtonType.Custom) as UIButton
        infoButton.addTarget(self, action: "GoToInfoSegue", forControlEvents: UIControlEvents.TouchUpInside)
        infoButton.setTitle("Help", forState: UIControlState.Normal)
        infoButton.sizeToFit()
        infoButton.setTitleColor(UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.9), forState: UIControlState.Normal)
        let myCustomInfoButtonItem:UIBarButtonItem = UIBarButtonItem(customView: infoButton)
        self.navigationItem.rightBarButtonItem = myCustomInfoButtonItem
        // End: UI Setup
    }
    
    func GoToInfoSegue() {
        self.performSegueWithIdentifier("GoToInfo", sender: nil)
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
        speltWord = ""
        
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
        
        // Play audio
        if sound {
            let soundURL = NSBundle.mainBundle().URLForResource("crunch", withExtension: "wav")! as CFURLRef
            AudioServicesCreateSystemSoundID(soundURL, &spinSound)
            
            AudioServicesPlaySystemSound(spinSound)
        }
    }
    
    // Updates the word display area with new value
    private func setUpWord(value: Int) {
        for view in wordHSLayout.subviews{
            view.removeFromSuperview()
        }
        
        let word = words[value]
        currentWord = word
        
        for char in word.characters {
            let label = UILabel()
            label.text = String(char)
            label.textAlignment = .Center
            label.textColor = UIColor.greenColor()
            wordHSLayout.addArrangedSubview(label)
        }
    }
    
    // Updates the keyboard
    private func setUpKeyBoard() {
        // remove previous keyboard
        for view in topKeyStack.subviews{
            view.removeFromSuperview()
        }
        for view in bottomKeyStack.subviews{
            view.removeFromSuperview()
        }
        
        // create new random options
        var keyboardChars = generateKeyOptions()
        
        // fill out top row
        for (var i = 0; i < currentWord.characters.count * 2; i++) {
            let index = Int(arc4random_uniform(UInt32(keyboardChars.characters.count)))
            let char = keyboardChars.startIndex.advancedBy(index)
            
            // Create keyboard key
            let button = createKeyboardButtonWithLetter(String(keyboardChars[char]))
            button.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
            
            if i < currentWord.characters.count {
                topKeyStack.addArrangedSubview(button)
            } else {
                bottomKeyStack.addArrangedSubview(button)
            }
            
            keyboardChars.removeAtIndex(char)
        }
    }
    
    private func generateKeyOptions() -> String {
        var keyboardChars = currentWord
        let curWordLength = currentWord.characters.count
        let lettersLength = UInt32(letters.characters.count)
        for (var i = 0; i < curWordLength; i++) {
            let char = letters.startIndex.advancedBy(Int(arc4random_uniform(lettersLength)))
            keyboardChars.append(letters[char])
        }
        return keyboardChars
    }
    
    private func createKeyboardButtonWithLetter(letter: String) -> UIButton {
        let button = UIButton()
        button.setTitle(letter, forState: .Normal)
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        button.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        button.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blackColor().CGColor
        return button
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
                speltWord += letter!
                break
            }
        }
        
        if speltWord.characters.count == currentWord.characters.count {
            var alertTitle = ""
            var alertMsg = ""
            var alertDismiss = ""
            
            if speltWord == currentWord {
                alertTitle = "Nice Job!"
                alertMsg = "You spelled the word right!"
                alertDismiss = "Next Word"
                
                words.removeAtIndex(lastValue)
                images.removeAtIndex(lastValue)
                
                numCorrect++
                numCorrectConsecutive++
                
                if sound {
                    let soundURL = NSBundle.mainBundle().URLForResource("hit", withExtension: "wav")! as CFURLRef
                    AudioServicesCreateSystemSoundID(soundURL, &correctSound)
                    
                    AudioServicesPlaySystemSound(correctSound)
                }
                
            } else {
                alertTitle = "Uh Oh..."
                alertMsg = "Thats not how you spell the word!"
                alertDismiss = "Try Again"
                
                numCorrectConsecutive = 0
            }
            
            let alert = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: alertDismiss, style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func earnBadge () {
        let alertTitle = "New Badge!"
        var alertMsg = ""
        let alertDismiss = "Continue"
        
        if numCorrect == 10 {
            alertMsg = "You spelled 5 words correct!"
        }
        
        if numCorrect == 20 {
            alertMsg = "You spelled 10 words correct!"
        }
        
        if numCorrectConsecutive == 5 {
            alertMsg = "You spelled 5 words correct in a row!"
        }
        
        if numCorrectConsecutive == 10 {
            alertMsg = "You spelled 5 words correct in a row!"
        }
        
        let alert = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: alertDismiss, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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

