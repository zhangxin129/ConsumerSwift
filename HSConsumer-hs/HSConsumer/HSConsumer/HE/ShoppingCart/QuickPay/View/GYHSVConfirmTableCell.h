//
//  GYHSVConfirmTableCell.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSVConfirmTableCellDelegate <NSObject>

- (void)confirmButtonAction:(UIButton*)button;

@end

@interface GYHSVConfirmTableCell : UITableViewCell

@property (nonatomic, weak) id<GYHSVConfirmTableCellDelegate> cellDelegate;

- (void)setCellName:(NSString*)name;

- (void)setCellBackground:(UIColor*)color;

@end
