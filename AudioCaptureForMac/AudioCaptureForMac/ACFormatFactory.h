//
//  ACFormatFactory.h
//  AudioCaptureForMac
//
//  Created by LHMacCoder on 2021/6/25.
//  Copyright © 2021 LHMacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AUDIO_FORMAT_PCM 1
#define AUDIO_FORMAT_FLOAT 3

// WAV文件头（44字节）
typedef struct {
    // RIFF chunk的id
    uint8_t riffChunkId[4] = {'R', 'I', 'F', 'F'};
    // RIFF chunk的data大小，即文件总长度减去8字节
    uint32_t riffChunkDataSize;
    
    // "WAVE"
    uint8_t format[4] = {'W', 'A', 'V', 'E'};
    
    /* fmt chunk */
    // fmt chunk的id
    uint8_t fmtChunkId[4] = {'f', 'm', 't', ' '};
    // fmt chunk的data大小：存储PCM数据时，是16
    uint32_t fmtChunkDataSize = 16;
    // 音频编码，1表示PCM，3表示Floating Point
    uint16_t audioFormat = AUDIO_FORMAT_FLOAT;
    // 声道数
    uint16_t numChannels;
    // 采样率
    uint32_t sampleRate;
    // 字节率 = sampleRate * blockAlign
    uint32_t byteRate;
    // 一个样本的字节数 = bitsPerSample * numChannels >> 3
    uint16_t blockAlign;
    // 位深度
    uint16_t bitsPerSample;
    
    /* data chunk */
    // data chunk的id
    uint8_t dataChunkId[4] = {'d', 'a', 't', 'a'};
    // data chunk的data大小：音频数据的总长度，即文件总长度减去文件头的长度(一般是44)
    uint32_t dataChunkDataSize;
} WAVHeader;

NS_ASSUME_NONNULL_BEGIN

@interface ACFormatFactory : NSObject

+ (BOOL)formatConversionPCMToWAV:(NSString *)pcm parameter:(WAVHeader *)header;

@end

NS_ASSUME_NONNULL_END
