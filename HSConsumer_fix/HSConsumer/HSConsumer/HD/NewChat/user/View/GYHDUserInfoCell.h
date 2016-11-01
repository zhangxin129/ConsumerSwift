//
//  GYHDUserInfoCell.h
//  HSConsumer
//
//  Created by shiang on 16/3/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHDUserInfoModel;
@interface GYHDUserInfoCell : UITableViewCell
@property (nonatomic, strong) GYHDUserInfoModel* model;
- (void)setIconWithImage:(UIImage*)image;
@end
