//
//  CallViewController.swift
//  CallKitSwiftSample
//
//  Created by Nikolay Andonov on 11/15/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

import UIKit

class CallViewController: UIViewController, CallManagerDelegate {

    var phoneNumber : String?
    var uuid : UUID?
    var isIncoming = false
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var callerLabel: UILabel!
    @IBOutlet weak var holdButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    
    var timeFormatter : DateComponentsFormatter?
    var callDurationTimer : Timer?
    var callDuration : TimeInterval?
    
    private var isOnHold = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        callerLabel.text = phoneNumber
        setupTimeFormatter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if phoneNumber != nil {
            CallManager.sharedInstance.delegate = self
            if isIncoming {
                
                weak var weakSelf = self
                let deadlineTime = DispatchTime.now() + .seconds(2)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                    weakSelf?.performCall()
                })
            }
            else {
                if let unwrappedPhoneNumber = phoneNumber {
                    CallManager.sharedInstance.startCallWithPhoneNumber(phoneNumber: unwrappedPhoneNumber)
                }
            }
        }
    }
    
    func setupTimeFormatter() {
        timeFormatter = DateComponentsFormatter.init()
        timeFormatter?.unitsStyle = DateComponentsFormatter.UnitsStyle.positional
        timeFormatter?.zeroFormattingBehavior = DateComponentsFormatter.ZeroFormattingBehavior.pad
        timeFormatter?.allowedUnits = [.minute, .second]
    }

    // MARK: - Actions
    
    @IBAction func endButtonTapepd(_ sender: Any) {
        
        CallManager.sharedInstance.endCall()
    }
    
    @IBAction func holdButtonTapped(_ sender: Any) {
        
        isOnHold = !isOnHold
        let title = isOnHold ? "RESUME" : "HOLD"
        holdButton.setTitle(title, for: .normal)
        CallManager.sharedInstance.holdCall(hold: isOnHold)
    }

    // MARK: - CallManagerDelegate

    func callDidAnswer() {
        
        timeLabel.isHidden = false
        holdButton.isHidden = false
        endButton.isHidden = false
        infoLabel.text = "Active"
        startTimer()
    }
    
    func callDidEnd() {
        
        callDurationTimer?.invalidate()
        callDurationTimer = nil
        holdButton.isHidden = true
        endButton.isHidden = true
        infoLabel.text = "Ended"
        dismiss()
    }
    
    func callDidHold(isOnHold: Bool) {
        
        if isOnHold {
            
            callDurationTimer?.invalidate()
            callDurationTimer = nil
            holdButton.setTitle("RESUME", for: .normal)
            infoLabel.text = "On Hold"
        }
        else {
         
            startTimer()
            holdButton.setTitle("HOLD", for: .normal)
            infoLabel.text = "Active"
        }
    }
    
    func callDidFail() {
        
        callDurationTimer?.invalidate()
        callDurationTimer = nil
        infoLabel.text = "Failed"
        dismiss()
    }
    
    // MARK: - Utilities
    
    private func performCall() {
        
        if let unwrappedUUID = uuid, let unwrapepdPhoneNumber = phoneNumber {
        
        CallManager.sharedInstance.reportIncomingCallFor(uuid: unwrappedUUID, phoneNumber: unwrapepdPhoneNumber)
        }
    }

    private func dismiss() {
        
        dismiss(animated: true, completion: nil)
    }
    
    private func startTimer() {
        
        weak var weakSelf = self
        callDurationTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer : Timer) in
            
            if weakSelf?.callDuration != nil {
            weakSelf?.callDuration = TimeInterval((weakSelf?.callDuration)! + 1)
            weakSelf?.timeLabel.text = weakSelf?.timeFormatter?.string(from: (weakSelf?.callDuration)!)
            }
        })
    }

}
