//
//  IntentHandler.m
//  SiriKitExtension
//
//  Created by Dobrinka Tabakova on 12/5/16.
//  Copyright © 2016 Dobrinka Tabakova. All rights reserved.
//

#import "IntentHandler.h"
#import "PhotosProvider.h"


@interface IntentHandler () <INSearchForPhotosIntentHandling>

@end

@implementation IntentHandler

- (id)handlerForIntent:(INIntent *)intent {
    // This is the default implementation.  If you want different objects to handle different intents,
    // you can override this and return the handler you want for that particular intent.
    
    return self;
}

- (void)handleSearchForPhotos:(INSearchForPhotosIntent *)intent completion:(void (^)(INSearchForPhotosIntentResponse * _Nonnull))completion {
    NSLog(@"%@", intent.searchTerms);
    NSLog(@"%@", intent.albumName);
    
    BOOL hasResult = NO;
    if (intent.searchTerms.count) {
        NSString *searchTerm = intent.searchTerms.firstObject;
        if (searchTerm) {
            hasResult = [[PhotosProvider sharedInstance] containsPhotoForSearchTerm:searchTerm];
        }
    }
    
    INSearchForPhotosIntentResponse *response;
    if (hasResult) {
        NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:@"INSearchForPhotosIntent"];
        userActivity.userInfo = @{@"searchTerm":intent.searchTerms.firstObject};
        response = [[INSearchForPhotosIntentResponse alloc] initWithCode:INSearchForPhotosIntentResponseCodeContinueInApp userActivity:userActivity];
    } else {
        response = [[INSearchForPhotosIntentResponse alloc] initWithCode:INSearchForPhotosIntentResponseCodeFailure userActivity:nil];

    }
    completion(response);
}

@end


