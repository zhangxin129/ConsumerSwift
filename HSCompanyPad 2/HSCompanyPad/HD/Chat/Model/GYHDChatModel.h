//
//  GYHDChatModel.h
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/8.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYHDChatBaseBodyModel.h"
#import "GYHDChatUserInfoModel.h"

@interface GYHDChatModel : NSObject
/**文字富文本*/
@property(nonatomic, strong)NSAttributedString *messageContentAttString;
/**普通文字*/
@property(nonatomic, copy)NSString *messageContentString;
/**消息接收时间*/
@property(nonatomic, copy)NSString *messageRecvTimeString;
/**消息头像*/
@property(nonatomic, strong)NSString *messageIconString;
/**展现方位*/
@property(nonatomic, assign)BOOL isRight;
/**消息代码 例如 [GYHDUtils chatText] */
@property(nonatomic, copy)NSString *chatType;
/**资源本地文件路径1*/
@property(nonatomic, copy)NSString *messageFileBasePath;
/**资源本地文件路径2*/
@property(nonatomic, copy)NSString *messageFileDetailPath;
/**资源网络文件路径1*/
@property(nonatomic, copy)NSString *messageNetWorkBasePath;
/**资源网络文件路径2*/
@property(nonatomic, copy)NSString *messageNetWorkDetailPath;
/**消息发送状态 例如 GYHDDataBaseCenterMessageSendStateSending*/
//@property(nonatomic, copy)NSString *messageSendState;
@property(nonatomic, assign)GYHDDataBaseCenterMessageSendStateOption messageSendState;
/**消息唯一ID*/
@property(nonatomic, copy)NSString *messageID;
/**消息体*/
@property(nonatomic, strong)GYHDChatBaseBodyModel *messageBody;
/**消息体(字符串 主要是关联订单和商品用到)*/
@property(nonatomic, copy)NSString *body;
/**图片*/
@property(nonatomic, strong)UIImage *messageImage;
/**文件读取*/
@property(nonatomic, copy)NSString *fileRead;
/**好友基本信息*/
@property(nonatomic, strong)GYHDChatUserInfoModel *infoModel;
@end
