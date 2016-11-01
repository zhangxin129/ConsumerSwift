//
//  GYHDMsgListNewController.m
//  GYRestaurant
//
//  Created by apple on 16/7/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDMsgListNewController.h"
//#import "GYHDChatViewController.h"
#import "GYHDMessageCenter.h"
#import "GYHDAllMsgListModel.h"
#import "GYHDAllMsgListCell.h"
#import "GYHDPushMsgListCell.h"
#import "GYHDMsgShowPageController.h"
#import "GYMsgListContentController.h"
#import "GYHDStaffInfoViewController.h"
#import "GYHDPopMessageView.h"
#import "GYHDPopView.h"
#import "GYRefreshFooter.h"
#import "GYRefreshHeader.h"
@interface GYHDMsgListNewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView*msgTableView;
//@property(nonatomic,strong)GYHDChatViewController*chatController;
@property(nonatomic,strong)UITableView*pushTabelView;
@property(nonatomic,strong)NSMutableArray*msgListArr;
@property(nonatomic,strong)NSMutableArray*pushMsgArr;
@property(nonatomic,assign)NSInteger ureadCount;//记录未读数量
@property(nonatomic,assign)NSInteger pushMessageCount;
@end

@implementation GYHDMsgListNewController

-(UITableView *)msgTableView{

    if (!_msgTableView) {
        
        _msgTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,350, kScreenHeight-64) style:UITableViewStylePlain];
        [_msgTableView registerClass:[GYHDAllMsgListCell class] forCellReuseIdentifier:@"GYHDAllMsgListCell"];
        _msgTableView.delegate=self;
        _msgTableView.dataSource=self;
        UILongPressGestureRecognizer *gestureLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(gestureLongPress:)];
            gestureLongPress.minimumPressDuration =1;
        [_msgTableView addGestureRecognizer:gestureLongPress];
        _msgTableView.tableFooterView=[[UIView alloc]init];
        [self.view addSubview:_msgTableView];
    }
    
    return _msgTableView;

}
-(UITableView *)pushTabelView{

    if (!_pushTabelView) {
        
        _pushTabelView=[[UITableView alloc]initWithFrame:CGRectMake(370, 0, kScreenWidth-390, kScreenHeight-64) style:UITableViewStylePlain];
        _pushTabelView.delegate=self;
        _pushTabelView.dataSource=self;
        [_pushTabelView registerClass:[GYHDPushMsgListCell class] forCellReuseIdentifier:@"GYHDPushMsgListCell"];
        _pushTabelView.tableFooterView=[[UIView alloc]init];
        _pushTabelView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _pushTabelView.showsVerticalScrollIndicator=NO;
        [self.view addSubview:_pushTabelView];
    }

    return _pushTabelView;
}
//-(GYHDChatViewController *)chatController{
//    
//    if (!_chatController) {
//        
//        _chatController=[[GYHDChatViewController alloc]init];
//        
//        [_chatController.view setFrame:CGRectMake(350, 0, kScreenWidth-350, kScreenHeight-64)];
//        [self addChildViewController:_chatController];
//        [self.view addSubview:_chatController.view];
//        
//    }
//    return _chatController;
//    
//}
-(NSMutableArray *)msgListArr{
    
    if (!_msgListArr) {
        
        _msgListArr=[NSMutableArray array];
    }
    return _msgListArr;
}

-(NSMutableArray *)pushMsgArr{

    if (!_pushMsgArr) {
        
        _pushMsgArr=[NSMutableArray array];
    }
    return _pushMsgArr;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.pushMsgArr removeAllObjects];
    NSString*pushMsgType=[[NSUserDefaults standardUserDefaults]objectForKey:@"pushMsgType"];
    NSString*msgType=[[NSUserDefaults standardUserDefaults]objectForKey:@"msgType"];
