//
//  GYSeachShopsHeadView.h
//  HSConsumer
//
//  Created by apple on 15/11/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BackMyBlock)(NSInteger tag, NSDictionary* dic);
@interface GYSeachShopsHeadView : UIView
@property (nonatomic, strong) UIView* bgView;
@property (nonatomic, strong) NSMutableArray* topArr; //顶部视图
@property (nonatomic, strong) NSMutableArray* btnArr; //按钮数组
@property(nonatomic, strong) BackMyBlock block;

@end
