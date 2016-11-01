//
//  GYHEFoodOrderHeaderView.h
//  HSConsumer
//
//  Created by 吴文超 on 16/10/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHEFoodOrderHeaderView : UIView
@property (nonatomic, assign) BOOL hasAbilityTakeHSCard; //判断赠卡的条件

@property (nonatomic, assign) BOOL isOnlyPayOnline; //仅仅在线支付
-(void)initView;
@property (nonatomic, assign) BOOL hasValidAddress;  //前面传过来的 存在有效地址
@end
