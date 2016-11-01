//
//  GYHDAttentionIndustryModel.h
//  HSConsumer
//
//  Created by shiang on 16/3/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDAttentionIndustryModel : NSObject
/**行业ID*/
@property (nonatomic, weak) NSString* industryID;
/**行业标题*/
@property (nonatomic, weak) NSString* industryTitle;
/**行业副标题*/
@property (nonatomic, weak) NSString* industrySubtitle;
/**行业图片*/
@property (nonatomic, weak) NSString* industryImageUrl;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
