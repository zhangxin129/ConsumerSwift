//
//  GYHSCentreLabCell.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSCentreLabCell;

@protocol GYHSCentreLabCellDelegate<NSObject>

- (void)showInvestmentDetail:(GYHSCentreLabCell *)cell;

@end

@interface GYHSCentreLabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab1;
@property (weak, nonatomic) IBOutlet UILabel *textLab1;
@property (weak, nonatomic) IBOutlet UILabel *titleLab2;
@property (weak, nonatomic) IBOutlet UILabel *textLab2;
@property (weak, nonatomic) IBOutlet UILabel *titleLab3;
@property (weak, nonatomic) IBOutlet UILabel *textLab3;
@property (nonatomic, weak)id<GYHSCentreLabCellDelegate> delegate;

@end
