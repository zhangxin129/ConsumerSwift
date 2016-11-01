//
//  GYCustomerSerViceDetailView.m
//  HSCompanyPad
//
//  Created by apple on 16/10/12.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYCustomerSerViceDetailView.h"
#import "GYHDNetWorkTool.h"
#import "GYHDSessionRecordModel.h"
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
#import "GYHDRightLocationCell.h"
#import "GYHDLeftLocationCell.h"
#import "GYHDChatImageShowView.h"
#import "GYHDChatVideoShowView.h"
#import "GYHDAudioTool.h"
#import <UITableView_FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import <GYKit/GYRefreshFooter.h>
#import <GYKit/GYRefreshHeader.h>
#import "GYHDShowMapViewController.h"
@interface GYCustomerSerViceDetailView()<UITableViewDelegate,UITableViewDataSource,GYHDChatDelegate>
@property(nonatomic,strong)UITableView * customerServiceDetailTableView;
@property(nonatomic,strong)UIView * headView;
@property(nonatomic,strong)UIButton * backBtn;
@property(nonatomic,strong)UILabel * sessionLabel;
@property(nonatomic,strong)NSMutableArray * listArray;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic, weak)GYHDLeftChatAudioCell     *leftAudioCell;
@property(nonatomic, weak)GYHDRightChatAudioCell    *rightAudioCell;
@property(nonatomic, strong)GYHDAudioTool *audioTool;
@end

@implementation GYCustomerSerViceDetailView


-(NSMutableArray *)listArray{

    if (!_listArray) {
        _listArray=[NSMutableArray array];
    }
    return _listArray;
}
- (GYHDAudioTool *)audioTool {
    if (!_audioTool) {
        _audioTool = [GYHDAudioTool sharedInstance];
    }
    return _audioTool;
}

-(instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        
        self.headView=[[UIView alloc]init];
        
        self.headView.backgroundColor=[UIColor whiteColor];
        
        [self addSubview: self.headView];
        
        self.backBtn=[[UIButton alloc]init];
        
        [self.backBtn setImage:[UIImage imageNamed:@"gyhd_return_icon"] forState:UIControlStateNormal];
        
        [self.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
        [ self.headView addSubview:self.backBtn];
        
        self.sessionLabel=[[UILabel alloc]init];
        self.sessionLabel.font=[UIFont systemFontOfSize:14.0];
        self.sessionLabel.textAlignment=NSTextAlignmentCenter;
        [ self.headView addSubview:self.sessionLabel];
        
        self.customerServiceDetailTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        self.customerServiceDetailTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        self.customerServiceDetailTableView.backgroundColor=kDefaultVCBackgroundColor;
        
        self.customerServiceDetailTableView.delegate=self;
        
        self.customerServiceDetailTableView.dataSource=self;
        
        [self.customerServiceDetailTableView registerClass:[GYHDLeftChatTextCell class] forCellReuseIdentifier:NSStringFromClass([GYHDLeftChatTextCell class])];
        [self.customerServiceDetailTableView registerClass:[GYHDRightChatTextCell class] forCellReuseIdentifier:NSStringFromClass([GYHDRightChatTextCell class])];
        [self.customerServiceDetailTableView registerClass:[GYHDLeftChatImageCell class] forCellReuseIdentifier:NSStringFromClass([GYHDLeftChatImageCell class])];
        [self.customerServiceDetailTableView registerClass:[GYHDRightChatImageCell class] forCellReuseIdentifier:NSStringFromClass([GYHDRightChatImageCell class])];
        [self.customerServiceDetailTableView registerClass:[GYHDLeftChatVideoCell class] forCellReuseIdentifier:NSStringFromClass([GYHDLeftChatVideoCell class])];
        [self.customerServiceDetailTableView registerClass:[GYHDRightChatVideoCell class] forCellReuseIdentifier:NSStringFromClass([GYHDRightChatVideoCell class])];
        [self.customerServiceDetailTableView registerClass:[GYHDLeftChatAudioCell class] forCellReuseIdentifier:NSStringFromClass([GYHDLeftChatAudioCell class])];
        [self.customerServiceDetailTableView registerClass:[GYHDRightChatAudioCell class] forCellReuseIdentifier:NSStringFromClass([GYHDRightChatAudioCell class])];
        [self.customerServiceDetailTableView registerClass:[GYHDLeftChatMapCell class] forCellReuseIdentifier:NSStringFromClass([GYHDLeftChatMapCell class])];
        [self.customerServiceDetailTableView registerClass:[GYHDRightChatMapCell class] forCellReuseIdentifier:NSStringFromClass([GYHDRightChatMapCell class])];
        [self.customerServiceDetailTableView registerClass:[GYHDChatAdvisoryCell class] forCellReuseIdentifier:NSStringFromClass([GYHDChatAdvisoryCell class])];
        [self.customerServiceDetailTableView registerClass:[GYHDRelatedGoodsCell class] forCellReuseIdentifier:NSStringFromClass([GYHDRelatedGoodsCell class])];
        [self.customerServiceDetailTableView registerClass:[GYHDRelatedOrderCell class] forCellReuseIdentifier:NSStringFromClass([GYHDRelatedOrderCell class])];
        [self.customerServiceDetailTableView registerClass:[GYHDRightLocationCell class] forCellReuseIdentifier:NSStringFromClass([GYHDRightLocationCell class])];
        [self.customerServiceDetailTableView registerClass:[GYHDLeftLocationCell class] forCellReuseIdentifier:NSStringFromClass([GYHDLeftLocationCell class])];
        @weakify(self);
        
        GYRefreshHeader*header=[GYRefreshHeader headerWithRefreshingBlock:^{
            
            @strongify(self);
            self.page++;
           [self loadSessionRecordWithSessionId:self.sessionId];
            [self.customerServiceDetailTableView.mj_header endRefreshing];
        }];
        
        self.customerServiceDetailTableView.mj_header=header;
        
        GYRefreshFooter*footer=[GYRefreshFooter footerWithRefreshingBlock:^{
            
            @strongify(self);
           
             self.page=1;
            [self loadSessionRecordWithSessionId:self.sessionId];
            [self.customerServiceDetailTableView.mj_footer endRefreshing];
            
        }];
        
        self.customerServiceDetailTableView.mj_footer=footer;
        
        
        [self addSubview:self.customerServiceDetailTableView];
        
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
            
        }];
        
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(10);
            make.top.bottom.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        [self.sessionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.bottom.mas_equalTo(0);
            make.center.mas_equalTo(self.headView.center);
            
        }];
        
        [self.customerServiceDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            @strongify(self);
            
            make.top.equalTo(self.headView.mas_bottom).offset(0);
            
            make.left.right.bottom.mas_equalTo(0);
            
        }];
        
        
    }
    return self;
}



