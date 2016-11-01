//
//  GYHealthUploadImgView.h
//  HSConsumer
//
//  Created by Apple03 on 15/7/24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHealthUploadImgModel;
@class GYHealthUploadImgView;
@protocol GYHealthUploadImgViewDelegate <NSObject>
@optional
- (void)HealthUploadImgViewShowExampleWithButton:(UIButton*)button;
- (void)HealthUploadImgViewChooseImgWithButton:(UIButton*)button;
@end

@interface GYHealthUploadImgView : UIView
@property (nonatomic, strong) GYHealthUploadImgModel* model;
@property (nonatomic, weak) id<GYHealthUploadImgViewDelegate> delegate;

- (void)setShowTag:(NSInteger)showTag chooseImageTag:(NSInteger)chooseImageTag;
- (void)setImageWithImage:(UIImage*)image;
- (NSInteger)getImgChooseTag;
@end
