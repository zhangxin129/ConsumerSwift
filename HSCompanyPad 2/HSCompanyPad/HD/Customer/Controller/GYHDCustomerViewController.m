//
//  GYHDCustomerViewController.m
//  HSCompanyPad
//
//  Created by shiang on 16/8/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDCustomerViewController.h"
#import "GYHDCustomerCell.h"
#import "GYHDAdvisoryListView.h"
#import "GYHDSwitch.h"
#import "GYHDDataBaseCenter.h"
#import "GYCustomerSerViceDetailView.h"
@interface GYHDCustomerViewController ()<UITableViewDataSource,UITableViewDelegate,GYHDSwitchDelegate,GYHDAdvisoryListViewDelegate,GYCustomerSerViceDetailViewDelegate>
/**左边tableview*/
@property(nonatomic, strong)UITableView     *leftTableView;
/**左边表格数据源*/
@property(nonatomic, strong)NSMutableArray  *leftArray;

@property(nonatomic, strong)UIView *leftHeaderView;//左边表头
@property(nonatomic, strong)UIButton *advisoryButton;//右边视图弹出按钮
@property(nonatomic, strong)GYHDAdvisoryListView *advisoryListView;//右侧滑动视图
@property(nonatomic, assign)BOOL select;//咨询中、咨询结束按钮选定状态
@property(nonatomic,strong)GYCustomerSerViceDetailView *customerSerViceDetailView;//客服列表详情
@end

@implementation GYHDCustomerViewController

#pragma mark - 懒加载数据相关
- (void)createHeaderView {
    self.leftHeaderView = [[UIView alloc] init];
    self.leftHeaderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.leftHeaderView];
    
    GYHDSwitch *hdswith = [[GYHDSwitch alloc] init];
    hdswith.delegate = self;
    [self.leftHeaderView addSubview:hdswith];
    
    [self.leftHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(325);
        make.height.mas_equalTo(60);
    }];
    @weakify(self);
    [hdswith mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.center.equalTo(self.leftHeaderView);
//        make.size.mas_equalTo(CGSizeMake(173, 32));
    }];
}

-(GYCustomerSerViceDetailView *)customerSerViceDetailView{
    
    if (!_customerSerViceDetailView) {
        
        _customerSerViceDetailView=[[GYCustomerSerViceDetailView alloc]init];
        
        _customerSerViceDetailView.delegate=self;
        
        _customerSerViceDetailView.customerVc=self;
        
        [self.view addSubview:_customerSerViceDetailView];
        
        @weakify(self);
        
        [_customerSerViceDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            @strongify(self);
            
            make.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(44);
            make.left.equalTo(self.leftTableView.mas_right).offset(0);
            
            
        }];
        
    }
    
    return _customerSerViceDetailView;
}

-(NSMutableArray *)leftArray{

    if (!_leftArray) {
        
        _leftArray=[NSMutableArray array];
    }
    return _leftArray;
}

-(UITableView *)leftTableView{

    if (!_leftTableView) {
        
        
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        _leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _leftTableView.rowHeight = UITableViewAutomaticDimension;
        _leftTableView.estimatedRowHeight = 240;
        [_leftTableView registerClass:[GYHDCustomerCell class] forCellReuseIdentifier:NSStringFromClass([GYHDCustomerCell class])];
        [self.view addSubview:_leftTableView];
        @weakify(self);
        [_leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.bottom.mas_equalTo(0);
            make.top.equalTo(self.leftHeaderView.mas_bottom);
            make.width.mas_equalTo(325);
        }];

    }

    return _leftTableView;

}

//-(GYHDChatViewController *)chatViewController{
//
//    if (!_chatViewController) {
//        
//        _chatViewController = [[GYHDChatViewController alloc] init];
//        [self addChildViewController:_chatViewController];
//        [self.view addSubview:_chatViewController.view];
//        _chatViewController.view.hidden=YES;
//        @weakify(self);
//        [_chatViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
//            @strongify(self);
//            make.top.mas_equalTo(44);
//            make.right.mas_equalTo(-30);
//            make.bottom.mas_equalTo(0);
//            make.left.equalTo(self.leftTableView.mas_right);
//        }];
//        
//    }
//    return _chatViewController;
//}

