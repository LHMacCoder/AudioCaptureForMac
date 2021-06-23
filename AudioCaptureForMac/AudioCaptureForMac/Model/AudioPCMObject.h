//
//  AudioPCMObject.h
//  AudioCaptureForMac
//
//  Created by LHMacCoder on 2021/6/22.
//  Copyright © 2021 LHMacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioPCMObject : NSObject

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, assign) unsigned long long size;
@property (nonatomic, assign) unsigned long long length;

@end

NS_ASSUME_NONNULL_END
