//
//  GYHSLoginVCButtonActionTableCellTableViewCell.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHSLoginViewController.h"

@protocol GYHSLoginVCSecurityCodeTableCellDelegate <NSObject>

- (void)inputAnswer:(UITextField*)textField indexPath:(NSIndexPath*)indexPath;

- (void)securityGenCode:(NSString*)genCode;

@end

@interface GYHSLoginVCSecurityCodeTableCell : UITableViewCell

@property (nonatomic, weak) id<GYHSLoginVCSecurityCodeTableCellDelegate> cellDelegate;

- (void)setCellName:(NSString*)placeHodler
            btnName:(NSString*)btnName
          indexPath:(NSIndexPath*)indexPath;

- (void)refreshVerifyCode;

@end
