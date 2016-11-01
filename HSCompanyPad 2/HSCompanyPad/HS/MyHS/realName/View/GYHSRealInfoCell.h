//
//  GYHSRealInfoCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/25.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString * realNameInfoCell = @"realNameInfoCell";
@interface GYHSRealInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@end
