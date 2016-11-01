//
//  GYHDApplicantListModel.h
//  HSConsumer
//
//  Created by shiang on 16/4/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDApplicantListModel : NSObject
/**消息ID*/
@property (nonatomic, copy) NSString* applicantMessageID;
/**头像*/
@property (nonatomic, copy) NSString* applicantHeadImageUrlString;
/**昵称*/
@property (nonatomic, copy) NSString* applicantNikeNameString;
/**用户状态*/
@property (nonatomic, assign) NSInteger applicantUserStatus;
/**好友ID*/
@property (nonatomic, copy) NSString* applicantID;
/**提示*/
@property (nonatomic, copy) NSString* applicantCont;
@property (nonatomic, copy) NSString* applicantCode;
@property (nonatomic, copy) NSString* applicantBody;
- (instancetype)initWithDict:(NSDictionary*)dict;
@end