-(void)setSessionId:(NSString *)sessionId{
    
    _sessionId=sessionId;

    self.sessionLabel.text=[NSString stringWithFormat:@"%@：%@",kLocalized(@"GYHD_SessionId"),sessionId];
    
    self.page=1;

    [self loadSessionRecordWithSessionId:sessionId];
    
}

-(void)loadSessionRecordWithSessionId:(NSString*)sessionId{
    
    [[GYHDNetWorkTool sharedInstance] querySessionRecordWithSession:sessionId  page:self.page RequetResult:^(NSArray *resultArry) {
        
        if (resultArry!=nil && resultArry.count>0) {
            
            if (self.page==1) {
                
                [self.listArray removeAllObjects];
            }
            
            
            for (int i = resultArry.count-1; i >= 0;i--) {
                
                GYHDSessionRecordModel*model=[[GYHDSessionRecordModel alloc]init];
                NSDictionary *dict = resultArry[i];
                [model initWithDict:dict];
                //                [self.listArray addObject:model];
                [self.listArray insertObject:model atIndex:0];
                
            }
 
            [self.customerServiceDetailTableView reloadData];
        }
        
    }];

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listArray.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = nil;
    cell = [[UITableViewCell alloc] init];
    cell.backgroundColor= kDefaultVCBackgroundColor;
    cell.textLabel.text = @"未设置";
    GYHDSessionRecordModel *model = self.listArray[indexPath.row];
    if (model.isRight) {    //右边
        if ([model.chatType isEqualToString:[GYHDUtils chatText]]) {
            GYHDRightChatTextCell  *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDRightChatTextCell class])];
            baseCell.sessionModel = model;
            baseCell.delegate = self;
            cell = baseCell;
        } else  if ([model.chatType isEqualToString:[GYHDUtils chatImage]]) {
            GYHDRightChatImageCell  *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDRightChatImageCell class])];
            baseCell.delegate = self;
            baseCell.sessionModel = model;
            cell = baseCell;
        }else  if ([model.chatType isEqualToString:[GYHDUtils chatVdieo]]) {
            GYHDRightChatVideoCell  *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDRightChatVideoCell class])];
            baseCell.delegate = self;
            baseCell.sessionModel = model;
            cell = baseCell;
        }else  if ([model.chatType isEqualToString:[GYHDUtils chatAudio]]) {
            GYHDRightChatAudioCell  *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDRightChatAudioCell class])];
            baseCell.sessionModel = model;
            baseCell.delegate = self;
            cell = baseCell;
        }else  if ([model.chatType isEqualToString:[GYHDUtils chatMap]]) {
            GYHDRightLocationCell  *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDRightLocationCell class])];
            baseCell.sessionModel = model;
            baseCell.delegate = self;
            cell = baseCell;
        }
        
    }else {                 //左边
        if ([model.chatType isEqualToString:[GYHDUtils chatText]]) {
            GYHDLeftChatTextCell  *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDLeftChatTextCell class])];
            baseCell.sessionModel = model;
            cell = baseCell;
        } else  if ([model.chatType isEqualToString:[GYHDUtils chatImage]]) {
            GYHDLeftChatImageCell  *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDLeftChatImageCell class])];
            baseCell.delegate = self;
            baseCell.sessionModel = model;
            cell = baseCell;
        }else  if ([model.chatType isEqualToString:[GYHDUtils chatVdieo]]) {
            GYHDLeftChatVideoCell  *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDLeftChatVideoCell class])];
            baseCell.delegate = self;
            baseCell.sessionModel = model;
            cell = baseCell;
        }else  if ([model.chatType isEqualToString:[GYHDUtils chatAudio]]) {
            GYHDLeftChatAudioCell  *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDLeftChatAudioCell class])];
            baseCell.sessionModel = model;
            baseCell.delegate = self;
            cell = baseCell;
        }else if ([model.chatType isEqualToString:[GYHDUtils chatGoods]]){
            
            GYHDRelatedGoodsCell *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDRelatedGoodsCell class])];
            baseCell.sessionModel = model;
            cell = baseCell;
        }else if ([model.chatType isEqualToString:[GYHDUtils chatOrder]]){
            
            GYHDRelatedOrderCell *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDRelatedOrderCell class])];
            baseCell.sessionModel = model;
            cell = baseCell;
        }else if ([model.chatType isEqualToString:[GYHDUtils chatGreeting]]){
            
            GYHDChatAdvisoryCell*baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDChatAdvisoryCell class])];
            baseCell.sessionModel=model;
            cell=baseCell;
        }else  if ([model.chatType isEqualToString:[GYHDUtils chatMap]]) {
            GYHDLeftLocationCell  *baseCell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([GYHDLeftLocationCell class])];
            baseCell.sessionModel = model;
            baseCell.delegate = self;
            cell = baseCell;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GYHDSessionRecordModel *chatModel = self.listArray[indexPath.row];
    switch ([chatModel.chatType integerValue]) {
        case GYHDDataBaseCenterMessageChatText:
            if (!chatModel.isRight) {
                return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([GYHDLeftChatTextCell class]) configuration:^(GYHDLeftChatTextCell *cell) {
                    cell.sessionModel = self.listArray[indexPath.row];
                }];
            } else {
                return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([GYHDRightChatTextCell class]) configuration:^(GYHDRightChatTextCell *cell) {
                    cell.sessionModel = self.listArray[indexPath.row];
                }];
            }
            break;
        case GYHDDataBaseCenterMessageChatPicture:
            
            if (!chatModel.isRight) {
                return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([GYHDLeftChatImageCell class]) configuration:^(GYHDLeftChatImageCell *cell) {
                    cell.sessionModel = self.listArray[indexPath.row];
                }];
            } else {
                return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([GYHDRightChatImageCell class]) configuration:^(GYHDRightChatImageCell *cell) {
                    cell.sessionModel = self.listArray[indexPath.row];
                }];
            }
            break;
        case GYHDDataBaseCenterMessageChatMap:
            return 180.0f;
        case GYHDDataBaseCenterMessageChatAudio:
            return 130.0f;
        case GYHDDataBaseCenterMessageChatOrder:
            return 120.0f;
        case GYHDDataBaseCenterMessageChatGoods:
            return 120.0f;
        case GYHDDataBaseCenterMessageTypeGreeting:
            return 60.0f;
        case GYHDDataBaseCenterMessageChatVideo:
            if (!chatModel.isRight) {
                return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([GYHDLeftChatVideoCell class]) configuration:^(GYHDLeftChatVideoCell *cell) {
                    cell.sessionModel = self.listArray[indexPath.row];
                }];
            } else {
                return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([GYHDRightChatVideoCell class]) configuration:^(GYHDRightChatVideoCell *cell) {
                    cell.sessionModel = self.listArray[indexPath.row];
                }];
            }
            break;
        default:
            break;
    }
    return 80;
}


