//
//  GYHDChatViewController.m
//  HSConsumer
//
//  Created by shiang on 15/12/30.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDChatViewController.h"
#import "GYHDMessageCenter.h"
//#import "GYHDChatViewCell.h"
//#import "GYHDChatModel.h"
//#import "GYHDNewChatCell.h"
#import "GYHDInputView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "GYHDNewChatModel.h"
#import "GYHDLeftChatTextCell.h"
#import "GYHDRightChatTextCell.h"
#import "GYHDLeftChatImageCell.h"
#import "GYHDRightChatImageCell.h"
#import "GYHDLeftChatVideoCell.h"
#import "GYHDRightChatVideoCell.h"
#import "GYHDLeftChatAudioCell.h"
#import "GYHDRightChatAudioCell.h"
#import "GYHDRelatedGoodsCell.h"
#import "GYHDRelatedOrderCell.h"
#import "GYHDLeftChatMapCell.h"
#import "GYHDRightChatMapCell.h"

#import "GYHDAudioTool.h"
#import "GYHDChatImageShowView.h"
#import "GYHDChatVideoShowView.h"
#import "GYHDUserInfoViewController.h"
#import "GYHDFriendDetailViewController.h"
#import "GYHDPopMoreView.h"
#import "GYShopAboutViewController.h"
#import "GYHDPopDeleteTeamView.h"
#import "GYHDPopView.h"
#import "IQKeyboardManager.h"
#import "GYHDGPSViewController.h"
#import "GYHDShowMapViewController.h"
static NSInteger const selectChatCount = 5;
@interface GYHDChatViewController () <UITableViewDelegate, UITableViewDataSource, GYHDInputViewDelegate, GYHDChatDelegate>
/**
 * 聊天消息控制器
 */
@property (nonatomic, weak) UITableView* chatTableView;
/**
 * 记录聊天内容的数组
 */
@property (nonatomic, strong) NSMutableArray* chatArrayM;
/**
 * 发送者ID
 */
@property (nonatomic, copy) NSString* sendMessageID;
/**
 * 接收者ID
 */
@property (nonatomic, copy) NSString* recvMessageID;
/**
 * 输入条
 */
@property (nonatomic, weak) GYHDInputView* chatInputView;
/**记录左边上次播放的音频的View*/
@property (nonatomic, weak) GYHDLeftChatAudioCell* leftAudioCell;
/**记录右边上次播放的音频的View*/
@property (nonatomic, weak) GYHDRightChatAudioCell* rightAudioCell;
/**
 *  商品ID;
 */
@property (nonatomic, strong) NSString* shopID;
@property(nonatomic, assign)BOOL searchBool;
@end

@implementation GYHDChatViewController

