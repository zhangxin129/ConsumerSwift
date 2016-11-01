//
//  GYHSAddBankCardInfoTableViewCell.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSAddBankCardInfoTableViewCellDelegate <NSObject>

- (void)chooseButtonAction:(NSIndexPath*)indexPath;

- (void)inputValue:(NSString*)value indexPath:(NSIndexPath*)indexPath;

@end

@interface GYHSAddBankCardInfoTableViewCell : UITableViewCell

@property (nonatomic, weak) id<GYHSAddBankCardInfoTableViewCellDelegate> cellDelegate;

- (void)setCellValue:(NSString*)title
               value:(NSString*)value
          valueColor:(UIColor*)valueColor
           valueEdit:(BOOL)valueEdit
           imageName:(NSString*)imageName
         arrowButton:(BOOL)arrowButton
         placeholder:(NSString*)placeholder
                 tag:(NSIndexPath*)indexPath;

- (NSString*)valueInfo;

- (void)setValueInfo:(NSString*)value;

- (void)numberKeyBoard;

@end
