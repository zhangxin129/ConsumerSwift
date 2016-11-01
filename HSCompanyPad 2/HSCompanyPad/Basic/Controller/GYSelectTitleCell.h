//
//  GYSelectTitleCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYRelationShopsModel;

@interface GYSelectTitleCell : UITableViewCell

@property (nonatomic, strong) GYRelationShopsModel *model;
@property (nonatomic, assign) BOOL isSelect;

@end