- (NSMutableArray*)chatArrayM
{
    if (!_chatArrayM) {
        _chatArrayM = [NSMutableArray array];
    }
    return _chatArrayM;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245 / 255.0f green:245 / 255.0f blue:245 / 255.0f alpha:1];
    WS(weakSelf);
    UITableView* chatTableView = [[UITableView alloc] init];
    chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    chatTableView.delegate = self;
    chatTableView.dataSource = self;
    chatTableView.backgroundColor = [UIColor colorWithRed:245 / 255.0f green:245 / 255.0f blue:245 / 255.0f alpha:1];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [chatTableView registerClass:[GYHDLeftChatTextCell class] forCellReuseIdentifier:@"GYHDLeftChatTextCellID"];
    [chatTableView registerClass:[GYHDRightChatTextCell class] forCellReuseIdentifier:@"GYHDRightChatTextCellID"];
    [chatTableView registerClass:[GYHDLeftChatImageCell class] forCellReuseIdentifier:@"GYHDLeftChatImageCellID"];
    [chatTableView registerClass:[GYHDRightChatImageCell class] forCellReuseIdentifier:@"GYHDRightChatImageCellID"];
    [chatTableView registerClass:[GYHDLeftChatVideoCell class] forCellReuseIdentifier:@"GYHDLeftChatVideoCellID"];
    [chatTableView registerClass:[GYHDRightChatVideoCell class] forCellReuseIdentifier:@"GYHDRightChatVideoCellID"];
    [chatTableView registerClass:[GYHDLeftChatAudioCell class] forCellReuseIdentifier:@"GYHDLeftChatAudioCellID"];
    [chatTableView registerClass:[GYHDRightChatAudioCell class] forCellReuseIdentifier:@"GYHDRightChatAudioCellID"];
    [chatTableView registerClass:[GYHDRelatedGoodsCell class] forCellReuseIdentifier:@"GYHDRelatedGoodsCellID"];
    [chatTableView registerClass:[GYHDRelatedOrderCell class] forCellReuseIdentifier:@"GYHDRelatedOrderCellID"];
    [chatTableView registerClass:[GYHDLeftChatMapCell class] forCellReuseIdentifier:@"GYHDLeftChatMapCellID"];
    [chatTableView registerClass:[GYHDRightChatMapCell class] forCellReuseIdentifier:@"GYHDRightChatMapCellID"];
    [self.view addSubview:chatTableView];
    _chatTableView = chatTableView;
    [chatTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(kScreenHeight - 105 -64);
    }];
    //1. 输入View
    GYHDInputView* chatInputView = [[GYHDInputView alloc] init];
    chatInputView.delegate = self;
    [self.view addSubview:chatInputView];
    _chatInputView = chatInputView;

    [chatInputView showToSuperView:self.view];
    NSDictionary* myDict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
    if (myDict[@"Friend_ID"]) {
        self.sendMessageID = [NSString stringWithFormat:@"m_%@@im.gy.com/mobile_im", myDict[@"Friend_ID"]];
    }
    else {

        if (globalData.loginModel.cardHolder) {
            self.sendMessageID = [NSString stringWithFormat:@"m_c_%@@im.gy.com/mobile_im", globalData.loginModel.custId];
        }
        else {
            self.sendMessageID = [NSString stringWithFormat:@"m_nc_%@@im.gy.com/mobile_im", globalData.loginModel.custId];
        }
    }
    //. 添加通知
    [self addObserver];
    IQKeyboardManager* manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.enableAutoToolbar = NO;
    [self setupRefresh];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.chatArrayM.count && !self.searchBool) {
            [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArrayM.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    });

}
- (void)dealloc {
    IQKeyboardManager* manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.enableAutoToolbar = YES;
    [[GYHDMessageCenter sharedInstance] ClearUnreadMessageWithCard:self.messageCard];
    [self.chatInputView removeObserver:self forKeyPath:@"center"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setSearchID:(NSString *)searchID {
    _searchID = searchID;
    _searchBool = YES;
}
/**点击咨询*/
- (void)setCompanyInformationDict:(NSDictionary*)companyInformationDict
{
    _companyInformationDict = companyInformationDict;
    NSDictionary* myDict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
    //    NSString *custIDString = companyInformationDict[@"messageCard"];
    NSDictionary* dataDict = companyInformationDict[@"data"];
    NSString* custIDString = dataDict[@"messageCard"];
    self.navigationItem.title = dataDict[@"vShopName"];
    self.shopID = dataDict[@"vShopId"];

    NSMutableDictionary* selectDict = [NSMutableDictionary dictionary];
    selectDict[GYHDDataBaseCenterMessageCard] = custIDString;
    NSArray* selectArray = [[GYHDMessageCenter sharedInstance] selectInfoWithDict:selectDict TableName:GYHDDataBaseCenterMessageTableName];
    //    NSDictionary *dict = [[GYHDMessageCenter sharedInstance] selectFriendBaseWithCardString:custIDString];

    self.recvMessageID = [NSString stringWithFormat:@"%@@im.gy.com", custIDString];

    self.messageCard = [self.recvMessageID substringWithRange:NSMakeRange(0, 19)];

    NSMutableDictionary* friendDict = [NSMutableDictionary dictionary];
    friendDict[GYHDDataBaseCenterFriendFriendID] = [NSString stringWithFormat:@"e_%@", custIDString];
    friendDict[GYHDDataBaseCenterFriendCustID] = self.messageCard;
    friendDict[GYHDDataBaseCenterFriendResourceID] = [self.messageCard substringToIndex:11];
    friendDict[GYHDDataBaseCenterFriendName] = dataDict[@"vShopName"];
    friendDict[GYHDDataBaseCenterFriendIcon] = dataDict[@"logo"];
    friendDict[GYHDDataBaseCenterFriendUsetType] = @"e";
    friendDict[GYHDDataBaseCenterFriendMessageType] = GYHDDataBaseCenterTemporaryBusiness;
    friendDict[GYHDDataBaseCenterFriendMessageTop] = @"-1";
    friendDict[GYHDDataBaseCenterFriendInfoTeamID] = self.shopID;
    friendDict[GYHDDataBaseCenterFriendBasic] = [GYUtils dictionaryToString:companyInformationDict];
    friendDict[GYHDDataBaseCenterFriendDetailed] = [GYUtils dictionaryToString:companyInformationDict];
    if (selectArray.count) {
        NSMutableDictionary* conditionDict = [NSMutableDictionary dictionary];
        conditionDict[GYHDDataBaseCenterFriendCustID] = self.messageCard;

        NSMutableDictionary* updateDict = [NSMutableDictionary dictionary];
        updateDict[GYHDDataBaseCenterFriendName] = dataDict[@"vShopName"];
        updateDict[GYHDDataBaseCenterFriendIcon] = dataDict[@"logo"];
        [[GYHDMessageCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterFriendTableName];
    }
    else {
        [[GYHDMessageCenter sharedInstance] insertInfoWithDict:friendDict TableName:GYHDDataBaseCenterFriendTableName];

        NSMutableDictionary* messageDict = [NSMutableDictionary dictionary];

        messageDict[GYHDDataBaseCenterMessageFromID] = [NSString stringWithFormat:@"%@@im.gy.com", custIDString];
        messageDict[GYHDDataBaseCenterMessageToID] = [NSString stringWithFormat:@"m_%@@im.gy.com/mobile_im", myDict[@"Friend_ID"]];
        long long t = ([[NSDate date] timeIntervalSince1970]) * 1000;
        messageDict[GYHDDataBaseCenterMessageID] = [NSString stringWithFormat:@"%lld", t];
        messageDict[GYHDDataBaseCenterMessageCode] = @(GYHDDataBaseCenterMessageTypeChat);
        messageDict[GYHDDataBaseCenterMessageCard] = custIDString;

        NSDate* date = [NSDate date];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* dateString = [formatter stringFromDate:date];

        messageDict[GYHDDataBaseCenterMessageSendTime] = dateString;
        messageDict[GYHDDataBaseCenterMessageRevieTime] = dateString;
        messageDict[GYHDDataBaseCenterMessageIsSelf] = @(0);
        messageDict[GYHDDataBaseCenterMessageIsRead] = @(0);
        messageDict[GYHDDataBaseCenterMessageSentState] = @(GYHDDataBaseCenterMessageSentStateSending);
        messageDict[GYHDDataBaseCenterMessageData] = @"-1";
        messageDict[GYHDDataBaseCenterMessageBody] = @"-1";
        messageDict[GYHDDataBaseCenterMessageFriendType] = @"e";
        NSString* contString = [NSString stringWithFormat:@"%@\n%@%@\n%@",
                                         friendDict[GYHDDataBaseCenterFriendName],
                                         [GYUtils localizedStringWithKey:@"GYHD_companyHuSheng"],
                                [[GYHDMessageCenter sharedInstance] segmentationHuShengCardWithCard: [friendDict[GYHDDataBaseCenterFriendCustID] substringToIndex:11]],
                                         [GYUtils localizedStringWithKey:@"GYHD_Welcome_To_Consult"]];
        messageDict[GYHDDataBaseCenterMessageContent] = contString;
        //        [[GYHDMessageCenter sharedInstance] saveMessageWithDict:messageDict];
        [[GYHDMessageCenter sharedInstance] insertInfoWithDict:messageDict TableName:GYHDDataBaseCenterMessageTableName];
    }
    // 判断是否有订单key
    if (companyInformationDict[@"orders"] && [companyInformationDict[@"orders"] isKindOfClass:[NSDictionary class]]) {
        
        NSMutableDictionary* messageDict = [NSMutableDictionary dictionary];
        
        messageDict[ GYHDDataBaseCenterMessageToID] = [NSString stringWithFormat:@"%@@im.gy.com", custIDString];
        messageDict[GYHDDataBaseCenterMessageFromID] = [NSString stringWithFormat:@"m_%@@im.gy.com/mobile_im", myDict[@"Friend_ID"]];
        long long t = ([[NSDate date] timeIntervalSince1970]) * 1000;
        messageDict[GYHDDataBaseCenterMessageID] = [NSString stringWithFormat:@"%lld", t];
        messageDict[GYHDDataBaseCenterMessageCode] = @(GYHDDataBaseCenterMessageChatOrder);
        messageDict[GYHDDataBaseCenterMessageCard] = custIDString;
        
        NSDate* date = [NSDate date];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* dateString = [formatter stringFromDate:date];
        
        messageDict[GYHDDataBaseCenterMessageSendTime] = dateString;
        messageDict[GYHDDataBaseCenterMessageRevieTime] = dateString;
        messageDict[GYHDDataBaseCenterMessageIsSelf] = @(0);
        messageDict[GYHDDataBaseCenterMessageIsRead] = @(0);
        messageDict[GYHDDataBaseCenterMessageSentState] = @(GYHDDataBaseCenterMessageSentStateSending);
        messageDict[GYHDDataBaseCenterMessageData] = @"-1";
        NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithDictionary:companyInformationDict[@"orders"]];
        bodyDict[@"msg_code"] = @"16";
        bodyDict[@"msg_type"] = @"2";
        bodyDict[@"msg_note"] = myDict[GYHDDataBaseCenterFriendName];
        bodyDict[@"msg_icon"] = myDict[GYHDDataBaseCenterFriendIcon];
        bodyDict[@"sub_msg_code"] = @"10101";
        messageDict[GYHDDataBaseCenterMessageBody] = [GYUtils dictionaryToString:bodyDict];
        messageDict[GYHDDataBaseCenterMessageFriendType] = @"e";

        messageDict[GYHDDataBaseCenterMessageContent] = [GYUtils localizedStringWithKey:@"GYHD_Chat_order_message"];
        [[GYHDMessageCenter  sharedInstance] sendMessageWithDictionary:messageDict resend:NO];

        
        
    }else if (companyInformationDict[@"goods"] && [companyInformationDict[@"goods"] isKindOfClass:[NSDictionary class]]) {

        NSMutableDictionary* messageDict = [NSMutableDictionary dictionary];
        
        messageDict[ GYHDDataBaseCenterMessageToID] = [NSString stringWithFormat:@"%@@im.gy.com", custIDString];
        messageDict[GYHDDataBaseCenterMessageFromID] = [NSString stringWithFormat:@"m_%@@im.gy.com/mobile_im", myDict[@"Friend_ID"]];
        long long t = ([[NSDate date] timeIntervalSince1970]) * 1000;
        messageDict[GYHDDataBaseCenterMessageID] = [NSString stringWithFormat:@"%lld", t];
        messageDict[GYHDDataBaseCenterMessageCode] = @(GYHDDataBaseCenterMessageChatGoods);
        messageDict[GYHDDataBaseCenterMessageCard] = custIDString;
        
        NSDate* date = [NSDate date];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* dateString = [formatter stringFromDate:date];
        
        messageDict[GYHDDataBaseCenterMessageSendTime] = dateString;
        messageDict[GYHDDataBaseCenterMessageRevieTime] = dateString;
        messageDict[GYHDDataBaseCenterMessageIsSelf] = @(0);
        messageDict[GYHDDataBaseCenterMessageIsRead] = @(0);
        messageDict[GYHDDataBaseCenterMessageSentState] = @(GYHDDataBaseCenterMessageSentStateSending);
        messageDict[GYHDDataBaseCenterMessageData] = @"-1";
        NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithDictionary:companyInformationDict[@"goods"]];
        bodyDict[@"msg_code"] = @"15";
        bodyDict[@"msg_type"] = @"2";
        bodyDict[@"msg_note"] =myDict[GYHDDataBaseCenterFriendName];
        bodyDict[@"msg_icon"] = myDict[GYHDDataBaseCenterFriendIcon];
        bodyDict[@"sub_msg_code"] = @"10101";
        messageDict[GYHDDataBaseCenterMessageBody] = [GYUtils dictionaryToString:bodyDict];
        messageDict[GYHDDataBaseCenterMessageFriendType] = @"e";
        
        messageDict[GYHDDataBaseCenterMessageContent] = [GYUtils localizedStringWithKey:@"GYHD_Chat_shop_message"];
        [[GYHDMessageCenter  sharedInstance] sendMessageWithDictionary:messageDict resend:NO];

        
    }
}
//        "msg_code":"15",
//        "msg_type":"2",
//        "msg_note":"呢称名字",
//        "msg_icon":"头像URL",
//        "prod_id":"商品ID",
//        "prod_name":"商品名称",
//        "prod_des":"商品描述",
//        "prod_price":"商品价格",
//        "prod_pv":"积分数",
//        "imageNailsUrl":"商品缩略图地址",
//        "sub_msg_code":"10101",
//- (void)dealloc {
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    NSLog(@"xxxx");
//}
- (void)setMessageCard:(NSString*)messageCard
{
    [super setMessageCard:messageCard];
    NSDictionary* dict = [[GYHDMessageCenter sharedInstance] selectFriendBaseWithCardString:messageCard];
    self.title = dict[@"Friend_Name"];
    if ([dict[@"Friend_MessageType"] isEqualToString:@"Friend"]) {
        self.recvMessageID = [NSString stringWithFormat:@"m_%@@im.gy.com", dict[@"Friend_ID"]];

        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton addTarget:self action:@selector(moreSelect:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"gyhd_nav_rightView_more"] forState:UIControlStateNormal];
        rightButton.frame = CGRectMake(0, 0, 33, 33);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    }
    else {
        if (!self.shopID) {
            NSDictionary* companyDict = [[GYHDMessageCenter sharedInstance] selectFriendBaseWithCardString:messageCard];
            self.shopID = companyDict[GYHDDataBaseCenterFriendInfoTeamID];
            self.recvMessageID = [NSString stringWithFormat:@"%@@im.gy.com", dict[@"Friend_CustID"]];
        }
    }
}

