//
//  GYHDAudioTool.m
//  HSConsumer
//
//  Created by shiang on 16/2/4.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDAudioTool.h"
#import "GYHDMessageCenter.h"
#import <AVFoundation/AVFoundation.h>
#import "lame.h"

@interface GYHDAudioTool () <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
/**当前音频长度*/
@property (nonatomic, assign) NSTimeInterval deviceCurrentTime;
/**总音频时长*/
@property (nonatomic, assign) NSTimeInterval duration;
/**返回录制的MP3Data*/
@property (nonatomic, strong) NSData* mp3Data;
/**mp3路劲*/
@property (nonatomic, copy) NSString* mp3Path;
/**mp3名字*/
@property (nonatomic, copy) NSString* mp3Name;
/**caf路劲*/
@property (nonatomic, copy) NSString* cafPath;
/**录音*/
@property (nonatomic, strong) AVAudioRecorder* recorder;
/**播放*/
@property (nonatomic, strong) AVAudioPlayer* player;
@property (nonatomic, copy) completeRecordBlock recordBlock;
@property (nonatomic, copy) completePlayeBlock playerBlock;
@end

/**录音时长*/
static const NSTimeInterval timelen = 30.0f;
@implementation GYHDAudioTool
static id instance;
+ (id)allocWithZone:(struct _NSZone*)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];

    });
    return instance;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];

    });
    return instance;
}

- (id)copyWithZone:(NSZone*)zone
{
    return instance;
}

- (NSString*)cafPath
{
    if (!_cafPath) {
        _cafPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/downloadFilecaf.caf"];
    }
    return _cafPath;
}

/**创建播放*/
- (AVAudioPlayer*)createPlayerWithData:(NSData*)data;
{
    if (!data) {
        data = [NSData dataWithContentsOfFile:self.mp3Path];
    }
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    AVAudioPlayer* playerSound = [[AVAudioPlayer alloc] initWithData:data fileTypeHint:AVFileTypeMPEGLayer3 error:nil];
    //    playerSound.delegate = self;
    [playerSound setNumberOfLoops:0];
    [playerSound prepareToPlay];
    return playerSound;
}
- (AVAudioRecorder*)createRecorder
{
    // 1. 设置音频会话，允许录音
    AVAudioSession* session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    // 激活分类
    [session setActive:YES error:nil];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:self.cafPath error:nil];
    NSURL* url = [NSURL fileURLWithPath:self.cafPath];

    // 2) 录音文件设置的字典（设置音频的属性，例如音轨数量，音频格式等）
    //录音设置
    NSMutableDictionary* settings = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [settings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //采样率
    [settings setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey]; //44100.0
    //通道数
    [settings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //线性采样位数
    //[recordSettings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
    //音频质量,采样质量
    [settings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    NSError* error = nil;
    AVAudioRecorder* recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    recorder.delegate = self;
    [recorder prepareToRecord];
    return recorder;
}
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder*)recorder successfully:(BOOL)flag
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //get save path
//        NSInteger timeNumber = +;
        NSString *timeNumber = [NSString stringWithFormat:@"%u_%d", arc4random_uniform(1000), (int)[[NSDate date] timeIntervalSince1970]];
        NSString *mp3Name = [NSString stringWithFormat:@"audio%@.mp3", timeNumber];
        NSString *mp3Path = [NSString pathWithComponents:@[[[GYHDMessageCenter sharedInstance] mp3folderNameString], mp3Name]];
        [self audio_PCMUrl:self.cafPath toMP3:mp3Path];
        self.mp3Path = mp3Path;
        self.mp3Name = mp3Name;
        self.mp3Data = [NSData dataWithContentsOfFile:self.mp3Path];

        self.duration = self.recorder.deviceCurrentTime - self.deviceCurrentTime;
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(audioRecorderDidFinishRecordingWithPath:)]) {
                [self.delegate audioRecorderDidFinishRecordingWithPath:mp3Path];
            }
//            if (self.recorder.deviceCurrentTime >= self.deviceCurrentTime+timelen) {
//                if (_recordBlock) {
//                    _recordBlock(GYHDAudioToolRecordSurpass30Seconds);
//                }
//            }
        });
    });
}

