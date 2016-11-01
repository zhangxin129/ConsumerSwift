//
//  GYHSPerCardListCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  GYHSListSpecCardStyleModel;

@protocol GYHSLookSelectCellDelegate <NSObject>

- (void) lookSelectCell:(GYHSListSpecCardStyleModel *)model;

@end

@interface GYHSPerCardListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numLable;
@property (nonatomic, strong) GYHSListSpecCardStyleModel *model;
@property (nonatomic, weak) id<GYHSLookSelectCellDelegate> delegate;

@end
