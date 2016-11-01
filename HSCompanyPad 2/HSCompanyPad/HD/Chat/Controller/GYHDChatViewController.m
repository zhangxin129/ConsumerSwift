//
//  GYHDChatViewController.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/8.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDChatViewController.h"
#import "GYHDLeftChatTextCell.h"
#import "GYHDRightChatTextCell.h"
#import "GYHDLeftChatImageCell.h"
#import "GYHDRightChatImageCell.h"
#import "GYHDLeftChatVideoCell.h"
#import "GYHDRightChatVideoCell.h"
#import "GYHDLeftChatAudioCell.h"
#import "GYHDRightChatAudioCell.h"
#import "GYHDLeftChatMapCell.h"
#import "GYHDRightChatMapCell.h"
#import "GYHDRelatedGoodsCell.h"
#import "GYHDRelatedOrderCell.h"
#import "GYHDChatAdvisoryCell.h"
#import "GYHDLeftLocationCell.h"
#import "GYHDRightLocationCell.h"
#import "GYHDPhotoSelectViewController.h"
#import "GYHDCameraViewController.h"
#import "GYHDVideoViewController.h"
#import "GYHDGPSViewController.h"
#import "GYHDSDK.h"
#import "GYHDChatUserInfoModel.h"
#import "GYHDUtils.h"
#import "GYHDAudioTool.h"
#import "GYHDChatDelegate.h"
#import "GYHDNetWorkTool.h"
#import "GYHDChatImageShowView.h"
#import "GYHDChatVideoShowView.h"
#import <GYKit/GYRefreshHeader.h>
#import "GYHDChatTextBodyModel.h"
#import "GYHDChatImageBodyModel.h"
#import "GYHDChatVideoBodyModel.h"
#import "GYHDChatAudioBodyModel.h"
#import "GYHDChatLocationBodyModel.h"
#import "GYHDDataBaseCenter.h"
#import "GYHDMessageCenter.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <UITableView_FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "GYHDShowMapViewController.h"
@interface GYHDChatViewController ()<UITableViewDataSource,UITableViewDelegate,GYHDInputViewDelegate,GYHDChatDelegate>

@property(nonatomic, strong)NSMutableArray      *chatArray;
@property(nonatomic, strong)GYHDChatUserInfoModel *rightInfoModel;
@property(nonatomic, strong)GYHDChatUserInfoModel *leftInfoModel;

@property(nonatomic, weak)GYHDLeftChatAudioCell     *leftAudioCell;
@property(nonatomic, weak)GYHDRightChatAudioCell    *rightAudioCell;
@property(nonatomic, assign) NSTimeInterval lastTime;
@property(nonatomic, strong)GYHDAudioTool *audioTool;
@end

@implementation GYHDChatViewController

- (instancetype)initWithIsCompany:(BOOL)isCompany
{
    self = [super init];
    if (self) {
        
        self.isCompany=isCompany;
    }
    return self;
}
- (GYHDAudioTool *)audioTool {
    if (!_audioTool) {
        _audioTool = [GYHDAudioTool sharedInstance];
    }
    return _audioTool;
}
-  (GYHDChatUserInfoModel *)leftInfoModel {
    if (!_leftInfoModel) {
        _leftInfoModel = [[GYHDChatUserInfoModel alloc] init];
    }
    return _leftInfoModel;
}
- (GYHDChatUserInfoModel *)rightInfoModel {
    if (!_rightInfoModel) {
        _rightInfoModel = [[GYHDChatUserInfoModel alloc] init];
    }
    return _rightInfoModel;
}
- (NSMutableArray *)chatArray {
    if (!_chatArray) {
        _chatArray = [NSMutableArray array];
    }
    return _chatArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHex:0xf5f5f5];

    self.chatTableView = [[UITableView alloc] init];
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.dataSource = self;
    self.chatTableView.delegate = self;
//    self.chatTableView.rowHeight = UITableViewAutomaticDimension;
//    self.chatTableView.estimatedRowHeight = 240;
    [self.chatTableView registerClass:[GYHDLeftChatTextCell class] forCellReuseIdentifier:NSStringFromClass([GYHDLeftChatTextCell class])];
    [self.chatTableView registerClass:[GYHDRightChatTextCell class] forCellReuseIdentifier:NSStringFromClass([GYHDRightChatTextCell class])];
    [self.chatTableView registerClass:[GYHDLeftChatImageCell class] forCellReuseIdentifier:NSStringFromClass([GYHDLeftChatImageCell class])];
    [self.chatTableView registerClass:[GYHDRightChatImageCell class] forCellReuseIdentifier:NSStringFromClass([GYHDRightChatImageCell class])];
    [self.chatTableView registerClass:[GYHDLeftChatVideoCell class] forCellReuseIdentifier:NSStringFromClass([GYHDLeftChatVideoCell class])];
    [self.chatTableView registerClass:[GYHDRightChatVideoCell class] forCellReuseIdentifier:NSStringFromClass([GYHDRightChatVideoCell class])];
    [self.chatTableView registerClass:[GYHDLeftChatAudioCell class] forCellReuseIdentifier:NSStringFromClass([GYHDLeftChatAudioCell class])];
    [self.chatTableView registerClass:[GYHDRightChatAudioCell class] forCellReuseIdentifier:NSStringFromClass([GYHDRightChatAudioCell class])];
    [self.chatTableView registerClass:[GYHDLeftChatMapCell class] forCellReuseIdentifier:NSStringFromClass([GYHDLeftChatMapCell class])];
    [self.chatTableView registerClass:[GYHDRightChatMapCell class] forCellReuseIdentifier:NSStringFromClass([GYHDRightChatMapCell class])];
    [self.chatTableView registerClass:[GYHDChatAdvisoryCell class] forCellReuseIdentifier:NSStringFromClass([GYHDChatAdvisoryCell class])];
      [self.chatTableView registerClass:[GYHDRelatedGoodsCell class] forCellReuseIdentifier:NSStringFromClass([GYHDRelatedGoodsCell class])];
      [self.chatTableView registerClass:[GYHDRelatedOrderCell class] forCellReuseIdentifier:NSStringFromClass([GYHDRelatedOrderCell class])];
    [self.chatTableView registerClass:[GYHDRightLocationCell class] forCellReuseIdentifier:NSStringFromClass([GYHDRightLocationCell class])];
    [self.chatTableView registerClass:[GYHDLeftLocationCell class] forCellReuseIdentifier:NSStringFromClass([GYHDLeftLocationCell class])];
    self.chatTableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardDidHide)];
    
    @weakify(self);
    GYRefreshHeader *header = [GYRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self loadData];
        [self.chatTableView.mj_header endRefreshing];
    }];
    self.chatTableView.mj_header = header;
    [self.chatTableView addGestureRecognizer:tap];
    
    [self.view addSubview:self.chatTableView];
    self.hdInputView = [[GYHDInputView alloc] initWithFrame:self.view.bounds isCompany:self.isCompany];
    self.hdInputView.delegate=self;
    [self.view addSubview: self.hdInputView];

    [self.chatTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-62);
    }];
    [self.hdInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(260);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageChange:) name:GYHDMessageCenterDataBaseChageNotification object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)messageChange:(NSNotification *)noti{
    NSDictionary* dict = noti.object;

    // 接收消息
    if (dict[@"MSG_SendTime"] && dict[@"MSG_Content"] ) {
        
        if (![dict[GYHDDataBaseCenterMessageCard] isEqualToString:self.leftInfoModel.custID]) {
            return ;
        }
        NSDictionary *bodyDict = [GYHDUtils stringToDictionary:dict[@"MSG_Body"]];
        self.leftInfoModel.iconString = bodyDict[@"msg_icon"];
        GYHDChatModel *model = [[GYHDChatModel alloc] init];
        model.infoModel = self.leftInfoModel;
        model.messageContentString = dict[@"MSG_Content"];
        model.messageContentAttString = [GYHDUtils EmojiAttributedStringFromString:model.messageContentString];
        model.messageRecvTimeString = [self createLastTimeWithTimeString:dict[GYHDDataBaseCenterMessageSendTime]];
        model.isRight = NO;
        model.chatType = dict[GYHDDataBaseCenterMessageChatType];
        model.body=dict[GYHDDataBaseCenterMessageBody];
        model.messageID=dict[GYHDDataBaseCenterMessageID];
        model.messageFileBasePath = dict[GYHDDataBaseCenterMessageFileBasePath];
        model.messageFileDetailPath = dict[GYHDDataBaseCenterMessageFileDetailPath];
        model.messageNetWorkBasePath = dict[GYHDDataBaseCenterMessageNetWorkBasePath];
        model.messageNetWorkDetailPath = dict[GYHDDataBaseCenterMessageNetWorkDetailPath];
        model.fileRead = dict[GYHDDataBaseCenterMessageFileRead];
        [self.chatArray addObject:model];
        [self.chatTableView reloadData];
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
// 更新
    if (dict[@"msgID"] && dict[@"State"]) {
        NSInteger count = self.chatArray.count;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (int i = 0 ; i < count ; i++) {
                    GYHDChatModel* model = self.chatArray[i];
                    if ([model.messageID isEqualToString:dict[@"msgID"]]) {
                        model.messageSendState = [dict[@"State"] integerValue];
                        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                        dispatch_async_on_main_queue(^{
                            [self.chatTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:NO];
                        });
                        break;
                    }
                }
            });
 
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [[UITableViewCell alloc] init];
    cell.backgroundColor= kDefaultVCBackgroundColor;
    cell.textLabel.text = @"未设置";
    GYHDChatModel *model = self.chatArray[indexPath.row];
    if (model.isRight) {    //右边
        if ([model.chatType isEqualToString:[GYHDUtils chatText]]) {
            GYHDRightChatTextCell  *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDRightChatTextCell class])];
            baseCell.model = model;
            baseCell.delegate = self;
            cell = baseCell;
        } else  if ([model.chatType isEqualToString:[GYHDUtils chatImage]]) {
            GYHDRightChatImageCell  *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDRightChatImageCell class])];
            baseCell.delegate = self;
            baseCell.model = model;
            cell = baseCell;
        }else  if ([model.chatType isEqualToString:[GYHDUtils chatVdieo]]) {
            GYHDRightChatVideoCell  *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDRightChatVideoCell class])];
            baseCell.delegate = self;
            baseCell.model = model;
            cell = baseCell;
        }else  if ([model.chatType isEqualToString:[GYHDUtils chatAudio]]) {
            GYHDRightChatAudioCell  *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDRightChatAudioCell class])];
            baseCell.model = model;
            baseCell.delegate = self;
            cell = baseCell;
        }else if ([model.chatType isEqualToString:[GYHDUtils chatMap]]){
            
            GYHDRightLocationCell  *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDRightLocationCell class])];
            baseCell.chatModel = model;
            baseCell.delegate = self;
            cell = baseCell;
        }
    }else {                 //左边
        if ([model.chatType isEqualToString:[GYHDUtils chatText]]) {
            GYHDLeftChatTextCell  *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDLeftChatTextCell class])];
            baseCell.model = model;
            cell = baseCell;
        } else  if ([model.chatType isEqualToString:[GYHDUtils chatImage]]) {
            GYHDLeftChatImageCell  *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDLeftChatImageCell class])];
            baseCell.delegate = self;
            baseCell.model = model;
            cell = baseCell;
        }else  if ([model.chatType isEqualToString:[GYHDUtils chatVdieo]]) {
            GYHDLeftChatVideoCell  *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDLeftChatVideoCell class])];
            baseCell.delegate = self;
            baseCell.model = model;
            cell = baseCell;
        }else  if ([model.chatType isEqualToString:[GYHDUtils chatAudio]]) {
            GYHDLeftChatAudioCell  *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDLeftChatAudioCell class])];
            baseCell.model = model;
            baseCell.delegate = self;
            cell = baseCell;
        }else if ([model.chatType isEqualToString:[GYHDUtils chatGoods]]){
        
            GYHDRelatedGoodsCell *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDRelatedGoodsCell class])];
            baseCell.model = model;
            cell = baseCell;
        }else if ([model.chatType isEqualToString:[GYHDUtils chatOrder]]){
        
            GYHDRelatedOrderCell *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDRelatedOrderCell class])];
            baseCell.model = model;
        cell = baseCell;
        }else if ([model.chatType isEqualToString:[GYHDUtils chatGreeting]]){
            
            GYHDChatAdvisoryCell*baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDChatAdvisoryCell class])];
            baseCell.model=model;
            cell=baseCell;
        }else if ([model.chatType isEqualToString:[GYHDUtils chatMap]]){
            
            GYHDLeftLocationCell  *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDLeftLocationCell class])];
            baseCell.chatModel = model;
            baseCell.delegate = self;
            cell = baseCell;
        }
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GYHDChatModel *chatModel = self.chatArray[indexPath.row];
    switch ([chatModel.chatType integerValue]) {
        case GYHDDataBaseCenterMessageChatText:
            if (!chatModel.isRight) {
                return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([GYHDLeftChatTextCell class]) configuration:^(GYHDLeftChatTextCell *cell) {
                    cell.model = self.chatArray[indexPath.row];
                }];
            } else {
                return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([GYHDRightChatTextCell class]) configuration:^(GYHDRightChatTextCell *cell) {
                    cell.model = self.chatArray[indexPath.row];
                }];
            }
            break;
        case GYHDDataBaseCenterMessageChatPicture:
            
            if (!chatModel.isRight) {
                return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([GYHDLeftChatImageCell class]) configuration:^(GYHDLeftChatImageCell *cell) {
                    cell.model = self.chatArray[indexPath.row];
                }];
            } else {
                return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([GYHDRightChatImageCell class]) configuration:^(GYHDRightChatImageCell *cell) {
                    cell.model = self.chatArray[indexPath.row];
                }];
            }
            break;
        case GYHDDataBaseCenterMessageChatMap:
            return 160.0f;
        case GYHDDataBaseCenterMessageChatAudio:
            return 110.0f;
        case GYHDDataBaseCenterMessageChatOrder:
            return 120.0f;
        case GYHDDataBaseCenterMessageChatGoods:
            return 120.0f;
        case GYHDDataBaseCenterMessageTypeGreeting:
            return 60.0f;
        case GYHDDataBaseCenterMessageChatVideo:
            if (!chatModel.isRight) {
                return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([GYHDLeftChatVideoCell class]) configuration:^(GYHDLeftChatVideoCell *cell) {
                    cell.model = self.chatArray[indexPath.row];
                }];
            } else {
                return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([GYHDRightChatVideoCell class]) configuration:^(GYHDRightChatVideoCell *cell) {
                    cell.model = self.chatArray[indexPath.row];
                }];
            }
            break;
        default:
            break;
    }
    return 80;
}

