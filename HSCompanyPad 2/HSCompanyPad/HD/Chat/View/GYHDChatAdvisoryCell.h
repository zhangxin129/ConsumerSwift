//
//  GYHDChatAdvisoryCell.h
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/17.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDChatModel.h"
#import "GYHDSessionRecordModel.h"
@interface GYHDChatAdvisoryCell : UITableViewCell
@property(nonatomic, strong)GYHDChatModel *model;
@property (nonatomic, strong)GYHDSessionRecordModel * sessionModel;
@end
