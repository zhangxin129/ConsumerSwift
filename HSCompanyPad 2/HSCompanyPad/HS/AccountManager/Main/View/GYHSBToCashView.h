//
//  GYHSHSBToCoinLeftView.h
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/9.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYTextField.h"

@interface GYHSBToCashView : UIView
@property (nonatomic, copy) NSString *ltbBalance;//流通币余数
@property (nonatomic, strong) GYTextField *turnOutTf;//转出输入框
@property (nonatomic, strong) GYTextField *passWordTf;//密码输入框
@property (nonatomic, copy) NSString *turnOutFee;//转换费

@end
