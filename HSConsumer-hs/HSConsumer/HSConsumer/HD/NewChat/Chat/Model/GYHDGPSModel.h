//
//  GYHDGPSModel.h
//  HSConsumer
//
//  Created by shiang on 16/7/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDGPSModel : NSObject
/**检索标题*/
@property(nonatomic, copy)NSString *title;
/**检索地址*/
@property(nonatomic, copy)NSString *address;
/**位置*/
@property(nonatomic, assign)CLLocationCoordinate2D pt;
/**是否选择*/
@property(nonatomic, assign)BOOL selectState;
@property(nonatomic, copy)NSString *latitude;
@property(nonatomic, copy)NSString *longitude;
@property(nonatomic, copy)NSString *city;
@end