//创建最后一次时间 是否隐藏 还是显示
- (void)keyboardDidHide {
    [self.hdInputView disMiss];
}
- (void)keyboardDidShow:(NSNotification*)notification {
    NSDictionary* userInfo = notification.userInfo;
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    DDLogInfo(@"显示键盘，%@" ,NSStringFromCGRect(keyboardF));
    [self.hdInputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(260-keyboardF.size.height);
    }];
    @weakify(self);
    [self.chatTableView mas_remakeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.hdInputView.mas_top);
    }];
   [self.chatTableView layoutIfNeeded];
    if (self.chatArray.count > 0) {
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];

    }
    
}
- (void)GYHDInputViewFrameDidChange:(GYHDInputView *)inputView {
    @weakify(self);
    [self.chatTableView mas_remakeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.hdInputView.mas_top);
    }];
    [self.chatTableView layoutIfNeeded];
    if (self.chatArray.count) {
        
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }

}
- (void)setCustId:(NSString *)custId {
    if ([custId isEqualToString:_custId]) {
        return;
    }
    _custId = custId;

    NSDictionary *leftDict =  [[GYHDDataBaseCenter sharedInstance] selectfriendBaseWithCardStr:custId];
    DDLogInfo(@"%@",leftDict);
    self.leftInfoModel.nameString = leftDict[@"Friend_Name"];
    NSString *friendIcon = leftDict[@"Friend_Icon"];
    if ([friendIcon hasPrefix:@"http"]) {
        self.leftInfoModel.iconString = friendIcon;
    }else {
        self.leftInfoModel.iconString =[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,leftDict[@"Friend_Icon"]];
    }
    
    self.leftInfoModel.accountID  =  [NSString stringWithFormat:@"%@",leftDict[@"Friend_ID"]];
    self.leftInfoModel.sessionid  =leftDict[@"Friend_SessionID"];
    self.leftInfoModel.custID = leftDict[@"Friend_CustID"];
    self.leftInfoModel.userState = leftDict[@"Friend_UserType"];
    
    NSDictionary *rightDict = [[GYHDDataBaseCenter sharedInstance] selectfriendBaseWithCardStr:globalData.loginModel.custId];
    self.rightInfoModel.nameString =  globalData.loginModel.operName;   //操作员名称
    self.rightInfoModel.iconString =[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,rightDict[@"Friend_Icon"]];
    self.rightInfoModel.accountID = [NSString stringWithFormat:@"p_e_%@",globalData.loginModel.custId];
    
    self.chatArray = nil;
    [self loadData];
}
- (void) loadData {
    //1. 查询数据库
    NSMutableArray* array = [NSMutableArray array];
    for (NSDictionary* dict in [[GYHDDataBaseCenter sharedInstance] selectAllChatWithCard:self.leftInfoModel.custID frome:self.chatArray.count to:20]) {
        GYHDChatModel* model = [[GYHDChatModel alloc] init];
        model.messageID = dict[GYHDDataBaseCenterMessageID];
        model.messageContentString = dict[@"MSG_Content"];
        model.messageContentAttString = [GYHDUtils EmojiAttributedStringFromString:model.messageContentString];
    
        model.isRight = [dict[GYHDDataBaseCenterMessageIsRight]  boolValue];
        model.chatType = dict[GYHDDataBaseCenterMessageChatType];
        model.body=dict[GYHDDataBaseCenterMessageBody];
        model.messageFileBasePath = dict[GYHDDataBaseCenterMessageFileBasePath];
        model.messageFileDetailPath = dict[GYHDDataBaseCenterMessageFileDetailPath];
        model.messageNetWorkBasePath = dict[GYHDDataBaseCenterMessageNetWorkBasePath];
        model.messageNetWorkDetailPath = dict[GYHDDataBaseCenterMessageNetWorkDetailPath];
        model.fileRead = dict[GYHDDataBaseCenterMessageFileRead];
        model.messageSendState = [dict[GYHDDataBaseCenterMessageSendState] integerValue];
        if (model.isRight) {
            model.infoModel = self.rightInfoModel;
        }else {
            model.infoModel = self.leftInfoModel;
        }
        model.messageRecvTimeString = [self createLastTimeWithTimeString:dict[GYHDDataBaseCenterMessageSendTime]];
        
        [array addObject:model];
    }
    NSMutableArray* fristArray = [NSMutableArray arrayWithArray:self.chatArray];
    [array addObjectsFromArray:fristArray];
    self.chatArray = array;
   [self.chatTableView reloadData];
    if (self.chatArray.count && self.chatArray.count <= 20) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
             [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        });
      
    }
    
}
- (NSString *)createLastTimeWithTimeString:(NSString *)timeString {
    NSString *recvStrimg = nil;
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* currerDate = [fmt dateFromString:timeString];
    recvStrimg = [GYHDUtils messageTimeStrFromTimerString:timeString];
    if ([currerDate timeIntervalSince1970] < self.lastTime + 20) {
        recvStrimg = @"";
    }
    self.lastTime = [currerDate timeIntervalSince1970];
    return recvStrimg;
}
#pragma mark - GYHDInputViewDelegate
- (void)GYHDInputView:(GYHDInputView *)inputView sendModel:(GYHDSendModel *)model SendType:(GYHDInputeViewSendType)type {
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        switch (type) {
            case GYHDInputeViewSendText:
            {
                [self sendTextWithModel:model];
                break;
            }
            case GYHDInputeViewSendPhoto:{
                GYHDPhotoSelectViewController*photoVc=[[GYHDPhotoSelectViewController alloc]init];
                photoVc.block=^(NSDictionary*dict){
                    @strongify(self);
                    [self sendImaageWith:dict];
                };
                dispatch_async_on_main_queue(^{
                    [self.navigationController pushViewController:photoVc animated:NO];
                });
                return;
            }
            case GYHDInputeViewSendCamara:{//照相
                
                GYHDCameraViewController*cameraVc=[[GYHDCameraViewController alloc]init];
                cameraVc.block=^(NSDictionary*dict){
                    @strongify(self);
                    [self sendCamaraWith:dict];
                };
                dispatch_async_on_main_queue(^{
                    [self.navigationController pushViewController:cameraVc animated:NO];
                });
               return;
            }
            case GYHDInputeViewSendVideo:{//视频
                
                GYHDVideoViewController*videoVc=[[GYHDVideoViewController alloc]init];
                videoVc.bloclk=^(NSDictionary*dict){
                    @strongify(self);
                    [self sendVideoWithDict:dict];
                    
                };
                dispatch_async_on_main_queue(^{
                    [self.navigationController pushViewController:videoVc animated:NO];
                });
                return;
            }
            case GYHDInputeViewSendAudio:{//音频
                [self sendAudioWithModel:model];
                break;
            }
            case GYHDInputeViewSendLocation:{//地理位置
            
                GYHDGPSViewController*locationVc=[[GYHDGPSViewController alloc]init];
                
                locationVc.block=^(BMKPoiInfo*selectPoiInfo){
                    @strongify(self);
                [self sendLocationWithBMKPoiInfo:selectPoiInfo];
                };
                
                dispatch_async_on_main_queue(^{
                       
                    [self.navigationController pushViewController:locationVc animated:NO];
                });

                break;
            }
            default:
                break;
        }
    });
}
#pragma mark - GYHDChatDelegate
- (void)GYHDChatView:(UIView *)view tapType:(GYHDChatTapType)type chatModel:(GYHDChatModel *)chatModel {
    //    [self.hdInputView disMiss];
    //    NSDictionary* DataDict = [GYUtils stringToDictionary:chatModel.chatDataString];
    //    NSDictionary* bodyDict = [GYUtils stringToDictionary:chatModel.chatBody];
    switch (type) { 
            //        case GYHDChatTapUserIcon: {
            //
            //            if (chatModel.chatIsSelfSend) {
            //                GYHDUserInfoViewController* userInfoViewController = [[GYHDUserInfoViewController alloc] init];
            //                userInfoViewController.custID = globalData.loginModel.custId;
            //                [self.navigationController pushViewController:userInfoViewController animated:YES];
            //            }
            //            else {
            //                if (self.shopID) {
            //                    GYShopAboutViewController* vc = [[GYShopAboutViewController alloc] init];
            //                    vc.strVshopId = self.shopID;
            //                    [self.navigationController pushViewController:vc animated:YES];
            //                }
            //                else {
            //                    GYHDFriendDetailViewController* friendDetailViewController = [[GYHDFriendDetailViewController alloc] init];
            //                    friendDetailViewController.FriendCustID = chatModel.chatCard;
            //                    //                friendDetailViewController.hidenSendButton = YES;
            //                    [self.navigationController pushViewController:friendDetailViewController animated:YES];
            //                }
            //            }
            //            break;
            //        }
        case GYHDChatTapResendButton: {
            [self sendMessageWithModel:chatModel];
            break;
        }
        case GYHDChatTapChatImage: {
            
            GYHDChatImageShowView* showImageView = [[GYHDChatImageShowView alloc] initWithFrame:self.navigationController.view.bounds];
            if (chatModel.messageNetWorkDetailPath.length > 1) {
                [showImageView setImageWithUrl:[NSURL URLWithString:[[GYHDMessageCenter sharedInstance]appendAuthenticationStr:chatModel.messageNetWorkDetailPath]]];
            }else {
                NSURL *url = nil;
                if ([chatModel.messageFileDetailPath hasPrefix:@"assets-library:"]) {
                    url = [NSURL URLWithString:chatModel.messageFileDetailPath];
                }else {
                    url = [NSURL fileURLWithPath:[NSString pathWithComponents:@[[GYHDUtils imagefolderNameString], chatModel.messageFileDetailPath]]];
                }
                
                [showImageView setImageWithUrl:url];
            }
            
            // [showImageView show]; 原来方法在长按时出现的MenuController，会与点击手势添加的window冲突，故而换成以下方法
            [showImageView showInView:self.navigationController.view];
            break;
        }
        case GYHDChatTapChatVideo: {
            
            NSString *filePath = nil;
            if (chatModel.messageFileDetailPath.length > 1){
                filePath = [NSString pathWithComponents:@[[GYHDUtils mp4folderNameString],chatModel.messageFileDetailPath ]];
            }
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                GYHDChatVideoShowView* showVideoView = [[GYHDChatVideoShowView alloc] init];
                showVideoView.transform = CGAffineTransformMakeRotation(M_PI);
                [showVideoView setVideoWithUrl: [NSURL fileURLWithPath:filePath]];
                [showVideoView show];
            }else {
                [[GYHDNetWorkTool sharedInstance] downloadDataWithUrlString:[[GYHDMessageCenter sharedInstance]appendAuthenticationStr:chatModel.messageNetWorkDetailPath] RequetResult:^(NSDictionary *resultDict) {
                    NSData *mp4Data = resultDict[GYNetWorkDataKey];
                    [mp4Data writeToFile:filePath atomically:NO];
                    NSURL *mp4Url = [NSURL fileURLWithPath:filePath];
                    GYHDChatVideoShowView *showVideoView = [[GYHDChatVideoShowView alloc] init];
                    showVideoView.transform = CGAffineTransformMakeRotation(M_PI);
                    [showVideoView setVideoWithUrl:mp4Url];
                    [showVideoView show];
                }];
            }
            if (!chatModel.fileRead.intValue) {
                chatModel.fileRead = @"1";
                NSDictionary *conditionDict = @{GYHDDataBaseCenterMessageID :chatModel.messageID};
                NSDictionary *updateDict =    @{GYHDDataBaseCenterMessageFileRead:chatModel.fileRead};
                [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterMessageTableName];
            }
            break;
        }
        case GYHDChatTapChatAudio: {
            NSString *filePath = nil;
            if (chatModel.messageFileDetailPath.length > 1) {
                filePath = [NSString pathWithComponents:@[[GYHDUtils mp3folderNameString],chatModel.messageFileDetailPath]];
            }
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                if ([NSStringFromClass(view.class) isEqualToString:NSStringFromClass([GYHDLeftChatAudioCell class])]) {
                    
                    GYHDLeftChatAudioCell* cell = (GYHDLeftChatAudioCell*)view;
                    if ([cell isEqual:self.leftAudioCell]) {
                        if ([cell isAudioAnimation]) {
                            [cell stopAudioAnimation];
                            [self.audioTool stopPlaying];
                        }
                        else {
                            [cell startAudioAnimation];
                            [self.audioTool playMp3WithFilePath:filePath complete:^(GYHDAudioToolPlayerState state) {
                                [cell stopAudioAnimation];
                            }];
                            
                        }
                    }
                    else {
                        [cell startAudioAnimation];
                        [self.audioTool playMp3WithFilePath:filePath complete:^(GYHDAudioToolPlayerState state) {
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
                            [self.audioTool stopPlaying];
                        }
                        else {
                            [cell startAudioAnimation];
                            [self.audioTool playMp3WithFilePath:filePath complete:^(GYHDAudioToolPlayerState state) {
                                [cell stopAudioAnimation];
                            }];
                            
                        }
                    }
                    else {
                        [cell startAudioAnimation];
                        [self.audioTool playMp3WithFilePath:filePath complete:^(GYHDAudioToolPlayerState state) {
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
                [[GYHDNetWorkTool sharedInstance] downloadDataWithUrlString:[[GYHDMessageCenter sharedInstance]appendAuthenticationStr:chatModel.messageNetWorkDetailPath] RequetResult:^(NSDictionary *resultDict) {
                    NSData *mp3Data = resultDict[GYNetWorkDataKey];
                    [mp3Data writeToFile:filePath atomically:NO];
                    if ([NSStringFromClass(view.class) isEqualToString:NSStringFromClass([GYHDLeftChatAudioCell class])]) {
                        GYHDLeftChatAudioCell *cell = (GYHDLeftChatAudioCell *)view;
                        if ([cell isEqual:self.leftAudioCell]) {
                            if ([cell isAudioAnimation]) {
                                [cell stopAudioAnimation];
                                [self.audioTool stopPlaying];
                            } else {
                                [cell startAudioAnimation];
                                [self.audioTool playMp3WithFilePath:filePath complete:^(GYHDAudioToolPlayerState state) {
                                    [cell stopAudioAnimation];
                                }];
                            }
                        } else {
                            [cell startAudioAnimation];
                            [self.audioTool playMp3WithFilePath:filePath complete:^(GYHDAudioToolPlayerState state) {
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
                                [self.audioTool stopPlaying ];
                            } else {
                                [cell startAudioAnimation];
                                [self.audioTool playMp3WithFilePath:filePath complete:^(GYHDAudioToolPlayerState state) {
                                    [cell stopAudioAnimation];
                                }];
                            }
                        } else {
                            [cell startAudioAnimation];
                            [self.audioTool playMp3WithFilePath:filePath complete:^(GYHDAudioToolPlayerState state) {
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
            if (!chatModel.fileRead.intValue) {
                chatModel.fileRead = @"1";
                NSDictionary *conditionDict = @{GYHDDataBaseCenterMessageID :chatModel.messageID};
                NSDictionary *updateDict =    @{GYHDDataBaseCenterMessageFileRead:chatModel.fileRead};
                [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterMessageTableName];
            }
            break;
        }
            
        case GYHDChatTapChatMap:
            {
                
            GYHDShowMapViewController *mapViewController =[[GYHDShowMapViewController alloc] init];
                
                NSDictionary *bodyDict = [GYHDUtils stringToDictionary:chatModel.body];
                
                NSMutableDictionary*locationDic=[NSMutableDictionary dictionary];
                locationDic[@"map_address"]=bodyDict[@"map_address"];
                locationDic[@"map_name"]= bodyDict[@"map_name"];
                locationDic[@"map_lng"]=bodyDict[@"map_lng"];
                locationDic[@"map_lat"]=bodyDict[@"map_lat"];
            mapViewController.locationDict = locationDic;
            [self.navigationController pushViewController:mapViewController animated:YES];
            break;
        }
        default:
            break;
    }
}
/**发送音频*/
- (void)sendAudioWithModel:(GYHDSendModel *)model {
    __block GYHDChatModel *chatModel = [[GYHDChatModel alloc] init];
    long long t = ([[NSDate date] timeIntervalSince1970]) * 1000;
    chatModel.messageID = [NSString stringWithFormat:@"%lld",t];
    chatModel.infoModel = self.rightInfoModel;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateString = [formatter stringFromDate:[NSDate date]];
    chatModel.messageRecvTimeString =[self createLastTimeWithTimeString:dateString];
    chatModel.isRight = YES;
    chatModel.chatType = [GYHDUtils chatAudio];
    chatModel.messageSendState = GYHDDataBaseCenterMessageSendStateSending;
    chatModel.messageFileBasePath = model.sendString ;
    chatModel.messageFileDetailPath = model.fileBaseName;
    chatModel.messageNetWorkBasePath = model.sendString;
    chatModel.messageNetWorkDetailPath = model.fileBaseName;
    chatModel.fileRead = @"1";
    [self.chatArray addObject:chatModel];
    dispatch_async_on_main_queue(^{
        
        [self.chatTableView reloadData];
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    });
    
    
    NSMutableDictionary *dbDict = [NSMutableDictionary dictionary];
    dbDict[GYHDDataBaseCenterMessageID] =  chatModel.messageID ;
    dbDict[GYHDDataBaseCenterMessageFromID] = self.rightInfoModel.accountID;
    dbDict[GYHDDataBaseCenterMessageToID] = self.leftInfoModel.accountID;
    dbDict[GYHDDataBaseCenterMessageBody] = @"";
    dbDict[GYHDDataBaseCenterMessageContent] =kLocalized(@"GYHD_Chat_Audio");
    dbDict[GYHDDataBaseCenterMessageCode] = @"-1";
    dbDict[GYHDDataBaseCenterMessageSendTime] = dateString;
    dbDict[GYHDDataBaseCenterMessageRevieTime] = dateString;
    dbDict[GYHDDataBaseCenterMessageIsRight] = @(YES);
    dbDict[GYHDDataBaseCenterMessageIsRead] = @(0);
    dbDict[GYHDDataBaseCenterMessageSendState] =@(chatModel.messageSendState);
    dbDict[GYHDDataBaseCenterMessageCard] = self.leftInfoModel.custID;
    dbDict[GYHDDataBaseCenterMessageData] = @"-1";
    dbDict[GYHDDataBaseCenterMessageUserState] = self.leftInfoModel.userState;
    dbDict[GYHDDataBaseCenterMessageChatType] =  chatModel.chatType;
    dbDict[GYHDDataBaseCenterMessageFileBasePath] =  chatModel.messageFileBasePath;
    dbDict[GYHDDataBaseCenterMessageFileDetailPath] =chatModel.messageFileDetailPath;
    dbDict[GYHDDataBaseCenterMessageNetWorkBasePath] = chatModel.messageNetWorkBasePath;
    dbDict[GYHDDataBaseCenterMessageNetWorkDetailPath] = chatModel.messageNetWorkDetailPath;
    dbDict[GYHDDataBaseCenterMessageFileRead] = @"1";
    [[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:dbDict TableName:GYHDDataBaseCenterMessageTableName];
    
    NSString *audioPath = [NSString pathWithComponents:@[[GYHDUtils mp3folderNameString], model.fileBaseName]];
    NSData *audioData = [NSData dataWithContentsOfFile:audioPath];
    [[GYHDNetWorkTool sharedInstance]postAudioWithData:audioData RequetResult:^(NSDictionary *resultDict) {
        
        if (resultDict) {
            NSString *mp3Url = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"audioUrl"]];
            GYHDChatAudioBodyModel *bodyModel = [[GYHDChatAudioBodyModel alloc] init];
            if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
                bodyModel.msg_note = self.rightInfoModel.nameString;
                bodyModel.msg_icon = self.rightInfoModel.iconString;
            }else {
                bodyModel.msg_note = globalData.loginModel.vshopName;
                bodyModel.msg_icon = [NSString stringWithFormat:@"%@%@",globalData.loginModel.hsecTfsUrl,globalData.loginModel.vshopLogo];
            }
            bodyModel.msg_fileSize = chatModel.messageFileBasePath;
            bodyModel.msg_content = mp3Url ;
            chatModel.messageBody = bodyModel;
            NSString *jsonString = bodyModel.jsonString;
            
            if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
                //    企业内部通讯
                [[GYHDSDK sharedInstance] sendMessageToFriendID:self.leftInfoModel.accountID guid:chatModel.messageID content:bodyModel.jsonString];
                
            }else {
                
                //        客服对话
                [[GYHDSDK sharedInstance]sendMessageToKefuWithSessionid:self.leftInfoModel.sessionid guid:chatModel.messageID toid:self.leftInfoModel.accountID content:bodyModel.jsonString];
            }
            
            NSDictionary *conditionDict = @{GYHDDataBaseCenterMessageID :chatModel.messageID};
            NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
            updateDict[GYHDDataBaseCenterMessageBody] = jsonString;
            updateDict[GYHDDataBaseCenterMessageNetWorkBasePath] = resultDict[@"timelen"];
            updateDict[GYHDDataBaseCenterMessageNetWorkDetailPath] = mp3Url ;
            [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterMessageTableName];
        }else {
            NSDictionary *conditionDict = @{GYHDDataBaseCenterMessageID :chatModel.messageID};
            NSDictionary *updateDict =    @{GYHDDataBaseCenterMessageSendState:@(GYHDDataBaseCenterMessageSendStateFailure)};
            [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterMessageTableName];
            
            NSUInteger count = self.chatArray.count;
            for (NSUInteger i = 0 ; i < count ; i++) {
                GYHDChatModel* model = self.chatArray[i];
                if ([model.messageID isEqualToString:chatModel.messageID]) {
                    model.messageSendState = GYHDDataBaseCenterMessageSendStateFailure;
                    NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                    dispatch_async_on_main_queue(^{
                        [self.chatTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:NO];
                    });
                    break;
                }
            }
        }
        
    }];
    
}
/**发送文字*/
- (void)sendTextWithModel:(GYHDSendModel *)model {
    
    NSString* tempStr = [GYHDUtils StringFromEmojiAttributedString:model.sendAttString];
    
    while (tempStr.length>512) {
        
        NSString * str = [tempStr substringToIndex:512];
        
        tempStr = [tempStr substringFromIndex:512];
        
        GYHDChatModel *chatModel = [[GYHDChatModel alloc] init];
        long long t = ([[NSDate date] timeIntervalSince1970]) * 1000;
        chatModel.messageID = [NSString stringWithFormat:@"%lld",t];
        chatModel.messageContentAttString = [GYHDUtils EmojiAttributedStringFromString:str];
        chatModel.infoModel = self.rightInfoModel;
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* dateString = [formatter stringFromDate:[NSDate date]];
        chatModel.messageRecvTimeString = [self createLastTimeWithTimeString:dateString];
        chatModel.isRight = YES;
        chatModel.chatType = [GYHDUtils chatText];
        chatModel.messageSendState = GYHDDataBaseCenterMessageSendStateSending;
        
        [self.chatArray addObject:chatModel];

         chatModel.messageContentString = str;
        
        GYHDChatTextBodyModel *bodyModel = [[GYHDChatTextBodyModel alloc] init];
        if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
            bodyModel.msg_note = self.rightInfoModel.nameString;
            bodyModel.msg_icon = self.rightInfoModel.iconString;
        }else {
            bodyModel.msg_note = globalData.loginModel.vshopName;
            bodyModel.msg_icon = [NSString stringWithFormat:@"%@%@",globalData.loginModel.hsecTfsUrl,globalData.loginModel.vshopLogo];
        }
        bodyModel.msg_content = chatModel.messageContentString;
        chatModel.messageBody = bodyModel;
        
        
        NSMutableDictionary *dbDict = [NSMutableDictionary dictionary];
        dbDict[GYHDDataBaseCenterMessageID] = [NSString stringWithFormat:@"%lld", t] ;
        dbDict[GYHDDataBaseCenterMessageFromID] = self.rightInfoModel.accountID;
        dbDict[GYHDDataBaseCenterMessageToID] = self.leftInfoModel.accountID;
        dbDict[GYHDDataBaseCenterMessageBody] = @"";
        dbDict[GYHDDataBaseCenterMessageContent] = chatModel.messageContentString;
        dbDict[GYHDDataBaseCenterMessageCode] = @"-1";
        dbDict[GYHDDataBaseCenterMessageSendTime] = dateString;
        dbDict[GYHDDataBaseCenterMessageRevieTime] = dateString;
        dbDict[GYHDDataBaseCenterMessageIsRight] = @(YES);
        dbDict[GYHDDataBaseCenterMessageIsRead] = @(0);
        dbDict[GYHDDataBaseCenterMessageSendState] =@(chatModel.messageSendState);
        dbDict[GYHDDataBaseCenterMessageCard] = self.leftInfoModel.custID;
        dbDict[GYHDDataBaseCenterMessageData] = @"-1";
        dbDict[GYHDDataBaseCenterMessageUserState] = self.leftInfoModel.userState;
        dbDict[GYHDDataBaseCenterMessageChatType] =  chatModel.chatType;
        dbDict[GYHDDataBaseCenterMessageFileBasePath] = @"";
        dbDict[GYHDDataBaseCenterMessageFileDetailPath] =@"";
        dbDict[GYHDDataBaseCenterMessageNetWorkBasePath] = @"";
        dbDict[GYHDDataBaseCenterMessageNetWorkDetailPath] = @"";
        dbDict[GYHDDataBaseCenterMessageFileRead] = @"1";
        [[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:dbDict TableName:GYHDDataBaseCenterMessageTableName];
        
        
        if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
            //    企业内部通讯
            [[GYHDSDK sharedInstance] sendMessageToFriendID:self.leftInfoModel.accountID guid:chatModel.messageID content:bodyModel.jsonString];
            
        }else {
            
            //        客服对话
            [[GYHDSDK sharedInstance]sendMessageToKefuWithSessionid:self.leftInfoModel.sessionid guid:chatModel.messageID toid:self.leftInfoModel.accountID content:bodyModel.jsonString];
        }
        
    }
    
    if (tempStr.length<=512) {
        
        GYHDChatModel *chatModel = [[GYHDChatModel alloc] init];
        long long t = ([[NSDate date] timeIntervalSince1970]) * 1000;
        chatModel.messageID = [NSString stringWithFormat:@"%lld",t];
        chatModel.messageContentAttString = [GYHDUtils EmojiAttributedStringFromString:tempStr];
        
        chatModel.infoModel = self.rightInfoModel;
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* dateString = [formatter stringFromDate:[NSDate date]];
        chatModel.messageRecvTimeString = [self createLastTimeWithTimeString:dateString];
        chatModel.isRight = YES;
        chatModel.chatType = [GYHDUtils chatText];
        chatModel.messageSendState = GYHDDataBaseCenterMessageSendStateSending;
        
        [self.chatArray addObject:chatModel];
        
        dispatch_async_on_main_queue(^{
            
            [self.chatTableView reloadData];
            [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        });
        
//        chatModel.messageContentString = [GYHDUtils StringFromEmojiAttributedString:chatModel.messageContentAttString];
        
        chatModel.messageContentString = tempStr;
        
        GYHDChatTextBodyModel *bodyModel = [[GYHDChatTextBodyModel alloc] init];
        if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
            bodyModel.msg_note = self.rightInfoModel.nameString;
            bodyModel.msg_icon = self.rightInfoModel.iconString;
        }else {
            bodyModel.msg_note = globalData.loginModel.vshopName;
            bodyModel.msg_icon = [NSString stringWithFormat:@"%@%@",globalData.loginModel.hsecTfsUrl,globalData.loginModel.vshopLogo];
        }
        bodyModel.msg_content = chatModel.messageContentString;
        chatModel.messageBody = bodyModel;
        
        
        NSMutableDictionary *dbDict = [NSMutableDictionary dictionary];
        dbDict[GYHDDataBaseCenterMessageID] = [NSString stringWithFormat:@"%lld", t] ;
        dbDict[GYHDDataBaseCenterMessageFromID] = self.rightInfoModel.accountID;
        dbDict[GYHDDataBaseCenterMessageToID] = self.leftInfoModel.accountID;
        dbDict[GYHDDataBaseCenterMessageBody] = @"";
        dbDict[GYHDDataBaseCenterMessageContent] = chatModel.messageContentString;
        dbDict[GYHDDataBaseCenterMessageCode] = @"-1";
        dbDict[GYHDDataBaseCenterMessageSendTime] = dateString;
        dbDict[GYHDDataBaseCenterMessageRevieTime] = dateString;
        dbDict[GYHDDataBaseCenterMessageIsRight] = @(YES);
        dbDict[GYHDDataBaseCenterMessageIsRead] = @(0);
        dbDict[GYHDDataBaseCenterMessageSendState] =@(chatModel.messageSendState);
        dbDict[GYHDDataBaseCenterMessageCard] = self.leftInfoModel.custID;
        dbDict[GYHDDataBaseCenterMessageData] = @"-1";
        dbDict[GYHDDataBaseCenterMessageUserState] = self.leftInfoModel.userState;
        dbDict[GYHDDataBaseCenterMessageChatType] =  chatModel.chatType;
        dbDict[GYHDDataBaseCenterMessageFileBasePath] = @"";
        dbDict[GYHDDataBaseCenterMessageFileDetailPath] =@"";
        dbDict[GYHDDataBaseCenterMessageNetWorkBasePath] = @"";
        dbDict[GYHDDataBaseCenterMessageNetWorkDetailPath] = @"";
        dbDict[GYHDDataBaseCenterMessageFileRead] = @"1";
        [[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:dbDict TableName:GYHDDataBaseCenterMessageTableName];
        
        
        if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
            //    企业内部通讯
            [[GYHDSDK sharedInstance] sendMessageToFriendID:self.leftInfoModel.accountID guid:chatModel.messageID content:bodyModel.jsonString];
            
        }else {
            
            //        客服对话
            [[GYHDSDK sharedInstance]sendMessageToKefuWithSessionid:self.leftInfoModel.sessionid guid:chatModel.messageID toid:self.leftInfoModel.accountID content:bodyModel.jsonString];
        }

    }
    
}
/**发送视频*/
- (void)sendVideoWithDict:(NSDictionary *)dict{
    long long t = ([[NSDate date] timeIntervalSince1970]) * 1000;
    __block GYHDChatModel *chatModel = [[GYHDChatModel alloc] init];
    chatModel.messageID = [NSString stringWithFormat:@"%lld", t];
    chatModel.messageFileBasePath =  dict[@"thumbnailsName"];
    chatModel.messageFileDetailPath = dict[@"mp4Name"];
    chatModel.infoModel = self.rightInfoModel;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateString = [formatter stringFromDate:[NSDate date]];
    chatModel.messageRecvTimeString = [self createLastTimeWithTimeString:dateString];
    chatModel.isRight = YES;
    chatModel.chatType = [GYHDUtils chatVdieo];
    chatModel.messageSendState = GYHDDataBaseCenterMessageSendStateSending;
    [self.chatArray addObject:chatModel];
    dispatch_async_on_main_queue(^{
        
        [self.chatTableView reloadData];
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    });
    
    NSString *mp4Path = [NSString pathWithComponents:@[[GYHDUtils mp4folderNameString], dict[@"mp4Name"]]];
    NSData *mp4Data = [NSData dataWithContentsOfFile:mp4Path];
    
    NSMutableDictionary *dbDict = [NSMutableDictionary dictionary];
    dbDict[GYHDDataBaseCenterMessageID] =  chatModel.messageID;
    dbDict[GYHDDataBaseCenterMessageFromID] = self.rightInfoModel.accountID;
    dbDict[GYHDDataBaseCenterMessageToID] = self.leftInfoModel.accountID;
    dbDict[GYHDDataBaseCenterMessageBody] = @"";
    dbDict[GYHDDataBaseCenterMessageContent] = chatModel.messageContentString;
    dbDict[GYHDDataBaseCenterMessageCode] = @"-1";
    dbDict[GYHDDataBaseCenterMessageSendTime] = dateString;
    dbDict[GYHDDataBaseCenterMessageRevieTime] = dateString;
    dbDict[GYHDDataBaseCenterMessageIsRight] = @(YES);
    dbDict[GYHDDataBaseCenterMessageIsRead] = @(0);
    dbDict[GYHDDataBaseCenterMessageSendState] =@(chatModel.messageSendState);
    dbDict[GYHDDataBaseCenterMessageCard] = self.leftInfoModel.custID;
    dbDict[GYHDDataBaseCenterMessageData] = @"-1";
    dbDict[GYHDDataBaseCenterMessageUserState] = self.leftInfoModel.userState;
    dbDict[GYHDDataBaseCenterMessageChatType] =  chatModel.chatType;
    dbDict[GYHDDataBaseCenterMessageFileBasePath] = chatModel.messageFileBasePath;
    dbDict[GYHDDataBaseCenterMessageFileDetailPath] = chatModel.messageFileDetailPath;
    dbDict[GYHDDataBaseCenterMessageNetWorkBasePath] = @"";
    dbDict[GYHDDataBaseCenterMessageNetWorkDetailPath] = @"";
    dbDict[GYHDDataBaseCenterMessageFileRead] = @"1";
    [[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:dbDict TableName:GYHDDataBaseCenterMessageTableName];
    
    [[GYHDNetWorkTool sharedInstance] postVideoWithData:mp4Data RequetResult:^(NSDictionary *resultDict) {
        
        if (resultDict) {

            NSString *mp4VideoPath = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"videoUrl"]];
            NSString *mp4ImagePath = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"firstFrameUrl"]];
            GYHDChatVideoBodyModel *bodyModel = [[GYHDChatVideoBodyModel alloc] init];
            if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
                bodyModel.msg_note = self.rightInfoModel.nameString;
                bodyModel.msg_icon = self.rightInfoModel.iconString;
            }else {
                bodyModel.msg_note = globalData.loginModel.vshopName;
                bodyModel.msg_icon = [NSString stringWithFormat:@"%@%@",globalData.loginModel.hsecTfsUrl,globalData.loginModel.vshopLogo];
            }
            bodyModel.msg_imageNail = mp4ImagePath;
            bodyModel.msg_content = mp4VideoPath;
            bodyModel.msg_imageNails_height = @"150";
            bodyModel.msg_imageNails_width = @"150";
            chatModel.messageBody = bodyModel;
            
            if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
                //    企业内部通讯
                [[GYHDSDK sharedInstance] sendMessageToFriendID:self.leftInfoModel.accountID guid:chatModel.messageID content:bodyModel.jsonString];
                
            }else {
                
                //        客服对话
                [[GYHDSDK sharedInstance]sendMessageToKefuWithSessionid:self.leftInfoModel.sessionid guid:chatModel.messageID toid:self.leftInfoModel.accountID content:bodyModel.jsonString];
            }
            
            NSDictionary *conditionDict = @{GYHDDataBaseCenterMessageID :chatModel.messageID};
            NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
            updateDict[GYHDDataBaseCenterMessageBody] = bodyModel.jsonString;
            updateDict[GYHDDataBaseCenterMessageNetWorkBasePath] = mp4ImagePath;
            updateDict[GYHDDataBaseCenterMessageNetWorkDetailPath] = mp4VideoPath;
            [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterMessageTableName];
        }else {
            NSDictionary *conditionDict = @{GYHDDataBaseCenterMessageID :chatModel.messageID};
            NSDictionary *updateDict =    @{GYHDDataBaseCenterMessageSendState:@(GYHDDataBaseCenterMessageSendStateFailure)};
            [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterMessageTableName];
            
            NSUInteger count = self.chatArray.count;
            for (NSUInteger i = 0 ; i < count ; i++) {
                GYHDChatModel* model = self.chatArray[i];
                if ([model.messageID isEqualToString:chatModel.messageID]) {
                    model.messageSendState = GYHDDataBaseCenterMessageSendStateFailure;
                    NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                    dispatch_async_on_main_queue(^{
                        [self.chatTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:NO];
                    });
                    break;
                }
            }
        }
        
    }];
}
/**发送照片*/
- (void)sendCamaraWith:(NSDictionary *)dict {
    GYHDChatModel *chatModel = [[GYHDChatModel alloc] init];
    long long t = ([[NSDate date] timeIntervalSince1970]) * 1000;
    chatModel.messageID = [NSString stringWithFormat:@"%lld",t];
    chatModel.messageFileBasePath = dict[@"thumbnailsName"] ;
    chatModel.messageFileDetailPath = dict[@"originalName"];
    chatModel.infoModel = self.rightInfoModel;
    chatModel.messageContentString = @"图片";
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateString = [formatter stringFromDate:[NSDate date]];
    chatModel.messageRecvTimeString = [self createLastTimeWithTimeString:dateString];
    chatModel.isRight = YES;
    chatModel.chatType = [GYHDUtils chatImage];
    chatModel.messageSendState = GYHDDataBaseCenterMessageSendStateSending;
    [self.chatArray addObject:chatModel];
    dispatch_async_on_main_queue(^{
        [self.chatTableView reloadData];
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    });
    
    NSString *iamgePath = [NSString pathWithComponents:@[[GYHDUtils imagefolderNameString], dict[@"originalName"]]];
    NSData *imageData = [NSData dataWithContentsOfFile:iamgePath];
    
    NSMutableDictionary *dbDict = [NSMutableDictionary dictionary];
    dbDict[GYHDDataBaseCenterMessageID] = [NSString stringWithFormat:@"%lld", t] ;
    dbDict[GYHDDataBaseCenterMessageFromID] = self.rightInfoModel.accountID;
    dbDict[GYHDDataBaseCenterMessageToID] = self.leftInfoModel.accountID;
    dbDict[GYHDDataBaseCenterMessageBody] = @"";
    dbDict[GYHDDataBaseCenterMessageContent] = chatModel.messageContentString;
    dbDict[GYHDDataBaseCenterMessageCode] = @"-1";
    dbDict[GYHDDataBaseCenterMessageSendTime] = dateString;
    dbDict[GYHDDataBaseCenterMessageRevieTime] = dateString;
    dbDict[GYHDDataBaseCenterMessageIsRight] = @(YES);
    dbDict[GYHDDataBaseCenterMessageIsRead] = @(0);
    dbDict[GYHDDataBaseCenterMessageSendState] =@(chatModel.messageSendState);
    dbDict[GYHDDataBaseCenterMessageCard] = self.leftInfoModel.custID;
    dbDict[GYHDDataBaseCenterMessageData] = @"-1";
    dbDict[GYHDDataBaseCenterMessageUserState] = self.leftInfoModel.userState;
    dbDict[GYHDDataBaseCenterMessageChatType] =  chatModel.chatType;
    dbDict[GYHDDataBaseCenterMessageFileBasePath] = dict[@"thumbnailsName"];
    dbDict[GYHDDataBaseCenterMessageFileDetailPath] = dict[@"originalName"];
    dbDict[GYHDDataBaseCenterMessageNetWorkBasePath] = @"";
    dbDict[GYHDDataBaseCenterMessageNetWorkDetailPath] = @"";
    dbDict[GYHDDataBaseCenterMessageFileRead] = @"1";
    [[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:dbDict TableName:GYHDDataBaseCenterMessageTableName];
    
    [[GYHDNetWorkTool sharedInstance] postImageWithData:imageData RequetResult:^(NSDictionary *resultDict) {
        
        if (resultDict) {
            NSString *bigImageUrlStr = nil;
            NSString *smallImageUrlStr = nil;
            NSString *jsonString = nil;
            bigImageUrlStr = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"bigImgUrl"]];
            smallImageUrlStr = nil;
            if ([[resultDict allKeys] containsObject:@"smallImgUrl"]) {
                smallImageUrlStr = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"smallImgUrl"]];
            } else {
                smallImageUrlStr = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"bigImgUrl"]];
            }
            GYHDChatImageBodyModel *bodyModel = [[GYHDChatImageBodyModel alloc] init];
            if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
                bodyModel.msg_note = self.rightInfoModel.nameString;
                bodyModel.msg_icon = self.rightInfoModel.iconString;
            }else {
                bodyModel.msg_note = globalData.loginModel.vshopName;
                bodyModel.msg_icon = [NSString stringWithFormat:@"%@%@",globalData.loginModel.hsecTfsUrl,globalData.loginModel.vshopLogo];
            }
            bodyModel.msg_imageNailsUrl = smallImageUrlStr;
            bodyModel.msg_content = bigImageUrlStr;
            bodyModel.msg_imageNails_height = @"150";
            bodyModel.msg_imageNails_width = @"150";
            chatModel.messageBody = bodyModel;
            jsonString = bodyModel.jsonString;
            
            if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
                //    企业内部通讯
                [[GYHDSDK sharedInstance] sendMessageToFriendID:self.leftInfoModel.accountID guid:chatModel.messageID content:bodyModel.jsonString];
                
            }else {
                
                //        客服对话
                [[GYHDSDK sharedInstance]sendMessageToKefuWithSessionid:self.leftInfoModel.sessionid guid:chatModel.messageID toid:self.leftInfoModel.accountID content:bodyModel.jsonString];
            }
            
            NSDictionary *conditionDict = @{GYHDDataBaseCenterMessageID :chatModel.messageID};
            NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
            updateDict[GYHDDataBaseCenterMessageBody] = jsonString;
            updateDict[GYHDDataBaseCenterMessageNetWorkBasePath] = smallImageUrlStr;
            updateDict[GYHDDataBaseCenterMessageNetWorkDetailPath] = bigImageUrlStr;
            [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterMessageTableName];
        }else {
            NSDictionary *conditionDict = @{GYHDDataBaseCenterMessageID :chatModel.messageID};
            NSDictionary *updateDict =    @{GYHDDataBaseCenterMessageSendState:@(GYHDDataBaseCenterMessageSendStateFailure)};
            [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterMessageTableName];
            
            NSUInteger count = self.chatArray.count;
            for (NSUInteger i = 0 ; i < count ; i++) {
                GYHDChatModel* model = self.chatArray[i];
                if ([model.messageID isEqualToString:chatModel.messageID]) {
                    model.messageSendState = GYHDDataBaseCenterMessageSendStateFailure;
                    NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                    dispatch_async_on_main_queue(^{
                        [self.chatTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:NO];
                    });
                    break;
                }
            }
        }
        
    }];

}
/**发送图片*/
- (void)sendImaageWith:(NSDictionary *)dict {
    long long t = ([[NSDate date] timeIntervalSince1970]) * 1000;
    __block  GYHDChatModel *chatModel = [[GYHDChatModel alloc] init];
    chatModel.messageFileBasePath = dict[@"originalImageUrl"];
    chatModel.messageFileDetailPath = dict[@"originalImageUrl"];
    chatModel.messageID = [NSString stringWithFormat:@"%lld",t];
    chatModel.messageImage = dict[@"thumbnailImage"];
    chatModel.infoModel = self.rightInfoModel;
    chatModel.messageContentString = kLocalized(@"GYHD_Chat_Picture");
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateString = [formatter stringFromDate:[NSDate date]];
    chatModel.messageRecvTimeString = [self createLastTimeWithTimeString:dateString];
    chatModel.isRight = YES;
    chatModel.chatType = [GYHDUtils chatImage];
    chatModel.messageSendState = GYHDDataBaseCenterMessageSendStateSending;
    [self.chatArray addObject:chatModel];
    dispatch_async_on_main_queue(^{
        [self.chatTableView reloadData];
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    });
    @weakify(self);
    ALAssetsLibrary* assetLibrary = [[ALAssetsLibrary alloc] init];
    NSURL *url = [NSURL URLWithString: dict[@"originalImageUrl"]];
    [assetLibrary assetForURL:url resultBlock:^(ALAsset* asset) {
        @strongify(self);
        UIImage *image = nil;
        if ([dict[@"original"] boolValue]) {
            image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            
        }else {
            UIImage *photoImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            if (photoImage.size.width > 1080 || photoImage.size.height > 1080) {
                image = [GYHDUtils imageCompressForWidth:photoImage targetWidth:1080];
            } else {
                image = photoImage;
            }
        }
        NSData* imageData = nil;
        if (UIImageJPEGRepresentation(image, 1)) {
            imageData = UIImageJPEGRepresentation(image, 1);
        }
        else {
            imageData = UIImagePNGRepresentation(image);
        }

        
        
        NSMutableDictionary *dbDict = [NSMutableDictionary dictionary];
        dbDict[GYHDDataBaseCenterMessageID] = [NSString stringWithFormat:@"%lld", t] ;
        dbDict[GYHDDataBaseCenterMessageFromID] = self.rightInfoModel.accountID;
        dbDict[GYHDDataBaseCenterMessageToID] = self.leftInfoModel.accountID;
        dbDict[GYHDDataBaseCenterMessageBody] = @"";
        dbDict[GYHDDataBaseCenterMessageContent] = chatModel.messageContentString;
        dbDict[GYHDDataBaseCenterMessageCode] = @"-1";
        dbDict[GYHDDataBaseCenterMessageSendTime] = dateString;
        dbDict[GYHDDataBaseCenterMessageRevieTime] = dateString;
        dbDict[GYHDDataBaseCenterMessageIsRight] = @(YES);
        dbDict[GYHDDataBaseCenterMessageIsRead] = @(0);
        dbDict[GYHDDataBaseCenterMessageSendState] =@(chatModel.messageSendState);
        dbDict[GYHDDataBaseCenterMessageCard] = self.leftInfoModel.custID;
        dbDict[GYHDDataBaseCenterMessageData] = @"-1";
        dbDict[GYHDDataBaseCenterMessageUserState] = self.leftInfoModel.userState;
        dbDict[GYHDDataBaseCenterMessageChatType] =  chatModel.chatType;
        dbDict[GYHDDataBaseCenterMessageFileBasePath] = dict[@"originalImageUrl"];
        dbDict[GYHDDataBaseCenterMessageFileDetailPath] = dict[@"originalImageUrl"];
        dbDict[GYHDDataBaseCenterMessageNetWorkBasePath] = @"";
        dbDict[GYHDDataBaseCenterMessageNetWorkDetailPath] = @"";
        dbDict[GYHDDataBaseCenterMessageFileRead] = @"1";
        [[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:dbDict TableName:GYHDDataBaseCenterMessageTableName];

        [[GYHDNetWorkTool sharedInstance] postImageWithData:imageData RequetResult:^(NSDictionary *resultDict) {
            
            if (resultDict) {
                NSString *bigImageUrlStr = nil;
                NSString *smallImageUrlStr = nil;
                NSString *jsonString = nil;
                bigImageUrlStr = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"bigImgUrl"]];
                smallImageUrlStr = nil;
                if ([[resultDict allKeys] containsObject:@"smallImgUrl"]) {
                    smallImageUrlStr = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"smallImgUrl"]];
                } else {
                    smallImageUrlStr = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"bigImgUrl"]];
                }
                GYHDChatImageBodyModel *bodyModel = [[GYHDChatImageBodyModel alloc] init];
                if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
                    bodyModel.msg_note = self.rightInfoModel.nameString;
                    bodyModel.msg_icon = self.rightInfoModel.iconString;
                }else {
                    bodyModel.msg_note = globalData.loginModel.vshopName;
                    bodyModel.msg_icon = [NSString stringWithFormat:@"%@%@",globalData.loginModel.hsecTfsUrl,globalData.loginModel.vshopLogo];
                }
                bodyModel.msg_imageNailsUrl = smallImageUrlStr;
                bodyModel.msg_content = bigImageUrlStr;
                bodyModel.msg_imageNails_height = @"150";
                bodyModel.msg_imageNails_width = @"150";
                chatModel.messageBody = bodyModel;
                jsonString = bodyModel.jsonString;
                
                if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
                    //    企业内部通讯
                    [[GYHDSDK sharedInstance] sendMessageToFriendID:self.leftInfoModel.accountID guid:chatModel.messageID content:bodyModel.jsonString];
                    
                }else {
                    
                    //        客服对话
                    [[GYHDSDK sharedInstance]sendMessageToKefuWithSessionid:self.leftInfoModel.sessionid guid:chatModel.messageID toid:self.leftInfoModel.accountID content:bodyModel.jsonString];
                }
                
                NSDictionary *conditionDict = @{GYHDDataBaseCenterMessageID :chatModel.messageID};
                NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
                updateDict[GYHDDataBaseCenterMessageBody] = jsonString;
                updateDict[GYHDDataBaseCenterMessageNetWorkBasePath] = smallImageUrlStr;
                updateDict[GYHDDataBaseCenterMessageNetWorkDetailPath] = bigImageUrlStr;
                [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterMessageTableName];
            }else {
                NSDictionary *conditionDict = @{GYHDDataBaseCenterMessageID :chatModel.messageID};
                NSDictionary *updateDict =    @{GYHDDataBaseCenterMessageSendState:@(GYHDDataBaseCenterMessageSendStateFailure)};
                [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterMessageTableName];
                
                NSUInteger count = self.chatArray.count;
                for (NSUInteger i = 0 ; i < count ; i++) {
                    GYHDChatModel* model = self.chatArray[i];
                    if ([model.messageID isEqualToString:chatModel.messageID]) {
                        model.messageSendState = GYHDDataBaseCenterMessageSendStateFailure;
                        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                        dispatch_async_on_main_queue(^{
                            [self.chatTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:NO];
                        });
                        break;
                    }
                }
            }
            
        }];
    } failureBlock:nil];
}

