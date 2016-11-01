//
//  GYHDBindHSViewController.m
//  HSConsumer
//
//  Created by shiang on 16/1/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDBindHSViewController.h"
#import "GYHDMessageCenter.h"
#import "GYHDPopDeleteTeamView.h"
#import "GYHDPopView.h"

@interface GYHDBindHSViewController ()
@property (nonatomic, strong) NSMutableDictionary* messageDict;
@property (nonatomic, weak) UIButton* agreeButton;
@end

@implementation GYHDBindHSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _messageDict = [GYUtils stringToDictionary:self.messageBody].mutableCopy;
    self.title = [GYUtils localizedStringWithKey:@"GYHD_Company_Binding_husheng"];
    //1. 消息标题
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [self.view addSubview:titleLabel];
    //2. 消息时间
    UILabel* timerLabel = [[UILabel alloc] init];
    timerLabel.font = [UIFont systemFontOfSize:11.0f];
    timerLabel.textColor = [UIColor colorWithRed:153.0f / 255.0f green:153.0f / 255.0f blue:153.0f / 255.0f alpha:1];
    [self.view addSubview:timerLabel];
    //3. 消息正文
    UILabel* contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:12.0f];
    contentLabel.numberOfLines = 0;
    [self.view addSubview:contentLabel];

    //4. 确认按钮
    UIButton* agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeButton setBackgroundImage:[UIImage imageNamed:@"gyhd_argee_btn_Highlighte"] forState:UIControlStateNormal];
//    [agreeButton setBackgroundImage:[UIImage imageNamed:@"gyhd_argee_btn_Highlighte"] forState:UIControlStateHighlighted];
    [agreeButton setBackgroundImage:[UIImage imageNamed:@"gyhd_ignore_btn_normal"] forState:UIControlStateSelected];
    [agreeButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_Friend_agree"] forState:UIControlStateNormal];
    [agreeButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_Company_Binding_already_success"] forState:UIControlStateSelected];
    [agreeButton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreeButton];
    _agreeButton = agreeButton;
    titleLabel.text = _messageDict[@"msg_subject"];
    NSDictionary* dict = [GYUtils stringToDictionary:_messageDict[@"msg_content"]];
    //    timerLabel.text = dict[@"msgTime"];
    contentLabel.text = [NSString stringWithFormat:[GYUtils localizedStringWithKey:@"GYHD_Company_Binding_husheng_tips"], dict[@"entResNo"], dict[@"name"]];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    [timerLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);

    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(timerLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    [agreeButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    if (_messageDict[@"agreen"]) {
        agreeButton.selected = YES;
        agreeButton.userInteractionEnabled = NO;
    }
    else {
        agreeButton.selected = NO;
        agreeButton.userInteractionEnabled = YES;
    }
}

- (void)btnClick
{

    GYHDPopDeleteTeamView* deleteTeamView = [[GYHDPopDeleteTeamView alloc] init];
    [deleteTeamView setTitle:[GYUtils localizedStringWithKey:@"GYHD_Company_Binding_Husheng_confirm"] Content:[GYUtils localizedStringWithKey:@"GYHD_Company_Binding_Husheng_confirm_tips"]];
    [deleteTeamView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(230, 137.0f));
    }];
    WS(weakSelf);
    GYHDPopView* topView = [[GYHDPopView alloc] initWithChlidView:deleteTeamView];
    deleteTeamView.block = ^(NSString* message) {
        if (message)  {
            NSDictionary *dict = [GYUtils stringToDictionary:_messageDict[@"msg_content"]];
            [[GYHDMessageCenter sharedInstance]bindCompanyWithDict:dict RequetResult:^(NSDictionary *resultDict) {
                [GYUtils showToast:resultDict[@"msg"] duration:1.0f position:CSToastPositionCenter];
                if ([[resultDict[@"retCode"] stringValue] isEqualToString:@"200"]) {
                    weakSelf.agreeButton.selected = YES;
                    weakSelf.agreeButton.userInteractionEnabled = NO;
                    _messageDict[@"agreen"] = @"1";
                    NSMutableDictionary *condDict = [NSMutableDictionary dictionary];
                    condDict[GYHDDataBaseCenterPushMessageID] = weakSelf.messageID;
                    NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
                    updateDict[GYHDDataBaseCenterPushMessageBody] = [GYUtils dictionaryToString:_messageDict];
                    updateDict[GYHDDataBaseCenterPushMessageContent] = [GYUtils dictionaryToString:_messageDict];
                    [[GYHDMessageCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:condDict TableName:GYHDDataBaseCenterPushMessageTableName];
                }
            }];
        }
        [topView disMiss];
    };
    [topView showToView:self.navigationController.view];
    //    [UIAlertView showWithTitle:nil message:@"是否绑定？" cancelButtonTitle:kLocalized(@"cancel") otherButtonTitles:@[kLocalized(@"")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
    //        if (buttonIndex != 0) {
    //            NSDictionary *dict = [GYUtils stringToDictionary:_messageDict[@"msg_content"]];
    //            [[GYHDMessageCenter sharedInstance]bindCompanyWithDict:dict RequetResult:^(NSDictionary *resultDict) {
    //                UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    //                [GYUtils showToast:resultDict[@"msg"] duration:0.25 position:CSToastPositionCenter];
    //                if ([[resultDict[@"retCode"] stringValue] isEqualToString:@"200"]) {
    //                    self.agreeButton.selected = YES;
    //                    self.agreeButton.userInteractionEnabled = NO;
    //                    _messageDict[@"agreen"] = @"1";
    //                    NSMutableDictionary *condDict = [NSMutableDictionary dictionary];
    //                    condDict[GYHDDataBaseCenterPushMessageID] = self.messageID;
    //                    NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
    //                    updateDict[@"PUSH_MSG_Body"] = [GYUtils dictionaryToString:_messageDict];
    //                    updateDict[@"PUSH_MSG_Content"] = [GYUtils dictionaryToString:_messageDict];
    //                    [[GYHDMessageCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:condDict TableName:GYHDDataBaseCenterPushMessageTableName];
    //                }
    //            }];
    //        }
    //    }];
}

@end