#pragma mark - GYHDChatDelegate
- (void)GYHDChatView:(UIView *)view tapType:(GYHDChatTapType)type sessionModel:(GYHDSessionRecordModel *)sessionModel{
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
            
        case GYHDChatTapChatImage: {
            UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
            
            GYHDChatImageShowView* showImageView = [[GYHDChatImageShowView alloc] initWithFrame:window.frame];
            if (sessionModel.messageNetWorkDetailPath.length > 1) {
                [showImageView setImageWithUrl:[NSURL URLWithString:[[GYHDMessageCenter sharedInstance]appendAuthenticationStr:sessionModel.messageNetWorkDetailPath]]];
            }else {
                NSURL *url = nil;
                if ([sessionModel.messageFileDetailPath hasPrefix:@"assets-library:"]) {
                    url = [NSURL URLWithString:sessionModel.messageFileDetailPath];
                }else {
                    url = [NSURL fileURLWithPath:[NSString pathWithComponents:@[[GYHDUtils imagefolderNameString], sessionModel.messageFileDetailPath]]];
                }
                
                [showImageView setImageWithUrl:url];
            }
            // [showImageView show]; 原来方法在长按时出现的MenuController，会与点击手势添加的window冲突，故而换成以下方法
            [showImageView showInView:window];
            break;
        }
        case GYHDChatTapChatVideo: {
            
            NSString *filePath = nil;
            if (sessionModel.messageFileDetailPath.length > 1){
                filePath = [NSString pathWithComponents:@[[GYHDUtils mp4folderNameString],sessionModel.messageFileDetailPath ]];
            }
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                GYHDChatVideoShowView* showVideoView = [[GYHDChatVideoShowView alloc] init];
                showVideoView.transform = CGAffineTransformMakeRotation(M_PI);
                [showVideoView setVideoWithUrl: [NSURL fileURLWithPath:filePath]];
                [showVideoView show];
            }else {
                [[GYHDNetWorkTool sharedInstance] downloadDataWithUrlString:[[GYHDMessageCenter sharedInstance]appendAuthenticationStr:sessionModel.messageNetWorkDetailPath] RequetResult:^(NSDictionary *resultDict) {
                    NSData *mp4Data = resultDict[GYNetWorkDataKey];
                    [mp4Data writeToFile:filePath atomically:NO];
                    NSURL *mp4Url = [NSURL fileURLWithPath:filePath];
                    GYHDChatVideoShowView *showVideoView = [[GYHDChatVideoShowView alloc] init];
                    showVideoView.transform = CGAffineTransformMakeRotation(M_PI);
                    [showVideoView setVideoWithUrl:mp4Url];
                    [showVideoView show];
                }];
            }
            break;
        }
        case GYHDChatTapChatAudio: {
            NSString *filePath = nil;
            if (sessionModel.messageFileDetailPath.length > 1) {
                filePath = [NSString pathWithComponents:@[[GYHDUtils mp3folderNameString],sessionModel.messageFileDetailPath]];
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
                [[GYHDNetWorkTool sharedInstance] downloadDataWithUrlString:[[GYHDMessageCenter sharedInstance]appendAuthenticationStr:sessionModel.messageNetWorkDetailPath] RequetResult:^(NSDictionary *resultDict) {
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

            break;
        }
            
        case GYHDChatTapChatMap:
        {
            GYHDShowMapViewController *mapViewController =[[GYHDShowMapViewController alloc] init];
            
            NSDictionary *bodyDict = [GYHDUtils stringToDictionary:sessionModel.msgContent];
            
            NSMutableDictionary*locationDic=[NSMutableDictionary dictionary];
            locationDic[@"map_address"]=bodyDict[@"map_address"];
            locationDic[@"map_name"]= bodyDict[@"map_name"];
            locationDic[@"map_lng"]=bodyDict[@"map_lng"];
            locationDic[@"map_lat"]=bodyDict[@"map_lat"];
            mapViewController.locationDict = locationDic;
        [self.managementVc.navigationController pushViewController:mapViewController animated:YES];

            break;
        }
        default:
            break;
    }
}

-(void)backAction{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hidenGYCustomerSerViceDetailView)]) {
        
        [self.delegate hidenGYCustomerSerViceDetailView];
    }

}
@end
