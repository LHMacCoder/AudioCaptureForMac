//
//  FFmpegRecord.m
//  AudioCaptureForMac
//
//  Created by LHMacCoder on 2021/6/22.
//  Copyright © 2021 LHMacCoder. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FFmpegRecord.h"

@interface FFmpegRecord () {
    AVFormatContext *ctx;
    AVPacket *pkt;
    BOOL _stop;
    
    NSString *_recordingPath;
}

@end

@implementation FFmpegRecord

- (void)avdeviceRegisterAll {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        avdevice_register_all();
    });
}

- (void)startRecord {
    const AVInputFormat *fmt = av_find_input_format("avfoundation");
    if (!fmt) {
        // 如果找不到输入格式
        [self showAlertMessage:@"找不到输入格式：avfoundation"];
        return ;
    }
    // 格式上下文（后面通过格式上下文操作设备）
    ctx = avformat_alloc_context();
    // 打开设备
    AVDictionary *options = NULL;
    int ret = avformat_open_input(&ctx, ":0", fmt, &options);
    // 如果打开设备失败
    if (ret < 0) {
        char errbuf[1024] = {0};
        // 根据函数返回的错误码获取错误信息
        av_strerror(ret, errbuf, sizeof (errbuf));
        [self showAlertMessage:[NSString stringWithFormat:@"打开设备失败: %s",errbuf]];
        return ;
    }
    [self showSpec:ctx];
    NSString *path = [NSString stringWithFormat:@"/Users/%@/Music/AudioCapture", NSUserName()];
    if (![NSFileManager.defaultManager fileExistsAtPath:path]) {
        [NSFileManager.defaultManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    _recordingPath = [path stringByAppendingPathComponent:[currentTimeString stringByAppendingString:@".pcm"]];
    FILE *fp = fopen([_recordingPath UTF8String], "wb+");
    if (!fp) {
        [self showAlertMessage:@"文件打开失败"];
        // 关闭设备
        avformat_close_input(&ctx);
        return ;
    }
    
    // 数据包
    pkt = av_packet_alloc();
    while (!_stop) {
        // 从设备中采集数据，返回值为0，代表采集数据成功
        if ((ret = av_read_frame(ctx, pkt)) >= 0) {
            // 将数据写入文件
            //            NSLog(@"size = %d",pkt->size);
            fwrite(pkt->data,pkt->size,1,fp);
            // 释放资源
            av_packet_unref(pkt);
        }
        else if (ret == AVERROR(EAGAIN)) { // 资源临时不可用
            continue;
        } else { // 其他错误
            char errbuf[1024];
            av_strerror(ret, errbuf, sizeof(errbuf));
            [self showAlertMessage:[NSString stringWithFormat:@"av_read_frame error: %s",errbuf]];
            break;
        }
    }
    
    // 关闭文件
    fclose(fp);
    // 释放资源
    av_packet_free(&pkt);
    // 关闭设备
    avformat_close_input(&ctx);
}

- (NSString *)stopRecord {
    _stop = YES;
    return _recordingPath;
}

- (void)showSpec:(AVFormatContext *)ctx {
    // 获取输入流
    AVStream *stream = ctx->streams[0];
    // 获取音频参数
    AVCodecParameters *params = stream->codecpar;
    // 声道数
    NSLog(@"channels: %d",params->channels);
    // 采样率
    NSLog(@"sample rate: %d",params->sample_rate);
    // 采样格式
    NSLog(@"format: %d",params->format);
    // 每一个样本的一个声道占用多少个字节
    NSLog(@"per sample bytes: %d",av_get_bytes_per_sample((AVSampleFormat)params->format));
    NSLog(@"per sample bytes: %d",BYTES_PER_SAMPLE);
    
    // 编码ID（可以看出采样格式）
    NSLog(@"codec id: %d",params->codec_id);
    // 每一个样本的一个声道占用多少位（这个函数需要用到avcodec库）
    NSLog(@"per sample bits: %d",av_get_bits_per_sample(params->codec_id));
}

- (void)showAlertMessage:(NSString *)info {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAlert *alert = [NSAlert new];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:info];
        [alert setAlertStyle:NSAlertStyleWarning];
        alert.icon = [NSImage imageNamed:@"NSInfo"];
        [alert runModal];
    });
}

@end
