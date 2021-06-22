//
//  AppDelegate.m
//  AudioCaptureForMac
//
//  Created by Tenorshare_Lin on 2021/6/22.
//  Copyright © 2021 LHMacCoder. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        
    } else if(authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSAlert *alert = [NSAlert new];
            [alert addButtonWithTitle:@"OK"];
            [alert setMessageText:@"AVAuthorizationStatusDenied"];
            [alert setAlertStyle:NSAlertStyleWarning];
            alert.icon = [NSImage imageNamed:@"NSInfo"];
            [alert runModal];
        });
    } else if(authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (!granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSAlert *alert = [NSAlert new];
                    [alert addButtonWithTitle:@"OK"];
                    [alert setMessageText:@"AVAuthorizationStatusNotDetermined"];
                    [alert setAlertStyle:NSAlertStyleWarning];
                    alert.icon = [NSImage imageNamed:@"NSInfo"];
                    [alert runModal];
                });
            }
        }];
    } else {
        
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}


@end
