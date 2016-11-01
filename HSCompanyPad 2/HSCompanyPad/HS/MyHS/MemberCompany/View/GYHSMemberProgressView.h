//
//  GYHSMenberProgressView.h
//
//  Created by apple on 16/8/8.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHSMemberProgressView : UIView

- (instancetype)initWithFrame:(CGRect)frame array:(NSArray*)array;
/*!
 *    设置当前步骤，从1开始
 */
@property (nonatomic, assign) NSInteger index;
@end
                                                