//
//  GYHDMessageViewController.m
//  HSCompanyPad
//
//  Created by shiang on 16/8/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDMessageViewController.h"
#import "GYHDMessageGroupCell.h"
#import "GYHDMessageListCell.h"
#import "GYHDDataBaseCenter.h"
#import "GYOrderMessageListModel.h"
#import "GYHDMsgShowPageController.h"
#import "GYMsgListContentController.h"
#import "GYHDPopMessageView.h"
#import "GYHDPopView.h"
#import <GYKit/GYRefreshFooter.h>
@interface GYHDMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
/**左边tableview*/
@property(nonatomic, strong)UITableView     *leftTableView;
/**左边表格数据源*/
@property(nonatomic, strong)NSMutableArray  *leftArray;

@property(nonatomic, strong)UITableView     *rightTableView;
@property(nonatomic, strong)NSMutableArray  *rightArray;
@property(nonatomic,assign)NSInteger ureadCount;//记录未读数量
@property(nonatomic,assign)NSInteger pushMessageCount;//推送消息拉取数量
@end

@implementation GYHDMessageViewController
#pragma mark - 懒加载数据源
-(NSMutableArray *)leftArray{

    if (!_leftArray) {
        
        _leftArray=[NSMutableArray array];
    }
    return _leftArray;
}

-(NSMutableArray*)rightArray{


    if (!_rightArray) {
        
        _rightArray=[NSMutableArray array];
    }
    return _rightArray;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self initTabelView];
    
    [self loadAllMessageListData];
    self.pushMessageCount=10;
    self.ureadCount=0;
    [self addObserver];
}
#pragma mark -监听通知
-(void)addObserver{
    
    [[GYHDMessageCenter sharedInstance] addDataBaseChangeNotificationObserver:self selector:@selector(messageCenterDataBaseChagne:)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMessageChange) name:GYHDPushMessageChageNotification object:nil];
    
}

//接收聊天通知
-(void)messageCenterDataBaseChagne:(NSNotification *)noti{
    
    NSString*companyMsgCard=[[NSUserDefaults standardUserDefaults]objectForKey:@"CompanyMsgCard"];
    
    [[GYHDDataBaseCenter sharedInstance]ClearUnreadMessageWithCard:companyMsgCard];
    
   NSString*customerMsgCard=[[NSUserDefaults standardUserDefaults]objectForKey:@"CustomerMsgCard"];
    
    [[GYHDDataBaseCenter sharedInstance]ClearUnreadMessageWithCard:customerMsgCard];
    
    
    [self loadAllMessageListData];
    
}
//接收推送通知
- (void)pushMessageChange{
    
    [self.rightArray removeAllObjects];
    
    [self loadAllMessageListData];
    
    NSString*pushMsgType=[[NSUserDefaults standardUserDefaults]objectForKey:@"pushMsgType"];
    NSString*msgType=[[NSUserDefaults standardUserDefaults]objectForKey:@"msgType"];
    
    if (pushMsgType && ![pushMsgType isEqualToString:@""] && [msgType integerValue]== GYHDMessageTpyePush) {
        
        self.rightTableView.hidden=NO;
        if ([pushMsgType integerValue]== GYHDPushMessageTpyeHuSheng) {
            
            NSArray*hsArr=[[GYHDDataBaseCenter sharedInstance]selectPushAllHuShengMsgListWithselectCount:self.pushMessageCount];
            
            for (NSDictionary*dict in hsArr) {
                
                GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
                
                [self.rightArray addObject:model];
            }
            
        }else if ([pushMsgType integerValue]== GYHDPushMessageTpyeDingDan){
            
            NSArray*orderArr=[[GYHDDataBaseCenter sharedInstance] selectPushMsgWithselectCount:self.pushMessageCount];
            for (NSDictionary *dict in orderArr) {
                
                GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
                
                [self.rightArray addObject:model];
            }
            
        }else{
            
            NSArray*orderArr=[[GYHDDataBaseCenter sharedInstance] selectPushAllFuWuMsgListWithselectCount:self.pushMessageCount];
            for (NSDictionary *dict in orderArr) {
                
                GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
                
                [self.rightArray addObject:model];
            }
            
        }
        [self.rightTableView reloadData];
    }
    
}

#pragma mark - 左右表格视图布局
-(void)initTabelView{

    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.leftTableView.dataSource = self;
    self.leftTableView.delegate = self;
    self.leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    UILongPressGestureRecognizer *gestureLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(gestureLongPress:)];
