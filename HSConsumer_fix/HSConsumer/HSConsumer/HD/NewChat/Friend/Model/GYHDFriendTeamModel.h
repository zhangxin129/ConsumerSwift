//
//  GYHDFriendTeamModel.h
//  HSConsumer
//
//  Created by shiang on 16/3/21.
//  Copyright © 2016年 GY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDFriendTeamModel : NSObject
/**teamID*/
@property (nonatomic, copy) NSString* teamID;
/**teamName*/
@property (nonatomic, copy) NSString* teamName;

- (instancetype)initWithDict:(NSDictionary*)dict;
@end
