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
    
    private var spinSound: SystemSoundID = 0
    private var correctSound: SystemSoundID = 0
    
    private var numCorrect: Int = 0
    private var numCorrectConsecutive: Int = 0
    
    var topic : NSDictionary = NSDictionary()
    
    var maxLength = Int()
    var sound = Bool()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var arrowUIView: UIImageView!
    @IBOutlet weak var spinUIButton: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var wordHSLayout: UIStackView!
    @IBOutlet weak var topKeyStack: UIStackView!
    @IBOutlet weak var bottomKeyStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
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
                    
                    let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
                    
                    /* Create session, and optionally set a NSURLSessionDelegate. */
                    let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
                    
                    let URL = NSURL(string: item.value as! String)
                    let request = NSMutableURLRequest(URL: URL!)
                    request.HTTPMethod = "GET"
                    
                    /* Start a new Task */
                    let task = session.dataTaskWithRequest(request, completionHandler: { (data : NSData?, response : NSURLResponse?, error : NSError?) -> Void in
                        if (error == nil) { // Success
                            let statusCode = (response as! NSHTTPURLResponse).statusCode
                            print("URL Session Task Succeeded: HTTP \(statusCode)")
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                let image = UIImage(data: data!)
                                self.images.append(image!)
                                self.words.append(word.uppercaseString)
                                if self.images.count == self.topic["words"]!.count {
                                    // load picker in here
                                    self.activityIndicator.hidesWhenStopped = true
                                    self.activityIndicator.stopAnimating()
                                    self.picker.reloadAllComponents()
                                }
                                
                            })
                        }
                        else { // Failure
                            print("URL Session Task Failed: %@", error!.localizedDescription);
                        }
                    })
                    task.resume()
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
        picker.reloadAllComponents()
        picker.selectRow(lastValue, inComponent: 0, animated: false)
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
        picker.reloadAllComponents()
        picker.selectRow(newValue, inComponent: 0, animated: true)
        
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
            
            let showSecondAlertCorrect = secondAlertCorrect()
            let showSecondAlertConsecutive = secondAlertConsecutive()
            
            if words.count >= 1 {
                if showSecondAlertCorrect == false && showSecondAlertConsecutive == false {
                    self.presentViewController(showAlert(alertTitle, alertMsg: alertMsg, alertDismiss: alertDismiss), animated: true, completion: nil)
                } else if showSecondAlertCorrect {
                    alertTitle = "New Badge!"
                    alertMsg = "You spelled \(numCorrect) words correct"
                    
                    if badges.contains(alertMsg) == false {
                        self.presentViewController(showAlert(alertTitle, alertMsg: alertMsg, alertDismiss: alertDismiss), animated: true, completion: nil)
                    
                        badges.insert(alertMsg, atIndex: badgeIndexCount)
                        badgeIndexCount++
                    } else {
                        self.presentViewController(showAlert(alertTitle, alertMsg: alertMsg, alertDismiss: alertDismiss), animated: true, completion: nil)
                    }
                } else if showSecondAlertConsecutive {
                    alertTitle = "New Badge!"
                    alertMsg = "You spelled \(numCorrectConsecutive) words correct in a row"
                    
                    if badges.contains(alertMsg) == false {
                        self.presentViewController(showAlert(alertTitle, alertMsg: alertMsg, alertDismiss: alertDismiss), animated: true, completion: nil)

                        badges.insert(alertMsg, atIndex: badgeIndexCount)
                        badgeIndexCount++
                    } else {
                        self.presentViewController(showAlert(alertTitle, alertMsg: alertMsg, alertDismiss: alertDismiss), animated: true, completion: nil)
                    }
                }
            } else {
                performSegueWithIdentifier("GoToFinishedSegue", sender: nil)
            }
        }
    }
    
    // Display an alert
    func showAlert(alertTitle: String, alertMsg: String, alertDismiss: String) -> UIAlertController {
        let alert = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: alertDismiss, style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.spin(self)
        }))
        return alert
    }
    
    // Check if a badge has been earned for a certain number of words correct
    func secondAlertCorrect() -> Bool {
        return numCorrect == 2 || numCorrect == 10 || numCorrect == 20
    }
    
    // Check if a badge has been earned for a certain number of words consecutively correct
    func secondAlertConsecutive() -> Bool {
        return numCorrectConsecutive == 3 || numCorrectConsecutive == 10
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
        // something in here is wrong... it is loading the wrong word with the wrong image 
        var imageView = UIImageView()
        if self.images.count != 0 {
            let image = images[row]
            imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: picker.frame.width, height: picker.frame.height)
            imageView.contentMode = .ScaleAspectFit
            return imageView
        }
        return imageView
    }
    
    // Size of each Row
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return picker.frame.height
    }
}

