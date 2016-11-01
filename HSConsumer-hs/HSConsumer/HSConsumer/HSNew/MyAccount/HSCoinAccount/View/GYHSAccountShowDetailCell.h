//
//  GYHSAccountShowDetailCell.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSAccountShowDetailCell;
@protocol GYHSAccountShowDetailCellDelegate <NSObject>

- (void)searchAccountDetail:(GYHSAccountShowDetailCell *)cell;

@end

@interface GYHSAccountShowDetailCell : UITableViewCell

@property (nonatomic ,weak)id<GYHSAccountShowDetailCellDelegate> delegate;

@end
