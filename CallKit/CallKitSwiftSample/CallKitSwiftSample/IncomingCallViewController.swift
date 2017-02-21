//
//  IncomingCallViewController.swift
//  CallKitSwiftSample
//
//  Created by Nikolay Andonov on 11/15/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

import UIKit

class IncomingCallViewController: UIViewController {
    
    private let kTitle = "Incomming Call"
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var simualteCallButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = kTitle
    }

    // MARK: - Actions
    @IBAction func phoneNumberValueChanged(_ sender: UITextField) {
        
        let phoneNumber = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        simualteCallButton.isEnabled = (phoneNumber?.characters.count)! > 0
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowCall" {
            let callViewController = segue.destination as! CallViewController
            callViewController.phoneNumber = phoneNumberTextField.text
            callViewController.isIncoming = true
            callViewController.uuid = UUID.init()
        }
    }
}
