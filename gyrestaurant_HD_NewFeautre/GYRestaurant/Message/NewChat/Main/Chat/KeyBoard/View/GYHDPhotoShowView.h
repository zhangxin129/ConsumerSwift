//
//  GYHDPhotoShowView.h
//  HSConsumer
//
//  Created by shiang on 16/2/23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  GYHDPhotoShowView;
@protocol GYHDPhotoShowViewDelegate <NSObject>

- (void)GYHDPhotoShowView:(UIView *)photoShowView SendImageData:(NSData *)imageData;

@end

@interface GYHDPhotoShowView : UIView

@property(nonatomic, weak) id<GYHDPhotoShowViewDelegate> delegate;
- (void)setImage:(UIImage *)image;
- (void)show;
@end