- (void)moreSelect:(UIButton*)button
{

    NSDictionary* myDict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
    NSDictionary* dict = [[GYHDMessageCenter sharedInstance] selectFriendBaseWithCardString:self.messageCard];
    NSDictionary* friendDict = [GYUtils stringToDictionary:dict[@"Friend_Basic"]];

    GYHDPopMoreView* popMoreView = [[GYHDPopMoreView alloc] init];
    popMoreView.moreSelectArray = @[ [GYUtils localizedStringWithKey:@"GYHD_clear_message"],
        [GYUtils localizedStringWithKey:@"GYHD_delete_friend"],
        [GYUtils localizedStringWithKey:@"GYHD_add_black"] ];
    [popMoreView show];
    WS(weakSelf);
    popMoreView.block = ^(NSString* message) {

        if ([message isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_clear_message"]]) {
            
            
            

            GYHDPopDeleteTeamView *deleteTeamView = [[GYHDPopDeleteTeamView alloc] init];
            [deleteTeamView setTitle:[GYUtils localizedStringWithKey:@"GYHD_clear_message"] Content:[GYUtils localizedStringWithKey:@"GYHD_clear_message_tips"]];
            [deleteTeamView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(230, 137.0f));
            }];
            WS(weakSelf);
            GYHDPopView *topView = [[GYHDPopView alloc] initWithChlidView:deleteTeamView];
            deleteTeamView.block = ^(NSString *message) {
                if (message) {
                    [[GYHDMessageCenter sharedInstance] deleteWithMessage:weakSelf.messageCard fieldName:GYHDDataBaseCenterMessageCard TableName:GYHDDataBaseCenterMessageTableName];
                    [weakSelf.chatArrayM removeAllObjects];
                    [weakSelf loadChat];
                }
                [topView disMiss];
            };
            [topView showToView:self.navigationController.view];
            
//            [[GYHDMessageCenter sharedInstance] deleteWithMessage:self.messageCard fieldName:GYHDDataBaseCenterMessageCard TableName:GYHDDataBaseCenterMessageTableName];
//            [self.chatArrayM removeAllObjects];
//            [self loadChat];
        } else if ([message isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_delete_friend"]]) {



            NSDictionary *myDict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
            NSDictionary *friendDict = [[GYHDMessageCenter sharedInstance] selectFriendBaseWithCardString:weakSelf.messageCard];
            GYHDPopDeleteTeamView *deleteTeamView = [[GYHDPopDeleteTeamView alloc] init];
            [deleteTeamView setTitle:[NSString stringWithFormat:[GYUtils localizedStringWithKey:@"GYHD_Friend_will_be_delete"], weakSelf.title] Content:[GYUtils localizedStringWithKey:@"GYHD_Friend_delete_tips"]];
            [deleteTeamView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(230, 137.0f));
            }];
            WS(weakSelf);
            GYHDPopView *topView = [[GYHDPopView alloc] initWithChlidView:deleteTeamView];
            deleteTeamView.block = ^(NSString *message) {
                if (message) {
                    NSMutableDictionary *insideDict = [NSMutableDictionary dictionary];
                    [insideDict setValue:myDict[@"Friend_ID"] forKey:@"accountId"];
                    [insideDict setValue:myDict[@"Friend_Name"] forKey:@"accountNickname"];
                    [insideDict setValue:myDict[@"Friend_Icon"] forKey:@"accountHeadPic"];
                    [insideDict setValue:friendDict[@"Friend_ID"] forKey:@"friendId"];
                    [insideDict setValue:friendDict[@"Friend_Name"] forKey:@"friendNickname"];
                    [insideDict setValue:@"4" forKey:@"friendStatus"];
                    [insideDict setValue:friendDict[@"Friend_Icon"] forKey:@"friendHeadPic"];

                    [[GYHDMessageCenter sharedInstance] deleteFriendWithDict:insideDict RequetResult:^(NSDictionary *resultDict) {
                        if (resultDict && [resultDict[@"retCode"] integerValue] == 200) {
                            NSMutableDictionary *deleteFriendDict = [NSMutableDictionary dictionary];
                            deleteFriendDict[GYHDDataBaseCenterFriendCustID] = friendDict[@"Friend_CustID"];
                            [[GYHDMessageCenter sharedInstance] deleteInfoWithDict:deleteFriendDict TableName:GYHDDataBaseCenterFriendTableName];

                            NSMutableDictionary *deleteMessageDict = [NSMutableDictionary dictionary];
                            deleteMessageDict[GYHDDataBaseCenterMessageCard] = friendDict[@"Friend_CustID"];
                            [[GYHDMessageCenter sharedInstance] deleteInfoWithDict:deleteMessageDict TableName:GYHDDataBaseCenterMessageTableName];
                            
                            NSMutableDictionary *delectDict = [NSMutableDictionary dictionary];
                            delectDict[GYHDDataBaseCenterPushMessageFromID] = friendDict[@"Friend_CustID"];
                            [[GYHDMessageCenter sharedInstance]deleteInfoWithDict:delectDict TableName:GYHDDataBaseCenterPushMessageTableName];
                            NSMutableDictionary *frienddeletedict = [NSMutableDictionary dictionary];
                            frienddeletedict[@"friendChange"] = @(11);
                            frienddeletedict[@"toID"] = friendDict[@"accountId"];
                            [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:frienddeletedict];
                            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                        }

                    }];
                }
                [topView disMiss];
            };
            [topView showToView:self.navigationController.view];
        } else if ([message isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_add_black"]]) {
            GYHDPopDeleteTeamView *deleteTeamView = [[GYHDPopDeleteTeamView alloc] init];
            [deleteTeamView setTitle:[NSString stringWithFormat:[GYUtils localizedStringWithKey:@"GYHD_Friend_move_in_blacklist"],weakSelf.title] Content:[GYUtils localizedStringWithKey:@"GYHD_Friend_move_in_blacklist_tips"]];
            [deleteTeamView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(230, 137.0f));
            }];
            WS(weakSelf)
            GYHDPopView *topView = [[GYHDPopView alloc] initWithChlidView:deleteTeamView];
            deleteTeamView.block = ^(NSString *message) {
                
                if (message) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    dict[@"teamId"] = @"blacklisted";
                    dict[@"userId"] =  myDict[@"Friend_ID"];
                    dict[@"friendId"] = friendDict[@"accountId"];
                    [[GYHDMessageCenter sharedInstance] MovieFriendWithDict:dict RequetResult:^(NSDictionary *resultDict) {
                        NSMutableDictionary *frienddeletedict = [NSMutableDictionary dictionary];
                        frienddeletedict[@"friendChange"] = @(11);
                        frienddeletedict[@"toID"] = friendDict[@"accountId"];
                        [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:frienddeletedict];
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    }];
                    
                }
                [topView disMiss];
            };
            [topView showToView:self.navigationController.view];
        }
        //        [popMoreView disMiss];
    };
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//
//    [self.chatArrayM removeAllObjects];
//
//    [self loadChat];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (self.chatArrayM.count && !self.searchBool) {
//            [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArrayM.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        }
//    });
//
//    //. 添加通知
//    [self addObserver];
//    IQKeyboardManager* manager = [IQKeyboardManager sharedManager];
//    manager.enable = NO;
//    manager.enableAutoToolbar = NO;
//}

