//
//  FFmpegRecord.h
//  AudioCaptureForMac
//
//  Created by Tenorshare_Lin on 2021/6/22.
//  Copyright © 2021 LHMacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

extern "C" {
    // 设备相关API
#include <libavdevice/avdevice.h>
    // 格式相关API
#include <libavformat/avformat.h>
    // 工具相关API（比如错误处理）
#include <libavutil/avutil.h>
    // 编码相关API
#include <libavcodec/avcodec.h>
}

@interface FFmpegRecord : NSObject

/// 程序生命周期内只需注册一次
- (void)avdeviceRegisterAll;

- (void)startRecord;
- (NSString *)stopRecord;

@end
