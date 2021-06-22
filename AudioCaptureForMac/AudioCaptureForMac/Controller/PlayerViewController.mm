//
//  PlayerViewController.m
//  AudioCaptureForMac
//
//  Created by Tenorshare_Lin on 2021/6/22.
//  Copyright © 2021 LHMacCoder. All rights reserved.
//

#import "PlayerViewController.h"
#import "AudioPCMObject.h"

// 用于存储读取的音频数据和长度
typedef struct {
    int len = 0;
    int pullLen = 0;
    Uint8 *data = NULL;
} AudioBuffer;

@interface PlayerViewController () {
    BOOL _initSDL;
    BOOL _playing;
    BOOL _pause;
    FILE *_fp;
    NSTimer *_timer;
    NSInteger _timeCount;
    AudioPCMObject *_playingObj;
}

@property (weak) IBOutlet NSButton *playButton;
@property (weak) IBOutlet NSButton *backwardBtn;
@property (weak) IBOutlet NSButton *forwardBtn;

@property (weak) IBOutlet NSTextField *playerInfo;
@property (weak) IBOutlet NSTextField *timingText;
@property (weak) IBOutlet NSTextField *totalLength;
@property (weak) IBOutlet NSProgressIndicator *progress;

@end

@implementation PlayerViewController

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    _playing = YES;
    _timeCount = 0;
    _playingObj = _files[_selectedIndex];
    if (_selectedIndex + 1 == _files.count) {
        _forwardBtn.enabled = NO;
    }
    
    if (_selectedIndex == 0) {
        _backwardBtn.enabled = NO;
    }
    
    [self startTimeCounter];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self playRecord];
    });
}

- (void)viewWillDisappear {
    _playing = NO;
    // 关闭文件
    fclose(_fp);
    _fp = NULL;
    [_timer invalidate];
    // 关闭音频设备
    SDL_CloseAudio();
    // 清理所有初始化的子系统
    SDL_Quit();
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (void)updateButtonStatus {
    if (self.selectedIndex > 0 && self.selectedIndex < self.files.count - 1) {
        _backwardBtn.enabled = YES;
        _forwardBtn.enabled = YES;
    }
}

- (IBAction)playBtnAction:(id)sender {
    if (!_pause) {
        _pause = YES;
        _playButton.image = [NSImage imageNamed:@"play"];
        [_timer invalidate];
        
    } else {
        _pause = NO;
        _playButton.image = [NSImage imageNamed:@"pause"];
        [self startTimeCounter];
    }
}

- (IBAction)forwardBtnAction:(id)sender {
    _playing = NO;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // 等待文件关闭播放结束
        [NSThread sleepForTimeInterval:1];
        if (strongSelf->_selectedIndex + 1 < strongSelf->_files.count) {
            strongSelf->_selectedIndex += 1;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (strongSelf->_selectedIndex + 1 == strongSelf->_files.count) {
                    strongSelf.forwardBtn.enabled = NO;
                }
                [self updateButtonStatus];
            });
        }
        strongSelf->_playingObj = strongSelf->_files[strongSelf->_selectedIndex];
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf->_timeCount = 0;
            strongSelf.timingText.stringValue = [NSString stringWithFormat:@"00:%li",strongSelf->_timeCount];
            strongSelf.progress.doubleValue = 0;
            [strongSelf startTimeCounter];
        });
        strongSelf->_playing = YES;
        [strongSelf playRecord];
    });
}

- (IBAction)backwardAction:(id)sender {
    _playing = NO;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // 等待文件关闭播放结束
        [NSThread sleepForTimeInterval:1];
        if (strongSelf->_selectedIndex - 1 >= 0) {
            strongSelf->_selectedIndex -= 1;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (strongSelf->_selectedIndex == 0) {
                    strongSelf.backwardBtn.enabled = NO;
                }
                [self updateButtonStatus];
            });
        }
        strongSelf->_playingObj = strongSelf->_files[strongSelf->_selectedIndex];
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf->_timeCount = 0;
            strongSelf.timingText.stringValue = [NSString stringWithFormat:@"00:%li",strongSelf->_timeCount];
            strongSelf.progress.doubleValue = 0;
            [strongSelf startTimeCounter];
        });
        strongSelf->_playing = YES;
        [strongSelf playRecord];
    });
}

- (void)startTimeCounter {
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf->_timeCount++;
        if (strongSelf->_timeCount <= strongSelf->_playingObj.length) {
            strongSelf.timingText.stringValue = [NSString stringWithFormat:@"00:%li",strongSelf->_timeCount];
            strongSelf.progress.doubleValue = (double)strongSelf->_timeCount / strongSelf->_playingObj.length * 100;
        }
    }];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
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

- (void)playRecord {
    NSString *pcmFile = _playingObj.filePath;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.playerInfo.stringValue = [NSString stringWithFormat:@"正在播放：%@",self->_playingObj.fileName];
        self.totalLength.stringValue = [NSString stringWithFormat:@"00:%llu",self->_playingObj.length];
    });
    
    
    if (!_initSDL) {
        if (SDL_Init(SDL_INIT_AUDIO)) {
            _initSDL = NO;
            [self showAlertMessage:[NSString stringWithFormat:@"SDL_Init Error: %s",SDL_GetError()]];
            return ;
        }
    }
    
    _initSDL = YES;
    // 音频参数
    SDL_AudioSpec spec;
    // 采样率
    spec.freq = SAMPLE_RATE;
    // 采样格式
    spec.format = SAMPLE_FORMAT;
    // 声道数
    spec.channels = CHANNELS;
    // 音频缓冲区的样本数量（这个值必须是2的幂）
    spec.samples = SAMPLES;
    // 回调
    spec.callback = pull_audio_data;
    // 传递给回调的参数
    AudioBuffer buffer;
    spec.userdata = &buffer;
    
    // 打开音频设备
    if (SDL_OpenAudio(&spec, NULL)) {
        [self showAlertMessage:[NSString stringWithFormat:@"SDL_OpenAudio Error: %s",SDL_GetError()]];
        // 清除所有初始化的子系统
        SDL_Quit();
        return;
    }
    
    _fp = fopen([pcmFile UTF8String], "r");
    
    // 开始播放
    SDL_PauseAudio(0);
    
    // 存放文件数据
    Uint8 data[BUFFER_SIZE];
    
    while (_playing) {
        // 只要从文件中读取的音频数据，还没有填充完毕，就跳过
        if (buffer.len > 0 || _pause) continue;
        
        if (fread(data, BUFFER_SIZE, 1, _fp) == 0) {
            break;
        }
        buffer.len = BUFFER_SIZE;
        buffer.data = data;
    }
    
    [_timer invalidate];
    // 关闭文件
    fclose(_fp);
    // 关闭音频设备
    SDL_CloseAudio();
}

void pull_audio_data(void *userdata, Uint8 *stream, int len) {
    // 清空stream
    SDL_memset(stream, 0, len);
    
    // 取出缓冲信息
    AudioBuffer *buffer = (AudioBuffer *) userdata;
    if (buffer->len == 0) return;
    
    // 取len、bufferLen的最小值（为了保证数据安全，防止指针越界）
    buffer->pullLen = (len > buffer->len) ? buffer->len : len;
    
    // 填充数据
    SDL_MixAudio(stream,
                 buffer->data,
                 buffer->pullLen,
                 SDL_MIX_MAXVOLUME);
    buffer->data += buffer->pullLen;
    buffer->len -= buffer->pullLen;
}


@end
