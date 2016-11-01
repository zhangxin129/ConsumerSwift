//
//  GYHDMsgListViewController.m
//  HSEnterprise
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "GYHDMsgListViewController.h"
#import "GYHDMsgListView.h"
#import "GYHDMessageCenter.h"
#import "GYOrderMessageListModel.h"
#import "GYRefreshFooter.h"
#import "GYRefreshHeader.h"
#import "GYHDNetWorkTool.h"
@interface GYHDMsgListViewController ()
@property(nonatomic,strong)   NSMutableArray *orderMessageArray;//订单消息
@property(nonatomic,strong)  NSMutableArray*hsMessageArr;//互生系统消息
@property(nonatomic,strong) NSMutableArray *severMessageArr;//服务消息
@property(nonatomic,assign) NSInteger selectOrderCount;//拉取订单消息长度
@property(nonatomic,assign) NSInteger selectHSCount;//拉取互生消息长度
@property(nonatomic,assign) NSInteger selectServerCount;//拉取服务消息长度
@property(nonatomic,weak)GYHDMsgListView *systemMsgListView;
@property(nonatomic,weak)GYHDMsgListView *orderMsgListView;
@property(nonatomic,weak)GYHDMsgListView *serviceMsgListView;
@end

@implementation GYHDMsgListViewController

-(NSMutableArray *)orderMessageArray{

    if (!_orderMessageArray) {
        
        _orderMessageArray=[ NSMutableArray array];
    }

    return _orderMessageArray;
}
-(NSMutableArray *)hsMessageArr{

    if (!_hsMessageArr) {
        
        _hsMessageArr=[ NSMutableArray array];
    }
    
    return _hsMessageArr;
}
-(NSMutableArray *)severMessageArr{
    
    if (!_severMessageArr) {
        
        _severMessageArr=[ NSMutableArray array];
    }
    
    return _severMessageArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageCenterDataBaseChange) name:@"pushMessage" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectOrderCount=10;
    self.selectHSCount=10;
    self.selectServerCount=10;
    [self initUI];
    [self loadOrderMessageData];
    [self LoadHSMessageData];
    [self loadSeverMessageData];
    [self refreshData];
}

-(UILabel*)tipLabel{

    UILabel*tipLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    
    tipLabel.font=[UIFont systemFontOfSize:16];
    
    tipLabel.text=@"暂无消息记录";
    
    tipLabel.textAlignment=NSTextAlignmentCenter;
    
    return tipLabel;

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}