- (NSString*)mp3pathName
{
    return self.mp3Path;
}

- (NSString*)mp3NameString
{
    return self.mp3Name;
}

- (void)startRecord:(completeRecordBlock)block
{

    if ([self.recorder isRecording]) {
        return;
    }
    if (block) {
        _recordBlock = block;
        AVAudioSession* session = [AVAudioSession sharedInstance];
        if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
            [session requestRecordPermission:^(BOOL available) {
                if (!available) {
                    _recordBlock(GYHDAudioToolRecordProhibit);
                }
            }];
        }
    }
    self.recorder = [self createRecorder];
    // 2. 如果当前正在播放录音
    if ([self.player isPlaying]) {
        [self.player stop];
    }

    [self.recorder recordForDuration:timelen];
    self.deviceCurrentTime = self.recorder.deviceCurrentTime;
}

- (void)startRecord
{
    if ([self.recorder isRecording]) {
        return;
    }
    self.recorder = [self createRecorder];
    // 2. 如果当前正在播放录音
    if ([self.player isPlaying]) {
        [self.player stop];
    }

    [self.recorder recordForDuration:timelen];
}

- (void)stopRecord
{
    if ([self.recorder isRecording]) {
        [self.recorder stop];

        //        //get save path
        //        NSString *timeNumber = [NSString stringWithFormat:@"%u_%d", arc4random_uniform(1000), (int)[[NSDate date] timeIntervalSince1970]];
        //
        //        NSString *mp3Name = [NSString stringWithFormat:@"audio%@.mp3", timeNumber];
        //        NSString *mp3Path = [NSString pathWithComponents:@[[[GYHDMessageCenter sharedInstance] mp3folderNameString], mp3Name]];
        //        self.mp3Path = mp3Path;
        //        self.mp3Name = mp3Name;
        //        [self audio_PCMUrl:self.cafPath toMP3:mp3Path];
        //        self.mp3Data = [NSData dataWithContentsOfFile:self.mp3Path];
        //        self.duration = self.recorder.deviceCurrentTime - self.deviceCurrentTime;
    }
}

#pragma mark 开始播放
/**播放MP3文件*/
- (void)playMp3WithFilePath:(NSString*)filePath complete:(completePlayeBlock)block
{
    self.playerBlock = block;
    if ([self.player isPlaying]) {
        [self.player stop];
    }
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    NSURL* url = [NSURL fileURLWithPath:filePath];
    AVAudioPlayer* playerSound = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    playerSound.delegate = self;
    [playerSound setNumberOfLoops:0];
    [playerSound prepareToPlay];
    self.player = playerSound;
    [self.player play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag
{
    self.playerBlock(GYHDAudioToolPlayerSuccess);
}

- (void)startPlayingWithData:(NSData*)data complete:(completePlayeBlock)block
{
    // 1) 实例化播放器
    if ([self.player isPlaying]) {
        [self.player stop];
    }
    self.player = [self createPlayerWithData:data];
    [self.player play];
}

#pragma mark 停止播放
- (void)stopPlaying
{
    if ([self.player isPlaying]) {
        [self.player stop];
    }
}

- (NSData*)mp3Data
{
    return _mp3Data;
}

- (NSTimeInterval)gettime
{
    return self.duration;
}

/**
 * caf 转MP3
 */
- (void)audio_PCMUrl:(NSString*)cafFilePath toMP3:(NSString*)mp3FilePath
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:mp3FilePath error:nil];
    @try {
        int read, write;

        FILE* pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb"); //source 被转换的音频文件位置
        fseek(pcm, 4 * 1024, SEEK_CUR); //skip file header
        FILE* mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb"); //output 输出生成的Mp3文件位置

        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE * 2];
        unsigned char mp3_buffer[MP3_SIZE];

        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);

        do {
            read = fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);

            fwrite(mp3_buffer, write, 1, mp3);

        } while (read != 0);

        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }@catch (NSException *exception) {
        NSLog(@"%@", [exception description]);
    }
}

@end
