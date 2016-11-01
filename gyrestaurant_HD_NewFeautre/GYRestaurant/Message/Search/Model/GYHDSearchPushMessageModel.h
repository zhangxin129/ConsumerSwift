//
//  GYHDSearchPushMessageModel.h
//  GYRestaurant
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface GYHDSearchPushMessageModel : NSObject
@property(nonatomic,copy)NSString*titleName;//消息标题
@property(nonatomic,copy)NSString*content;//消息内容、摘要
@property(nonatomic,copy)NSString*time;//发送时间
@property(nonatomic,copy)NSString*pageUrl;//发送图片
@property(nonatomic,copy)NSString*msgCode;//消息编码
@property(nonatomic,copy)NSString*kerWord;
-(void)initWithDict:(NSDictionary*)dict;
@end