//    gestureLongPress.minimumPressDuration =1;
//    [ self.leftTableView addGestureRecognizer:gestureLongPress];
    self.leftTableView.rowHeight = UITableViewAutomaticDimension;
    self.leftTableView.estimatedRowHeight = 240;
    [self.leftTableView registerClass:[GYHDMessageGroupCell class] forCellReuseIdentifier:NSStringFromClass([GYHDMessageGroupCell class])];
    [self.view addSubview:self.leftTableView];
    
    self.rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.rightTableView.dataSource = self;
    self.rightTableView.delegate = self;
    self.rightTableView.rowHeight = 120;
    self.rightTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.rightTableView registerClass:[GYHDMessageListCell class] forCellReuseIdentifier:NSStringFromClass([GYHDMessageListCell class])];
    [self.view addSubview:self.rightTableView];
    @weakify(self);
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(325);
    }];
    
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(44);
        make.left.equalTo(self.leftTableView.mas_right);
    }];

}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHD_Message");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    DDLogInfo(@"Load Controller: %@", [self class]);
}
#pragma mark -获取各类消息列表数组
//获取所有消息数据源
-(void)loadAllMessageListData{
    self.ureadCount=0;
    [self.leftArray removeAllObjects];
    //获取推送消息最后一条数组
    NSArray*pushArr= [[GYHDDataBaseCenter sharedInstance] selectLastGroupPushMessage];
    
    for (NSDictionary*dict in pushArr) {
        if ([dict[GYHDDataBaseCenterPushMessageDelete] integerValue] == 1) {
            continue;
        }
        GYHDAllMsgListModel*model=[[GYHDAllMsgListModel alloc]init];
        model.msgType=[NSString stringWithFormat:@"%ld",GYHDMessageTpyePush];
        [model initWithDict:dict];
        model.messageUnreadCount=[[GYHDDataBaseCenter sharedInstance]UnreadPushMessageCountWithMsgID:model.pushMsgType];
        self.ureadCount +=[model.messageUnreadCount integerValue];
        [self.leftArray addObject:model];
        
    }
    
    //获取聊天消息最后一条消息数组
    NSArray*chatArr=[[GYHDDataBaseCenter sharedInstance]selectLastGroupChatAllMessage];
    
    for (NSDictionary*dict in chatArr) {
        if ([dict[GYHDDataBaseCenterMessageDelete] integerValue] == 1) {
            continue;
        }
        GYHDAllMsgListModel*model=[[GYHDAllMsgListModel alloc]init];
         model.msgType=[NSString stringWithFormat:@"%ld",GYHDMessageTpyeChat];
        [model initWithDict:dict];
        model.messageUnreadCount=[[GYHDDataBaseCenter sharedInstance] UnreadMessageCountWithCard:model.msgCard];
        self.ureadCount +=[model.messageUnreadCount integerValue];
        [self.leftArray addObject:model];
    }
    
    NSSortDescriptor* dateSort0 = [NSSortDescriptor sortDescriptorWithKey:@"messageState" ascending:YES];
    
    NSSortDescriptor* dateSort = [NSSortDescriptor sortDescriptorWithKey:@"messageTopTime" ascending:NO];
    
    NSSortDescriptor* dateSort2 = [NSSortDescriptor sortDescriptorWithKey:@"timeStr" ascending:NO];
    [self.leftArray sortUsingDescriptors:@[dateSort0,dateSort ,dateSort2]];
    
//    未读消息红点提示
    if (self.ureadCount>0) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(showMsgTip)]) {
            
            [self.delegate showMsgTip];
        }
        
    }else{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(hidenMsgTip)]) {
            
            [self.delegate hidenMsgTip];
        }
    }
    
    [self.leftTableView reloadData];

}

