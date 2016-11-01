//
//  GYCommentViewController.h
//  HSConsumer
//
//  Created by appleliss on 15/9/23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
@protocol GYCommentViewControllerDelegate <NSObject>
- (void)setValut:(NSString*)value;

@end
#import <UIKit/UIKit.h>

@interface GYCommentViewController : GYViewController
@property (nonatomic, weak) id<GYCommentViewControllerDelegate> gydelegate;
@property (nonatomic, strong) UINavigationController* nv;
@property (nonatomic, strong) UITextView* mycommenttext;
@property (nonatomic, strong) UILabel* lab;
@property (nonatomic, strong) NSString* str;
@property (nonatomic) BOOL strtype; /// yes 餐厅 no 外卖
@end
