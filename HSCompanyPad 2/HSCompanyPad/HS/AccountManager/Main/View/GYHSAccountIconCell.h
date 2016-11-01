//
//  GYHSAccountIconCell.h
//  HSCompanyPad
//
//  Created by sqm on 16/8/25.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSAccountIconModel;
@interface GYHSAccountIconCell : UITableViewCell
@property (nonatomic, strong) GYHSAccountIconModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, assign) BOOL select;
@property (nonatomic, assign) NSInteger cellNumber;
@end
