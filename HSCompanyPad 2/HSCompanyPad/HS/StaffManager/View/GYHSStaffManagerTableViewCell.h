//
//  GYHSStaffManagerTableViewCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSStaffManagerTableViewCell, GYHSStaffManModel;

@protocol GYHSOperatorInfoCellDelegate <NSObject>

- (void)postAction:(GYHSStaffManModel *)model roleArr:(NSMutableArray *)roleArr;

- (void)changeAction:(GYHSStaffManModel *)model;

- (void)deleteAction:(GYHSStaffManModel *)model;

-(void)switchAction:(GYHSStaffManModel *)model switch:(UISwitch *)cusSwitch;

-(void)blingingCardAction:(GYHSStaffManModel *)model;


@end


@interface GYHSStaffManagerTableViewCell : UITableViewCell

@property (nonatomic, weak) id<GYHSOperatorInfoCellDelegate> delegate;

@property (nonatomic, assign) CGFloat fCellHeight;
@property (nonatomic, strong) GYHSStaffManModel *model;

@end
