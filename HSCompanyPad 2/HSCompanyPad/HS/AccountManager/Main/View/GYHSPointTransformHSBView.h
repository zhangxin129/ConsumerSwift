//
//  GYHSPointTransformHSBView.h
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/2.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYTextField.h"
@class GYHSAccountUIFactory;
@interface GYHSPointTransformHSBView : UIView
/**
 *  可用积分数
 */
@property (nonatomic, copy) NSString *canUsePoints;
/**
 *  转出积分数
 */
@property (nonatomic, copy) NSString *turanOutValue;
/**
 *  转出数据的输入框
 */
@property (nonatomic, strong) GYTextField *turnOutTf;
/**
 *  密码输入框
 */
@property (nonatomic, strong) GYTextField *passWordTf;

@end
