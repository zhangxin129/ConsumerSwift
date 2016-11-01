//
//  GYHEFoodTitleCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYRoleListModel;

@protocol GYHSRoleDescDelegate <NSObject>

- (void)pullDownRoleDesc:(GYRoleListModel *)model;

@end

@interface GYHEFoodTitleCell : UITableViewCell

@property (nonatomic, strong) GYRoleListModel *model;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, weak) id<GYHSRoleDescDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *questionButton;

@end
