//
//  GYHDSeachMessageModel.h
//  HSConsumer
//
//  Created by shiang on 16/4/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDSeachMessageGroupModel : NSObject
@property (nonatomic, copy) NSString* seachTitle;
@property (nonatomic, strong) NSMutableArray* seachMessageArray;
@property (nonatomic, assign) BOOL showMore;
@end

@interface GYHDSeachMessageModel : NSObject
/**
 *  custID
 */
@property (nonatomic, strong) NSString* custID;
/**
 *  搜索名字
 */
@property (nonatomic, strong) NSMutableAttributedString* seachAttName;
/**
 *  搜索消息
 */
@property (nonatomic, copy) NSString* seachContent;
/**
 *  搜索名字
 */
@property (nonatomic, copy) NSString* seachName;

/**
 *  搜索头像
 */
@property (nonatomic, copy) NSString* seachIcon;
/**
 *  搜索消息体
 */
@property (nonatomic, strong) NSMutableAttributedString* seachAttContent;
/**
 *  搜索时间
 */
@property (nonatomic, copy) NSString* seachTime;
- (instancetype)initWithDict:(NSDictionary*)dict;
@end
