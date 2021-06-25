//
//  ACFormatFactory.m
//  AudioCaptureForMac
//
//  Created by LHMacCoder on 2021/6/25.
//  Copyright © 2021 LHMacCoder. All rights reserved.
//

#import "ACFormatFactory.h"

@implementation ACFormatFactory

+ (BOOL)formatConversionPCMToWAV:(NSString *)pcm parameter:(WAVHeader *)header {
    FILE *pcmFP = fopen([pcm UTF8String], "r+");
    if (!pcmFP) {
        return NO;
    }
    
    NSString *pcmName = [[pcm lastPathComponent] stringByDeletingPathExtension];
    NSString *wavPath = [[pcm stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",pcmName]];
    FILE *wavFP = fopen([wavPath UTF8String], "wb+");
    if (!wavFP) {
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:pcm]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:pcm error:&error];
        if (!error && fileDict) {
            header->dataChunkDataSize = (uint32_t)[fileDict fileSize];
            header->riffChunkDataSize = header->dataChunkDataSize + sizeof(WAVHeader) - 8;
        } else {
            fclose(pcmFP);
            fclose(wavFP);
            return NO;
        }
    } else {
        fclose(pcmFP);
        fclose(wavFP);
        return NO;
    }
    
    header->blockAlign = header->bitsPerSample * header->numChannels >> 3;
    header->byteRate = header->blockAlign * header->sampleRate;
    
    // 写入wav文件头
    fwrite(header,sizeof(WAVHeader),1,wavFP);

    char buffer[1024] = {0};
    while (fread(buffer, sizeof(buffer), 1, pcmFP) != 0) {
        fwrite(buffer,sizeof(buffer),1,wavFP);
    }
    
    fclose(pcmFP);
    fclose(wavFP);
    return YES;
}

@end
