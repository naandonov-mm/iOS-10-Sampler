//
//  IntentHandler.swift
//  SiriKitExtension
//
//  Created by Nikolay Andonov on 12/8/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

import Intents

class IntentHandler: INExtension, INSearchForPhotosIntentHandling {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
    
    // MARK: - INSearchForPhotosIntentHandling
    
    func handle(searchForPhotos intent: INSearchForPhotosIntent, completion: @escaping (INSearchForPhotosIntentResponse) -> Void) {
        
        print(intent.searchTerms ?? "")
        print(intent.albumName ?? "")
        
        var hasResult = false
        if (intent.searchTerms?.count)! > 0 {
            if let searchTerm = intent.searchTerms?.first {
                hasResult = PhotosProvider.sharedInstance.containsPhotoForSearchTerm(term: searchTerm)
            }
        }
        
        var response : INSearchForPhotosIntentResponse
        if hasResult {
            let userActivity = NSUserActivity.init(activityType: "INSearchForPhotosIntent")
            if let firstSerchTerm = intent.searchTerms?.first {
                userActivity.userInfo = ["searchterm" : firstSerchTerm]
            }
            response = INSearchForPhotosIntentResponse.init(code: .continueInApp, userActivity: userActivity)
        }
        else {
            response = INSearchForPhotosIntentResponse.init(code: .failure, userActivity: nil)
        }
        
        completion(response);        
    }

}

