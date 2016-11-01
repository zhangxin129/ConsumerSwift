//
//  GYHSPayListCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHSPaymentCheckModel;

static NSString * payListCell = @"payListCell";
@interface GYHSPayListCell : UITableViewCell
@property (nonatomic,strong) GYHSPaymentCheckModel * model;

@end
