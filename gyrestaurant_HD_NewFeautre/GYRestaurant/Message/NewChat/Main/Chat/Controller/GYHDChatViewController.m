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
#import "GYRefreshFooter.h"
#import "GYRefreshHeader.h"
#import "GYHDAudioTool.h"
#import "GYHDChatImageShowView.h"
#import "GYHDChatVideoShowView.h"
#import "GYHDCustomerInfoViewController.h"
#import "GYPhotoGroupView.h"
#import "GYHDChatHeadView.h"
#import "GYHDMessageCenter.h"
#import "GYHDRelatedGoodsCell.h"
#import "GYHDRelatedOrderCell.h"
static NSInteger const selectChatCount = 20;
@interface GYHDChatViewController ()<UITableViewDelegate,UITableViewDataSource,GYHDInputViewDelegate,GYHDChatDelegate>
/**
 * 聊天消息控制器
 */
@property(nonatomic, weak)UITableView *chatTableView;

/**
 * 发送者ID
 */
@property(nonatomic, copy)NSString  *sendMessageID;
/**
 * 接收者ID
 */
@property(nonatomic, copy)NSString  *recvMessageID;
/**
 * 输入条
 */
@property(nonatomic, weak)GYHDInputView *chatInputView;
/**记录左边上次播放的音频的View*/
@property(nonatomic, weak)GYHDLeftChatAudioCell *leftAudioCell;
/**记录右边上次播放的音频的View*/
@property(nonatomic, weak)GYHDRightChatAudioCell *rightAudioCell;
@property(nonatomic ,assign)CGFloat frontY;
@property(nonatomic,assign)BOOL isClickRight;
@property(nonatomic,strong)GYHDChatHeadView*chatHeadView;
@property(nonatomic,strong)UIView*chatHeadBgView;
@end


@implementation GYHDChatViewController

