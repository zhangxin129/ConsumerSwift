//
//  GYHDSaleNetWorkOperModel.m
//  GYRestaurant
//
//  Created by apple on 16/6/16.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSaleNetWorkOperModel.h"

@implementation GYHDSaleNetWorkOperModel
- (NSMutableArray *)operGroupArray {
    if (!_operGroupArray) {
        _operGroupArray = [NSMutableArray array];
    }
    return _operGroupArray;
}
@end