//    NSString*msgCard=[[NSUserDefaults standardUserDefaults]objectForKey:@"msgCard"];
    
    if ([msgType isEqualToString:@"9"]) {
        
    [self setRefreshWithPushType:pushMsgType];
        
//      self.chatController.view.hidden=YES;
        self.pushTabelView.hidden=NO;
        if ([pushMsgType isEqualToString:@"1"]) {
            
            NSArray*hsArr=[[GYHDMessageCenter sharedInstance]selectPushAllHuShengMsgListWithselectCount:10];
            
            for (NSDictionary*dict in hsArr) {
                
                GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
                
                [self.pushMsgArr addObject:model];
            }
            
        }else if ([pushMsgType isEqualToString:@"2"]){
        
            NSArray*orderArr=[[GYHDMessageCenter sharedInstance] selectPushMsgWithselectCount:10];
            for (NSDictionary *dict in orderArr) {
                
                GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
                
                [self.pushMsgArr addObject:model];
            }

        }else{
        
            NSArray*orderArr=[[GYHDMessageCenter sharedInstance] selectPushAllFuWuMsgListWithselectCount:10];
            for (NSDictionary *dict in orderArr) {
                
                GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
                
                [self.pushMsgArr addObject:model];
            }
            
        }
         [self.pushTabelView reloadData];
    }
//    else{
//    
//    
//        for (GYHDAllMsgListModel*model in self.msgListArr) {
//            
//            if ([model.msgCard isEqualToString:msgCard]) {
//                self.pushTabelView.hidden=YES;
//                self.chatController.view.hidden=NO;
//                GYHDCustomerModel*customerModel=[[GYHDCustomerModel alloc]init];
//                customerModel.Friend_CustID=model.msgCard;
//                self.chatController.model=customerModel;
//                self.chatController.messageCard=model.msgCard;
//                
//            }
//            
//            
//        }
//    
//    }
//    
//
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:245/250.0 green:245/250.0 blue:245/250.0 alpha:1.0];
    self.pushMessageCount=10;
    self.ureadCount=0;
    [self addObserver];
    [self loadAllMessageListData];
    
}

