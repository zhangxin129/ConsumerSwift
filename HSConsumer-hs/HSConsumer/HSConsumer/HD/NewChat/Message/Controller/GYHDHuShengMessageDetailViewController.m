//
//  GYHDHuShengMessageDetailViewController.m
//  HSConsumer
//
//  Created by shiang on 16/2/1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDHuShengMessageDetailViewController.h"
#import "Masonry.h"

@interface GYHDHuShengMessageDetailViewController ()

@end

@implementation GYHDHuShengMessageDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary* dict = [GYUtils stringToDictionary:self.messageBody].mutableCopy;
    //1. 消息头
    UILabel* messagetitleLabel = [[UILabel alloc] init];
    [messagetitleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.f]];
    [self.view addSubview:messagetitleLabel];
    [messagetitleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(10);
        make.width.height.mas_equalTo(100);
    }];
    messagetitleLabel.text = dict[@"msg_subject"];
    //2. 消息体
    UILabel* messageContentLabel = [[UILabel alloc] init];
    messageContentLabel.numberOfLines = 0;
    [self.view addSubview:messageContentLabel];
    [messagetitleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(messagetitleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.width.height.mas_equalTo(100);
    }];
    messageContentLabel.text = dict[@"msg_content"];


}

@end
