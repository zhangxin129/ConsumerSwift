//
//  GYHDAudioTool.h
//  HSConsumer
//
//  Created by shiang on 16/2/4.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GYHDAudioToolPlayerState) {
    GYHDAudioToolPlayerSuccess,
    GYHDAudioToolPlayerFailure
};


typedef NS_ENUM(NSInteger, GYHDAudioToolRecordState) {
    GYHDAudioToolRecordSuccess,
    GYHDAudioToolRecordFailure,
    GYHDAudioToolRecordProhibit,         //录音禁止
    GYHDAudioToolRecordSurpass30Seconds  // 超过30秒
};
typedef void(^completeRecordBlock)(GYHDAudioToolRecordState state);
typedef void(^completePlayeBlock)(GYHDAudioToolPlayerState state);

@interface GYHDAudioTool : NSObject
+ (instancetype)sharedInstance;

/**开始录音*/
- (void)startRecord;
- (void)startRecord:(completeRecordBlock)block;
/**结束录音*/
- (void)stopRecord;
/**播放MP3文件*/
- (void)playMp3WithFilePath:(NSString *)filePath complete:(completePlayeBlock)block;
/**开始播放 data为 MP3 文件*/
- (void)startPlayingWithData:(NSData *)data complete:(completePlayeBlock)block;
/**结束播放*/
- (void)stopPlaying;
/**获取MP3data*/
- (NSData *)mp3Data;
/**获得录音长度*/
- (NSTimeInterval)gettime;
/**MP3路劲*/
- (NSString *)mp3pathName;
/**MP3名字*/
- (NSString *)mp3NameString;
@end

