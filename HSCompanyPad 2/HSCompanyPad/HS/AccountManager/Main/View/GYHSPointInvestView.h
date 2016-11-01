//
//  GYHSPointInvestmentLeftView.h
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYTextField.h"
@interface GYHSPointInvestView : UIView
@property (nonatomic, copy) NSString *canUsePoints; //积分账户余数
@property (nonatomic, strong) GYTextField *turnOutTf;
@property (nonatomic, strong) GYTextField *passWordTf;

@end
