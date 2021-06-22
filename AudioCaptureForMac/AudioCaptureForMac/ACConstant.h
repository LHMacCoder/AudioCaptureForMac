//
//  ACConstant.h
//  AudioCaptureForMac
//
//  Created by Tenorshare_Lin on 2021/6/22.
//  Copyright © 2021 LHMacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDL2/SDL.h>

// 采样率
#define SAMPLE_RATE 44100
// 采样格式
#define SAMPLE_FORMAT AUDIO_F32LSB
// 采样大小
#define SAMPLE_SIZE SDL_AUDIO_BITSIZE(SAMPLE_FORMAT)
// 声道数
#define CHANNELS 2
// 音频缓冲区的样本数量
#define SAMPLES 1024
// 每个样本占用多少个字节
#define BYTES_PER_SAMPLE ((SAMPLE_SIZE * CHANNELS) / 8)
// 文件缓冲区的大小
#define BUFFER_SIZE (SAMPLES * BYTES_PER_SAMPLE)
