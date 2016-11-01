//
//  GYHEShopFoodCartCell.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHEShopFoodCartCell : UITableViewCell

@property (nonatomic, copy) NSString* num;
@property (nonatomic, assign) NSInteger maxNum;
@property (nonatomic, copy)void (^deleteRowBlock)();

@end
