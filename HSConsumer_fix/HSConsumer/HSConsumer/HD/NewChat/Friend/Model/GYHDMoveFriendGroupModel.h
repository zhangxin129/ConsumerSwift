//
//  GYHDMoveFriendGroupModel.h
//  HSConsumer
//
//  Created by shiang on 16/3/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDMoveFriendGroupModel : NSObject
/**移动好友标题*/
@property (nonatomic, copy) NSString* moveFriendTitle;
/**移动好友数组*/
@property (nonatomic, strong) NSMutableArray* moveFriendArray;
@end

@interface GYHDMoveFriendModel : NSObject
/**是否是当前组*/
@property (nonatomic, assign) BOOL TeamSelf;
/**选中状态*/
@property (nonatomic, assign) BOOL moveFriendSelectState;
/**好友ID*/
@property (nonatomic, copy, readonly) NSString* moveFriendAccountID;
/**好友头像*/
@property (nonatomic, copy, readonly) NSString* moveFriendIconUrl;
/**好友昵称*/
@property (nonatomic, copy, readonly) NSString* moveFriendNikeName;
/**好友TeamID*/
@property (nonatomic, copy, readonly) NSString* moveFriendTeamID;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
