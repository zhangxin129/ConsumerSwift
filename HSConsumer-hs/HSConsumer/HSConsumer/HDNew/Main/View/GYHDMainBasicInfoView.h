//
//  GYHDMainBasicInfoView.h
//  GYHDMainViewController
//
//  Created by kuser on 16/9/9.
//  Copyright © 2016年 hsxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHDMainBasicInfoView;

@protocol GYHDMainBasicInfoViewDelegate <NSObject>

@optional

- (void)upGestureClickDelegate;


@end

@interface GYHDMainBasicInfoView : UIView

//互生号
@property (strong, nonatomic) IBOutlet UILabel *hsNumberLabel;
//手机绑定
@property (strong, nonatomic) IBOutlet UILabel *mobileBindLabel;
//邮件绑定
@property (strong, nonatomic) IBOutlet UILabel *emailBindLabel;


//收缩视图
@property (strong, nonatomic) IBOutlet UIButton *upArrowTouchBtn;

@property (strong, nonatomic) IBOutlet UIButton *upTouchBtn;

//互生卡状态
@property (strong, nonatomic) IBOutlet UIButton *hsCardStatusBtn;
//互生卡用户
@property (strong, nonatomic) IBOutlet UIButton *hsCardUserBtn;
//绑定手机号
@property (strong, nonatomic) IBOutlet UIButton *hsCardMobileBindBtn;
//绑定邮箱
@property (strong, nonatomic) IBOutlet UIButton *hsCardEmailBindBtn;
//补卡
@property (strong, nonatomic) IBOutlet UIButton *fillCardBtn;
//互生号状态
@property (strong, nonatomic) IBOutlet UILabel *hsCardStatusLabel;
//未认证
@property (strong, nonatomic) IBOutlet UILabel *hsNotRegisterLabel;
//实名名字
@property (strong, nonatomic) IBOutlet UILabel *realNameLabel;
//已经实名图标
@property (strong, nonatomic) IBOutlet UIImageView *hasAlreadyRealNameImage;
//已经注册图标
@property (strong, nonatomic) IBOutlet UIImageView *hasAlreadyRegiisterNameImage;

//绑定手机图标
@property (strong, nonatomic) IBOutlet UIImageView *hasAlreadyBindMobileImage;
//绑定邮箱图标
@property (strong, nonatomic) IBOutlet UIImageView *hasAlreadyBindEmailImage;


@property (strong, nonatomic) IBOutlet UIView *bottomView;


//实名注册距离左边距离
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *realNameRegisteristanceLeftConnstraint;
//绑定邮箱距左边距离
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bindEmaildistanceLeftConstraint;
//绑定邮箱距电话距离
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bindMobiledistanceLeftConstraint;


@property(nonatomic,weak)id<GYHDMainBasicInfoViewDelegate>delegate;



@end
