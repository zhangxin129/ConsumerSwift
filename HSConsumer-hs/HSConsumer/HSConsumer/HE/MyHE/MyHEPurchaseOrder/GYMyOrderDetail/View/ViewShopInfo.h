//
//  ViewShopInfo.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewShopInfo : UIView

@property (weak, nonatomic) IBOutlet UIView* vLine;
//@property (strong, nonatomic) IBOutlet UILabel *lbShopName;
@property (weak, nonatomic) IBOutlet UILabel* lbShopAddress;

@property (weak, nonatomic) IBOutlet UILabel* telLabel;
@property (weak, nonatomic) IBOutlet UIButton* btnShopTel;

+ (CGFloat)getHeight;
@end
