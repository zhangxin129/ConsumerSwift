//
//  GYImageTextFieldItem.m
//  GYCompany
//
//  Created by cook on 15/9/20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYImageTextFieldItem.h"



@implementation GYImageTextFieldItem

#pragma mark - 系统方法
- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

#pragma mark - 自定义方法
/**
 *  初始化方法
 */
- (void)setup
{

    UIImageView *icon = [[UIImageView alloc]init];
    [self addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@30);
  
    }];
    
    UITextField *textField = [[UITextField alloc]init];
    [self addSubview:textField];

    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).offset(30);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_bottom).offset(20);
        make.height.equalTo(@30);
    }];

}
@end