-(void)setRefreshWithPushType:(NSString*)pushType{

    GYRefreshFooter*footer=[GYRefreshFooter footerWithRefreshingBlock:^{
        
        self.pushMessageCount+=10;
        [self.pushMsgArr removeAllObjects];
        if ([pushType isEqualToString:@"1"]) {
            
            NSArray*hsArr=[[GYHDMessageCenter sharedInstance]selectPushAllHuShengMsgListWithselectCount:self.pushMessageCount];
            
            for (NSDictionary*dict in hsArr) {
                
                GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
                
                [self.pushMsgArr addObject:model];
            }
            
        }else if ([pushType isEqualToString:@"2"]){
            
            NSArray*orderArr=[[GYHDMessageCenter sharedInstance] selectPushMsgWithselectCount:self.pushMessageCount];
            for (NSDictionary *dict in orderArr) {
                
                GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
                
                [self.pushMsgArr addObject:model];
            }
            
        }else{
            
            NSArray*orderArr=[[GYHDMessageCenter sharedInstance] selectPushAllFuWuMsgListWithselectCount:self.pushMessageCount];
            for (NSDictionary *dict in orderArr) {
                
                GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
                
                [self.pushMsgArr addObject:model];
            }
            
        }
        
        [self.pushTabelView.mj_footer endRefreshing];
        [self.pushTabelView reloadData];
    }];

    self.pushTabelView.mj_footer=footer;

}
-(void)addObserver{

    [[GYHDMessageCenter sharedInstance] addDataBaseChangeNotificationObserver:self selector:@selector(messageCenterDataBaseChagne:)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMessageChange) name:@"pushMessage" object:nil];
}
//获取所有消息数据源
-(void)loadAllMessageListData{
    
    [self.msgListArr removeAllObjects];
    //获取推送消息最后一条数组
    NSArray*pushArr= [[GYHDMessageCenter sharedInstance] selectLastGroupPushMessage];
    
    for (NSDictionary*dict in pushArr) {
        
        GYHDAllMsgListModel*model=[[GYHDAllMsgListModel alloc]init];
            model.msgType=@"9";
        [model initWithDict:dict];
        model.messageUnreadCount=[[GYHDMessageCenter sharedInstance]UnreadPushMessageCountWithMsgID:model.pushMsgType];
        self.ureadCount +=[model.messageUnreadCount integerValue];
        [self.msgListArr addObject:model];
        
    }
    //获取聊天消息最后一条消息数组
    NSArray*chatArr=[[GYHDMessageCenter sharedInstance]selectLastGroupChatAllMessage];
    
    for (NSDictionary*dict in chatArr) {
        
        GYHDAllMsgListModel*model=[[GYHDAllMsgListModel alloc]init];
        model.msgType=@"10";
        [model initWithDict:dict];
        model.messageUnreadCount=[[GYHDMessageCenter sharedInstance] UnreadMessageCountWithCard:model.msgCard];
        self.ureadCount +=[model.messageUnreadCount integerValue];
        [self.msgListArr addObject:model];
    }
    
    NSSortDescriptor* dateSort0 = [NSSortDescriptor sortDescriptorWithKey:@"messageState" ascending:YES];
    
    NSSortDescriptor* dateSort = [NSSortDescriptor sortDescriptorWithKey:@"messageTopTime" ascending:NO];
    
    NSSortDescriptor* dateSort2 = [NSSortDescriptor sortDescriptorWithKey:@"timeStr" ascending:NO];
    [self.msgListArr sortUsingDescriptors:@[dateSort0,dateSort ,dateSort2]];
    
    if (self.ureadCount>0) {
        
        [self.mainView showMsgLabel];
    }
    
    [self.msgTableView reloadData];
}
//接收聊天通知
-(void)messageCenterDataBaseChagne:(NSNotification *)noti{

    [self loadAllMessageListData];

}
//接收推送通知
- (void)pushMessageChange{
    [self.pushMsgArr removeAllObjects];
    
  [self loadAllMessageListData];

    NSString*pushMsgType=[[NSUserDefaults standardUserDefaults]objectForKey:@"pushMsgType"];
    NSString*msgType=[[NSUserDefaults standardUserDefaults]objectForKey:@"msgType"];
    
    if (pushMsgType && ![pushMsgType isEqualToString:@""] && [msgType isEqualToString:@"9"]) {
//        self.chatController.view.hidden=YES;
        self.pushTabelView.hidden=NO;
        if ([pushMsgType isEqualToString:@"1"]) {
            
            NSArray*hsArr=[[GYHDMessageCenter sharedInstance]selectPushAllHuShengMsgListWithselectCount:self.pushMessageCount];
            
            for (NSDictionary*dict in hsArr) {
                
                GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
                
                [self.pushMsgArr addObject:model];
            }
            
        }else if ([pushMsgType isEqualToString:@"2"]){
            
            NSArray*orderArr=[[GYHDMessageCenter sharedInstance] selectPushMsgWithselectCount:self.pushMessageCount];
            for (NSDictionary *dict in orderArr) {
                
                GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
                
                [self.pushMsgArr addObject:model];
            }
            
        }else{
            
            NSArray*orderArr=[[GYHDMessageCenter sharedInstance] selectPushAllFuWuMsgListWithselectCount:self.pushMessageCount];
            for (NSDictionary *dict in orderArr) {
                
                GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
                
                [self.pushMsgArr addObject:model];
            }
            
        }
        [self.pushTabelView reloadData];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.msgTableView) {
        
        return self.msgListArr.count;
    }
    return self.pushMsgArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.msgTableView) {
        
        GYHDAllMsgListCell*cell=[tableView dequeueReusableCellWithIdentifier:@"GYHDAllMsgListCell"];
        GYHDAllMsgListModel*model=self.msgListArr[indexPath.row];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell refreshUIWithModle:model];
        return cell;
        
    }
    
    GYHDPushMsgListCell*cell=[tableView dequeueReusableCellWithIdentifier:@"GYHDPushMsgListCell"];
    GYOrderMessageListModel*model=self.pushMsgArr[indexPath.row];
    cell.model=model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.msgTableView) {
        
        GYHDAllMsgListModel*model=self.msgListArr[indexPath.row];
        if ([model.msgType isEqualToString:@"9"]) {
//           推送
//          self.chatController.view.hidden=YES;
            self.pushTabelView.hidden=NO;
            
            [self setRefreshWithPushType:model.pushMsgType];
            
            if ([model.pushMsgType isEqualToString:@"1"]) {
//                系统消息
                [self.pushMsgArr removeAllObjects];
                
                NSArray*hsArr=[[GYHDMessageCenter sharedInstance]selectPushAllHuShengMsgListWithselectCount:self.pushMessageCount];
                
                for (NSDictionary*dict in hsArr) {
                    
                    GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
                    
                    [self.pushMsgArr addObject:model];
                }
                
            }else if([model.pushMsgType isEqualToString:@"2"]){
//                 订单消息
                [self.pushMsgArr removeAllObjects];
                
                NSArray*orderArr=[[GYHDMessageCenter sharedInstance] selectPushMsgWithselectCount:self.pushMessageCount];
                for (NSDictionary *dict in orderArr) {
                    
                    GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
                    
                    [self.pushMsgArr addObject:model];
                }
            
            }else{
//                服务消息
                [self.pushMsgArr removeAllObjects];
                NSArray*orderArr=[[GYHDMessageCenter sharedInstance]selectPushAllFuWuMsgListWithselectCount:self.pushMessageCount];
                for (NSDictionary *dict in orderArr) {
                    
                    GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
                    
                    [self.pushMsgArr addObject:model];
                }
            
            }

            [[NSUserDefaults standardUserDefaults] setObject:model.pushMsgType forKey:@"pushMsgType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
//            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"msgCard"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
            
             [self.pushTabelView reloadData];
        }else{
            self.pushTabelView.hidden=YES;
//            self.chatController.view.hidden=NO;
////        聊天
//            GYHDCustomerModel*customerModel=[[GYHDCustomerModel alloc]init];
//            customerModel.Friend_CustID=model.msgCard;
//            self.chatController.model=customerModel;
//            self.chatController.messageCard=model.msgCard;
        
            [[GYHDMessageCenter sharedInstance]ClearUnreadMessageWithCard:model.msgCard];
            model.messageUnreadCount=@"";
            
//            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"pushMsgType"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
            if ([model.MSG_UserState isEqualToString:@"c"]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:model.msgCard forKey:@"customerIndex"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"navindex"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSMutableDictionary*dic=[NSMutableDictionary dictionary];
                [dic setObject:@"" forKey:@"primaryId"];
                [dic setObject:@"" forKey:@"name"];
                [dic setObject:model.msgCard forKey:@"msgCard"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"popCustomerMessage" object:dic];
                
                [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            }else{
            
                GYHDStaffInfoViewController*vc=[[GYHDStaffInfoViewController alloc]init];
                GYHDOpereotrListModel *tempModel=[[GYHDOpereotrListModel alloc]init];
                NSDictionary*dict=[[GYHDMessageCenter sharedInstance]selectFriendBaseWithCardString:model.msgCard];
                
                NSDictionary *friendDetailDict =  [Utils stringToDictionary:dict[@"Friend_Basic"]];
                
                tempModel.roleName= friendDetailDict[@"roleName"];
                
                tempModel.saleAndOperatorRelationList=friendDetailDict[@"saleAndOperatorRelationList"];
            tempModel.searchUserInfo=friendDetailDict[@"searchUserInfo"];
                
                vc.OperatorModel=tempModel;
                vc.isCheckAllOperator=YES;
                [self.navigationController pushViewController:vc animated:YES];
            
            }
            
            [self.msgTableView reloadData];
        }
        [[NSUserDefaults standardUserDefaults] setObject:model.msgType forKey:@"msgType"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
    
        GYOrderMessageListModel*model=self.pushMsgArr[indexPath.row];
        
        [[GYHDMessageCenter sharedInstance]ClearUnreadPushMessageWithCard:globalData.loginModel.custId messageId:model.ID];
            model.readStatus=@"0";
        [self.pushTabelView reloadData];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView==self.msgTableView) {
        
        return 70;
    }
    
    GYOrderMessageListModel*model=self.pushMsgArr[indexPath.row];
    
    CGFloat rowHight= [Utils heightForString:model.messageListContent font:[UIFont systemFontOfSize:16.0] width:kScreenWidth-430];
    
    return 85+rowHight;
}

#pragma mark -  长按置顶

-(void)gestureLongPress:(UILongPressGestureRecognizer*)longPress{

    CGPoint tmpPointTouch = [longPress locationInView:self.msgTableView];
    
    if (longPress.state ==UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [self.msgTableView indexPathForRowAtPoint:tmpPointTouch];
        if (indexPath == nil) {
          
            
        }else{
        
             GYHDAllMsgListModel*model=self.msgListArr[indexPath.row];
            
            if ([model.msgType isEqualToString:@"9"]) {
//                推送消息
                NSArray *messageArray = @[model.titlName == nil ? @"" : @"互生消息",
                                          
                                          model.messageState == GYHDPopMessageStateTop?kLocalized(@"取消置顶"):kLocalized(@"对话置顶")];
                
                GYHDPopMessageView *messageTopView = [[GYHDPopMessageView alloc] initWithMessageArray:messageArray];
                [messageTopView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(230, 100));
                }];
                
                GYHDPopView *topView = [[GYHDPopView alloc] initWithChlidView:messageTopView];
                
                messageTopView.block =  ^(NSString *messageString){
              
                    if ([messageString isEqualToString:kLocalized(@"对话置顶")]) {
                        
                        
                        [[GYHDMessageCenter sharedInstance]pushMsgTopWithMessageType:[NSString stringWithFormat:@"%@",model.pushMsgType]];
                        
                    }
                    
                    else if ([messageString isEqualToString:kLocalized(@"取消置顶")]) {
                        
                        [[GYHDMessageCenter sharedInstance]pushMsgClearTopWithMessageType:[NSString stringWithFormat:@"%@",model.pushMsgType]];
                    }
                    
                    [topView disMiss];
                };
                
                [topView show];

            }else if ([model.msgType isEqualToString:@"10"]){
//            聊天消息
                NSArray *messageArray = @[model.titlName == nil ? @"" : @"互生消息",
                                          
                                          model.messageState == GYHDPopMessageStateTop?kLocalized(@"取消置顶"):kLocalized(@"对话置顶")];
                
                GYHDPopMessageView *messageTopView = [[GYHDPopMessageView alloc] initWithMessageArray:messageArray];
                [messageTopView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(230, 100));
                }];
                
                GYHDPopView *topView = [[GYHDPopView alloc] initWithChlidView:messageTopView];
                
                messageTopView.block =  ^(NSString *messageString){
                
                    if ([messageString isEqualToString:kLocalized(@"对话置顶")]) {
                        [[GYHDMessageCenter sharedInstance] msgTopWithCustId:model.msgCard];
                        
                    }
                    else if ([messageString isEqualToString:kLocalized(@"取消置顶")]) {
                        [[GYHDMessageCenter sharedInstance] msgClearTopWhitCustId:model.msgCard];
                    }
                    
                    [topView disMiss];
                };
                [topView show];

            }
        }
    }
}
-(void)dealloc{
 [[GYHDMessageCenter sharedInstance] removeDataBaseChangeNotificationWithObserver:self];
[[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushMessage" object:nil];
}
@end
