//
//  GYHDSessionRecordModel.h
//  HSCompanyPad
//
//  Created by apple on 16/10/12.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDSessionRecordModel : NSObject
@property(nonatomic,copy)NSString * csOperNo;//客服编号
@property(nonatomic,copy)NSString * fromId;//消息发送id
@property(nonatomic,copy)NSString * msgContent;//消息内容
@property(nonatomic,copy)NSString * receiverHeadIcon;//接受者头像
@property(nonatomic,copy)NSString * receiverNickName;//接收者昵称
@property(nonatomic,copy)NSString * sendTime;//发送时间戳
@property(nonatomic,copy)NSString * sendTimeFormat;//发送时间格式化显示
@property(nonatomic,copy)NSString * senderHeadIcon;//发送者头像
@property(nonatomic,copy)NSString * senderNickName;//发送者昵称
@property(nonatomic,copy)NSString * toId;//toid
@property(nonatomic,assign)BOOL isRight;//是否居右显示
/**文字富文本*/
@property(nonatomic, strong)NSAttributedString *messageContentAttString;
/**资源网络文件路径1*/
@property(nonatomic, copy)NSString *messageNetWorkBasePath;
/**资源网络文件路径2*/
@property(nonatomic, copy)NSString *messageNetWorkDetailPath;

/**资源本地文件路径1*/
@property(nonatomic, copy)NSString *messageFileBasePath;
/**资源本地文件路径2*/
@property(nonatomic, copy)NSString *messageFileDetailPath;

/**消息代码 例如 [GYHDUtils chatText] */
@property(nonatomic, copy)NSString *chatType;

@property(nonatomic, assign) NSTimeInterval lastTime;

-(void)initWithDict:(NSDictionary*)dict;
@end