- (void)dealloc {
    
   [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushMessage" object:nil];
}

- (void)messageCenterDataBaseChange {
    
    [self loadOrderMessageData];
    [self LoadHSMessageData];
    [self loadSeverMessageData];
    [self refreshData];
    
    [self.mainView showMsgLabel];
}

-(void)refreshData{

    _serviceMsgListView.dataSource = self.severMessageArr;

    if (self.hsMessageArr.count>0) {
    
        _systemMsgListView.tableView.tableFooterView=[[UIView alloc]init];
        _systemMsgListView.tableView.mj_footer.hidden=NO;
        
        
    }else{
        
        _systemMsgListView.tableView.tableFooterView=[self tipLabel];
        _systemMsgListView.tableView.mj_footer.hidden=YES;
    }
    [_systemMsgListView.tableView reloadData];
    
    
    _orderMsgListView.dataSource =self.orderMessageArray;
    
    if (self.orderMessageArray.count>0) {
        _orderMsgListView.tableView.tableFooterView=[[UIView alloc]init];
         _orderMsgListView.tableView.mj_footer.hidden=NO;
    }else{
        
        _orderMsgListView.tableView.tableFooterView=[self tipLabel];
        _orderMsgListView.tableView.mj_footer.hidden=YES;
    }
    [_orderMsgListView.tableView reloadData];
    
    
    _serviceMsgListView.dataSource=self.severMessageArr;
    
    if (self.severMessageArr.count>0) {
        _serviceMsgListView.tableView.tableFooterView=[[UIView alloc]init];
        _serviceMsgListView.tableView.mj_footer.hidden=NO;
    }else{
        
        _serviceMsgListView.tableView.tableFooterView=[self tipLabel];
        _serviceMsgListView.tableView.mj_footer.hidden=YES;
    }
    [_serviceMsgListView .tableView reloadData];
    
}

#pragma mark -查询互生类消息
-(void)LoadHSMessageData{

 [self.hsMessageArr removeAllObjects];

    NSArray*hsArr=[[GYHDMessageCenter sharedInstance]selectPushAllHuShengMsgListWithselectCount:self.selectHSCount];
    
    for (NSDictionary*dict in hsArr) {
        
        GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
        
        [self.hsMessageArr addObject:model];
    }
    
    
}
#pragma mark -查询服务类消息
-(void)loadSeverMessageData{

    [self.severMessageArr removeAllObjects];

    NSArray*severArr=[[GYHDMessageCenter sharedInstance]selectPushAllFuWuMsgListWithselectCount:self.selectServerCount];
    
    for (NSDictionary*dict in severArr) {
        
        GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
        
        [self.severMessageArr addObject:model];
    }
    
}
#pragma mark - 查询订单推送消息数据库
-(void)loadOrderMessageData{

    [self.orderMessageArray removeAllObjects];

    NSArray*orderArr=[[GYHDMessageCenter sharedInstance] selectPushMsgWithselectCount:self.selectOrderCount];
    for (NSDictionary *dict in orderArr) {
        
        GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]initWithDictionary:dict];
        
        [self.orderMessageArray addObject:model];
    }
    
   
}
- (void)initUI {
    
    GYHDMsgListView *systemMsgListView = [[GYHDMsgListView alloc]initWithFrame:CGRectMake(0, 0, (kScreenWidth  - 24 ) / 3, kScreenHeight-64)];
    systemMsgListView.dataSource = self.hsMessageArr;
    systemMsgListView.title = kLocalized(@"系统消息");
    systemMsgListView.image = @"icon_xtxx";
    systemMsgListView.showPage=self;
    systemMsgListView.color = [UIColor colorWithRed:251.0/255.0 green:99.0/255.0 blue:83.0/255.0 alpha:1.0];;
    systemMsgListView.tag=100;
    _systemMsgListView=systemMsgListView;
    [self.view addSubview:systemMsgListView];
    [self setFreshWithTableView:systemMsgListView.tableView viewTag:systemMsgListView.tag];
    
    GYHDMsgListView *orderMsgListView = [[GYHDMsgListView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(systemMsgListView.frame) + 12, 0, (kScreenWidth- 24 ) / 3, kScreenHeight-64)];
    orderMsgListView.title = kLocalized(@"订单消息");
    orderMsgListView.image = @"icon_ddxx";
    orderMsgListView.showPage=self;
    orderMsgListView.color = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:96.0/255.0 alpha:1.0];;
    orderMsgListView.tag=101;
    _orderMsgListView=orderMsgListView;
    [self.view addSubview:orderMsgListView];
    [self setFreshWithTableView:orderMsgListView.tableView viewTag:orderMsgListView.tag];
    
    GYHDMsgListView *serviceMsgListView = [[GYHDMsgListView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(orderMsgListView.frame) + 12, 0, (kScreenWidth  - 24 ) / 3, kScreenHeight-64)];
    serviceMsgListView.title = kLocalized(@"服务消息");
    serviceMsgListView.image = @"icon_fwxx";
    serviceMsgListView.color = [UIColor colorWithRed:35.0/255.0 green:179.0/255.0 blue:86.0/255.0 alpha:1.0];
    serviceMsgListView.tag=102;
    serviceMsgListView.showPage=self;
    _serviceMsgListView=serviceMsgListView;
    [self.view addSubview:serviceMsgListView];
    [self setFreshWithTableView:serviceMsgListView.tableView viewTag:serviceMsgListView.tag];
    
    [systemMsgListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.right.equalTo(orderMsgListView.mas_left).with.offset(-12);
        make.height.mas_equalTo(kScreenHeight - 41);
        make.width.equalTo(@[orderMsgListView, serviceMsgListView]);
    }];
    
    [orderMsgListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(systemMsgListView);
        make.width.equalTo(@[systemMsgListView, serviceMsgListView]);
    }];
    @weakify(self);
    [serviceMsgListView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(0);
        make.left.equalTo(orderMsgListView.mas_right).with.offset(10);
        make.right.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(systemMsgListView);
        make.width.equalTo(@[orderMsgListView, systemMsgListView]);
    }];
    
    
    
}
//默认显示10条，下拉再拉10条
-(void)setFreshWithTableView:(UITableView*)tableView viewTag:(NSInteger)tag{


    GYRefreshHeader *header=[GYRefreshHeader headerWithRefreshingBlock:^{
        switch (tag) {
            case 100:{
                self.selectHSCount=10;
                [self LoadHSMessageData];
                
            
            }
                break;
            case 101:{
                self.selectOrderCount=10;
                [self loadOrderMessageData];
            
            }break;
                
            case 102:{
                self.selectServerCount=10;
                [self loadSeverMessageData];
            }break;
            default:
                break;
        }
        [tableView.mj_header endRefreshing];
        [tableView reloadData];
        
    }];
 
    
        tableView.mj_header=header;
    
    GYRefreshFooter*footer=[GYRefreshFooter footerWithRefreshingBlock:^{
        switch (tag) {
            case 100:{
                    self.selectHSCount+=10;
                [self LoadHSMessageData];
                
            }
                break;
            case 101:{
                self.selectOrderCount+=10;
                [self loadOrderMessageData];
                
            }break;
                
            case 102:{
                self.selectServerCount+=10;
                [self loadSeverMessageData];
            }break;
            default:
                break;
        }
        [tableView.mj_footer endRefreshing];
        [tableView reloadData];
        
    }];
    
  
    
    tableView.mj_footer=footer;
    
}
@end
