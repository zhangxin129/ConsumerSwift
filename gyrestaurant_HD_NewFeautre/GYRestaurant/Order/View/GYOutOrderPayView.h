//
//  GYOutOrderPayView.h
//  GYRestaurant
//
//  Created by apple on 15/10/28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYOrdDetailModel;
typedef void (^SendViewBlock)(id sender);
@interface GYOutOrderPayView : UIView
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

- (void)refreshUI:(GYOrdDetailModel*)model;
@property (nonatomic,copy)SendViewBlock sendBlock;
@end
