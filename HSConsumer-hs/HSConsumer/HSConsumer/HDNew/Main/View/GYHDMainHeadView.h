//
//  GYHDMainHeadView.h
//  GYHDMainViewController
//
//  Created by kuser on 16/9/9.
//  Copyright © 2016年 hsxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHDMainHeadView : UIView

@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;  //昵称
@property (strong, nonatomic) IBOutlet UILabel *hsNumberLabel;  //互生号
@property (strong, nonatomic) IBOutlet UIButton *upArrowTouchBtn; //收缩背景按钮
@property (strong, nonatomic) IBOutlet UIButton *upTouchBtn;
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;//卡号，手机图标
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;

@end
