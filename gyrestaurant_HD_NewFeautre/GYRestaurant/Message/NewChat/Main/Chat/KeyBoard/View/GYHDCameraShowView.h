//
//  GYHDCameraShowView.h
//  HSConsumer
//
//  Created by shiang on 16/2/24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDCameraView.h"
@class  GYHDCameraShowView;
@protocol GYHDCameraShowViewDelegate <NSObject>

- (void)GYHDCameraShowView:(UIView *)cameraShowView SendImageData:(NSData *)imageData;

@end

@interface GYHDCameraShowView : UIView
@property(nonatomic, weak) id<GYHDCameraShowViewDelegate> delegate;
@property(nonatomic,strong)GYHDCameraView*dele;
- (void)setImage:(UIImage *)image;
- (void)show;
@end
