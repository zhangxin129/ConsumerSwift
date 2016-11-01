//
//  GYHSLoginVConfirmTableCell.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHSLoginViewController.h"

@protocol GYHSLoginVConfirmTableCellDelegate <NSObject>

- (void)confirmButtonAction;

@end

@interface GYHSLoginVConfirmTableCell : UITableViewCell

@property (nonatomic, weak) id<GYHSLoginVConfirmTableCellDelegate> cellDelegate;

- (void)setCellName:(NSString*)name loginType:(GYHSLoginViewControllerEnum)loginType;

- (void)setCellBackground:(UIColor*)color;

@end
