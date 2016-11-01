//
//  GYHDCustomerServiceListModel.h
//  HSCompanyPad
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDCustomerServiceListModel : NSObject
@property(nonatomic,copy)NSString*sessionId;//会话id
@property(nonatomic,copy)NSString*sessionState;//会话状态
@property(nonatomic,copy)NSString*customerServiceListStr;//客服数组
@property(nonatomic,copy)NSString*sessionTimeListStr;//时间数组
@property(nonatomic,copy)NSString*operId;//操作号
-(void)initWithDict:(NSDictionary*)dict;
@end
