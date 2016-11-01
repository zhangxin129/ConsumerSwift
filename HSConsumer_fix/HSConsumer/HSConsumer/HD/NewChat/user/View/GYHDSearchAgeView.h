//
//  GYHDSearchAgeView.h
//  HSConsumer
//
//  Created by shiang on 16/3/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^defineChildBlock)(NSString* message);
@interface GYHDSearchAgeView : UIView
/**返回Block*/
@property (nonatomic, copy) defineChildBlock block;
/**选择数组*/
@property (nonatomic, strong) NSArray* chooseAgeArray;
/**选择提示*/
@property(nonatomic, copy) NSString *chooseTips;
@end