- (void)ignoreClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**下拉刷新*/
- (void)setupRefresh
{

    WS(weakSelf);
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf loadChat];
        [weakSelf.chatTableView.mj_header endRefreshing];
    }];

    self.chatTableView.mj_header = header;
    [self.chatTableView.mj_header beginRefreshing];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//
//    self.navigationController.navigationBar.barTintColor = kNavBackgroundColor;
//
//    NSMutableDictionary *attDict = [NSMutableDictionary dictionary];
//    attDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:attDict];
//}

/**加载聊天记录*/
- (void)loadChat
{

    if (self.searchID ) {
        NSLog(@"xxxx");

        while (self.searchID) {
            NSMutableArray* array = [NSMutableArray array];
            for (NSDictionary* chatDict in [[GYHDMessageCenter sharedInstance] selectAllChatWithCard:self.messageCard frome:self.chatArrayM.count to:selectChatCount]) {
                GYHDNewChatModel* chatMode = [[GYHDNewChatModel alloc] initWithDictionary:chatDict];
                [array addObject:chatMode];
                if ([chatMode.chatMessageID isEqualToString:self.searchID]) {
                    self.searchID = nil;
               
                }
            }
            NSMutableArray* fristArray = [NSMutableArray arrayWithArray:self.chatArrayM];
            [array addObjectsFromArray:fristArray];
            self.chatArrayM = array;
        }
    }else {
        if ([self.messageCard isEqualToString:@""]||[self.messageCard isKindOfClass:[NSNull class]]) {
            
            //消息card为空
            // DDLogCError(@"消息card为空,不刷新数据库");
            return [GYUtils showMessage:@"消息card为空"];
        }
        //1. 查询数据库
        NSMutableArray* array = [NSMutableArray array];
        for (NSDictionary* chatDict in [[GYHDMessageCenter sharedInstance] selectAllChatWithCard:self.messageCard frome:self.chatArrayM.count to:selectChatCount]) {
            GYHDNewChatModel* chatMode = [[GYHDNewChatModel alloc] initWithDictionary:chatDict];
            [array addObject:chatMode];
        }
        NSMutableArray* fristArray = [NSMutableArray arrayWithArray:self.chatArrayM];
        [array addObjectsFromArray:fristArray];
        self.chatArrayM = array;
        [self.chatTableView reloadData];
        if (self.chatArrayM.count && self.chatArrayM.count <= selectChatCount ) {
            if (self.searchBool) {
                
            }else {
                [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArrayM.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }

        }
    }

}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary<NSString*, id>*)change context:(void*)context
{
    if ([keyPath isEqualToString:@"center"]) {

            CGRect rectInKey = [self.chatInputView convertRect:self.chatInputView.bounds toView:[self.chatInputView superview]];
            [self.chatTableView mas_remakeConstraints:^(MASConstraintMaker* make) {
                make.top.left.right.mas_equalTo(0);
                make.height.mas_equalTo(rectInKey.origin.y);
            }];
            [self.chatTableView layoutIfNeeded];
        if (self.chatArrayM.count > 0) {
            [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArrayM.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

- (void)addObserver
{

    [self.chatInputView addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
    [[GYHDMessageCenter sharedInstance] addDataBaseChangeNotificationObserver:self selector:@selector(messageCenterDataBaseChagne:)];
}

- (void)messageCenterDataBaseChagne:(NSNotification*)noti
{
    NSDictionary* dict = noti.object;
    if (dict[@"State"] && dict[@"msgID"]) { //  更新数据
        int count = self.chatArrayM.count;
        for (int i = 0 ; i < count ; i++) {
            GYHDNewChatModel* model = self.chatArrayM[i];
            if ([model.chatMessageID isEqualToString:dict[@"msgID"]]) {
                model.chatSendState = [dict[@"State"] integerValue];
                NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                [self.chatTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:NO];
                break;
            }
        }
    }

    if (dict[GYHDDataBaseCenterMessageBody] && dict[GYHDDataBaseCenterMessageToID] && [[self.messageCard substringToIndex:11] isEqualToString:[dict[GYHDDataBaseCenterMessageCard] substringToIndex:11]]) {
        self.recvMessageID = dict[GYHDDataBaseCenterMessageFromID];
        GYHDNewChatModel* model = [[GYHDNewChatModel alloc] initWithDictionary:dict];
        [self.chatArrayM addObject:model];
        for (GYHDNewChatModel *chatModel in self.chatArrayM) {
            if (!chatModel.chatIsSelfSend) {
                chatModel.chatIcon = model.chatIcon;
            }

        }
        [self.chatTableView reloadData];
    }


    if (self.chatArrayM.count>1) {
        CGRect rectInTableView = [self.chatTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArrayM.count - 2 inSection:0]];
        rectInTableView = [self.chatTableView convertRect:rectInTableView toView:[self.chatTableView superview]];
        CGRect rectInKey = [self.chatInputView convertRect:self.chatInputView.bounds toView:[self.chatInputView superview]];
        if (rectInTableView.origin.y < rectInKey.origin.y) { // 判断是不是最后一行
            [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArrayM.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }

    if (dict[@"friendChange"]) {
        if ([dict[@"toID"] rangeOfString:self.messageCard].location != NSNotFound) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    IQKeyboardManager* manager = [IQKeyboardManager sharedManager];
//    manager.enable = YES;
//    manager.enableAutoToolbar = YES;
//    [[GYHDMessageCenter sharedInstance] ClearUnreadMessageWithCard:self.messageCard];
//    [self.chatInputView removeObserver:self forKeyPath:@"center"];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

#pragma mark--tableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatArrayM.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHDNewChatModel* chatModel = self.chatArrayM[indexPath.row];
    UITableViewCell *baseCell = nil;
    NSDictionary* bodyDict = [GYUtils stringToDictionary:chatModel.chatBody];

    switch ([bodyDict[@"msg_code"] integerValue]) {
    case GYHDDataBaseCenterMessageChatText:
        if (!chatModel.chatIsSelfSend) {
            GYHDLeftChatTextCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDLeftChatTextCellID" forIndexPath:indexPath];
            cell.delegate = self;
            cell.chatModel = chatModel;
           baseCell = cell;
        }
        else {
            GYHDRightChatTextCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDRightChatTextCellID" forIndexPath:indexPath];
            cell.delegate = self;
            cell.chatModel = chatModel;
           baseCell = cell;
        }
        break;
    case GYHDDataBaseCenterMessageChatPicture:
        if (!chatModel.chatIsSelfSend) {
            GYHDLeftChatImageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDLeftChatImageCellID" forIndexPath:indexPath];
            cell.delegate = self;
            cell.chatModel = chatModel;
           baseCell = cell;
        }
        else {
            GYHDRightChatImageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDRightChatImageCellID" forIndexPath:indexPath];
            cell.delegate = self;
            cell.chatModel = chatModel;
           baseCell = cell;
        }
        break;
    case GYHDDataBaseCenterMessageChatAudio:
        if (!chatModel.chatIsSelfSend) {
            GYHDLeftChatAudioCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDLeftChatAudioCellID" forIndexPath:indexPath];
            cell.delegate = self;
            cell.chatModel = chatModel;
           baseCell = cell;
        }
        else {
            GYHDRightChatAudioCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDRightChatAudioCellID" forIndexPath:indexPath];
            cell.delegate = self;
            cell.chatModel = chatModel;
           baseCell = cell;
        }
        break;
    case GYHDDataBaseCenterMessageChatVideo:
        if (!chatModel.chatIsSelfSend) {
            GYHDLeftChatVideoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDLeftChatVideoCellID" forIndexPath:indexPath];
            cell.delegate = self;
            cell.chatModel = chatModel;
           baseCell = cell;
        }
        else {
            GYHDRightChatVideoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDRightChatVideoCellID" forIndexPath:indexPath];
            cell.delegate = self;
            cell.chatModel = chatModel;
           baseCell = cell;
        }
        break;
        case GYHDDataBaseCenterMessageChatGoods:
        {
            GYHDRelatedGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDRelatedGoodsCellID" forIndexPath:indexPath];
            cell.model = chatModel;
            baseCell = cell;
            break;
        }
        case GYHDDataBaseCenterMessageChatOrder:
        {
            GYHDRelatedOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDRelatedOrderCellID" forIndexPath:indexPath];
            cell.model = chatModel;
            baseCell = cell;
            break;
        }

        case GYHDDataBaseCenterMessageChatMap:
            if (!chatModel.chatIsSelfSend) {
                GYHDLeftChatMapCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDLeftChatMapCellID" forIndexPath:indexPath];
                cell.delegate = self;
                cell.chatModel = chatModel;
                baseCell = cell;
            }
            else {
                GYHDRightChatMapCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDRightChatMapCellID" forIndexPath:indexPath];
                cell.delegate = self;
                cell.chatModel = chatModel;
                baseCell = cell;
            }
            break;
    default:
        break;
    }

    return baseCell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{

    GYHDNewChatModel* chatModel = self.chatArrayM[indexPath.row];
    NSDictionary* bodyDict = [GYUtils stringToDictionary:chatModel.chatBody];
    switch ([bodyDict[@"msg_code"] integerValue]) {
    case GYHDDataBaseCenterMessageChatText:
        if (!chatModel.chatIsSelfSend) {
            return [tableView fd_heightForCellWithIdentifier:@"GYHDLeftChatTextCellID" configuration:^(GYHDLeftChatTextCell* cell) {
                cell.chatModel = self.chatArrayM[indexPath.row];
            }];
        }
        else {
            return [tableView fd_heightForCellWithIdentifier:@"GYHDRightChatTextCellID" configuration:^(GYHDRightChatTextCell* cell) {
                cell.chatModel = self.chatArrayM[indexPath.row];
            }];
        }
        break;
    case GYHDDataBaseCenterMessageChatPicture:

        if (!chatModel.chatIsSelfSend) {
            return [tableView fd_heightForCellWithIdentifier:@"GYHDLeftChatImageCellID" configuration:^(GYHDLeftChatTextCell* cell) {
                cell.chatModel = self.chatArrayM[indexPath.row];
            }];
        }
        else {
            return [tableView fd_heightForCellWithIdentifier:@"GYHDRightChatImageCellID" configuration:^(GYHDRightChatImageCell* cell) {
                cell.chatModel = self.chatArrayM[indexPath.row];
            }];
        }
        break;
    case GYHDDataBaseCenterMessageChatMap:
        return 150.0f;
    case GYHDDataBaseCenterMessageChatAudio:
        return 100.0f;
    case GYHDDataBaseCenterMessageChatOrder:
            return 200.0f;
    case GYHDDataBaseCenterMessageChatGoods:
            return 155.0f;
    case GYHDDataBaseCenterMessageChatVideo:
        if (!chatModel.chatIsSelfSend) {
            return [tableView fd_heightForCellWithIdentifier:@"GYHDLeftChatVideoCellID" configuration:^(GYHDLeftChatVideoCell* cell) {
                cell.chatModel = self.chatArrayM[indexPath.row];
            }];
        }
        else {
            return [tableView fd_heightForCellWithIdentifier:@"GYHDRightChatVideoCellID" configuration:^(GYHDRightChatVideoCell* cell) {
                cell.chatModel = self.chatArrayM[indexPath.row];
            }];
        }
        break;
    default:
        break;
    }
    return 80;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    // 隐藏键盘
    //    [tableView didse:indexPath animated:YES];
    [self.chatInputView disMiss];
}

#pragma mark-- GYHDKeyboardInptuViewDelegate

- (void)GYHDInputView:(GYHDInputView*)inputView sendDict:(NSDictionary*)dict SendType:(GYHDInputeViewSendType)type
{

    NSDictionary* friendInfoDict = [[GYHDMessageCenter sharedInstance] selectFriendBaseWithCardString:self.messageCard];
    NSDictionary* FriendBasicDict = [GYUtils stringToDictionary:friendInfoDict[@"Friend_Basic"]];
    NSDictionary* myDict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
    NSString* msgNoto = nil;

    if ([FriendBasicDict[@"Friend_Name"] isEqualToString:@""] ||
        [FriendBasicDict[@"Friend_Name"] isEqual:[NSNull null]] || FriendBasicDict[@"Friend_Name"] == nil || ![FriendBasicDict objectForKey:@"Friend_Name"]) {
        msgNoto = myDict[@"Friend_Name"];
    }
    else {
        msgNoto = FriendBasicDict[@"Friend_Name"];
    }

    NSMutableDictionary* messageDict = [NSMutableDictionary dictionary];
    switch (type) {
    case GYHDInputeViewSendText: {
        NSMutableDictionary* bodyDict = [NSMutableDictionary dictionary];
        bodyDict[@"msg_note"] = msgNoto;
        bodyDict[@"msg_content"] = dict[@"string"];
        bodyDict[@"msg_type"] = @"2";
        bodyDict[@"msg_icon"] = myDict[@"Friend_Icon"];
        bodyDict[@"msg_code"] = @"00";
        bodyDict[@"sub_msg_code"] = @"10101";
        NSString* bodyString = [GYUtils dictionaryToString:bodyDict];
        NSString* saveString = @"";
        messageDict = [NSMutableDictionary dictionaryWithDictionary:[self sendWithMessageType:GYHDDataBaseCenterMessageTypeChat saveDictString:saveString bodyString:bodyString]];
        messageDict[GYHDDataBaseCenterMessageContent] = bodyDict[@"msg_content"];

        break;
    }
    case GYHDInputeViewSendAudio: {

        NSMutableDictionary* bodyDict = [NSMutableDictionary dictionary];
        bodyDict[@"msg_code"] = @"13";
        bodyDict[@"msg_type"] = @"2";
        bodyDict[@"msg_icon"] = myDict[@"Friend_Icon"];
        bodyDict[@"msg_note"] = msgNoto;
        NSInteger len = [dict[@"mp3Len"] integerValue];
        bodyDict[@"msg_fileSize"] = [NSString stringWithFormat:@"%ld", (long)len];
        bodyDict[@"msg_content"] = @"";
        bodyDict[@"sub_msg_code"] = @"10101";
        NSString* bodyString = [GYUtils dictionaryToString:bodyDict];
        NSString* saveString = [GYUtils dictionaryToString:dict];
        messageDict = [NSMutableDictionary dictionaryWithDictionary:[self sendWithMessageType:GYHDDataBaseCenterMessageTypeChat saveDictString:saveString bodyString:bodyString]];
        messageDict[GYHDDataBaseCenterMessageContent] = [GYUtils localizedStringWithKey:@"GYHD_Chat_audio_message"];
        break;
    }
    case GYHDInputeViewSendPhoto: {
        NSMutableDictionary* bodyDict = [NSMutableDictionary dictionary];
        bodyDict[@"msg_imageNailsUrl"] = @"";
        bodyDict[@"msg_content"] = @"";
        bodyDict[@"msg_imageNails_width"] = @"";
        bodyDict[@"msg_imageNails_height"] = @"";
        bodyDict[@"msg_type"] = @"2";
        bodyDict[@"msg_icon"] = myDict[@"Friend_Icon"];
        bodyDict[@"sub_msg_code"] = @"10101";
        bodyDict[@"msg_note"] = msgNoto; //好友昵称
        bodyDict[@"msg_code"] = @"10";

        NSString* bodyString = [GYUtils dictionaryToString:bodyDict];
        NSString* saveString = [GYUtils dictionaryToString:dict];
        messageDict = [NSMutableDictionary dictionaryWithDictionary:[self sendWithMessageType:GYHDDataBaseCenterMessageTypeChat saveDictString:saveString bodyString:bodyString]];
        messageDict[GYHDDataBaseCenterMessageContent] = [GYUtils localizedStringWithKey:@"GYHD_Chat_image_message"];
        break;
    }
    case GYHDInputeViewSendVideo: {

        NSMutableDictionary* bodyDict = [NSMutableDictionary dictionary];
        bodyDict[@"msg_imageNailsUrl"] = @"";
        bodyDict[@"msg_content"] = @"";
        bodyDict[@"msg_imageNails_width"] = @"";
        bodyDict[@"msg_imageNails_height"] = @"";
        bodyDict[@"msg_type"] = @"2";
        bodyDict[@"msg_icon"] = myDict[@"Friend_Icon"];
        bodyDict[@"sub_msg_code"] = @"10101";
        bodyDict[@"msg_note"] = msgNoto;
        bodyDict[@"msg_code"] = @"14";

        NSString* bodyString = [GYUtils dictionaryToString:bodyDict];
        NSString* saveString = [GYUtils dictionaryToString:dict];
        messageDict = [NSMutableDictionary dictionaryWithDictionary:[self sendWithMessageType:GYHDDataBaseCenterMessageTypeChat saveDictString:saveString bodyString:bodyString]];
        messageDict[GYHDDataBaseCenterMessageContent] = [GYUtils localizedStringWithKey:@"GYHD_Chat_video_message"];
        break;
    }
        case GYHDInputeViewSendGPS:
        {
            GYHDGPSViewController *gpsViewController = [[GYHDGPSViewController alloc] init];
            [self.navigationController pushViewController:gpsViewController animated:YES];
            WS(weakSelf);
            gpsViewController.block = ^(NSDictionary *dict) {
                NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                bodyDict[@"msg_code"] = @"11";
                bodyDict[@"msg_type"] = @"2";
                bodyDict[@"msg_note"] = msgNoto;
                bodyDict[@"msg_icon"] = myDict[@"Friend_Icon"];
                bodyDict[@"sub_msg_code"] = @"10101";
                NSString* bodyString = [GYUtils dictionaryToString:bodyDict];
                NSString* saveString = [GYUtils dictionaryToString:dict];
                
                NSMutableDictionary* messageDict = [NSMutableDictionary dictionary];
                messageDict = [NSMutableDictionary dictionaryWithDictionary:[weakSelf sendWithMessageType:GYHDDataBaseCenterMessageTypeChat saveDictString:saveString bodyString:bodyString]];
                messageDict[GYHDDataBaseCenterMessageContent] = [GYUtils localizedStringWithKey:@"GYHD_Chat_GPS_message"];
                [[GYHDMessageCenter sharedInstance] sendMessageWithDictionary:messageDict resend:NO];
                GYHDNewChatModel* model = [[GYHDNewChatModel alloc] initWithDictionary:messageDict];
                [weakSelf.chatArrayM addObject:model];
                [weakSelf.chatTableView reloadData];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:weakSelf.chatArrayM.count - 1 inSection:0];
                [weakSelf.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            };

            break;
        }
    default:
        break;
    }
    if (type != GYHDInputeViewSendGPS) {
        [[GYHDMessageCenter sharedInstance] sendMessageWithDictionary:messageDict resend:NO];
        GYHDNewChatModel* model = [[GYHDNewChatModel alloc] initWithDictionary:messageDict];
        [self.chatArrayM addObject:model];
        [self.chatTableView reloadData];
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.chatArrayM.count - 1 inSection:0];
        [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
  
}

- (NSDictionary*)sendWithMessageType:(GYHDDataBaseCenterMessageType)type saveDictString:(NSString*)dictString bodyString:(NSString*)bodyString
{
    NSMutableDictionary* messageDict = [NSMutableDictionary dictionary];
    messageDict[GYHDDataBaseCenterMessageFromID] = self.sendMessageID;
    messageDict[GYHDDataBaseCenterMessageToID] = self.recvMessageID;
    long long t = ([[NSDate date] timeIntervalSince1970]) * 1000;
    messageDict[GYHDDataBaseCenterMessageID] = [NSString stringWithFormat:@"%lld", t];
    messageDict[GYHDDataBaseCenterMessageCode] = @(type);
    messageDict[GYHDDataBaseCenterMessageCard] = self.messageCard;

    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateString = [formatter stringFromDate:date];

    messageDict[GYHDDataBaseCenterMessageSendTime] = dateString;
    messageDict[GYHDDataBaseCenterMessageRevieTime] = dateString;
    messageDict[GYHDDataBaseCenterMessageIsSelf] = @(1);
    messageDict[GYHDDataBaseCenterMessageIsRead] = @(0);
    messageDict[GYHDDataBaseCenterMessageSentState] = @(GYHDDataBaseCenterMessageSentStateSending);
    messageDict[GYHDDataBaseCenterMessageData] = dictString;
    messageDict[GYHDDataBaseCenterMessageBody] = bodyString;

    //    NSString *pattern1 = @"\\d{11}";
    //    NSRegularExpression *regex1 = [[NSRegularExpression alloc] initWithPattern:pattern1 options:0 error:nil];
    //    // 2.测试字符串
    //    NSArray *results1 = [regex1 matchesInString:self.recvMessageID options:0 range:NSMakeRange(0,self.recvMessageID.length)];
    //    // 3.遍历结果
    //    NSTextCheckingResult *result1 =  [results1 firstObject];
    //    messageDict[GYHDDataBaseCenterMessageFriendID] = [self.recvMessageID substringWithRange:result1.range];;
    if ([self.recvMessageID rangeOfString:@"_c_"].location != NSNotFound) {
        messageDict[GYHDDataBaseCenterMessageFriendType] = @"c";
    }
    else {
        messageDict[GYHDDataBaseCenterMessageFriendType] = @"e";
    }

    return messageDict;
}

#pragma mark-- GYHDChatDelegate
- (void)GYHDChatView:(UIView*)view longTapType:(GYHDChatTapType)type selectOption:(GYHDChatSelectOption)option chatMessageID:(NSString*)chatMessageID
{
    switch (option) {
    case GYHDChatSelectDelete: {
        NSInteger count = self.chatArrayM.count;
        for (int i = 0; i < count; i++) {
            GYHDNewChatModel* model = self.chatArrayM[i];
            if ([model.chatMessageID isEqualToString:chatMessageID]) {
                [[GYHDMessageCenter sharedInstance] deleteMessageWithMessage:chatMessageID fieldName:GYHDDataBaseCenterMessageID];
                [self.chatArrayM removeObjectAtIndex:i];
                [self.chatTableView reloadData];
                break;
            }
        }

        break;
    }
    default:
        break;
    }
}

- (void)GYHDChatView:(UIView*)view tapType:(GYHDChatTapType)type chatModel:(GYHDNewChatModel*)chatModel
{
    [self.chatInputView disMiss];
    NSDictionary* DataDict = [GYUtils stringToDictionary:chatModel.chatDataString];
    NSDictionary* bodyDict = [GYUtils stringToDictionary:chatModel.chatBody];
    switch (type) {
    case GYHDChatTapUserIcon: {

        if (chatModel.chatIsSelfSend) {
            GYHDUserInfoViewController* userInfoViewController = [[GYHDUserInfoViewController alloc] init];
            userInfoViewController.custID = globalData.loginModel.custId;
            [self.navigationController pushViewController:userInfoViewController animated:YES];
        }
        else {
            if (self.shopID) {
                GYShopAboutViewController* vc = [[GYShopAboutViewController alloc] init];
                vc.strVshopId = self.shopID;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else {
                GYHDFriendDetailViewController* friendDetailViewController = [[GYHDFriendDetailViewController alloc] init];
                friendDetailViewController.FriendCustID = chatModel.chatCard;
                //                friendDetailViewController.hidenSendButton = YES;
                [self.navigationController pushViewController:friendDetailViewController animated:YES];
            }
        }
        break;
    }
    case GYHDChatTapResendButton: {
        [self sendMessageWithModel:chatModel];
        break;
    }
    case GYHDChatTapChatImage: {
        NSURL* url = nil;
        if (DataDict[@"originalName"]) {
            NSString* imagePath = [NSString pathWithComponents:@[ [[GYHDMessageCenter sharedInstance] imagefolderNameString], DataDict[@"originalName"] ]];
            url = [NSURL fileURLWithPath:imagePath];
        }
        else {

            url = [NSURL URLWithString:bodyDict[@"msg_content"]];
        }
        GYHDChatImageShowView* showImageView = [[GYHDChatImageShowView alloc] initWithFrame:self.navigationController.view.bounds];
        //        showImageView.url = url;
        //        showImageView.delegate = self;
        [showImageView setImageWithUrl:url];
        // [showImageView show]; 原来方法在长按时出现的MenuController，会与点击手势添加的window冲突，故而换成以下方法
        [self.chatInputView disMiss];
        [showImageView showInView:self.navigationController.view];
        break;
    }
    case GYHDChatTapChatVideo: {

        if (!DataDict[@"mp4Name"])
            return;
        NSURL* url = nil;
        NSString* mp4Path = [NSString pathWithComponents:@[ [[GYHDMessageCenter sharedInstance] mp4folderNameString], DataDict[@"mp4Name"] ]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:mp4Path]) {
            url = [NSURL fileURLWithPath:mp4Path];
            GYHDChatVideoShowView* showVideoView = [[GYHDChatVideoShowView alloc] init];
            [showVideoView setVideoWithUrl:url];
            [showVideoView show];
        }
        else {
            [[GYHDMessageCenter sharedInstance] downloadDataWithUrlString:bodyDict[@"msg_content"] RequetResult:^(NSDictionary* resultDict) {
                    NSData *mp4Data = resultDict[@"data"];
                    [mp4Data writeToFile:mp4Path atomically:NO];
                    NSURL *mp4Url = [NSURL fileURLWithPath:mp4Path];
                    GYHDChatVideoShowView *showVideoView = [[GYHDChatVideoShowView alloc] init];
                    [showVideoView setVideoWithUrl:mp4Url];
                    [showVideoView show];
            }];
        }
        NSMutableDictionary* saveDict = [NSMutableDictionary dictionary];
        saveDict[@"mp4Name"] = DataDict[@"mp4Name"];
        saveDict[@"thumbnailsName"] = DataDict[@"thumbnailsName"];
        saveDict[@"read"] = @"1";
        NSString* saveString = [GYUtils dictionaryToString:saveDict];
        [[GYHDMessageCenter sharedInstance] updateMessageWithMessageID:chatModel.chatMessageID fieldName:GYHDDataBaseCenterMessageData updateString:saveString];
        chatModel.chatDataString = saveString;
        break;
    }
    case GYHDChatTapChatAudio: {
        NSString* mp3Path = [NSString pathWithComponents:@[ [[GYHDMessageCenter sharedInstance] mp3folderNameString], DataDict[@"mp3"] ]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:mp3Path]) {
            if ([NSStringFromClass(view.class) isEqualToString:NSStringFromClass([GYHDLeftChatAudioCell class])]) {

                GYHDLeftChatAudioCell* cell = (GYHDLeftChatAudioCell*)view;
                if ([cell isEqual:self.leftAudioCell]) {
                    if ([cell isAudioAnimation]) {
                        [cell stopAudioAnimation];
                        [[GYHDAudioTool sharedInstance] stopPlaying];
                    }
                    else {
                        [cell startAudioAnimation];
                        [[GYHDAudioTool sharedInstance] playMp3WithFilePath:mp3Path complete:^(GYHDAudioToolPlayerState state) {
                                [cell stopAudioAnimation];
                        }];
                    }
                }
                else {
                    [cell startAudioAnimation];
                    [[GYHDAudioTool sharedInstance] playMp3WithFilePath:mp3Path complete:^(GYHDAudioToolPlayerState state) {
                            [cell stopAudioAnimation];
                    }];
                    [self.leftAudioCell stopAudioAnimation];
                    self.leftAudioCell = cell;
                }
                self.leftAudioCell = cell;
                [self.rightAudioCell stopAudioAnimation];
            }
            else {
                GYHDRightChatAudioCell* cell = (GYHDRightChatAudioCell*)view;
                if ([cell isEqual:self.rightAudioCell]) {
                    if ([cell isAudioAnimation]) {
                        [cell stopAudioAnimation];
                        [[GYHDAudioTool sharedInstance] stopPlaying];
                    }
                    else {
                        [cell startAudioAnimation];
                        [[GYHDAudioTool sharedInstance] playMp3WithFilePath:mp3Path complete:^(GYHDAudioToolPlayerState state) {
                                [cell stopAudioAnimation];
                        }];
                    }
                }
                else {
                    [cell startAudioAnimation];
                    [[GYHDAudioTool sharedInstance] playMp3WithFilePath:mp3Path complete:^(GYHDAudioToolPlayerState state) {
                            [cell stopAudioAnimation];
                    }];
                    [self.rightAudioCell stopAudioAnimation];
                    self.rightAudioCell = cell;
                }
                self.rightAudioCell = cell;
                [self.leftAudioCell stopAudioAnimation];
            }
        }
        else {
            [[GYHDMessageCenter sharedInstance] downloadDataWithUrlString:bodyDict[@"msg_content"] RequetResult:^(NSDictionary* resultDict) {
                    NSData *mp3Data = resultDict[@"data"];
                    [mp3Data writeToFile:mp3Path atomically:NO];
                    if ([NSStringFromClass(view.class) isEqualToString:NSStringFromClass([GYHDLeftChatAudioCell class])]) {
                        GYHDLeftChatAudioCell *cell = (GYHDLeftChatAudioCell *)view;
                        if ([cell isEqual:self.leftAudioCell]) {
                            if ([cell isAudioAnimation]) {
                                [cell stopAudioAnimation];
                                [[GYHDAudioTool sharedInstance] stopPlaying];
                            } else {
                                [cell startAudioAnimation];
                                [[GYHDAudioTool sharedInstance] playMp3WithFilePath:mp3Path complete:^(GYHDAudioToolPlayerState state) {
                                    [cell stopAudioAnimation];
                                }];
                            }
                        } else {
                            [cell startAudioAnimation];
                            [[GYHDAudioTool sharedInstance] playMp3WithFilePath:mp3Path complete:^(GYHDAudioToolPlayerState state) {
                                [cell stopAudioAnimation];
                            }];
                            [self.leftAudioCell stopAudioAnimation];
                            self.leftAudioCell = cell;
                        }
                        self.leftAudioCell = cell;
                        [self.rightAudioCell stopAudioAnimation];
                    } else {
                        GYHDRightChatAudioCell *cell = (GYHDRightChatAudioCell *)view;
                        if ([cell isEqual:self.rightAudioCell]) {
                            if ([cell isAudioAnimation]) {
                                [cell stopAudioAnimation];
                                [[GYHDAudioTool sharedInstance] stopPlaying ];
                            } else {
                                [cell startAudioAnimation];
                                [[GYHDAudioTool sharedInstance] playMp3WithFilePath:mp3Path complete:^(GYHDAudioToolPlayerState state) {
                                    [cell stopAudioAnimation];
                                }];
                            }
                        } else {
                            [cell startAudioAnimation];
                            [[GYHDAudioTool sharedInstance] playMp3WithFilePath:mp3Path complete:^(GYHDAudioToolPlayerState state) {
                                [cell stopAudioAnimation];
                            }];
                            [self.rightAudioCell stopAudioAnimation];
                            self.rightAudioCell = cell;
                        }
                        self.rightAudioCell = cell;
                        [self.leftAudioCell stopAudioAnimation];
                    }
            }];
        }

        NSMutableDictionary* saveDict = [NSMutableDictionary dictionary];
        saveDict[@"mp3"] = DataDict[@"mp3"];
        saveDict[@"mp3Len"] = DataDict[@"mp3Len"];
        saveDict[@"read"] = @"1";
        NSString* saveString = [GYUtils dictionaryToString:saveDict];
        [[GYHDMessageCenter sharedInstance] updateMessageWithMessageID:chatModel.chatMessageID fieldName:GYHDDataBaseCenterMessageData updateString:saveString];
        chatModel.chatDataString = saveString;
        break;
    }
            
        case GYHDChatTapChatMap:
        {
            GYHDShowMapViewController *mapViewController =[[GYHDShowMapViewController alloc] init];
            mapViewController.locationDict = bodyDict;
            [self.navigationController pushViewController:mapViewController animated:YES];
            break;
        }
    default:
        break;
    }
}

- (void)sendMessageWithModel:(GYHDNewChatModel*)chatModel
{

    NSMutableDictionary* messageDict = [NSMutableDictionary dictionary];
    messageDict[GYHDDataBaseCenterMessageFromID] = chatModel.chatFromID;
    messageDict[GYHDDataBaseCenterMessageToID] = chatModel.chatToID;
    messageDict[GYHDDataBaseCenterMessageID] = chatModel.chatMessageID;
    messageDict[GYHDDataBaseCenterMessageCode] = chatModel.chatCard;
    messageDict[GYHDDataBaseCenterMessageCard] = self.messageCard;
    messageDict[GYHDDataBaseCenterMessageSendTime] = chatModel.chatRecvTime;
    messageDict[GYHDDataBaseCenterMessageRevieTime] = chatModel.chatRecvTime;
    messageDict[GYHDDataBaseCenterMessageIsSelf] = @(1);
    messageDict[GYHDDataBaseCenterMessageIsRead] = @(0);
    messageDict[GYHDDataBaseCenterMessageSentState] = @(GYHDDataBaseCenterMessageSentStateSending);
    chatModel.chatSendState = GYHDDataBaseCenterMessageSentStateSending;
    messageDict[GYHDDataBaseCenterMessageData] = chatModel.chatDataString;
    messageDict[GYHDDataBaseCenterMessageBody] = chatModel.chatBody;
    [[GYHDMessageCenter sharedInstance] sendMessageWithDictionary:messageDict resend:YES];
    [[GYHDMessageCenter sharedInstance] updateMessageStateWithMessageID:chatModel.chatMessageID State:GYHDDataBaseCenterMessageSentStateSending];
   
//    for (GYHDNewChatModel *model in self.chatArrayM) {
//        model.chatMessageID
//    }
    int count = self.chatArrayM.count;
    for (int i = 0; i < count; i++) {
        GYHDNewChatModel *model = self.chatArrayM[i];
        if ([model.chatMessageID isEqualToString:chatModel.chatMessageID]) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
            [self.chatTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:NO];
        }
    }
//    [self.chatTableView reloadData];
}

@end