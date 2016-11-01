//
//  GYHSConsumeListCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHSPointCheckModel;
static NSString* consumeListCell = @"consumeListCell";

@interface GYHSConsumeListCell : UITableViewCell
@property (nonatomic,strong) GYHSPointCheckModel * model;
@end
