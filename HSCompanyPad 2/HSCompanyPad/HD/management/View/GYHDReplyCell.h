//
//  GYHDReplyCell.h
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDReplyModel.h"

@class GYHDReplyCell;
@protocol GYHDReplyCellDelegate <NSObject>

- (void)editButonClickWithCell:(GYHDReplyCell *)cell model:(GYHDReplyModel *)model;
- (void)deleteButonClickWithCell:(GYHDReplyCell *)cell model:(GYHDReplyModel *)model;
@end

@interface GYHDReplyCell : UITableViewCell
@property(nonatomic, strong)GYHDReplyModel *model;
@property(nonatomic, weak) id<GYHDReplyCellDelegate> delegate;
@end
