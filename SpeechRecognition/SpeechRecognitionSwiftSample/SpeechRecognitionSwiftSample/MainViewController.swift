//
//  MainViewController.swift
//  SpeechRecognitionSwiftSample
//
//  Created by nikolay.andonov on 10/31/16.
//  Copyright © 2016 nikolay.andonov. All rights reserved.
//

import UIKit
import Speech

class MainViewController: UIViewController, SFSpeechRecognizerDelegate {

    private var speechRecognizer: SFSpeechRecognizer!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest!
    private var recognitionTask: SFSpeechRecognitionTask!
    private let audioEngine = AVAudioEngine()
    // Locale Settings can be custommized for speech recognition supporting different languages
    private let defaultLocale = Locale(identifier: "en-US")
    
    @IBOutlet private weak var textView : UITextView!
    @IBOutlet private weak var recordBtn : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareSpeechRecognizer(locale: defaultLocale)
    }
    
    private func prepareSpeechRecognizer(locale: Locale) {
        
        speechRecognizer = SFSpeechRecognizer(locale: locale)!
        speechRecognizer.delegate = self
        
        weak var weakSelf = self
        SFSpeechRecognizer.requestAuthorization { authStatus in
            
            //The callback may not be called on the main thread.
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    weakSelf?.recordBtn.isEnabled = true
                    
                case .denied:
                    weakSelf?.recordBtn.isEnabled = false
                    weakSelf?.recordBtn.setTitle("User denied access to speech recognition", for: .disabled)
                    
                case .restricted:
                    weakSelf?.recordBtn.isEnabled = false
                    weakSelf?.recordBtn.setTitle("Speech recognition restricted on this device", for: .disabled)
                    
                case .notDetermined:
                    weakSelf?.recordBtn.isEnabled = false
                    weakSelf?.recordBtn.setTitle("Speech recognition not yet authorized", for: .disabled)
                }
            }
        }
    }
    
    private func startRecording() throws {
        
        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object")
        }
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        weak var weakSelf = self
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            
            OperationQueue.main.addOperation {
                
                var isFinal = false
                
                if let result = result {
                    weakSelf?.textView.text = result.bestTranscription.formattedString
                    isFinal = result.isFinal
                }
                
                if error != nil || isFinal {
                    weakSelf?.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    
                    weakSelf?.recognitionRequest = nil
                    weakSelf?.recognitionTask = nil
                    
                    weakSelf?.recordBtn.isEnabled = true
                    weakSelf?.recordBtn.setTitle("Start Recording", for: [])
                }
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            weakSelf?.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        textView.text = "(listening...)"
    }
    
    // MARK: - SFSpeechRecognizerDelegate
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        
        if available {
            recordBtn.isEnabled = true
            recordBtn.setTitle("Start Recording", for: [])
        } else {
            recordBtn.isEnabled = false
            recordBtn.setTitle("Recognition not available", for: .disabled)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func recordBtnTapped() {
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordBtn.isEnabled = false
        } else {
            try! startRecording()
            recordBtn.setTitle("Stop recording", for: [])
        }
    }


    


}
