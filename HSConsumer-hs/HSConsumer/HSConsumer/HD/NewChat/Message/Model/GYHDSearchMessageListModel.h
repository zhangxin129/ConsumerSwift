//
//  GYHDSearchMessageListModel.h
//  HSConsumer
//
//  Created by shiang on 16/7/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDSearchMessageListModel : NSObject
/**头像*/
@property(nonatomic, copy)NSString *iconString;
/**昵称*/
@property(nonatomic, copy)NSString *nameString;
/**详细*/
@property(nonatomic, copy)NSString *detailString;
/**详细*/
@property(nonatomic, strong)NSMutableAttributedString *detailAttributedString;
/**时间*/
@property(nonatomic, copy)NSString *timeString;
@property(nonatomic, copy)NSString *custID;
@property(nonatomic, copy)NSString *messageBody;
@property(nonatomic, copy)NSString *messageID;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
