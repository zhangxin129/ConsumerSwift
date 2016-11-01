//
//  GYHDSaleNetWorkOperModel.h
//  GYRestaurant
//
//  Created by apple on 16/6/16.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDSaleNetWorkOperModel : NSObject
/**
 *好友Title
 */
@property(nonatomic, copy) NSString * operGroupTitle;
/**
 *好友数组
 */
@property(nonatomic, strong) NSMutableArray *operGroupArray;
@end
