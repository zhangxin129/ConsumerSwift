//
//  GYHSLoginHistoryTableCell.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSLoginHistoryTableCellDelegate <NSObject>

- (void)deleteButtonAction:(NSString*)hsNumber;

@end

@interface GYHSLoginHistoryTableCell : UITableViewCell

@property (nonatomic, weak) id<GYHSLoginHistoryTableCellDelegate> cellDelegate;

- (void)setCellValue:(NSString*)imageName value:(NSString*)value;

@end
