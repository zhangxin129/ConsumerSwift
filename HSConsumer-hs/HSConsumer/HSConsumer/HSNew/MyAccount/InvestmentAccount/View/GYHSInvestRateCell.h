//
//  GYHSInvestRateCell.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSInvestRateCell;

@protocol GYHSInvestRateCellDelegate<NSObject>

- (void)showYearInvestmentDetail:(GYHSInvestRateCell *)cell;

@end

@interface GYHSInvestRateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *textLab;

@property (nonatomic, weak)id<GYHSInvestRateCellDelegate> delegate;

@end
