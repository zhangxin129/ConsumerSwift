//
//  GYHSBankPopVC.h
//
//  Created by apple on 16/8/30.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BankModel;
typedef void (^block)(BankModel * model);

@interface GYHSBankPopVC : UIPopoverController
- (instancetype)initWithView:(UIView*)view dict:(NSMutableDictionary *)dict direction:(UIPopoverArrowDirection)direction;
/*!
 *    点击事件
 */
@property (nonatomic, copy) block selectBlock;
@end
                                                