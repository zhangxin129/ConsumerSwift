//
//  GYHDFriendGroupModel.h
//  HSConsumer
//
//  Created by shiang on 16/3/21.
//  Copyright © 2016年 GY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDFriendGroupModel : NSObject
/**好友Title*/
@property (nonatomic, copy) NSString* friendGroupTitle;
/**好友数组*/
@property (nonatomic, strong) NSMutableArray* friendGroupArray;
@end
