//
//  GYHEShopFoodListCell.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHEShopFoodListCell : UITableViewCell

@property (nonatomic, copy) NSString* num;
@property (nonatomic, assign) NSInteger maxNum;

@property (nonatomic, copy)void(^changeCountBlock)(NSString* num);

@end
