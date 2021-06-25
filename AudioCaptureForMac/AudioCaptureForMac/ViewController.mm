//
//  ViewController.m
//  AudioCaptureForMac
//
//  Created by LHMacCoder on 2021/6/22.
//  Copyright © 2021 LHMacCoder. All rights reserved.
//

#import "ViewController.h"
#import "FFmpegRecord.h"
#import "AudioPCMObject.h"
#import "PlayerViewController.h"
#import "ACFormatFactory.h"

@interface TableCellView : NSTableCellView

@property (nonatomic, weak) IBOutlet NSButton *button;

@end

@implementation TableCellView



@end

@interface ViewController ()<NSTableViewDelegate, NSTableViewDataSource> {
    FFmpegRecord *_record;
    FFmpegRecord *_recordPlay;
    
    BOOL _recording;
    NSTimer *_timer;
}

@property (weak) IBOutlet NSButton *recordBtn;
@property (weak) IBOutlet NSTextField *timeLengthLabel;
@property (weak) IBOutlet NSTableView *tableView;
@property (nonatomic, strong) NSMutableArray *pcmArray;

@property (nonatomic, assign) NSInteger second;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    _recording = NO;
    _recordBtn.title = @"开始录制";
    
    _second = 0;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _pcmArray = [NSMutableArray new];
    
    NSString *savePath = [NSString stringWithFormat:@"/Users/%@/Music/AudioCapture", NSUserName()];
    NSDirectoryEnumerator *enumerator = [NSFileManager.defaultManager enumeratorAtPath:savePath];
    NSString *path;
    while ((path = [enumerator nextObject]) != nil) {
        if ([path.pathExtension isEqualToString:@"pcm"]) {
            AudioPCMObject *obj = [[AudioPCMObject alloc] init];
            obj.fileName = path;
            obj.filePath = [savePath stringByAppendingPathComponent:path];
            NSDictionary *dic = [NSFileManager.defaultManager attributesOfItemAtPath:obj.filePath error:nil];
            obj.size = [dic fileSize];
            [_pcmArray addObject:obj];
        }
    }
    [_tableView reloadData];
}

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(NSButton *)sender {
    PlayerViewController *player = (PlayerViewController *)segue.destinationController;
    player.selectedIndex = sender.tag;
    player.files = _pcmArray;
}


- (IBAction)startRecord:(id)sender {
    if (_recording) {
        _recording = NO;
        _recordBtn.title = @"开始录制";
        NSString *path = [_record stopRecord];
        [_timer invalidate];
        _second = 0;
        _timeLengthLabel.stringValue = @"00:00";
        
        AudioPCMObject *obj = [[AudioPCMObject alloc] init];
        obj.fileName = path.lastPathComponent;
        obj.filePath = path;
        NSDictionary *dic = [NSFileManager.defaultManager attributesOfItemAtPath:obj.filePath error:nil];
        obj.size = [dic fileSize];
        [_pcmArray addObject:obj];
        [_tableView reloadData];
    } else {
        _recording = YES;
        _recordBtn.title = @"结束录制";
        __weak typeof(self) weakSelf = self;
        _timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            weakSelf.second++;
            weakSelf.timeLengthLabel.stringValue = [NSString stringWithFormat:@"00:%li",weakSelf.second];
        }];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self->_record = [[FFmpegRecord alloc] init];
            [self->_record avdeviceRegisterAll];
            [self->_record startRecord];
        });
    }
}
- (IBAction)ouputWAVAciton:(id)sender {
    NSUInteger index = _tableView.selectedRow;
    if (index < 0 || index > _pcmArray.count) {
        return ;
    }
    AudioPCMObject *obj = _pcmArray[index];
    
    WAVHeader header;
    header.numChannels = 2;
    header.sampleRate = 44100;
    header.bitsPerSample = 32;
    
    if ([ACFormatFactory formatConversionPCMToWAV:obj.filePath parameter:&header]) {
        NSAlert *alert = [NSAlert new];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"导出完成!"];
        [alert setAlertStyle:NSAlertStyleInformational];
        alert.icon = [NSImage imageNamed:@"NSInfo"];
        [alert runModal];
        [[NSWorkspace sharedWorkspace] openFile:[obj.filePath stringByDeletingLastPathComponent]];
    }
}

#pragma mark - NSTableViewDataSource
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 40;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _pcmArray.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *identifier = tableColumn.identifier;
    AudioPCMObject *item = _pcmArray[row];
    
    if ([identifier isEqualToString:@"FileNameCell"]) {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
        cellView.textField.stringValue = item.fileName;
        return cellView;
    } else if ([identifier isEqualToString:@"TimeLengthCell"]) {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
        cellView.textField.stringValue = [NSString stringWithFormat:@"00:%llu",item.length];
        return cellView;
    } else if ([identifier isEqualToString:@"SizeCell"]) {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
        cellView.textField.stringValue = [NSByteCountFormatter stringFromByteCount:item.size countStyle:NSByteCountFormatterCountStyleFile];
        return cellView;
    } else if ([identifier isEqualToString:@"ButtonCell"]) {
        TableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
        //        cellView.button.action = @selector(playPCM:);
        //        cellView.button.target = self;
        cellView.button.tag = row;
        return cellView;
    }
    return nil;
}
@end

