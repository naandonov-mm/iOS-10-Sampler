//
//  CallManager.swift
//  CallKitSwiftSample
//
//  Created by Nikolay Andonov on 11/15/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

import UIKit
import CallKit
import AVFoundation

private let sharedManager = CallManager.init()

protocol CallManagerDelegate : class {
    
    func callDidAnswer()
    func callDidEnd()
    func callDidHold(isOnHold : Bool)
    func callDidFail()
}

class CallManager: NSObject, CXProviderDelegate {

    var provider : CXProvider?
    var callController : CXCallController?
    var currentCall : UUID?
    
    weak var delegate : CallManagerDelegate?
    
    override init() {
        super.init()
        providerAndControllerSetup()
    }
    
    class var sharedInstance : CallManager {
        return sharedManager
    }
    
    func reportIncomingCallFor(uuid: UUID, phoneNumber: String) {
        
        let update = CXCallUpdate.init()
        update.remoteHandle = CXHandle.init(type: CXHandle.HandleType.phoneNumber, value: phoneNumber)
        weak var weakSelf = self
        provider!.reportNewIncomingCall(with: uuid, update: update, completion: { (error : Error?) in
            print("1")
            if error != nil {
                weakSelf?.delegate?.callDidFail()
                print("2")
            }
            else {
                print("3")
                weakSelf?.currentCall = uuid
            }
            print("4")
        })
    }
    
    func startCallWithPhoneNumber(phoneNumber : String) {
        
        currentCall = UUID.init()
        if let unwrappedCurrentCall = currentCall {
            
        let handle = CXHandle.init(type: CXHandle.HandleType.phoneNumber, value: phoneNumber)
        let startCallAction = CXStartCallAction.init(call: unwrappedCurrentCall, handle: handle)
        let transaction = CXTransaction.init()
        transaction.addAction(startCallAction)
        requestTransaction(transaction: transaction)
        }
    }
    
    func endCall() {
        
        if let unwrappedCurrentCall = currentCall {
            
        let endCallAction = CXEndCallAction.init(call: unwrappedCurrentCall)
        let transaction = CXTransaction.init()
        transaction.addAction(endCallAction)
        requestTransaction(transaction: transaction)
        }
    }
    
    func holdCall(hold : Bool) {
        
        if let unwrappedCurrentCall = currentCall {
            
            let holdCallAction = CXSetHeldCallAction.init(call: unwrappedCurrentCall, onHold: hold)
            let transaction = CXTransaction.init()
            transaction.addAction(holdCallAction)
            requestTransaction(transaction: transaction)
        }
    }
    
    func requestTransaction(transaction : CXTransaction) {
        
        weak var weakSelf = self
        callController?.request(transaction, completion: { (error : Error?) in
            
            if error != nil {
                print("\(error?.localizedDescription)")
                weakSelf?.delegate?.callDidFail()
            }
        })
    }
    
    //MARK: - Setup
    
    func providerAndControllerSetup() {
        
        let configuration = CXProviderConfiguration.init(localizedName: "CallKit")
        configuration.supportsVideo = true
        configuration.maximumCallsPerCallGroup = 1;
        configuration.supportedHandleTypes = [CXHandle.HandleType.phoneNumber]
        provider = CXProvider.init(configuration: configuration)
        provider?.setDelegate(self, queue: nil)
        
        callController = CXCallController.init()
    }
    
    //MARK : - CXProviderDelegate
    
    // Called when the provider has been fully created and is ready to send actions and receive updates
    func providerDidReset(_ provider: CXProvider) {
    }
    
    // If provider:executeTransaction:error: returned NO, each perform*CallAction method is called sequentially for each action in the transaction
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        
        //todo: configure audio session
        //todo: start network call
        provider.reportOutgoingCall(with: action.callUUID, startedConnectingAt: nil)
        provider.reportOutgoingCall(with: action.callUUID, connectedAt: nil)
        delegate?.callDidAnswer()
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        
        //todo: configure audio session
        //todo: answer network call
        delegate?.callDidAnswer()
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        //todo: configure audio session
        //todo: answer network call
        currentCall = nil
        delegate?.callDidEnd()
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        
        if action.isOnHold {
            //todo: stop audio
        } else {
            //todo: start audio
        }
        
        delegate?.callDidHold(isOnHold: action.isOnHold)
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetGroupCallAction) {
    }
    
    func provider(_ provider: CXProvider, perform action: CXPlayDTMFCallAction) {
    }
    
    // Called when an action was not performed in time and has been inherently failed. Depending on the action, this timeout may also force the call to end. An action that has already timed out should not be fulfilled or failed by the provider delegate
    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        // React to the action timeout if necessary, such as showing an error UI.
    }
    
    /// Called when the provider's audio session activation state changes.
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        //todo: start audio
        // Start call audio media, now that the audio session has been activated after having its priority boosted.
    }
    
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        /*
         Restart any non-call related audio now that the app's audio session has been
         de-activated after having its priority restored to normal.
         */  
    }
}
