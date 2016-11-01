//
//  GYSelectedButton.h
//  GYRestaurant
//
//  Created by kuser on 15/10/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYSelectedButton;
@protocol GYSelectedButtonDelegate<NSObject>

- (void)GYSelectedButtonDidClick:(GYSelectedButton *) btn withContent :(NSString *)content;

@end

@interface GYSelectedButton : UIButton
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) UIPopoverArrowDirection direction;
@property (nonatomic, assign) BOOL hiddenBackGround;

@property (nonatomic, weak)  id<GYSelectedButtonDelegate>delegate;

- (void)dataSourceArr:(NSMutableArray *)arr;
@end

