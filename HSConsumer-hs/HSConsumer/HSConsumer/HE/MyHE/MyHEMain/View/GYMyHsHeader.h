//
//  GYMyHsHeader.h
//  HSConsumer
//
//  Created by apple on 15/8/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYMyHsHeader : UIImageView

@property (weak, nonatomic) IBOutlet UIButton* btnHeadPic;
@property (weak, nonatomic) IBOutlet UILabel* LbUserHello;
@property (weak, nonatomic) IBOutlet UILabel* lbLastLoginTime;
@property (nonatomic, strong) UIButton* btnBackToRoot;
@property (weak, nonatomic) IBOutlet UILabel* myHSLabel; //我的互商
@property (weak, nonatomic) IBOutlet UIImageView* headerImgView;

- (void)reloadHeader;

@end
