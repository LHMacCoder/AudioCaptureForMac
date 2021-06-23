//
//  PlayerViewController.h
//  AudioCaptureForMac
//
//  Created by LHMacCoder on 2021/6/22.
//  Copyright © 2021 LHMacCoder. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayerViewController : NSViewController

@property (nonatomic, copy) NSArray *files;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

NS_ASSUME_NONNULL_END
