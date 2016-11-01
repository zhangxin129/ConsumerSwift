//
//  GYHSLoginVCInfoTableCell.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSLoginVCInfoTableCellDelegate <NSObject>

- (void)pullDownBtnAction:(UIImageView*)imageView indexPath:(NSIndexPath*)indexPath;

- (void)inputTextField:(NSString*)value indexPath:(NSIndexPath*)indexPath;

@end

@interface GYHSLoginVCInfoTableCell : UITableViewCell

@property (nonatomic, weak) id<GYHSLoginVCInfoTableCellDelegate> cellDelegate;

- (void)setCellValue:(NSString*)imageName
               value:(NSString*)value
         placeHolder:(NSString*)placeHolder
        pwdTextField:(BOOL)pwdTextField
           indexPath:(NSIndexPath*)indexPath;

@end
