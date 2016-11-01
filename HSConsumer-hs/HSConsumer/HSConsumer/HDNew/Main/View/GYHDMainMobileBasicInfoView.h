//
//  GYHDMainMobileBasicInfoView.h
//  HSConsumer
//
//  Created by kuser on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHDMainMobileBasicInfoView;

@protocol GYHDMainMobileBasicInfoViewDelegate <NSObject>

@optional

- (void)upGestureMobileClickDelegate;


@end


@interface GYHDMainMobileBasicInfoView : UIView

//手机号码
@property (strong, nonatomic) IBOutlet UILabel *mobileLabel;
//邮件号
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
//绑定邮箱图标
@property (strong, nonatomic) IBOutlet UIImageView *bindEmailImage;
//绑定按钮
@property (strong, nonatomic) IBOutlet UIButton *bindEmailBtn;
//合并按钮
@property (strong, nonatomic) IBOutlet UIButton *upArrowClickBtn;

@property (strong, nonatomic) IBOutlet UIView *bottomView;


//距离左边距离
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *distanceLeftConstraint;

@property(nonatomic,weak)id<GYHDMainMobileBasicInfoViewDelegate>delegate;


@end
