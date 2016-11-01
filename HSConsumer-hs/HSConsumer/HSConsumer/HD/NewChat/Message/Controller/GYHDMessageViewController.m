//
//  GYHDGroupMessageViewController.m
//  HSConsumer
//
//  Created by shiang on 16/1/4.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDMessageViewController.h"
#import "GYHDMessageCenter.h"
#import "GYHDMessageModel.h"
#import "GYHDMessageCell.h"
#import "GYHDBasicViewController.h"
#import "GYHDPopView.h"
#import "GYHDPopMessageTopView.h"

@interface GYHDMessageViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray* MessageArrayM;
@property (nonatomic, weak) UITableView* lastMessageView;
@property (nonatomic, weak) UILabel* zeroMessageLabel;
@end

@implementation GYHDMessageViewController

- (NSMutableArray*)MessageArrayM
{
    if (!_MessageArrayM) {
        _MessageArrayM = [NSMutableArray array];
    }
    return _MessageArrayM;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //1. 添加最后已条信息控制器

    UITableView* lastMessageView = [[UITableView alloc] init];
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc]
        initWithTarget:self
                action:@selector(longPressGestureRecognized:)];
    [lastMessageView addGestureRecognizer:longPress];
    lastMessageView.delegate = self;
    lastMessageView.dataSource = self;
    lastMessageView.backgroundColor = [UIColor colorWithRed:235.0 / 255.0f green:235.0 / 255.0f blue:235.0 / 255.0f alpha:1.0f];
    [lastMessageView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [lastMessageView registerClass:[GYHDMessageCell class] forCellReuseIdentifier:@"GYHDMessageCellID"];
    [self.view addSubview:lastMessageView];
    _lastMessageView = lastMessageView;
    [lastMessageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    UILabel* zeroMessageLabel = [[UILabel alloc] init];
    zeroMessageLabel.text = [GYUtils localizedStringWithKey:@"GYHD_zero_message"];
    zeroMessageLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    zeroMessageLabel.textColor = [UIColor grayColor];
    [self.view addSubview:zeroMessageLabel];
    _zeroMessageLabel = zeroMessageLabel;
    WS(weakSelf);
    [zeroMessageLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.center.equalTo(weakSelf.view);
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[GYHDMessageCenter sharedInstance] addDataBaseChangeNotificationObserver:self selector:@selector(messageCenterDataBaseChage)];
    [self messageCenterDataBaseChage];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[GYHDMessageCenter sharedInstance] removeDataBaseChangeNotificationWithObserver:self];
}

- (void)messageCenterDataBaseChage
{
    //1. 查询数据库
    if (globalData.isLogined) {
        NSMutableArray* messageArray = [NSMutableArray array];
        for (NSDictionary* lastDict in [[GYHDMessageCenter sharedInstance] selectLastGroupMessage]) {
            GYHDMessageModel* lastMsgModel = [GYHDMessageModel messageModelWithDictionary:lastDict];
            [messageArray addObject:lastMsgModel];
        }
        //2. 刷表
        NSSortDescriptor* dateSort = [NSSortDescriptor sortDescriptorWithKey:@"messgeTopString" ascending:NO];
        [messageArray sortUsingDescriptors:@[ dateSort ]];
        self.MessageArrayM = messageArray;
        if (self.MessageArrayM.count > 0) {

            self.zeroMessageLabel.hidden = YES;
        }
        else {

            self.zeroMessageLabel.hidden = NO;
        }
        [self.lastMessageView reloadData];
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.MessageArrayM.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    GYHDMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDMessageCellID"];
    cell.messageModel = self.MessageArrayM[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 68.0f;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    GYHDMessageModel* lastMsgMode = self.MessageArrayM[indexPath.row];
    [[GYHDMessageCenter sharedInstance] ClearUnreadMessageWithCard:lastMsgMode.messageCard];
    GYHDBasicViewController* NextVC = [[lastMsgMode.pushNextController alloc] init];
    NextVC.messageCard = lastMsgMode.messageCard;
    NextVC.title = [NSString stringWithFormat:@"%@", lastMsgMode.userNameStr];
    NextVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:NextVC animated:YES];
}

- (void)longPressGestureRecognized:(UILongPressGestureRecognizer*)longPress
{
    if (longPress.state != UIGestureRecognizerStateBegan)
        return;
    CGPoint location = [longPress locationInView:self.lastMessageView];
    NSIndexPath* indexPath = [self.lastMessageView indexPathForRowAtPoint:location];
    if (!indexPath)
        return;
    GYHDMessageModel* messageModel = self.MessageArrayM[indexPath.row];

    NSArray* messageArray = @[ [GYUtils saftToNSString:messageModel.userNameStr],
        messageModel.messageState == GYHDPopMessageStateClearTop ? [GYUtils localizedStringWithKey:@"GYHD_clear_message_top"] : [GYUtils localizedStringWithKey:@"GYHD_message_top"],
        [GYUtils localizedStringWithKey:@"GYHD_delete_message"] ];
    GYHDPopMessageTopView* messageTopView = [[GYHDPopMessageTopView alloc] initWithMessageArray:messageArray];
    [messageTopView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(230, 137.0f));
    }];
    GYHDPopView* topView = [[GYHDPopView alloc] initWithChlidView:messageTopView];
    messageTopView.block = ^(NSString* messageString) {
        if ([messageString isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_message_top"]]) {

            if ([[GYHDMessageCenter sharedInstance] selectCountMessageTop] > 25) {

                [GYUtils showToast:[GYUtils localizedStringWithKey:@"GYHD_Message_top_25_tips"] duration:1.0 position:CSToastPositionCenter];
            }else {
                [[GYHDMessageCenter sharedInstance] messageTopWithMessageCard:messageModel.messageCard];
            }

        }else if ([messageString isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_clear_message_top"]]) {
            [[GYHDMessageCenter sharedInstance] messageClearTopWithMessageCard:messageModel.messageCard];
        }else if ([messageString isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_delete_message"]]) {
            [[GYHDMessageCenter sharedInstance] setMessageHidenWithCustID:messageModel.messageCard];
            [[GYHDMessageCenter sharedInstance] messageClearTopWithMessageCard:messageModel.messageCard];

            [self messageCenterDataBaseChage];
        }
        [topView disMiss];
    };
    [topView showToView:self.navigationController.view];

}

@end

//            if (messageModel.messageCard.integerValue != GYHDProtobufMessageChat ) {
//                NSMutableDictionary *deleteDict = [NSMutableDictionary dictionary];
////                deleteDict[GYHDDataBaseCenterPushMessagePlantFromID] = @"";
//                deleteDict[GYHDDataBaseCenterPushMessagePlantFromID] = messageModel.messageCard;
//                [[GYHDMessageCenter sharedInstance] deleteInfoWithDict:deleteDict TableName:GYHDDataBaseCenterPushMessageTableName];
//
//            }else {
//                [[GYHDMessageCenter sharedInstance]deleteMessageWithMessageCard:messageModel.messageCard];
//            }