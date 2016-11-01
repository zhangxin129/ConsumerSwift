//
//  GYHSLoginVCButtonActionTableCellTableViewCell.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHSLoginViewController.h"

@protocol GYHSLoginVCBtnActionTableCellDelegate <NSObject>

- (void)changeHSView;

- (void)forgetPwdActon;

@end

@interface GYHSLoginVCBtnActionTableCell : UITableViewCell

@property (nonatomic, weak) id<GYHSLoginVCBtnActionTableCellDelegate> cellDelegate;

- (void)setCellName:(NSString*)changeBtnName
          loginType:(GYHSLoginViewControllerEnum)loginType
         forgetName:(NSString*)forgetName;

@end
