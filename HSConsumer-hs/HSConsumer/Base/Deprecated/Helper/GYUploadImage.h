//
//  GYUploadImage.h
//  HSConsumer
//
//  Created by apple on 15-2-10.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GYUploadPicDelegate <NSObject>

@optional
- (void)didFinishUploadImg:(NSURL*)url withTag:(int)index; //请求成功返回URL

- (void)didFinishUploadImg:(NSURL*)url withBigImg:(NSURL*)bigUrl withTag:(int)index; //请求成功返回URL
- (void)didFailUploadImg:(NSError*)error withTag:(int)index; //上传图片失败代理

@end

@interface GYUploadImage : NSObject <NSURLConnectionDelegate> {
    NSURLConnection* connection;
    NSMutableData* recvData;
}

@property (strong, nonatomic) UIImage* imgUpload;

@property (assign, nonatomic) id<GYUploadPicDelegate> delegate;
@property (nonatomic, strong) UIView* fatherView;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) int urlType; // 1: 互生修改头像  2：互生实名认证 3：轻松购 ：售后传图片

- (void)uploadImg:(UIImage *)image WithParam:(NSMutableDictionary *)Param;

//-(UIImage *)downloadImg:(NSURL *)url;

@end
