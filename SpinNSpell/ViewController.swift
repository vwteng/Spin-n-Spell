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
    
    var maxLength = 8
    var sound = false
    
    var badges : NSDictionary = [
        "badgeImage": "http://clipartzebraz.com/cliparts/star-clip-art/cliparti1_star-clip-art_03.jpg",
        "initialBadge": "Created a new game",
        "otherBadges": [
            "1": "5 correct words in a row",
            "2": "10 correct words in a row",
            "3": "10 correct words in a game",
            "4": "20 correct words in a game",
            "5": "Guessed all words in a topic",
            "6": "Guessed all words in all topics"
        ]
    ]
    
    // Default Topic to Farm Animals:
    var currentTopic : NSDictionary = [
        "topic": "Farm Animals",
        "startingImage": "http://donate.worldvision.org/media/catalog/product/cache/1/image/310x/9df78eab33525d08d6e5fb8d27136e95/D/4/D4041711_13_Farm_Animals.jpg",
        "words": [
            "Cow": "http://media-2.web.britannica.com/eb-media/11/136111-004-C620AA83.jpg",
            "Pig": "http://dealbreaker.com/uploads/2013/06/pig1_1204022c.jpg",
            "Chicken": "https://timenewsfeed.files.wordpress.com/2013/03/chicken.jpg?w=753",
            "Horse": "http://buzzsharer.com/wp-content/uploads/2015/06/beautiful-running-horse.jpg",
            "Sheep": "https://upload.wikimedia.org/wikipedia/commons/c/c4/Lleyn_sheep.jpg",
            "Rabbit": "http://media.philly.com/images/071514-rabbit-istock-600.jpg"
        ]
    ]

    @IBOutlet weak var currentTopicLabel: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        currentTopicLabel.text = "Current Topic: \(currentTopic["topic"]!)"
        //print("\(topics)")
        print(sound)
        print(maxLength)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTopicLabel.text = "Current Topic: \(currentTopic["topic"]!)"
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
        
        if segue.identifier == "GoToBadgesSegue" {
            if let vc = segue.destinationViewController as? BadgesViewController {
                (segue.destinationViewController as! BadgesViewController).delegate = self
                vc.badges = self.badges
            }
        }
    }
}

extension ViewController: SettingsViewControllerDelegate, ChangeTopicViewControllerDelegate, BadgesViewControllerDelegate {
    func updateData(data: [NSDictionary]) {
        self.topics = data
    }
    func updateCurrentTopic(topic: NSDictionary) {
        self.currentTopic = topic
    }
    func updateSettings(sound: Bool, maxLength: Int) {
        self.sound = sound
        self.maxLength = maxLength
    }
    func updateBadges(badge: NSDictionary) {
        self.badges = badge
    }
}