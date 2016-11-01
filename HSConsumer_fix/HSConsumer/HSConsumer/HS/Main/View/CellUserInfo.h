//
//  CellUserInfo.h
//  HSConsumer
//
//  Created by apple on 14-10-17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYKit.h"

@interface CellUserInfo : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* timeTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* phoneleftConstraint;
@property (strong, nonatomic) IBOutlet UIButton* btnUserPicture; //头像
@property (strong, nonatomic) IBOutlet UIButton* btnRealName; //实名认证按钮
@property (strong, nonatomic) IBOutlet UIButton* btnPhoneYes; //实名手机绑定按钮
@property (strong, nonatomic) IBOutlet UIButton* btnEmailYes; //实名绑定邮箱按钮
@property (strong, nonatomic) IBOutlet UIButton* btnBankYes; //实名银行账户绑定按钮

@property (strong, nonatomic) IBOutlet UILabel* lbLabelCardNo; //积分卡信息
@property (strong, nonatomic) IBOutlet UILabel* lbLabelHello; //问候语
@property (strong, nonatomic) IBOutlet UILabel* lbLastLoginInfo; //登录信息

@property (weak, nonatomic) IBOutlet YYLabel *vTipToInputInfo;//没有完善信息，提示

@end