#pragma mark TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger count;
    if ([tableView isEqual:self.leftTableView]) {
        
      count= self.leftArray.count;
        
    }else if([tableView isEqual:self.rightTableView]) {

        count=self.rightArray.count;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if ([tableView isEqual:self.leftTableView]) {
        GYHDMessageGroupCell *baseCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GYHDMessageGroupCell class])];
        GYHDAllMsgListModel*model=self.leftArray[indexPath.row];
        
        [baseCell refreshUIWithModle:model];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell = baseCell;
        
    }else if([tableView isEqual:self.rightTableView]) {
        GYHDMessageListCell *baseCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GYHDMessageListCell class])];
        baseCell.model = self.rightArray[indexPath.row];
        cell = baseCell;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        if (tableView==self.leftTableView) {
            
            GYHDAllMsgListModel*model=self.leftArray[indexPath.row];
            if ([model.msgType integerValue]== GYHDMessageTpyePush) {
                
                for (GYHDAllMsgListModel*tempModel in self.leftArray) {
                    
                    tempModel.isSelect=NO;
                }
                model.isSelect=YES;
                [self.leftTableView reloadData];
                self.rightTableView.hidden=NO;
                self.pushMessageCount=10;
                if ([model.pushMsgType integerValue]==  GYHDPushMessageTpyeHuSheng) {
                    //                系统消息
                    [self.rightArray removeAllObjects];
                    
                    NSArray*hsArr=[[GYHDDataBaseCenter sharedInstance]selectPushAllHuShengMsgListWithselectCount:self.pushMessageCount];
                    
                    for (NSDictionary*dict in hsArr) {
                        
                        GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
                        
                        [self.rightArray addObject:model];
                    }
                    
                }else if([model.pushMsgType integerValue]== GYHDPushMessageTpyeDingDan){
                    //                 订单消息
                    [self.rightArray removeAllObjects];
                    
                    NSArray*orderArr=[[GYHDDataBaseCenter sharedInstance] selectPushMsgWithselectCount:self.pushMessageCount];
                    for (NSDictionary *dict in orderArr) {
                        
                        GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
                        
                        [self.rightArray addObject:model];
                    }
                    
                }else{
                    //                服务消息
                    [self.rightArray removeAllObjects];
                    NSArray*orderArr=[[GYHDDataBaseCenter sharedInstance]selectPushAllFuWuMsgListWithselectCount:self.pushMessageCount];
                    for (NSDictionary *dict in orderArr) {
                        
                        GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
                        
                        [self.rightArray addObject:model];
                    }
                    
                }

                [[NSUserDefaults standardUserDefaults] setObject:kSaftToNSString(model.pushMsgType)  forKey:@"pushMsgType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CustomerMsgCard"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CompanyMsgCard"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                if (self.rightArray.count>0) {
//                    增加刷新
                    [self setRefreshWithPushType:model.pushMsgType];
                }
                [self.rightTableView reloadData];
                
            }else{
                
                self.rightTableView.hidden=YES;
                
                [[GYHDDataBaseCenter sharedInstance]ClearUnreadMessageWithCard:model.msgCard];
                model.messageUnreadCount=@"";
                
                if (![model.MSG_UserState isEqualToString:@"e"]) {
                    
//                    客服咨询
                [[NSUserDefaults standardUserDefaults] setObject:kSaftToNSString(model.msgCard)  forKey:@"CustomerMsgCard"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
                    dict[@"index"]=@"1";
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:GYHDHDMainChageTabBarIndexNotification object:dict];
                    
                });
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CompanyMsgCard"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                
                }else{
//                  企业操作员

                [[NSUserDefaults standardUserDefaults] setObject:kSaftToNSString(model.msgCard)  forKey:@"CompanyMsgCard"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSMutableDictionary*dict=[NSMutableDictionary dictionary];
                dict[@"index"]=@"2";
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:GYHDHDMainChageTabBarIndexNotification object:dict];
                    
                });
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CustomerMsgCard"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                }
                
                [self.leftTableView reloadData];
            }

            [[NSUserDefaults standardUserDefaults] setObject:kSaftToNSString(model.msgType) forKey:@"msgType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotification];
        }else{
            
            GYOrderMessageListModel*model=self.rightArray[indexPath.row];
            
            [[GYHDDataBaseCenter sharedInstance]ClearUnreadPushMessageWithCard:globalData.loginModel.custId messageId:model.ID];
            model.readStatus=@"0";
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:GYHDPushMessageChageNotification object:nil];
            });
            
            [self.rightTableView reloadData];
            if (model.isShowPage) {
                
                GYHDMsgShowPageController*vc=[[GYHDMsgShowPageController alloc]init];
                vc.pageUrl=model.pageUrl;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                
                GYMsgListContentController*vc=[[GYMsgListContentController alloc]init];
                
                vc.model=model;
                
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == self.rightTableView) {
        
        return NO;
    }
    return YES;
}

