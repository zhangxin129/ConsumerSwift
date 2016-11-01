//
//  GYHDUserSetingHeaderCell.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDUserSetingHeaderModel.h"

@class GYHDUserSetingHeaderCell;

@protocol GYHDUserSetingHeaderCellDelegate <NSObject>

- (void)showQR:(GYHDUserSetingHeaderCell *)cell;
- (void)requeatInfo:(GYHDUserSetingHeaderCell *)cell withName:(NSString *)name withSign:(NSString *)sign;

@end

@interface GYHDUserSetingHeaderCell : UITableViewCell

@property (nonatomic, strong)GYHDUserSetingHeaderModel *model;
@property (nonatomic, weak)id<GYHDUserSetingHeaderCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *qrBtn;


@end
