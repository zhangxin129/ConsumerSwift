//
//  GYHSConsumeCancelListCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHSPointCancelModel;
static NSString * consumeCancelCell = @"consumeCancelCell";
@interface GYHSConsumeCancelListCell : UITableViewCell
@property (nonatomic,strong) GYHSPointCancelModel * model;
@end