#pragma mark -获取之前点击的消费者信息进入并显示
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSString*msgCard=[[NSUserDefaults standardUserDefaults]objectForKey:@"CustomerMsgCard"];
    
    if (msgCard!=nil && self.leftArray.count>0) {
        
        for (GYHDCustomerModel*model in self.leftArray) {
            
            if ([model.Friend_CustID isEqualToString:msgCard]) {
                
                self.chatViewController.custId=model.Friend_CustID;
                
                self.chatViewController.view.hidden=NO;
                self.advisoryListView.model=model;
                [self.leftTableView reloadData];
            }
            
        }
        
    }
    if (self.leftArray.count<=0) {
        
        self.advisoryButton.hidden=YES;
    }else{
        self.advisoryButton.hidden=NO;
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createHeaderView];
    
    self.view.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
    [self initAdIsory];
    
    [self loadMessageData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageListClick) name:GYHDHDMainChageTabBarIndexNotification object:nil];
    [[GYHDMessageCenter sharedInstance] addDataBaseChangeNotificationObserver:self selector:@selector(messageCenterDataBaseChagne:)];
    
}
#pragma mark - 通知移除
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GYHDHDMainChageTabBarIndexNotification object:nil];
    [[GYHDMessageCenter sharedInstance] removeDataBaseChangeNotificationWithObserver:self];
}
#pragma mark - 右边关联商品、订单
-(void)initAdIsory{
    
    self.chatViewController = [[GYHDChatViewController alloc] init];
    [self addChildViewController:self.chatViewController];
    [self.view addSubview:self.chatViewController.view];
    self.chatViewController.view.hidden=YES;

    self.advisoryListView = [[GYHDAdvisoryListView alloc] init];
    self.advisoryListView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    self.advisoryListView.delegate=self;
    [self.view addSubview:self.advisoryListView];
    
    
    self.advisoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.advisoryButton setBackgroundImage:[UIImage imageNamed:@"gyhd_advisory_more_btn_normal"] forState:UIControlStateNormal];
    [self.advisoryButton setBackgroundImage:[UIImage imageNamed:@"gyhd_advisory_more_btn_select"] forState:UIControlStateSelected];
    [self.advisoryButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.advisoryButton];
    
    @weakify(self);
    [self.chatViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(44);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(0);
        make.left.equalTo(self.leftTableView.mas_right);
    }];
    
    [self.advisoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.view);
        make.right.mas_equalTo(0);
    }];
    
    [self.advisoryListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.advisoryButton);
        make.top.mas_equalTo(44);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(316);
    }];
//    [self.view bringSubviewToFront:self.advisoryButton];
    

}
#pragma mark - 获取消费者列表数据

-(void)loadMessageData{
    
    //获取消费者咨询中信息列表
    
    GYHDDataBaseCenter*dataCenter=[GYHDDataBaseCenter sharedInstance];
    
    NSArray*dataArr = [dataCenter selectLastGroupChatMessage];

    for (NSDictionary*dic in dataArr) {
        
        GYHDCustomerModel*model=[[GYHDCustomerModel alloc]init];
        
        [model initModelWithDic:dic];
        
        model.messageUnreadCount=[[GYHDDataBaseCenter sharedInstance] UnreadMessageCountWithCard:model.Friend_CustID];
        model.isSelect=NO;
        
        [self.leftArray addObject:model];
    }
    
    [self.leftTableView reloadData];
    
    if (self.leftArray.count<=0) {
        
        self.advisoryButton.hidden=YES;
    }else{
    
        self.advisoryButton.hidden=NO;
    }

}

- (void)loadSessionEndData{
    //获取消费者咨询结束列表
    
    GYHDDataBaseCenter*dataCenter=[GYHDDataBaseCenter sharedInstance];
    
    NSArray*dataArr = [dataCenter selectLastGroupChatMessageEndSession];
    
    for (NSDictionary*dic in dataArr) {
        
        GYHDCustomerModel*model=[[GYHDCustomerModel alloc]init];
        
        [model initModelWithDic:dic];

        model.isSelect=NO;
        
        [self.leftArray addObject:model];
    }
    
    [self.leftTableView reloadData];
    
}

#pragma mark - 监听消息列表过来的通知
-(void)messageListClick{
    
    NSString*msgCard=[[NSUserDefaults standardUserDefaults]objectForKey:@"CustomerMsgCard"];
    
    GYHDCustomerModel*customerModel;
    
    for ( GYHDCustomerModel*model in self.leftArray) {
        
        if (msgCard!=nil && [model.Friend_CustID isEqualToString:msgCard]) {
            
            customerModel=model;
            
        }
        model.isSelect=NO;
    }
    
    if (!customerModel.Friend_CustID) {
        customerModel.Friend_CustID = msgCard;
    }
    customerModel.isSelect=YES;
    self.chatViewController.view.hidden=NO;
    self.chatViewController.custId=customerModel.Friend_CustID;
    self.advisoryListView.model=customerModel;
    if (self.select) {
        
        self.advisoryListView.endAdvisoryButton.hidden=YES;
        self.advisoryListView.migrateAdvisoryButton.hidden=YES;
        
    }else{
      
        self.advisoryListView.model=customerModel;
        
        if (self.leftArray.count>0) {
            
              self.advisoryButton.hidden=NO;
        }else{
        
          self.advisoryButton.hidden=YES;
        }
      
        [self.leftTableView reloadData];
    }
    
}
//接收聊天通知
-(void)messageCenterDataBaseChagne:(NSNotification *)noti{
    
    [self.leftArray removeAllObjects];
    
    NSString*msgCard=[[NSUserDefaults standardUserDefaults]objectForKey:@"CustomerMsgCard"];
    
    NSDictionary*dict=noti.object;
    
    if ([dict[@"MSG_Card"] isEqualToString:msgCard]) {
        GYHDCustomerModel*customerModel=[[GYHDCustomerModel alloc]init];
        customerModel.Friend_CustID=msgCard;
        self.advisoryListView.model=customerModel;
    }
    
    if (self.select) {
        
        [self loadSessionEndData];
        
    }else{
        
        [self loadMessageData];
        
    }
    
}

