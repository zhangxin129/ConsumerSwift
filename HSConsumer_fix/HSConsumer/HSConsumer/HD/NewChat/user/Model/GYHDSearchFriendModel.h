//
//  GYHDSearchFriendModel.h
//  HSConsumer
//
//  Created by shiang on 16/3/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDSearchFriendModel : NSObject
/**英文图示*/
@property (nonatomic, copy) NSString* tipkeyString;
/**搜索提示*/
@property (nonatomic, copy) NSString* searchTips;
/**搜索结果*/
@property(nonatomic, copy) NSString *searchResults;
@end
