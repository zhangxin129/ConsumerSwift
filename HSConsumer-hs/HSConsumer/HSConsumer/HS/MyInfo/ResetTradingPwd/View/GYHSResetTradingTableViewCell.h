//
//  GYHSResetTradingTableViewCell.h
//  HSConsumer
//
//  Created by lizp on 16/8/15.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kGYHSResetTradingTableViewCellIdentifier @"GYHSResetTradingTableViewCell"

#import <UIKit/UIKit.h>

@interface GYHSResetTradingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextField *value;


-(void)refreshDataWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder indexPaht:(NSIndexPath *)indexPath;

@end