- (NSMutableArray *)chatArrayM {
    if (!_chatArrayM) {
        _chatArrayM = [NSMutableArray array];
    }
    return _chatArrayM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    WS(weakSelf);
    UITableView *chatTableView = [[UITableView alloc] init];
    chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    chatTableView.delegate = self;
    chatTableView.dataSource = self;
    chatTableView.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
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
    
    [self.view addSubview:chatTableView];
    _chatTableView = chatTableView;
  
    UITapGestureRecognizer*scrTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchScrollView)];
    [scrTap setNumberOfTapsRequired:1];
    [scrTap setNumberOfTouchesRequired:1];
    [self.chatTableView addGestureRecognizer:scrTap];
    
    [chatTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(kScreenHeight - 105 -64);
    }];
    [self setupRefresh];
    //. 添加通知
    [self addObserver];
    //1. 输入View
    GYHDInputView *chatInputView = [[GYHDInputView alloc] init];
    chatInputView.delegate = self;
    [self.view addSubview:chatInputView];
    _chatInputView = chatInputView;

    [chatInputView showToSuperView:self.view];
    [self.chatInputView addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
   
}
- (void)setMessageCard:(NSString *)messageCard {
    [super setMessageCard:messageCard];
    
    NSDictionary *dict =  [[GYHDMessageCenter sharedInstance] selectFriendBaseWithCardString:messageCard];
        self.sendMessageID = [NSString stringWithFormat:@"m_e_%@@im.gy.com/mobile_im",globalData.loginModel.custId];
    self.recvMessageID=[NSString stringWithFormat:@"%@@im.gy.com",dict[@"Friend_ID"]];
    DDLogCInfo(@"%@",dict);
    [self.chatArrayM removeAllObjects];
    [self loadChat];
    if (self.isFromSearch) {
        
        self.chatTableView.contentOffset=CGPointMake(0, 0);
    }
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.chatInputView disMiss];

}
/**下拉刷新*/
- (void)setupRefresh {
    kWEAKSELF;
    GYRefreshHeader *header=[GYRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf loadChat];
        [weakSelf.chatTableView.mj_header endRefreshing];
    }];
  
    weakSelf.chatTableView.mj_header=header;
    
}
/**加载聊天记录*/
- (void)loadChat {
    
//    //1. 查询数据库
    NSMutableArray *array = [NSMutableArray array];
//    for (NSDictionary *chatDict in [[GYHDMessageCenter sharedInstance] selectAllChatWithCard:self.messageCard frome:self.chatArrayM.count to:selectChatCount]) {
//        GYHDNewChatModel *chatMode = [[GYHDNewChatModel alloc] initWithDictionary:chatDict];
//        self.chatHeadView.chatShopModel=chatMode;
//        [array addObject:chatMode];
//    }
//    NSMutableArray *fristArray = [NSMutableArray arrayWithArray:self.chatArrayM];
//    [array addObjectsFromArray:fristArray];
//    self.chatArrayM = array;
//    [self.chatTableView reloadData];
//    if (self.chatArrayM.count && self.chatArrayM.count <= selectChatCount) {
//        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArrayM.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//    }
    if (self.isFromSearch==YES) {
        
        if (self.chatArrayM.count>0) {
            
            //说明已经至少加载过一条历史消息,再次上拉则将最旧一条消息id赋值给self.primaryId
            
            GYHDNewChatModel *chatModel =self.chatArrayM[0];
            
            self.primaryId = chatModel.primaryId;//最旧一条搜索消息id
            
            NSArray *chatListArray =[[GYHDMessageCenter sharedInstance]selectChatListMessageByMessageId:self.messageCard PrimaryId:self.primaryId FriendName:self.userName IsHeaderRefresh:NO];
            
            
            for ( NSDictionary *chatDict in chatListArray) {
                
                GYHDNewChatModel *chatMode = [[GYHDNewChatModel alloc] initWithDictionary:chatDict];
                [array addObject:chatMode];
            }
            
        }
        
        else{
            
            NSArray *chatArray =[[GYHDMessageCenter sharedInstance]selectChatListMessageByMessageId:self.messageCard PrimaryId:self.primaryId FriendName:self.userName IsHeaderRefresh:YES];
            
            
            for ( NSDictionary *chatDict in chatArray) {
                
                GYHDNewChatModel *chatMode = [[GYHDNewChatModel alloc] initWithDictionary:chatDict];
                [array addObject:chatMode];
            }
            
        }
        
    }
    else{
        for (NSDictionary *chatDict in [[GYHDMessageCenter sharedInstance] selectAllChatWithCard:self.messageCard frome:self.chatArrayM.count to:self.chatArrayM.count+selectChatCount]) {
            GYHDNewChatModel *chatMode = [[GYHDNewChatModel alloc] initWithDictionary:chatDict];
            [array addObject:chatMode];
        }
    }
    
    
    NSMutableArray *fristArray = [NSMutableArray arrayWithArray:self.chatArrayM];
    [array addObjectsFromArray:fristArray];
    
    self.chatArrayM = array;

    [self.chatTableView reloadData];
    if (self.chatArrayM.count && self.chatArrayM.count <= selectChatCount) {
        
        if (self.isFromSearch==YES) {
            
            
        }
        else{
            [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArrayM.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        
    }

}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if([keyPath isEqualToString:@"center"])
    {
        if (self.chatArrayM.count > 0) {
            CGRect rectInKey =  [self.chatInputView convertRect:self.chatInputView.bounds toView:[self.chatInputView superview]];
            [self.chatTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(0);
                make.height.mas_equalTo(rectInKey.origin.y);
            }];
            [self.chatTableView layoutIfNeeded];
            
            [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArrayM.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];

        }
    }
    if (self.isFromSearch) {
        
        self.chatTableView.contentOffset=CGPointMake(0, 0);
    }
}
- (void)addObserver {
    
    [[GYHDMessageCenter sharedInstance] addDataBaseChangeNotificationObserver:self selector:@selector(messageCenterDataBaseChagne:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

}

-(void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    
    [self.chatInputView disMiss];
    
}

- (void)messageCenterDataBaseChagne:(NSNotification *)noti {
    NSDictionary *dict = noti.object;
    if (self.isFromSearch==YES) {
        self.isFromSearch=NO;
    }
    if (dict[@"State"] && dict[@"msgID"]) {        //  更新数据
        for (GYHDNewChatModel *model in self.chatArrayM) {
            if (model.chatMessageID.integerValue == [dict[@"msgID"] integerValue]) {
                model.chatSendState = [dict[@"State"] integerValue];
            }
        }
    }
    
    if (dict[@"MSG_Body"] &&dict[@"MSG_ToID"] && [self.messageCard isEqualToString:dict[@"MSG_Card"]]) {
        GYHDNewChatModel *model = [[GYHDNewChatModel alloc]initWithDictionary:dict];
        [self.chatArrayM addObject:model];
    }
    [self.chatTableView reloadData];
    if (self.chatArrayM.count) {
        CGRect rectInTableView = [self.chatTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArrayM.count - 2 inSection:0]];
        rectInTableView = [self.chatTableView convertRect:rectInTableView toView:[self.chatTableView superview]];
        CGRect rectInKey =  [self.chatInputView convertRect:self.chatInputView.bounds toView:[self.chatInputView superview]];
        if (rectInTableView.origin.y < rectInKey.origin.y) { // 判断是不是最后一行
            [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArrayM.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[GYHDMessageCenter sharedInstance] ClearUnreadMessageWithCard:self.messageCard];
}

- (void)dealloc {
    [self.chatInputView removeObserver:self forKeyPath:@"center"];
    [[GYHDMessageCenter sharedInstance] removeDataBaseChangeNotificationWithObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}


#pragma mark --tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatArrayM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYHDNewChatModel *chatModel = self.chatArrayM[indexPath.row];
    NSDictionary *bodyDict = [Utils stringToDictionary:chatModel.chatBody];
    
    switch ([bodyDict[@"msg_code"] integerValue]) {
        case GYHDDataBaseCenterMessageChatText:
            if (!chatModel.chatIsSelfSend) {
                GYHDLeftChatTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDLeftChatTextCellID" forIndexPath:indexPath];
                cell.delegate = self;
                chatModel.headIconStr=self.leftHeadIconStr;
                cell.chatModel = chatModel;
                return cell;
            } else {
                GYHDRightChatTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDRightChatTextCellID" forIndexPath:indexPath];
                cell.delegate = self;
                cell.chatModel = chatModel;
                return cell;
            }
            break;
            case GYHDDataBaseCenterMessageChatPicture:
            if (!chatModel.chatIsSelfSend) {
                GYHDLeftChatImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDLeftChatImageCellID" forIndexPath:indexPath];
                cell.delegate = self;
                chatModel.headIconStr=self.leftHeadIconStr;
                cell.chatModel = chatModel;
                return cell;
            } else {
                GYHDRightChatImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDRightChatImageCellID" forIndexPath:indexPath];
                cell.delegate = self;
                cell.chatModel = chatModel;
                return cell;
            }
            break;
            case GYHDDataBaseCenterMessageChatAudio:
            if (!chatModel.chatIsSelfSend) {
                GYHDLeftChatAudioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDLeftChatAudioCellID" forIndexPath:indexPath];
                cell.delegate = self;
                chatModel.headIconStr=self.leftHeadIconStr;
                cell.chatModel = chatModel;
                return cell;
            } else {
                GYHDRightChatAudioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDRightChatAudioCellID" forIndexPath:indexPath];
                cell.delegate = self;
                cell.chatModel = chatModel;
                return cell;
            }
            break;
            case GYHDDataBaseCenterMessageChatVideo:
            if (!chatModel.chatIsSelfSend) {
                GYHDLeftChatVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDLeftChatVideoCellID" forIndexPath:indexPath];
                cell.delegate = self;
                chatModel.headIconStr=self.leftHeadIconStr;
                cell.chatModel = chatModel;
                return cell;
            } else {
                GYHDRightChatVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDRightChatVideoCellID" forIndexPath:indexPath];
                cell.delegate = self;
                cell.chatModel = chatModel;
                return cell;
            }
            break;
        case GYHDDataBaseCenterMessageChatGoods:
        {
            GYHDRelatedGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDRelatedGoodsCellID" forIndexPath:indexPath];
            cell.model = chatModel;
            return cell;
           
        }
            break;
        case GYHDDataBaseCenterMessageChatOrder:
        {
            GYHDRelatedOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDRelatedOrderCellID" forIndexPath:indexPath];
            cell.model = chatModel;
            return cell;
           
        }
            break;
        default:
            break;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (self.chatArrayM.count<indexPath.row) {
//        
//        return 0;
//    }
    GYHDNewChatModel *chatModel = self.chatArrayM[indexPath.row];
    NSDictionary *bodyDict = [Utils stringToDictionary:chatModel.chatBody];
    switch ([bodyDict[@"msg_code"] integerValue]) {
        case GYHDDataBaseCenterMessageChatText:
            if (!chatModel.chatIsSelfSend) {
                return [tableView fd_heightForCellWithIdentifier:@"GYHDLeftChatTextCellID" configuration:^(GYHDLeftChatTextCell *cell) {
                    cell.chatModel = self.chatArrayM[indexPath.row];
                }];
            } else {
                return [tableView fd_heightForCellWithIdentifier:@"GYHDRightChatTextCellID" configuration:^(GYHDRightChatTextCell *cell) {
                    cell.chatModel = self.chatArrayM[indexPath.row];
                }];
            }
            break;
            case GYHDDataBaseCenterMessageChatPicture:
            
            if (!chatModel.chatIsSelfSend) {
                return [tableView fd_heightForCellWithIdentifier:@"GYHDLeftChatImageCellID" configuration:^(GYHDLeftChatTextCell *cell) {
                    cell.chatModel = self.chatArrayM[indexPath.row];
                }];
            } else {
                return [tableView fd_heightForCellWithIdentifier:@"GYHDRightChatImageCellID" configuration:^(GYHDRightChatImageCell *cell) {
                    cell.chatModel = self.chatArrayM[indexPath.row];
                }];
            }
            break;
            case GYHDDataBaseCenterMessageChatAudio:
            return 100.0f;
        case GYHDDataBaseCenterMessageChatOrder:
            return 181.0f;
        case GYHDDataBaseCenterMessageChatGoods:
            return 155.0f;
        case GYHDDataBaseCenterMessageChatVideo:
            if (!chatModel.chatIsSelfSend) {
                return [tableView fd_heightForCellWithIdentifier:@"GYHDLeftChatVideoCellID" configuration:^(GYHDLeftChatVideoCell *cell) {
                    cell.chatModel = self.chatArrayM[indexPath.row];
                }];
            } else {
                return [tableView fd_heightForCellWithIdentifier:@"GYHDRightChatVideoCellID" configuration:^(GYHDRightChatVideoCell *cell) {
                    cell.chatModel = self.chatArrayM[indexPath.row];
                }];
            }
            break;
        default:
            break;
    }
    return 80;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 隐藏键盘
//    [tableView didse:indexPath animated:YES];
//    [self.chatInputView disMiss];
}

- (void)touchScrollView
{
    [self.chatInputView disMiss];
}


#pragma mark -- GYHDKeyboardInptuViewDelegate

- (void)GYHDInputView:(GYHDInputView *)inputView sendDict:(NSDictionary *)dict SendType:(GYHDInputeViewSendType) type {

    if (self.isFromSearch) {
        
        self.isFromSearch =NO;
    }
    
    NSDictionary *friendDict = [[GYHDMessageCenter sharedInstance] selectFriendBaseWithCardString:globalData.loginModel. custId];
    NSDictionary *messageDict = [NSDictionary dictionary];
    switch (type) {
        case GYHDInputeViewSendText:
        {
            NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
            bodyDict[@"msg_note"] = globalData.loginModel.operName;
            bodyDict[@"msg_content"] = dict[@"string"];
            bodyDict[@"msg_type"] = @"2";
            bodyDict[@"msg_icon"] =[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,friendDict[GYHDDataBaseCenterFriendIcon] ];
            bodyDict[@"msg_code"] = @"00";
            bodyDict[@"sub_msg_code"] = @"10101";
            if ([self.recvMessageID containsString:@"c_"]) {
                
                bodyDict[@"msg_note"]=globalData.loginModel.vshopName;
                bodyDict[@"msg_icon"]=[NSString stringWithFormat:@"%@%@",globalData.loginModel.hsecTfsUrl,globalData.loginModel.vshopLogo];
            }
            NSString *bodyString = [Utils dictionaryToString:bodyDict];
            NSString *saveString = @"";
            messageDict = [self sendWithMessageType:GYHDDataBaseCenterMessageTypeChat saveDictString:saveString bodyString:bodyString];
            
            break;
        }
        case GYHDInputeViewSendAudio:
        {
            
            NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
            bodyDict[@"msg_code"] = @"13";
            bodyDict[@"msg_type"] = @"2";
            bodyDict[@"msg_icon"]    = [NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,friendDict[GYHDDataBaseCenterFriendIcon] ];;
            bodyDict[@"msg_note"]    = globalData.loginModel.operName;
            int len = [dict[@"mp3Len"] intValue];
            bodyDict[@"msg_fileSize"] = [NSString stringWithFormat:@"%d",len];
            bodyDict[@"msg_content"] = @"";
            bodyDict[@"sub_msg_code"] = @"10101";
            if ([self.recvMessageID containsString:@"c_"]) {
                
                bodyDict[@"msg_note"]=globalData.loginModel.vshopName;
                 bodyDict[@"msg_icon"]=[NSString stringWithFormat:@"%@%@",globalData.loginModel.hsecTfsUrl,globalData.loginModel.vshopLogo];
            }
            NSString *bodyString = [Utils dictionaryToString:bodyDict];
            NSString *saveString = [Utils dictionaryToString:dict];
            messageDict = [self sendWithMessageType:GYHDDataBaseCenterMessageTypeChat saveDictString:saveString bodyString:bodyString];
            break;
        }
        case GYHDInputeViewSendPhoto:
        {
            NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
            bodyDict[@"msg_imageNailsUrl"] = @"";
            bodyDict[@"msg_content"] = @"";
            bodyDict[@"msg_imageNails_width"] = @"";
            bodyDict[@"msg_imageNails_height"] = @"";
            bodyDict[@"msg_type"] = @"2";
            bodyDict[@"msg_icon"] = [NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,friendDict[GYHDDataBaseCenterFriendIcon] ];;
            bodyDict[@"sub_msg_code"] = @"10101";
            bodyDict[@"msg_note"] = globalData.loginModel.operName;
            bodyDict[@"msg_code"] = @"10";
            
            if ([self.recvMessageID containsString:@"c_"]) {
                
                bodyDict[@"msg_note"]=globalData.loginModel.vshopName;
                 bodyDict[@"msg_icon"]=[NSString stringWithFormat:@"%@%@",globalData.loginModel.hsecTfsUrl,globalData.loginModel.vshopLogo];
            }
            
            NSString *bodyString = [Utils dictionaryToString:bodyDict];
            NSString *saveString = [Utils dictionaryToString:dict];
             messageDict = [self sendWithMessageType:GYHDDataBaseCenterMessageTypeChat saveDictString:saveString bodyString:bodyString];
  
            break;
        }
        case GYHDInputeViewSendVideo:
        {
            NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
            bodyDict[@"msg_imageNailsUrl"] = @"";
            bodyDict[@"msg_content"] = @"";
            bodyDict[@"msg_imageNails_width"] = @"";
            bodyDict[@"msg_imageNails_height"] = @"";
            bodyDict[@"msg_type"] = @"2";
            bodyDict[@"msg_icon"] = [NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,friendDict[GYHDDataBaseCenterFriendIcon] ];;
            bodyDict[@"sub_msg_code"] = @"10101";
            bodyDict[@"msg_note"]= globalData.loginModel.operName;
            bodyDict[@"msg_code"] = @"14";
            if ([self.recvMessageID containsString:@"c_"]) {
                
                bodyDict[@"msg_note"]=globalData.loginModel.vshopName;
                bodyDict[@"msg_icon"]=[NSString stringWithFormat:@"%@%@",globalData.loginModel.hsecTfsUrl,globalData.loginModel.vshopLogo];
            }
            NSString *bodyString = [Utils dictionaryToString:bodyDict];
            NSString *saveString = [Utils dictionaryToString:dict];
            messageDict = [self sendWithMessageType:GYHDDataBaseCenterMessageTypeChat saveDictString:saveString bodyString:bodyString];
            break;
        }
        case GYHDInputeViewSendGPS:{
        
        
        
            
            return;
        }break;
        default:
            break;
    }
    [[GYHDMessageCenter sharedInstance] sendMessageWithDictionary:messageDict resend:NO];
    GYHDNewChatModel *model = [[GYHDNewChatModel alloc] initWithDictionary:messageDict];
    [self.chatArrayM addObject:model];
    [self.chatTableView reloadData];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.chatArrayM.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (NSDictionary *)sendWithMessageType:(GYHDDataBaseCenterMessageType)type saveDictString:(NSString *)dictString bodyString:(NSString *)bodyString {
    
    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
    messageDict[GYHDDataBaseCenterMessageFromID] =self.sendMessageID;
    messageDict[GYHDDataBaseCenterMessageToID] = self.recvMessageID;
    long long t = [[NSDate date] timeIntervalSince1970];
    messageDict[GYHDDataBaseCenterMessageID] = [NSString stringWithFormat:@"%lld",t];
    messageDict[GYHDDataBaseCenterMessageCode] = @(type);
    messageDict[GYHDDataBaseCenterMessageCard] = self.messageCard;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    
    messageDict[GYHDDataBaseCenterMessageSendTime]  = dateString;
    messageDict[GYHDDataBaseCenterMessageRevieTime] = dateString;
    messageDict[GYHDDataBaseCenterMessageIsSelf]    = @(1);
    messageDict[GYHDDataBaseCenterMessageIsRead]    = @(0);
    messageDict[GYHDDataBaseCenterMessageSentState] = @(GYHDDataBaseCenterMessageSentStateSending);
    messageDict[GYHDDataBaseCenterMessageData] =  dictString;
    messageDict[GYHDDataBaseCenterMessageBody] = bodyString;
    NSDictionary *bodyDict = [Utils stringToDictionary:bodyString];
    messageDict[GYHDDataBaseCenterMessageContent] = bodyDict[@"msg_content"];
    if ([self.recvMessageID containsString:@"c"]) {
        messageDict[GYHDDataBaseCenterMessageUserState] = @"c";
    }
    if ([self.recvMessageID containsString:@"e"]) {
        messageDict[GYHDDataBaseCenterMessageUserState] = @"e";
    }
    return messageDict;
}

#pragma mark -- GYHDChatDelegate
- (void)GYHDChatView:(UIView *)view longTapType:(GYHDChatTapType)type selectOption:(GYHDChatSelectOption)option chatMessageID:(NSString *)chatMessageID {
    
    switch (option) {
        case GYHDChatSelectDelete:{
            for (int i = 0 ; i< self.chatArrayM.count; i++) {
                GYHDNewChatModel *model = self.chatArrayM[i];
                if ([model.chatMessageID isEqualToString:chatMessageID]) {
                    [[GYHDMessageCenter sharedInstance] deleteMessageWithMessage:chatMessageID fieldName:GYHDDataBaseCenterMessageID];
                    [self.chatArrayM removeObjectAtIndex:i];
                    [self.chatTableView reloadData];
                }
            }

            break;
        }
        default:
            break;
    }
}
- (void)GYHDChatView:(UIView *)view tapType:(GYHDChatTapType)type chatModel:(GYHDNewChatModel *)chatModel {
    NSDictionary *DataDict = [Utils stringToDictionary:chatModel.chatDataString];
    NSDictionary *bodyDict = [Utils stringToDictionary:chatModel.chatBody];
    switch (type) {
        case GYHDChatTapUserIcon: {
            
            if (chatModel.chatIsSelfSend) {
                
                GYHDCustomerInfoViewController*vc=[[GYHDCustomerInfoViewController alloc]init];
                vc.isClickSelf=YES;
                if (self.isCustomer) {
                    
                    vc.isFromCustomer=YES;
                }else{
                    
                    vc.isFromCustomer=NO;
                }
                [self.navigationController pushViewController:vc animated:YES];
                
                
            }else if (![self.recvMessageID containsString:@"e_"]){
                
                DDLogCInfo(@"头像点击。。。。");
                    GYHDCustomerInfoViewController*vc=[[GYHDCustomerInfoViewController alloc]init];
                    vc.model=self.model;
                    vc.isClickSelf=NO;
                    [self.navigationController pushViewController:vc animated:YES];
            }
           
            break;
        }
        case GYHDChatTapResendButton: {
            [self sendMessageWithModel:chatModel];
            break;
        }
        case GYHDChatTapChatImage: {
            NSURL *url = nil;
            if (DataDict[@"originalName"]) {
                NSString *imagePath = [NSString pathWithComponents:@[[[GYHDMessageCenter sharedInstance] imagefolderNameString],DataDict[@"originalName"]]];
                url = [NSURL fileURLWithPath:imagePath];
            }else {

                url = [NSURL URLWithString:bodyDict[@"msg_content"]];
            }
#if 1
            GYHDChatImageShowView *showImageView = [[GYHDChatImageShowView alloc] initWithFrame:self.navigationController.view.bounds];
//            showImageView.url = url;
//            showImageView.delegate = self;
            [showImageView setImageWithUrl:url];
            // [showImageView show]; 原来方法在长按时出现的MenuController，会与点击手势添加的window冲突，故而换成以下方法
            
            [showImageView showInView:self.navigationController.view];
#else
            GYPhotoGroupItem *item = [[GYPhotoGroupItem alloc]init];
            item.largeImageURL = url;
            item.thumbView = view;
            
            GYPhotoGroupView *v = [[GYPhotoGroupView alloc]initWithGroupItems:@[item]];
            [v presentFromImageView:view toContainer:self.navigationController.view animated:YES completion:nil];
#endif
            break;
        }
        case GYHDChatTapChatVideo: {
            DDLogCInfo(@"视频被点击");
            if (!DataDict[@"mp4Name"]) return;
            NSURL *url = nil;
            NSString *mp4Path = [NSString pathWithComponents:@[[[GYHDMessageCenter sharedInstance] mp4folderNameString],DataDict[@"mp4Name"]]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:mp4Path]) {
                url = [NSURL fileURLWithPath:mp4Path];
                GYHDChatVideoShowView *showVideoView = [[GYHDChatVideoShowView alloc] init];
//                if ( chatModel.chatIsSelfSend ) {
                
                    showVideoView.transform = CGAffineTransformMakeRotation(M_PI);

//                }
                
                [showVideoView setVideoWithUrl:url];
                [showVideoView show];
                
                
            } else {
               [[GYHDMessageCenter sharedInstance] downloadDataWithUrlString:bodyDict[@"msg_content"] RequetResult:^(NSDictionary *resultDict) {
                   NSData *mp4Data = resultDict[@"data"];
                   [mp4Data writeToFile:mp4Path atomically:NO];
                   NSURL *mp4Url = [NSURL fileURLWithPath:mp4Path];
                   GYHDChatVideoShowView *showVideoView = [[GYHDChatVideoShowView alloc] init];
                   [showVideoView setVideoWithUrl:mp4Url];
                   [showVideoView show];
               }];
            }
            NSMutableDictionary *saveDict = [NSMutableDictionary dictionary];
            saveDict[@"mp4Name"] = DataDict[@"mp4Name"];
            saveDict[@"thumbnailsName"] = DataDict[@"thumbnailsName"];
            saveDict[@"read"]= @"1";
            NSString *saveString = [Utils dictionaryToString:saveDict];
            [[GYHDMessageCenter sharedInstance] updateMessageWithMessageID:chatModel.chatMessageID fieldName:GYHDDataBaseCenterMessageData updateString:saveString];
            chatModel.chatDataString = saveString;
            break;
        }
        case GYHDChatTapChatAudio: {
            NSString *mp3Path = [NSString pathWithComponents:@[[[GYHDMessageCenter sharedInstance] mp3folderNameString],DataDict[@"mp3"]]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:mp3Path]) {
                if ([NSStringFromClass(view.class) isEqualToString:NSStringFromClass([GYHDLeftChatAudioCell class])]) {
       
                    GYHDLeftChatAudioCell *cell = (GYHDLeftChatAudioCell *)view;
                    if ([cell isEqual:self.leftAudioCell]) {
                        if ([cell isAudioAnimation]) {
                            [cell stopAudioAnimation];
                            [[GYHDAudioTool sharedInstance] stopPlaying];
                        }else {
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
                    }else {
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
            } else {
                [[GYHDMessageCenter sharedInstance] downloadDataWithUrlString:bodyDict[@"msg_content"] RequetResult:^(NSDictionary *resultDict) {
                    NSData *mp3Data = resultDict[@"data"];
                    [mp3Data writeToFile:mp3Path atomically:NO];
                    if ([NSStringFromClass(view.class) isEqualToString:NSStringFromClass([GYHDLeftChatAudioCell class])]) {
                        GYHDLeftChatAudioCell *cell = (GYHDLeftChatAudioCell *)view;
                        if ([cell isEqual:self.leftAudioCell]) {
                            if ([cell isAudioAnimation]) {
                                [cell stopAudioAnimation];
                                [[GYHDAudioTool sharedInstance] stopPlaying];
                            }else {
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
                        }else {
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
            
            NSMutableDictionary *saveDict = [NSMutableDictionary dictionary];
            saveDict[@"mp3"] = DataDict[@"mp3"];
            saveDict[@"mp3Len"]= DataDict[@"mp3Len"];
            saveDict[@"read"]= @"1";
            NSString *saveString = [Utils dictionaryToString:saveDict];
            [[GYHDMessageCenter sharedInstance] updateMessageWithMessageID:chatModel.chatMessageID fieldName:GYHDDataBaseCenterMessageData updateString:saveString];
            chatModel.chatDataString = saveString;
            break;
        }

        default:
            break;
    }
}
- (void)sendMessageWithModel:(GYHDNewChatModel *)chatModel {
    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
    messageDict[GYHDDataBaseCenterMessageFromID] = chatModel.chatFromID;
    messageDict[GYHDDataBaseCenterMessageToID] = chatModel.chatToID;
    messageDict[GYHDDataBaseCenterMessageID] = chatModel.chatMessageID;
    messageDict[GYHDDataBaseCenterMessageCode] = chatModel.chatCard;
    messageDict[GYHDDataBaseCenterMessageCard] = self.messageCard;
    messageDict[GYHDDataBaseCenterMessageSendTime]  = chatModel.chatRecvTime;
    messageDict[GYHDDataBaseCenterMessageRevieTime] = chatModel.chatRecvTime;
    messageDict[GYHDDataBaseCenterMessageUserState]=@"e";
    messageDict[GYHDDataBaseCenterMessageIsSelf]    = @(1);
    messageDict[GYHDDataBaseCenterMessageIsRead]    = @(0);
    messageDict[GYHDDataBaseCenterMessageSentState] = @(GYHDDataBaseCenterMessageSentStateSending);
    chatModel.chatSendState = GYHDDataBaseCenterMessageSentStateSending;
    messageDict[GYHDDataBaseCenterMessageData] =  chatModel.chatDataString;
    messageDict[GYHDDataBaseCenterMessageBody] = chatModel.chatBody;
    messageDict[GYHDDataBaseCenterMessageContent]=chatModel.content;
    [[GYHDMessageCenter sharedInstance] sendMessageWithDictionary:messageDict resend:YES];
    [[GYHDMessageCenter sharedInstance] updateMessageStateWithMessageID:chatModel.chatMessageID State:GYHDDataBaseCenterMessageSentStateSending];
    [self.chatTableView reloadData];
}

@end