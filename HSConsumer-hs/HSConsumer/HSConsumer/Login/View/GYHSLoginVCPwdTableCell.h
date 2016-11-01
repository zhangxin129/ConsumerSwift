//
//  GYHSLoginVCPwdTableCell.h
//  HSConsumer
//
//  Created by wangfd on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSLoginVCPwdTableCellDelegate <NSObject>

- (void)forgetPwdBtnAction:(NSIndexPath*)indexPath;

- (void)pwdInputTextField:(UITextField*)textField indexPath:(NSIndexPath*)indexPath;

@end

@interface GYHSLoginVCPwdTableCell : UITableViewCell

@property (nonatomic, weak) id<GYHSLoginVCPwdTableCellDelegate> cellDelegate;

- (void)setCellValue:(NSString*)placeHolder
             btnName:(NSString*)btnName
           indexPath:(NSIndexPath*)indexPath;

@end
