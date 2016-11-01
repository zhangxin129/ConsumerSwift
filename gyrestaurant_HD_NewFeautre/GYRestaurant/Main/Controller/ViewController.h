//
//  ViewController.h
//  GYCompany
//
//  Created by cook on 15/9/13.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewModel.h"



@interface ViewController : UIViewController<UITextFieldDelegate>




- (void)modelRequestNetwork : (ViewModel *)model : (void (^)
                                                    (id resultDic))success isIndicator : (BOOL)isIndicator;

- (void)customAlertView : (NSString *)title;


#pragma mark加载和重新加载数据
- (void)loadAndTapReloadNetData;


#pragma mark没网络默认显示
- (void)customNoNetWorkView;


- (void)pushViewController : (UIViewController *)viewController animated : (BOOL)animated;

- (void)notifyWithText : (NSString *)text;


- (NSArray *)popToViewControllerWithClassName:(NSString*)className animated:(BOOL)animated;
@end