//
//  GYHEMapSearchAddressCell.h
//  HSConsumer
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHEMapSearchAddressModel;
static NSString* GYHEMapSearchCell = @"GYHEMapSearchCell";
@interface GYHEMapSearchAddressCell : UITableViewCell
@property (nonatomic,strong) GYHEMapSearchAddressModel * model;
@end