#pragma mark - 置顶删除功能实现
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView) {
        
        GYHDAllMsgListModel*model=self.leftArray[indexPath.row];
        
        UITableViewRowAction * action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:kLocalized(@"GYHD_Delete") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            //Action 1
            if ([model.msgType integerValue]== GYHDMessageTpyePush) {
                NSDictionary *updateDict = @{GYHDDataBaseCenterPushMessageDelete:@1};
                NSDictionary *condDict = @{@"ID":model.ID};
                [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:condDict TableName:GYHDDataBaseCenterPushMessageTableName];
                
                [[GYHDDataBaseCenter sharedInstance] ClearUnreadPushMessageWithCard:globalData.loginModel.custId mainTpye:model.pushMsgType];
                
                self.rightTableView.hidden=YES;
                [[NSUserDefaults standardUserDefaults] setObject:@"10" forKey:@"msgType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }else {
                
                NSDictionary *updateDict = @{GYHDDataBaseCenterMessageDelete:@1};
                NSDictionary *condDict = @{GYHDDataBaseCenterMessageID:model.ID};
                [[GYHDDataBaseCenter sharedInstance]ClearUnreadMessageWithCard:model.msgCard];
                [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:condDict TableName:GYHDDataBaseCenterMessageTableName];
            }
            //        [self.leftArray removeObject:model];
            [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotification];
        }];
        action1.backgroundColor = [UIColor colorWithHex:0xfa3c28];
        
        UITableViewRowAction * action2;
        if ([model.msgType integerValue]== GYHDMessageTpyePush){
            
            
            if (model.messageState == GYHDPopMessageStateTop) {
                
                action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:kLocalized(@"GYHD_Cancel_Top") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                    //Action 2
                    
                    
                    [[GYHDDataBaseCenter sharedInstance]pushMsgClearTopWithMessageType:[NSString stringWithFormat:@"%@",model.pushMsgType]];
                    
                    [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotification];
                    
                }];
                
            }else{
                
                action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:kLocalized(@"GYHD_Top") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                    //Action 2
                    
                    
                    [[GYHDDataBaseCenter sharedInstance]pushMsgTopWithMessageType:[NSString stringWithFormat:@"%@",model.pushMsgType]];
                    
                    [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotification];
                    
                }];
            }
            
        }else if ([model.msgType integerValue]== GYHDMessageTpyeChat){
            
            
            if (model.messageState == GYHDPopMessageStateTop) {
                
                action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:kLocalized(@"GYHD_Cancel_Top") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                    //Action 2
                    
                    [[GYHDDataBaseCenter sharedInstance] msgClearTopWhitCustId:model.msgCard];
                    
                    [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotification];
                    
                }];
                
            }else{
                
                action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:kLocalized(@"GYHD_Top") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                    //Action 2
                    
                    
                    [[GYHDDataBaseCenter sharedInstance] msgTopWithCustId:model.msgCard];
                    
                    [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotification];
                    
                }];
            }
        }
        
        action2.backgroundColor = [UIColor colorWithHex:0xc7c7cc];
        
        return @[action1,action2];
  
    }
    
    return nil;
}

#pragma mark -添加上拉刷新
-(void)setRefreshWithPushType:(NSString*)pushType{
    
    GYRefreshFooter*footer=[GYRefreshFooter footerWithRefreshingBlock:^{
        
        self.pushMessageCount+=10;
        [self.rightArray removeAllObjects];
        if ([pushType integerValue]==GYHDPushMessageTpyeHuSheng) {
            
            NSArray*hsArr=[[GYHDDataBaseCenter sharedInstance]selectPushAllHuShengMsgListWithselectCount:self.pushMessageCount];
            
            for (NSDictionary*dict in hsArr) {
                
                GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
                
                [self.rightArray addObject:model];
            }
            
        }else if ([pushType integerValue]==GYHDPushMessageTpyeDingDan){
            
            NSArray*orderArr=[[GYHDDataBaseCenter sharedInstance] selectPushMsgWithselectCount:self.pushMessageCount];
            for (NSDictionary *dict in orderArr) {
                
                GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
                
                [self.rightArray addObject:model];
            }
            
        }else{
            
            NSArray*orderArr=[[GYHDDataBaseCenter sharedInstance] selectPushAllFuWuMsgListWithselectCount:self.pushMessageCount];
            for (NSDictionary *dict in orderArr) {
                
                GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
                
                [self.rightArray addObject:model];
            }
            
        }
        
        [self.rightTableView.mj_footer endRefreshing];
        [self.rightTableView reloadData];
    }];
    
    self.rightTableView.mj_footer=footer;
    
}


#pragma mark -通知移除
-(void)dealloc{
    
    [[GYHDMessageCenter sharedInstance] removeDataBaseChangeNotificationWithObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GYHDPushMessageChageNotification object:nil];
}

@end