/*发送位置*/
-(void)sendLocationWithBMKPoiInfo:(BMKPoiInfo*)selectPoiInfo{
    
    GYHDChatModel *chatModel = [[GYHDChatModel alloc] init];
    long long t = ([[NSDate date] timeIntervalSince1970]) * 1000;
    chatModel.messageID = [NSString stringWithFormat:@"%lld",t];
    chatModel.messageContentString = kLocalized(@"GYHD_Chat_Location");
    chatModel.infoModel = self.rightInfoModel;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateString = [formatter stringFromDate:[NSDate date]];
    chatModel.messageRecvTimeString = [self createLastTimeWithTimeString:dateString];
    chatModel.isRight = YES;
    chatModel.chatType = [GYHDUtils chatMap];
    chatModel.messageSendState = GYHDDataBaseCenterMessageSendStateSending;
    
    GYHDChatLocationBodyModel *bodyModel = [[GYHDChatLocationBodyModel alloc] init];
    if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
        bodyModel.msg_note = self.rightInfoModel.nameString;
        bodyModel.msg_icon = self.rightInfoModel.iconString;
    }else {
        bodyModel.msg_note = globalData.loginModel.vshopName;
        bodyModel.msg_icon = [NSString stringWithFormat:@"%@%@",globalData.loginModel.hsecTfsUrl,globalData.loginModel.vshopLogo];
    }
    bodyModel.map_name = selectPoiInfo.name;
    bodyModel.map_address = selectPoiInfo.address;
    bodyModel.map_lng = [NSString stringWithFormat:@"%f",selectPoiInfo.pt.longitude];//经度
    bodyModel.map_lat = [NSString stringWithFormat:@"%f",selectPoiInfo.pt.latitude];//纬度
    bodyModel.map_poi = @"2";
    bodyModel.msg_content = chatModel.messageContentString;
    chatModel.messageBody = bodyModel;
    chatModel.body=bodyModel.jsonString;
    [self.chatArray addObject:chatModel];
    dispatch_async_on_main_queue(^{
        [self.chatTableView reloadData];
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    });
    
    NSMutableDictionary *dbDict = [NSMutableDictionary dictionary];
    dbDict[GYHDDataBaseCenterMessageID] = [NSString stringWithFormat:@"%lld", t] ;
    dbDict[GYHDDataBaseCenterMessageFromID] = self.rightInfoModel.accountID;
    dbDict[GYHDDataBaseCenterMessageToID] = self.leftInfoModel.accountID;
    dbDict[GYHDDataBaseCenterMessageBody] = @"";
    dbDict[GYHDDataBaseCenterMessageContent] = chatModel.messageContentString;
    dbDict[GYHDDataBaseCenterMessageCode] = @"-1";
    dbDict[GYHDDataBaseCenterMessageSendTime] = dateString;
    dbDict[GYHDDataBaseCenterMessageRevieTime] = dateString;
    dbDict[GYHDDataBaseCenterMessageIsRight] = @(YES);
    dbDict[GYHDDataBaseCenterMessageIsRead] = @(0);
    dbDict[GYHDDataBaseCenterMessageSendState] =@(chatModel.messageSendState);
    dbDict[GYHDDataBaseCenterMessageCard] = self.leftInfoModel.custID;
    dbDict[GYHDDataBaseCenterMessageData] = @"-1";
    dbDict[GYHDDataBaseCenterMessageUserState] = self.leftInfoModel.userState;
    dbDict[GYHDDataBaseCenterMessageChatType] =  chatModel.chatType;
    dbDict[GYHDDataBaseCenterMessageFileBasePath] = @"";
    dbDict[GYHDDataBaseCenterMessageFileDetailPath] =@"";
    dbDict[GYHDDataBaseCenterMessageNetWorkBasePath] = @"";
    dbDict[GYHDDataBaseCenterMessageNetWorkDetailPath] = @"";
    dbDict[GYHDDataBaseCenterMessageFileRead] = @"1";
    [[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:dbDict TableName:GYHDDataBaseCenterMessageTableName];
    
    
    if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
        //    企业内部通讯
        [[GYHDSDK sharedInstance] sendMessageToFriendID:self.leftInfoModel.accountID guid:chatModel.messageID content:bodyModel.jsonString];
        
    }else {
        
        //        客服对话
        [[GYHDSDK sharedInstance]sendMessageToKefuWithSessionid:self.leftInfoModel.sessionid guid:chatModel.messageID toid:self.leftInfoModel.accountID content:bodyModel.jsonString];
    }
    
    NSDictionary *conditionDict = @{GYHDDataBaseCenterMessageID :chatModel.messageID};
    NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
    updateDict[GYHDDataBaseCenterMessageBody] = bodyModel.jsonString;
    [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterMessageTableName];
}
//重新发送
- (void)sendMessageWithModel:(GYHDChatModel *)chatModel {
    DDLogInfo(@"重新发送");
    NSDictionary *conditionDict = @{GYHDDataBaseCenterMessageID :chatModel.messageID};
    NSDictionary *updateDict =    @{GYHDDataBaseCenterMessageSendState:@(GYHDDataBaseCenterMessageSendStateSending)};
    [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterMessageTableName];
    
    if ([chatModel.chatType isEqualToString:[GYHDUtils chatText]]) {
        
        
        GYHDChatTextBodyModel *bodyModel = [[GYHDChatTextBodyModel alloc] init];
        if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
            bodyModel.msg_note = self.rightInfoModel.nameString;
            bodyModel.msg_icon = self.rightInfoModel.iconString;
        }else {
            bodyModel.msg_note = globalData.loginModel.vshopName;
            bodyModel.msg_icon = [NSString stringWithFormat:@"%@%@",globalData.loginModel.hsecTfsUrl,globalData.loginModel.vshopLogo];
        }
        bodyModel.msg_content = chatModel.messageContentString;
        chatModel.messageBody = bodyModel;
        
        if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
            //    企业内部通讯
            [[GYHDSDK sharedInstance] sendMessageToFriendID:self.leftInfoModel.accountID guid:chatModel.messageID content:chatModel.messageBody.jsonString];
            
        }else {
            
            //        客服对话
            [[GYHDSDK sharedInstance]sendMessageToKefuWithSessionid:self.leftInfoModel.sessionid guid:chatModel.messageID toid:self.leftInfoModel.accountID content:chatModel.messageBody.jsonString];
        }
        
    }else if ([chatModel.chatType isEqualToString:[GYHDUtils chatImage]]) {
        if ([chatModel.messageFileDetailPath hasPrefix:@"assets-library:"]) {
            @weakify(self);
            ALAssetsLibrary* assetLibrary = [[ALAssetsLibrary alloc] init];
            NSURL *url = [NSURL URLWithString: chatModel.messageFileDetailPath];
            [assetLibrary assetForURL:url resultBlock:^(ALAsset* asset) {
                @strongify(self);
                UIImage *image = nil;

                UIImage *photoImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                if (photoImage.size.width > 1080 || photoImage.size.height > 1080) {
                    image = [GYHDUtils imageCompressForWidth:photoImage targetWidth:1080];
                } else {
                    image = photoImage;
                }
                
                NSData* imageData = nil;
                if (UIImageJPEGRepresentation(image, 1)) {
                    imageData = UIImageJPEGRepresentation(image, 1);
                }
                else {
                    imageData = UIImagePNGRepresentation(image);
                }
                
                
                
                NSMutableDictionary *dbDict = [NSMutableDictionary dictionary];
                dbDict[GYHDDataBaseCenterMessageID] = chatModel.messageID ;
                dbDict[GYHDDataBaseCenterMessageFromID] = self.rightInfoModel.accountID;
                dbDict[GYHDDataBaseCenterMessageToID] = self.leftInfoModel.accountID;
                dbDict[GYHDDataBaseCenterMessageBody] = @"";
                dbDict[GYHDDataBaseCenterMessageContent] = chatModel.messageContentString;
                dbDict[GYHDDataBaseCenterMessageCode] = @"-1";
                dbDict[GYHDDataBaseCenterMessageSendTime] = chatModel.messageRecvTimeString;
                dbDict[GYHDDataBaseCenterMessageRevieTime] =  chatModel.messageRecvTimeString;
                dbDict[GYHDDataBaseCenterMessageIsRight] = @(YES);
                dbDict[GYHDDataBaseCenterMessageIsRead] = @(0);
                dbDict[GYHDDataBaseCenterMessageSendState] =@(chatModel.messageSendState);
                dbDict[GYHDDataBaseCenterMessageCard] = self.leftInfoModel.custID;
                dbDict[GYHDDataBaseCenterMessageData] = @"-1";
                dbDict[GYHDDataBaseCenterMessageUserState] = self.leftInfoModel.userState;
                dbDict[GYHDDataBaseCenterMessageChatType] =  chatModel.chatType;
                dbDict[GYHDDataBaseCenterMessageFileBasePath] = chatModel.messageFileBasePath;
                dbDict[GYHDDataBaseCenterMessageFileDetailPath] = chatModel.messageFileDetailPath;
                dbDict[GYHDDataBaseCenterMessageNetWorkBasePath] = @"";
                dbDict[GYHDDataBaseCenterMessageNetWorkDetailPath] = @"";
                dbDict[GYHDDataBaseCenterMessageFileRead] = @"1";
                [[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:dbDict TableName:GYHDDataBaseCenterMessageTableName];
                
                [[GYHDNetWorkTool sharedInstance] postImageWithData:imageData RequetResult:^(NSDictionary *resultDict) {
                    
                    if (resultDict) {
                        NSString *bigImageUrlStr = nil;
                        NSString *smallImageUrlStr = nil;
                        NSString *jsonString = nil;
                        bigImageUrlStr = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"bigImgUrl"]];
                        smallImageUrlStr = nil;
                        if ([[resultDict allKeys] containsObject:@"smallImgUrl"]) {
                            smallImageUrlStr = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"smallImgUrl"]];
                        } else {
                            smallImageUrlStr = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"bigImgUrl"]];
                        }
                        GYHDChatImageBodyModel *bodyModel = [[GYHDChatImageBodyModel alloc] init];
                        if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
                            bodyModel.msg_note = self.rightInfoModel.nameString;
                            bodyModel.msg_icon = self.rightInfoModel.iconString;
                        }else {
                            bodyModel.msg_note = globalData.loginModel.vshopName;
                            bodyModel.msg_icon = [NSString stringWithFormat:@"%@%@",globalData.loginModel.hsecTfsUrl,globalData.loginModel.vshopLogo];
                        }
                        bodyModel.msg_imageNailsUrl = smallImageUrlStr;
                        bodyModel.msg_content = bigImageUrlStr;
                        bodyModel.msg_imageNails_height = @"150";
                        bodyModel.msg_imageNails_width = @"150";
                        chatModel.messageBody = bodyModel;
                        jsonString = bodyModel.jsonString;
                        
                        if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
                            //    企业内部通讯
                            [[GYHDSDK sharedInstance] sendMessageToFriendID:self.leftInfoModel.accountID guid:chatModel.messageID content:bodyModel.jsonString];
                            
                        }else {
                            
                            //        客服对话
                            [[GYHDSDK sharedInstance]sendMessageToKefuWithSessionid:self.leftInfoModel.sessionid guid:chatModel.messageID toid:self.leftInfoModel.accountID content:bodyModel.jsonString];
                        }
                        
                        NSDictionary *conditionDict = @{GYHDDataBaseCenterMessageID :chatModel.messageID};
                        NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
                        updateDict[GYHDDataBaseCenterMessageBody] = jsonString;
                        updateDict[GYHDDataBaseCenterMessageNetWorkBasePath] = smallImageUrlStr;
                        updateDict[GYHDDataBaseCenterMessageNetWorkDetailPath] = bigImageUrlStr;
                        [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterMessageTableName];
                    }else {
                        NSDictionary *conditionDict = @{GYHDDataBaseCenterMessageID :chatModel.messageID};
                        NSDictionary *updateDict =    @{GYHDDataBaseCenterMessageSendState:@(GYHDDataBaseCenterMessageSendStateFailure)};
                        [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterMessageTableName];
                        
                        NSUInteger count = self.chatArray.count;
                        for (NSUInteger i = 0 ; i < count ; i++) {
                            GYHDChatModel* model = self.chatArray[i];
                            if ([model.messageID isEqualToString:chatModel.messageID]) {
                                model.messageSendState = GYHDDataBaseCenterMessageSendStateFailure;
                                NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                                dispatch_async_on_main_queue(^{
                                    [self.chatTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:NO];
                                });
                                break;
                            }
                        }
                    }
                    
                }];
            } failureBlock:nil];
        }else {
            
            NSString *iamgePath = [NSString pathWithComponents:@[[GYHDUtils imagefolderNameString],chatModel.messageFileDetailPath]];
            NSData *imageData = [NSData dataWithContentsOfFile:iamgePath];
            [[GYHDNetWorkTool sharedInstance] postImageWithData:imageData RequetResult:^(NSDictionary *resultDict) {
                
                if (resultDict) {
                    NSString *bigImageUrlStr = nil;
                    NSString *smallImageUrlStr = nil;
                    NSString *jsonString = nil;
                    bigImageUrlStr = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"bigImgUrl"]];
                    smallImageUrlStr = nil;
                    if ([[resultDict allKeys] containsObject:@"smallImgUrl"]) {
                        smallImageUrlStr = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"smallImgUrl"]];
                    } else {
                        smallImageUrlStr = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"bigImgUrl"]];
                    }
                    GYHDChatImageBodyModel *bodyModel = [[GYHDChatImageBodyModel alloc] init];
                    if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
                        bodyModel.msg_note = self.rightInfoModel.nameString;
                        bodyModel.msg_icon = self.rightInfoModel.iconString;
                    }else {
                        bodyModel.msg_note = globalData.loginModel.vshopName;
                        bodyModel.msg_icon = [NSString stringWithFormat:@"%@%@",globalData.loginModel.hsecTfsUrl,globalData.loginModel.vshopLogo];
                    }
                    bodyModel.msg_imageNailsUrl = smallImageUrlStr;
                    bodyModel.msg_content = bigImageUrlStr;
                    bodyModel.msg_imageNails_height = @"150";
                    bodyModel.msg_imageNails_width = @"150";
                    chatModel.messageBody = bodyModel;
                    jsonString = bodyModel.jsonString;
                    
                    if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
                        //    企业内部通讯
                        [[GYHDSDK sharedInstance] sendMessageToFriendID:self.leftInfoModel.accountID guid:chatModel.messageID content:bodyModel.jsonString];
                        
                    }else {
                        
                        //        客服对话
                        [[GYHDSDK sharedInstance]sendMessageToKefuWithSessionid:self.leftInfoModel.sessionid guid:chatModel.messageID toid:self.leftInfoModel.accountID content:bodyModel.jsonString];
                    }
                    
                    NSDictionary *conditionDict = @{GYHDDataBaseCenterMessageID :chatModel.messageID};
                    NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
                    updateDict[GYHDDataBaseCenterMessageBody] = jsonString;
                    updateDict[GYHDDataBaseCenterMessageNetWorkBasePath] = smallImageUrlStr;
                    updateDict[GYHDDataBaseCenterMessageNetWorkDetailPath] = bigImageUrlStr;
                    [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterMessageTableName];
                }else {
                    NSDictionary *conditionDict = @{GYHDDataBaseCenterMessageID :chatModel.messageID};
                    NSDictionary *updateDict =    @{GYHDDataBaseCenterMessageSendState:@(GYHDDataBaseCenterMessageSendStateFailure)};
                    [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterMessageTableName];
                    
                    NSUInteger count = self.chatArray.count;
                    for (NSUInteger i = 0 ; i < count ; i++) {
                        GYHDChatModel* model = self.chatArray[i];
                        if ([model.messageID isEqualToString:chatModel.messageID]) {
                            model.messageSendState =GYHDDataBaseCenterMessageSendStateFailure;
                            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                            dispatch_async_on_main_queue(^{
                                [self.chatTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:NO];
                            });
                            break;
                        }
                    }
                }
                
            }];
        }
    } else if ([chatModel.chatType isEqualToString:[GYHDUtils chatAudio]]) {
        NSString *audioPath = [NSString pathWithComponents:@[[GYHDUtils mp3folderNameString], chatModel.messageFileDetailPath]];
        NSData *audioData = [NSData dataWithContentsOfFile:audioPath];
        [[GYHDNetWorkTool sharedInstance]postAudioWithData:audioData RequetResult:^(NSDictionary *resultDict) {
            
            if (resultDict) {
                NSString *mp3Url = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"audioUrl"]];
                GYHDChatAudioBodyModel *bodyModel = [[GYHDChatAudioBodyModel alloc] init];
                if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
                    bodyModel.msg_note = self.rightInfoModel.nameString;
                    bodyModel.msg_icon = self.rightInfoModel.iconString;
                }else {
                    bodyModel.msg_note = globalData.loginModel.vshopName;
                    bodyModel.msg_icon = [NSString stringWithFormat:@"%@%@",globalData.loginModel.hsecTfsUrl,globalData.loginModel.vshopLogo];
                }
                bodyModel.msg_fileSize = chatModel.messageFileBasePath;
                bodyModel.msg_content = mp3Url ;
                chatModel.messageBody = bodyModel;
                NSString *jsonString = bodyModel.jsonString;
                
                if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
                    //    企业内部通讯
                    [[GYHDSDK sharedInstance] sendMessageToFriendID:self.leftInfoModel.accountID guid:chatModel.messageID content:bodyModel.jsonString];
                    
                }else {
                    
                    //        客服对话
                    [[GYHDSDK sharedInstance]sendMessageToKefuWithSessionid:self.leftInfoModel.sessionid guid:chatModel.messageID toid:self.leftInfoModel.accountID content:bodyModel.jsonString];
                }
                
                NSDictionary *conditionDict = @{GYHDDataBaseCenterMessageID :chatModel.messageID};
                NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
                updateDict[GYHDDataBaseCenterMessageBody] = jsonString;
                updateDict[GYHDDataBaseCenterMessageNetWorkBasePath] = resultDict[@"timelen"];
                updateDict[GYHDDataBaseCenterMessageNetWorkDetailPath] = mp3Url ;
                [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterMessageTableName];
            }else {
                NSDictionary *conditionDict = @{GYHDDataBaseCenterMessageID :chatModel.messageID};
                NSDictionary *updateDict =    @{GYHDDataBaseCenterMessageSendState:@(GYHDDataBaseCenterMessageSendStateFailure)};
                [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterMessageTableName];
                
                NSUInteger count = self.chatArray.count;
                for (NSUInteger i = 0 ; i < count ; i++) {
                    GYHDChatModel* model = self.chatArray[i];
                    if ([model.messageID isEqualToString:chatModel.messageID]) {
                        model.messageSendState = GYHDDataBaseCenterMessageSendStateFailure;
                        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                        dispatch_async_on_main_queue(^{
                            [self.chatTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:NO];
                        });
                        break;
                    }
                }
            }
            
        }];
    }else if ([chatModel.chatType isEqualToString:[GYHDUtils chatVdieo]]) {
        NSString *mp4Path = [NSString pathWithComponents:@[[GYHDUtils mp4folderNameString], chatModel.messageFileDetailPath]];
        NSData *mp4Data = [NSData dataWithContentsOfFile:mp4Path];
        [[GYHDNetWorkTool sharedInstance] postVideoWithData:mp4Data RequetResult:^(NSDictionary *resultDict) {
            
            if (resultDict) {
                
                NSString *mp4VideoPath = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"videoUrl"]];
                NSString *mp4ImagePath = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"firstFrameUrl"]];
                GYHDChatVideoBodyModel *bodyModel = [[GYHDChatVideoBodyModel alloc] init];
                if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
                    bodyModel.msg_note = self.rightInfoModel.nameString;
                    bodyModel.msg_icon = self.rightInfoModel.iconString;
                }else {
                    bodyModel.msg_note = globalData.loginModel.vshopName;
                    bodyModel.msg_icon = [NSString stringWithFormat:@"%@%@",globalData.loginModel.hsecTfsUrl,globalData.loginModel.vshopLogo];
                }
                bodyModel.msg_imageNail = mp4ImagePath;
                bodyModel.msg_content = mp4VideoPath;
                bodyModel.msg_imageNails_height = @"150";
                bodyModel.msg_imageNails_width = @"150";
                chatModel.messageBody = bodyModel;
                                NSDictionary *conditionDict = @{GYHDDataBaseCenterMessageID :chatModel.messageID};
                
                if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
                    //    企业内部通讯
                    [[GYHDSDK sharedInstance] sendMessageToFriendID:self.leftInfoModel.accountID guid:chatModel.messageID content:bodyModel.jsonString];
                    
                }else {
                    
                    //        客服对话
                    [[GYHDSDK sharedInstance]sendMessageToKefuWithSessionid:self.leftInfoModel.sessionid guid:chatModel.messageID toid:self.leftInfoModel.accountID content:bodyModel.jsonString];
                }
                
                NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
                updateDict[GYHDDataBaseCenterMessageBody] = bodyModel.jsonString;
                updateDict[GYHDDataBaseCenterMessageNetWorkBasePath] = mp4ImagePath;
                updateDict[GYHDDataBaseCenterMessageNetWorkDetailPath] = mp4VideoPath;
                [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterMessageTableName];
            }else {
                NSDictionary *conditionDict = @{GYHDDataBaseCenterMessageID :chatModel.messageID};
                NSDictionary *updateDict =    @{GYHDDataBaseCenterMessageSendState:@(GYHDDataBaseCenterMessageSendStateFailure)};
                [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterMessageTableName];
                
                NSUInteger count = self.chatArray.count;
                for (NSUInteger i = 0 ; i < count ; i++) {
                    GYHDChatModel* model = self.chatArray[i];
                    if ([model.messageID isEqualToString:chatModel.messageID]) {
                        model.messageSendState = GYHDDataBaseCenterMessageSendStateFailure;
                        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                        dispatch_async_on_main_queue(^{
                            [self.chatTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:NO];
                        });
                        break;
                    }
                }
            }
            
        }];
    } else if ([chatModel.chatType isEqualToString:[GYHDUtils chatMap]]) {
        
                 GYHDChatLocationBodyModel *bodyModel = [[GYHDChatLocationBodyModel alloc] init];
                if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
                    bodyModel.msg_note = self.rightInfoModel.nameString;
                    bodyModel.msg_icon = self.rightInfoModel.iconString;
                }else {
                    bodyModel.msg_note = globalData.loginModel.vshopName;
                    bodyModel.msg_icon = [NSString stringWithFormat:@"%@%@",globalData.loginModel.hsecTfsUrl,globalData.loginModel.vshopLogo];
                }
        NSDictionary *bodyDict = [GYHDUtils stringToDictionary:chatModel.body];
        
        bodyModel.map_name=bodyDict[@"map_name"];
        
        bodyModel.map_address= bodyDict[@"map_address"];
        
        bodyModel.map_lng = [NSString stringWithFormat:@"%@",bodyDict[@"map_lng"]];//经度
        bodyModel.map_lat = [NSString stringWithFormat:@"%@",bodyDict[@"map_lat"]];//纬度
        bodyModel.map_poi = @"2";
        bodyModel.msg_content = chatModel.messageContentString;
        chatModel.messageBody = bodyModel;
        chatModel.body=bodyModel.jsonString;
        NSString *jsonString = bodyModel.jsonString;
                
        if ([self.leftInfoModel.userState isEqualToString:@"e"]) {
                    //    企业内部通讯
                    [[GYHDSDK sharedInstance] sendMessageToFriendID:self.leftInfoModel.accountID guid:chatModel.messageID content:bodyModel.jsonString];
                    
                }else {
                    
                    //        客服对话
                    [[GYHDSDK sharedInstance]sendMessageToKefuWithSessionid:self.leftInfoModel.sessionid guid:chatModel.messageID toid:self.leftInfoModel.accountID content:bodyModel.jsonString];
                }
                
                NSDictionary *conditionDict = @{GYHDDataBaseCenterMessageID :chatModel.messageID};
                NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
                updateDict[GYHDDataBaseCenterMessageBody] = jsonString;
        
                [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterMessageTableName];
        }
}
@end
