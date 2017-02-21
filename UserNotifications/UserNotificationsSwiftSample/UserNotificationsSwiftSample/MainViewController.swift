//
//  MainViewController.swift
//  UserNotificationsSwiftSample
//
//  Created by Nikolay Andonov on 11/9/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func scheduleButtonAction(_ sender: Any) {
        
        let selectedDate = datePicker.date
        print("Selected date: \(selectedDate)")
        UserNotificationsHandler.sharedHandler.scheduleNotification(at: selectedDate)
        
        let alert = UIAlertController(title: nil, message: "The reminder was schedule!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
