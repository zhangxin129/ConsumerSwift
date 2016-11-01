//
//  GYMenuCell.h
//  HSCompanyPad
//
//  Created by User on 16/8/19.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYMainHistoryModel.h"

@interface GYMenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

-(void)loadModel:(GYMainHistoryModel*)model;

@end
