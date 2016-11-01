//
//  GYHDRecordVideoTool.h
//  HSConsumer
//
//  Created by shiang on 16/2/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GYHDRecordVideoTool;
@protocol GYHDRecordVideoDelegate <NSObject>
/**录音中代理*/
- (void)recordViewTimeInterval:(NSTimeInterval)timelen;
/**结束录像代理*/
//- (void)GYHDRecordVideoTool:(GYHDRecordVideoTool *)recordView mp4Path:(NSString *)mp4Path VideofristFramePath:(NSString *)imagePath;
/**结束录像代理2*/
- (void)GYHDRecordVideoTool:(GYHDRecordVideoTool*)recordView sendDict:(NSDictionary*)dict;
@end

@interface GYHDRecordVideoTool : NSObject
@property (nonatomic, weak) id<GYHDRecordVideoDelegate> delegate;
/**初始化*/
- (instancetype)initWithView:(UIView*)view;
/**初始化相机*/
- (instancetype)initWithCameraView:(UIView*)view;
/**开始录制照片*/
- (void)startRecordCamera;
/**开始录制录像*/
- (void)startRecordVideo;
/**开始录制30秒*/
- (void)startRecordVideoForDuration:(NSTimeInterval)duration;
/**停止录制*/
- (void)stopRecordVideo;
//- (BOOL)recording;
/**切换相机*/
- (void)changeCamera;
/**播放界面*/
- (void)playRecordVideoWithView:(UIView*)view Data:(NSData*)data;
/**播放路劲视频*/
- (void)playVideoWithView:(UIView*)view Url:(NSURL*)url;
/**暂停*/
- (void)pauseVideo;
/**播放*/
- (void)playerVideo;
/**MP4路劲*/
- (NSString*)mp4pathString;
/**获取照片*/
- (NSDictionary *)imagePathDict;
/**获取MP4data*/
- (NSData *)mp4Data;
/**获取imageData*/
- (NSData *)imageData;
/**视频第一帧*/
- (NSData *)VideofristFrameData;
+ (BOOL)CameraAvailable;
@end
