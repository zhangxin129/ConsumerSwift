//
//  GYHSQuickPaymentCardTableCell.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "GYHSQuickPayModel.h"


@interface GYHSQuickPaymentCardTableCell :SWTableViewCell

- (void) setCellValue:(GYHSQuickPayModel *)model;

@end
