//
//  GYHEOrderQuickPayInfoCell.h
//  HSConsumer
//
//  Created by wangfd on 16/5/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHEOrderQuickPayInfoCell : UITableViewCell

- (void)setCellValue:(NSString*)title
            orderNum:(NSString*)orderNum
               money:(NSString*)money;

@end
