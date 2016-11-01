//
//  GYHDReplyModel.h
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDReplyModel : NSObject
/**标题*/
@property(nonatomic, copy)NSString *titleString;
/**正文*/
@property(nonatomic, copy)NSString *contentString;
/**更新时间*/
@property(nonatomic, copy)NSString *updateTimeString;
/**创建时间*/
@property(nonatomic, copy)NSString *createTimeString;
/**默认*/
@property(nonatomic, copy)NSString *isDefault;
/**custID*/
@property(nonatomic, copy)NSString *entCustID;
/**快捷回复ID*/
@property(nonatomic, copy)NSString *messageID;
@end
