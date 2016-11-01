//
//  GYGoodComments.h
//  HSConsumer
//
//  Created by apple on 14-12-2.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
//商品评价列表里面的 cell内容。
@interface GYGoodComments : NSObject
@property (nonatomic, copy) NSString* strUserIconURL;
@property (nonatomic, copy) NSString* strUserName;
@property (nonatomic, copy) NSString* strComments;
@property (nonatomic, copy) NSString* strGoodName;
@property (nonatomic, copy) NSString* strGoodType;
@property (nonatomic, copy) NSString* strIdstring;
@property (nonatomic, copy) NSString* strTime; /////新增时间  by liss
@property (nonatomic, assign) CGFloat contentHeight;// songjk 内容高度
@end
