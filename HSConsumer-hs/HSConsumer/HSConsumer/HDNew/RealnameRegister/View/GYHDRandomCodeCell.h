//
//  GYHDRandomCodeCell.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYRandomCodeView.h"

@protocol GYHDNextRandomCodeBtnDelegate <NSObject>
@optional
- (void)nextRandomCodeBtn:(GYRandomCodeView*)randomCodeView;
@end
@interface GYHDRandomCodeCell : UITableViewCell
//验证码生成view
@property (weak, nonatomic) IBOutlet GYRandomCodeView* randomCodeView;
//验证码输入框
@property (weak, nonatomic) IBOutlet UITextField* randomCodeTextField;
//看不清换一张 按钮
@property (weak, nonatomic) IBOutlet UIButton* nextRandomCodeBtn;

@property (weak, nonatomic) IBOutlet UILabel* verificationCodeLabel; //验证码

@property (nonatomic,weak) id<GYHDNextRandomCodeBtnDelegate> randomCodeBtnDelegate;
@end
