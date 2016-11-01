//
//  GYEasybuyShopAddressCell.h
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEasybuyShopAddressModel.h"

@interface GYEasybuyShopAddressCell : UITableViewCell

@property (nonatomic, strong) GYEasybuyShopAddressModel* model;
@property (nonatomic, copy) void (^block)(NSString* str);

@end