#pragma mark - 广告栏滑动事件
- (void)btnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    [UIView animateWithDuration:0.5f animations:^{
        if (btn.selected) {
            self.advisoryListView.backgroundColor = [UIColor whiteColor];
            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-296);
            }];
        }else {
            self.advisoryListView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(0);
            }];
        }
        [self.view layoutIfNeeded];
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.leftArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    GYHDCustomerCell *baseCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GYHDCustomerCell class])];
    
    NSString*customerMsgCard=[[NSUserDefaults standardUserDefaults] objectForKey:@"CustomerMsgCard"];
    
    GYHDCustomerModel*model=self.leftArray[indexPath.row];
    
    if ([model.Friend_CustID isEqualToString:customerMsgCard]) {
        
        model.isSelect=YES;
        model.messageUnreadCount=@"";
        
        [[GYHDDataBaseCenter sharedInstance] ClearUnreadMessageWithCard:model.MSG_Card];
        
    }else{
        
        model.isSelect=NO;
    }

    baseCell.model = self.leftArray[indexPath.row];
    
    return baseCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.customerSerViceDetailView.hidden=YES;
    
    if (self.select) {
        
        GYHDCustomerModel*model=self.leftArray[indexPath.row];
        self.chatViewController.view.hidden=NO;
        self.chatViewController.custId=model.Friend_CustID;
        self.chatViewController.hdInputView.hidden=YES;
        self.advisoryButton.hidden=NO;
        self.advisoryListView.model=model;
        self.advisoryListView.endAdvisoryButton.hidden=YES;
        self.advisoryListView.migrateAdvisoryButton.hidden=YES;
        for (GYHDCustomerModel*model in self.leftArray) {
            
            model.isSelect=NO;
        }
        model.isSelect=YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:kSaftToNSString(model.Friend_CustID)  forKey:@"CustomerMsgCard"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CompanyMsgCard"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.leftTableView reloadData];

    }else{
    
        GYHDCustomerModel*model=self.leftArray[indexPath.row];
        
        self.chatViewController.view.hidden=NO;
         self.chatViewController.hdInputView.hidden=NO;
        self.advisoryListView.endAdvisoryButton.hidden=NO;
        self.advisoryListView.migrateAdvisoryButton.hidden=NO;
        self.chatViewController.custId=model.Friend_CustID;
        self.advisoryListView.model=model;
        for (GYHDCustomerModel*model in self.leftArray) {
            
            model.isSelect=NO;
        }
        model.isSelect=YES;
        
        [[GYHDDataBaseCenter sharedInstance] ClearUnreadMessageWithCard:model.Friend_CustID];
        [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotification];
        model.messageUnreadCount=@"";
        
        [[NSUserDefaults standardUserDefaults] setObject:kSaftToNSString(model.Friend_CustID)forKey:@"CustomerMsgCard"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CompanyMsgCard"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.leftTableView reloadData];
    }
   
}
#pragma mark- 咨询状态切换
- (void)GYHDSwitch:(GYHDSwitch *)hdswitch select:(BOOL)select {
    DDLogInfo(@"%d",select);
    self.select=select;
    [self.leftArray removeAllObjects];
    if (select) {
        //        咨询结束列表数据
        [self loadSessionEndData];
        self.advisoryListView.endAdvisoryButton.hidden=YES;
        self.advisoryListView.migrateAdvisoryButton.hidden=YES;
        self.chatViewController.view.hidden=YES;
        self.chatViewController.hdInputView.hidden=YES;
        [self.chatViewController.chatTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.left.right.mas_equalTo(0);
        }];
        
    }else{
        //    咨询中列表数据
        
        [self loadMessageData];
        self.advisoryListView.endAdvisoryButton.hidden=NO;
        self.advisoryListView.migrateAdvisoryButton.hidden=NO;
        self.chatViewController.view.hidden=YES;
        self.chatViewController.hdInputView.hidden=NO;
        [self.chatViewController.chatTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-62);
        }];
    }
}
#pragma mark -GYHDAdvisoryListViewDelegate
-(void)closeAdvisoryListView{
    [self.leftArray removeAllObjects];
      [self loadMessageData];
    self.advisoryListView.endAdvisoryButton.hidden=YES;
    self.advisoryListView.migrateAdvisoryButton.hidden=YES;
    [UIView animateWithDuration:0.5f animations:^{
      
            self.advisoryListView.backgroundColor = [UIColor whiteColor];
        
            [self.advisoryButton mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.right.mas_equalTo(0);
        
            }];
            [self.view layoutIfNeeded];
    }];
}

#pragma mark - GYCustomerSerViceDetailViewDelegate
-(void)showCustomerServiceListDetailViewWithModel:(GYHDAdvisoryListModel *)model{

    self.customerSerViceDetailView.sessionId=model.sessionId;
    
    self.customerSerViceDetailView.hidden=NO;

}


-(void)hidenGYCustomerSerViceDetailView{
    
    self.customerSerViceDetailView.hidden=YES;
    
    
}
@end
