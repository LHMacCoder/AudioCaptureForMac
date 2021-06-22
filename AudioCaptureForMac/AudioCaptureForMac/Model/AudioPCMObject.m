//
//  AudioPCMObject.m
//  AudioCaptureForMac
//
//  Created by Tenorshare_Lin on 2021/6/22.
//  Copyright © 2021 LHMacCoder. All rights reserved.
//

#import "AudioPCMObject.h"

@implementation AudioPCMObject

- (unsigned long long)length {
    return _size / BYTES_PER_SAMPLE / SAMPLE_RATE;
}

@end
