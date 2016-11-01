//
//  GYMsgViewController.m
//  HSEnterprise
//
//  Created by sqm on 16/2/2.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "GYHDMainViewController.h"
#import "GYHDMsgListViewController.h"
#import "GYHDNewsViewController.h"
#import "GYHDCustomerViewController.h"
#import "GYHDCompanyViewController.h"
#import "GYHDSearchViewController.h"
#import "GYHDNavView.h"
#import "GYHDCustomerInfoViewController.h"
#import "GYHDStaffInfoViewController.h"
#import "GYHDMessageCenter.h"
#import "GYHDDataBaseCenter.h"
#import "GYHDNetWorkTool.h"
#import "GYHDSaleListGrounpModel.h"
#import "GYHDSaleListModel.h"
#import "GYHDOpereotrListModel.h"
#import "GYPinYinConvertTool.h"
#import "GYHDOperGroupModel.h"
#import "GYHDSaleNetWorkOperModel.h"
#import "GYHDMsgListNewController.h"
@interface GYHDMainViewController ()<UIScrollViewDelegate,GYHDNavViewDelegate>
/**
 * 主控制器
 */
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic,strong)GYHDNavView *navView;
/**
 * 消息列表控制器
 */
@property (nonatomic, strong) GYHDMsgListViewController *msgListViewController;
/**
 *新的消息列表控制器
 */
@property(nonatomic,strong) GYHDMsgListNewController * MsgListNewController;
/**
 * 互生新闻控制器
 */
@property (nonatomic, strong) GYHDNewsViewController *newsViewController;
/**
 * 客户咨询控制器
 */
@property (nonatomic, strong) GYHDCustomerViewController *customerViewController;
/**
 * 企业通讯录控制器
 */
@property (nonatomic, strong) GYHDCompanyViewController *companyViewController;
/**
 * 选中的按钮
 */
@property (nonatomic, strong) UIButton *selectButton;
/**
 * 消息按钮
 */
@property (nonatomic, strong) UIButton  *msgBtn;
/**
 * 互生新闻按钮
 */
@property (nonatomic, strong) UIButton *newsBtn;
/**
 * 客户咨询按钮
 */
@property (nonatomic, strong) UIButton *customerBtn;
/**
 * 企业通讯录按钮
 */
@property (nonatomic, strong) UIButton *companyBtn;

/**连接状态Label*/
@property(nonatomic, strong) UIButton *linkTitleButton;
//消息数据源
@property(nonatomic,strong)NSMutableArray*customerMessageDatas;//客户咨询消息
@property(nonatomic,strong)NSMutableArray*companyMessageDatas;//企业通讯消息
@property(nonatomic,assign)NSInteger ureadCount;//记录企业通讯录未读数量
@end

@implementation GYHDMainViewController

-(NSMutableArray *)customerMessageDatas{
    
    if (!_customerMessageDatas) {
        
        _customerMessageDatas=[NSMutableArray array];
    }
    return _customerMessageDatas;
}

-(NSMutableArray *)companyMessageDatas{
    
    if (!_companyMessageDatas) {
        
        _companyMessageDatas=[NSMutableArray array];
    }
    return _companyMessageDatas;
}


- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.contentSize = CGSizeMake(3 * (kScreenWidth ), 0);
        _scrollView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
        
        [self.view addSubview: _scrollView];
        
       
    }
    return _scrollView;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
    self.ureadCount=0;
//    [self loadMessageData];
    [self loadCompanyOperatorRelationList];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self loadMessageData];
    [self setupNav];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.view.frame = CGRectMake(0, 0, kScreenWidth , kScreenHeight);
    
    self.navigationController.navigationBar.hidden=YES;
    
    [self addObserver];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden=NO;

}

#pragma mark - 设置导航栏
- (void)setupNav {
    
    self.navView = [[GYHDNavView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    self.navView.backgroundColor=[UIColor colorWithRed:0 green:143/255.0 blue:215/255.0 alpha:1.0];
    self.navView.delegate = self;
    [self.navView searchBtn];
    NSArray *btnArray = [self.navView segmentViewMsgBtn:self.msgBtn:self.customerBtn :self.companyBtn];
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth , 64));
    }];
    
    self.msgBtn = btnArray[0];
    self.customerBtn = btnArray[1];
    self.companyBtn = btnArray[2];
    
        NSString*indexStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"navindex"];
    NSInteger index;
    if (indexStr==nil) {
        index=0;
    }else{
        index=[indexStr integerValue];
    }
    
    for (UIButton*btn in btnArray) {
        btn.selected=NO;
        btn.userInteractionEnabled=YES;
    }
      self.selectButton = btnArray[index];
    self.selectButton.selected=YES;
    self.selectButton.userInteractionEnabled=NO;
    self.scrollView.contentOffset=CGPointMake(kScreenWidth*index, 0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xmppHidenState) name:@"xmppOnline" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(xmppShowState) name:@"xmppOffline" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xmppOtherLogin) name:@"xmppOtherLogin" object:nil];
    self.linkTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.linkTitleButton.titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(24)];
    [self.linkTitleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.linkTitleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.linkTitleButton setImage:[UIImage imageNamed:@"hd_failure"] forState:UIControlStateNormal];
    self.linkTitleButton.imageEdgeInsets=UIEdgeInsetsMake(0, -30, 0, 0);
    [self.linkTitleButton setTitle:@"当前网络不可用，请检查设置" forState:UIControlStateNormal];
    
    [self.linkTitleButton setBackgroundColor:[UIColor colorWithRed:253/255.0f green:239/255.0f blue:219/255.0f alpha:1]];

    [self.view addSubview:self.linkTitleButton];
    self.linkTitleButton.frame = CGRectMake(0, 64, kScreenWidth, 30);
    self.linkTitleButton.hidden=YES;
}

//获取本企业营业点列表
-(void)loadCompanyOperatorRelationList{
//数据库中读取
    NSArray *DataBaseArray = [[GYHDDataBaseCenter sharedInstance] selectFriendList];
//    DDLogCInfo(@"data==%@",DataBaseArray);
    
    if (DataBaseArray.count>0) {
        
        [self readCompanyListData:DataBaseArray];
        
    }
//    网络获取
    [[GYHDNetWorkTool sharedInstance] postListOperByEntCustIdResult:^(NSArray *resultArry) {
        
        [self readCompanyListData:resultArry];
        
  }];
    

}

-(void)readCompanyListData:(NSArray*)resultArry{

    
    NSArray*reasutlArr=[self loadOperatorRelationListArr:resultArry];
    
    NSArray*listArr=[self loadCompanyOperatorListArr:resultArry];
    
    NSMutableArray *tempArr= [self operListCompanyWithArray:listArr];
    
    _companyViewController.companyOperatorListArr=[tempArr mutableCopy];
    _companyViewController.OperatorRelationListArr=[reasutlArr mutableCopy];
    
    
}


//获取消息数据源
-(void)loadMessageData{

//获取消费者咨询信息列表
    
    GYHDDataBaseCenter*dataCenter=[GYHDDataBaseCenter sharedInstance];
    
    self.customerMessageDatas= [[dataCenter selectLastGroupChatMessage] mutableCopy];
    
//    for (UIView*view in self.scrollView.subviews) {
//        
//        [view removeFromSuperview];
//    }
    
    [self createChlidVC];
    
}

#pragma mark- 监听消息发出通知，即时更新数据
- (void)addObserver {
    
    [[GYHDMessageCenter sharedInstance] addDataBaseChangeNotificationObserver:self selector:@selector(messageCenterDataBaseChagne:)];
   
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchPop) name:@"popCustomerMessage" object:nil];
}

#pragma mark - 接收消息同步刷新界面
- (void)messageCenterDataBaseChagne:(NSNotification *)noti {
    
//接收通知钱移除数据源 重新获取数据源并刷新相关界面
    [self.customerMessageDatas removeAllObjects];
    [self.customerViewController.customerMessageDatas removeAllObjects];
    [self.customerViewController.customerListView.dataSource removeAllObjects];
    
//    获取消费者咨询列表
    GYHDDataBaseCenter*dataCenter=[GYHDDataBaseCenter sharedInstance];
    
    self.customerMessageDatas= [[dataCenter selectLastGroupChatMessage] mutableCopy];
    
    self.customerViewController.customerMessageDatas=self.customerMessageDatas;
    
    [self.customerViewController.customerListView.tableView reloadData];
    
//    获取企业操作员列表信息
    NSArray *DataBaseArray = [[GYHDDataBaseCenter sharedInstance] selectFriendList];
    
    NSArray* listArr= [self loadCompanyOperatorListArr:DataBaseArray];
    NSArray*reasutlArr= [self loadOperatorRelationListArr:DataBaseArray];
    
   //刷新企业通讯录相关界面s
    self.companyViewController.companyOperatorListArr= [listArr mutableCopy];
    
    self.companyViewController.OperatorRelationListArr=[reasutlArr mutableCopy];
//    记录当前点击的营业点列表下标，取得相关数据源 下次默认进入当前
    NSString*indexstr=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectIndex"];
//    点击查看所有操作员时，点击下标为-1
    if ([indexstr integerValue]==-1) {
        
        NSMutableArray *tempArr= [self operListCompanyWithArray:listArr];
        
        self.companyViewController.companyDetailsView.dataSource =[tempArr mutableCopy];
        self.companyViewController.companyListView.companyOperatorArr=[tempArr mutableCopy];
        self.companyViewController.companyListView.dataSource=[reasutlArr mutableCopy];
        self.companyViewController.companyDetailsView.isCheckList=YES;
        
    }else{
//    点击营业点列表时，取得对应下标 并刷新数据源
        NSInteger index=[indexstr integerValue];
        
        if (reasutlArr.count>0 && reasutlArr.count>index) {
            
            GYHDSaleListGrounpModel*model=reasutlArr[index];
            
            self.companyViewController.companyDetailsView.dataSource=model.operatorListArr;
            self.companyViewController.companyDetailsView.isCheckList=NO;
            self.companyViewController.companyListView.dataSource=[reasutlArr mutableCopy];
             NSMutableArray *tempArr= [self operListCompanyWithArray:listArr];
            self.companyViewController.companyListView.companyOperatorArr=[tempArr mutableCopy];
        }
     
    }
  
    [self.companyViewController.companyDetailsView.newsCollectionView reloadData];
    
}

-(NSArray*)loadCompanyOperatorListArr:(NSArray*)CompanyOperatorListArr{

    //    获取全部操作员列表方法
    NSMutableArray*listArr=[NSMutableArray array];
    
    for (NSDictionary*dict in CompanyOperatorListArr) {
        
        GYHDOpereotrListModel*model=[[GYHDOpereotrListModel alloc]init];
        
        model.saleAndOperatorRelationList=dict[@"saleAndOperatorRelationList"];
        model.searchUserInfo=dict[@"searchUserInfo"];
        if ([dict[@"roleName"] isEqualToString:@"null"] || dict[@"roleName"]==nil){
            
           model.roleName=@"";
            
        }else{
            
            model.roleName=dict[@"roleName"];
            
        }
//        取得操作员是否有未读消息 显示在通讯录
        model.messageUnreadCount=[[GYHDDataBaseCenter sharedInstance] UnreadMessageCountWithCard:dict[@"searchUserInfo"][@"custId"]];
        
        self.ureadCount +=[model.messageUnreadCount integerValue];
        
        if ([dict[@"searchUserInfo"][@"custId"] isEqualToString:globalData.loginModel.custId]) {
            
        }else{
        
            [listArr addObject:model];
        }

    }
//    if (self.ureadCount>0) {
//        
//        [self showTipLabel];
//    }else{
//        
//        self.navView.tipLabel.hidden=YES;
//    }

    return listArr;


}


-(NSArray*)loadOperatorRelationListArr:(NSArray*)operatorRelationListArr{


    //   数据重组 获取营业点列表 及相对应的操作员列表
    /*
     1.因为数据复杂性，先获取所有营业点列表名称
     2.以营业点列表名称去依次遍历操作员列表数据
     3.把匹配的操作员添加到当前营业点列表
     */
    NSMutableArray *arr=[NSMutableArray array];
    
    for (NSDictionary*dic in operatorRelationListArr) {
        NSArray*arr1=dic[@"saleAndOperatorRelationList"];
        
        if (arr1.count>0) {
            
            [arr addObject:dic];
            
        }
    }
//    DDLogCInfo(@"arr=%@",arr);
    
    NSMutableArray*salelistArr=[NSMutableArray array];
    
    for (NSDictionary*dic in arr) {
        
        NSArray*arr2= dic[@"saleAndOperatorRelationList"];
        
        for (NSDictionary*dict in arr2) {
            
            if ([salelistArr containsObject:dict[@"sale_networkName"]]) {
                
            }else{
                
                if ([dict[@"sale_networkName"]isEqualToString:@""]){
                    
                }else{
                    
                    [salelistArr addObject:dict[@"sale_networkName"]];
                }
                
            }
            
        }
        
    }
    NSMutableArray*reasutlArr=[NSMutableArray array];
    
    for (NSString*str in salelistArr) {
        
        GYHDSaleListGrounpModel*model=[[GYHDSaleListGrounpModel alloc]init];
        model.OperatorRelationName =str;
        
        for (NSDictionary*dic in arr) {
            
            NSArray*arry=dic[@"saleAndOperatorRelationList"];
            
            for (NSDictionary*tempDic in arry) {
                
                if ([str isEqualToString:tempDic[@"sale_networkName"]]) {
                    
                    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
                    
                    [dict addEntriesFromDictionary:tempDic];
                    
                    [dict addEntriesFromDictionary:dic[@"searchUserInfo"]];
                     if ([dict[@"roleName"] isEqualToString:@"null"] || dict[@"roleName"]==nil){
                        
                        [dict setObject:@""forKey:@"roleName"];
                    }else{
                        [dict setObject:dic[@"roleName"] forKey:@"roleName"];
                    }
                    
                    GYHDSaleListModel*listModel=[[GYHDSaleListModel alloc]initWithDic:dict];
                    if ([listModel.custId isEqualToString:globalData.loginModel.custId]) {
                        
                    }else{
                    
                        [model.operatorListArr addObject:listModel];
                    }
                    listModel.messageUnreadCount=[[GYHDDataBaseCenter sharedInstance] UnreadMessageCountWithCard:listModel.custId];
                    
                }
                
            }
        }
        [reasutlArr addObject:model];
        
    }

    return reasutlArr;
}
//推送消息显示导航栏
-(void)showMsgLabel{
    
    
    self.navView.msgLabel.hidden=NO;
    
}

//企业收到消息显示导航栏提示
//-(void)showTipLabel{
//
//    
//    self.navView.tipLabel.hidden=NO;
//
//}
//消费者受到消息显示导航栏提示
//-(void)showCustomerLabel{
//
//    self.navView.showLabel.hidden=NO;
//}
#pragma mark - 创建控制器
- (void)createChlidVC {
#warning 消息列表新界面修改
    //1. 消息列表制器
//    GYHDMsgListViewController *msgListViewController = [[GYHDMsgListViewController alloc] init];
//    更换新的控制器
    GYHDMsgListNewController *msgListViewController = [[GYHDMsgListNewController alloc] init];
    msgListViewController.view.frame = CGRectMake(0 , 0, (kScreenWidth ), kScreenHeight - 64);
    msgListViewController.mainView=self;
    [self addChildViewController:msgListViewController];
    [self.scrollView addSubview:msgListViewController.view];
//    self.msgListViewController=msgListViewController;
    self.MsgListNewController = msgListViewController;
    
    
//    //2. 互生新闻控制器
//    GYHDNewsViewController *newsViewController = [[GYHDNewsViewController alloc] init];
//    newsViewController.view.frame = CGRectMake((kScreenWidth - 128) * 1, 44, (kScreenWidth - 128), kScreenHeight - 44);
//    [self addChildViewController:newsViewController];
//    [self.scrollView addSubview:newsViewController.view];
//    self.newsViewController = newsViewController;
    
    
    //3. 客户咨询控制器
    GYHDCustomerViewController *customerViewController = [[GYHDCustomerViewController alloc] init];
    customerViewController.view.frame = CGRectMake((kScreenWidth ) * 1, 0, (kScreenWidth ), kScreenHeight - 64);
    customerViewController.mainView=self;
    customerViewController.customerMessageDatas=self.customerMessageDatas;
    [self addChildViewController:customerViewController];
    [self.scrollView addSubview:customerViewController.view];
    self.customerViewController = customerViewController;
    
    [self.customerViewController.customerListView.tableView reloadData];
    
    //    企业通讯录控制器
    GYHDCompanyViewController *companyViewController = [[GYHDCompanyViewController alloc] init];
    companyViewController.view.frame = CGRectMake((kScreenWidth ) * 2, 0, (kScreenWidth ), kScreenHeight - 64);
    
    [self addChildViewController:companyViewController];
    [self.scrollView addSubview:companyViewController.view];
    self.companyViewController = companyViewController;
    
}
//移除通知
-(void)dealloc{
    [[GYHDMessageCenter sharedInstance] removeDataBaseChangeNotificationWithObserver:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"xmppOnline" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"xmppOffline" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"xmppOtherLogin" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"popCustomerMessage" object:nil];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger selectInt = (int)scrollView.contentOffset.x /(kScreenWidth );
    [self recodeNavIndex:selectInt];
    switch (selectInt) {
        case 0:
        {
            if ([self.msgBtn.currentTitle isEqualToString:self.selectButton.currentTitle]) return;
            self.msgBtn.selected = YES;
            self.msgBtn.userInteractionEnabled = NO;
            self.selectButton.selected = NO;
            self.selectButton.userInteractionEnabled = YES;
            self.selectButton = self.msgBtn;
//            self.navView.msgLabel.hidden=YES;
            break;
        }
//        case 1:
//        {
//            if ([self.newsBtn.currentTitle isEqualToString: self.selectButton.currentTitle]) return;
//            self.newsBtn.selected = YES;
//            self.newsBtn.userInteractionEnabled = NO;
//            self.selectButton.selected = NO;
//            self.selectButton.userInteractionEnabled = YES;
//            self.selectButton = self.newsBtn;
//            break;
//        }
        case 1:
        {
            if ([self.customerBtn.currentTitle isEqualToString: self.selectButton.currentTitle]) return;
            self.customerBtn.selected = YES;
            self.customerBtn.userInteractionEnabled = NO;
            self.selectButton.selected = NO;
            self.selectButton.userInteractionEnabled = YES;
            self.selectButton = self.customerBtn;
//            self.navView.showLabel.hidden=YES;
            break;
        }
        case 2:
        {
            if ([self.companyBtn.currentTitle isEqualToString: self.selectButton.currentTitle]) return;
            self.companyBtn.selected = YES;
            self.companyBtn.userInteractionEnabled = NO;
            self.selectButton.selected = NO;
            self.selectButton.userInteractionEnabled = YES;
            self.selectButton = self.companyBtn;
//            self.navView.tipLabel.hidden=YES;
            break;
        }
        default:
            break;
    }
}

#pragma mark - GYHDNavViewDelegate
- (void)GYHDNavViewGoBackAction {
    
//    GYHDStaffInfoViewController *customerInfoVC = [[GYHDStaffInfoViewController alloc]init];
//    [self.navigationController pushViewController:customerInfoVC animated:YES];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)GYHDNavViewSearchAll {
    GYHDSearchViewController *searchVC = [[GYHDSearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)GYHDNavViewButtonClick:(UIButton *)button {

    self.selectButton.selected = NO;
    self.selectButton.userInteractionEnabled = YES;
    button.selected = YES;
    button.userInteractionEnabled = NO;
    self.selectButton = button;
    if ([button.currentTitle isEqualToString:@"消息列表"]) {
        [self recodeNavIndex:0];
        self.scrollView.contentOffset = CGPointMake(0 * (kScreenWidth ), 0);
//        self.navView.msgLabel.hidden=YES;
        
//    } else if ([button.currentTitle isEqualToString:@"互生新闻"]){
//        
//        self.scrollView.contentOffset = CGPointMake(1 * (kScreenWidth - 128), 0);
        
    } else if ([button.currentTitle isEqualToString:@"客户咨询"]){
        [self recodeNavIndex:1];
        self.scrollView.contentOffset = CGPointMake(1 * (kScreenWidth ), 0);
//        self.navView.showLabel.hidden=YES;
        
    } else if ([button.currentTitle isEqualToString:@"企业通讯录"]){
        [self recodeNavIndex:2];
        self.scrollView.contentOffset = CGPointMake(2 * (kScreenWidth), 0);
//        self.navView.tipLabel.hidden=YES;
    }

}
/**企业营业点操作员好友按字母分组*/
- (NSMutableArray *)saleNetWorkoperListCompanyWithArray:(NSArray *)array {
    NSArray *ABCArray = [NSArray arrayWithObjects: @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z",@"#", nil];
    NSMutableArray *operGroupArray = [NSMutableArray array];
    for (NSString *key in ABCArray) {
        GYHDSaleNetWorkOperModel *operGroupModel = [[GYHDSaleNetWorkOperModel alloc]init];
        
        for (GYHDSaleListGrounpModel*tempModel in array) {
            
            
            for (GYHDSaleListModel *operModel in tempModel.operatorListArr) {
                //1. 转字母
                NSString * tempStr = operModel.operName;
                if (!tempStr || tempStr.length == 0) {
                    tempStr = @"未设置名称";
                }
                if (tempStr) {
                    tempStr = [[tempStr substringToIndex:1] uppercaseString];
                }
                if ([GYPinYinConvertTool isIncludeChineseInString:tempStr]) {
                    tempStr = [GYPinYinConvertTool chineseConvertToPinYinHead:tempStr];
                }
                //2. 获取首字母
                NSString *firstLetter;
                if (tempStr.length >= 1) {
                    firstLetter = [[tempStr substringToIndex:1] uppercaseString];
                }
                if (![ABCArray containsObject:firstLetter]) {
                    tempStr = [@"#" stringByAppendingString:tempStr];
                    firstLetter = [[tempStr substringToIndex:1] uppercaseString];
                }
                //3. 加入数组
                if([firstLetter isEqualToString:key]) {
                    operGroupModel.operGroupTitle = key;
                    [operGroupModel.operGroupArray addObject:operModel];
                }
            }

            
        }
            if (operGroupModel.operGroupTitle && operGroupModel.operGroupArray.count > 0) {
            [operGroupArray addObject:operGroupModel];
        }
    }
    return  operGroupArray;
}


/**企业所有操作员好友按字母分组*/
- (NSMutableArray *)operListCompanyWithArray:(NSArray *)array {
    NSArray *ABCArray = [NSArray arrayWithObjects: @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z",@"#", nil];
    NSMutableArray *operGroupArray = [NSMutableArray array];
    for (NSString *key in ABCArray) {
        GYHDOperGroupModel *operGroupModel = [[GYHDOperGroupModel alloc]init];
        for (GYHDOpereotrListModel *operModel in array) {
            
            //1. 转字母
            NSString * tempStr = operModel.searchUserInfo[@"operName"];
            if (!tempStr || tempStr.length == 0) {
                tempStr = @"未设置名称";
            }
            if (tempStr) {
                tempStr = [[tempStr substringToIndex:1] uppercaseString];
            }
            if ([GYPinYinConvertTool isIncludeChineseInString:tempStr]) {
                tempStr = [GYPinYinConvertTool chineseConvertToPinYinHead:tempStr];
            }
            //2. 获取首字母
            NSString *firstLetter;
            if (tempStr.length >= 1) {
                firstLetter = [[tempStr substringToIndex:1] uppercaseString];
            }
            if (![ABCArray containsObject:firstLetter]) {
                tempStr = [@"#" stringByAppendingString:tempStr];
                firstLetter = [[tempStr substringToIndex:1] uppercaseString];
            }
            //3. 加入数组
            if([firstLetter isEqualToString:key]) {
                operGroupModel.operGroupTitle = key;
                [operGroupModel.operGroupArray addObject:operModel];
            }
        }
        if (operGroupModel.operGroupTitle && operGroupModel.operGroupArray.count > 0) {
            [operGroupArray addObject:operGroupModel];
        }
    }
    return  operGroupArray;
}
#pragma mark - 记录导航栏按钮下标
-(void)recodeNavIndex:(NSInteger)index{

    NSString*indexStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"navindex"];
    indexStr=[NSString stringWithFormat:@"%ld",index];
    
    [[NSUserDefaults standardUserDefaults] setObject:indexStr forKey:@"navindex"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

}
#pragma mark - 依据网络状态显示提示
-(void)xmppShowState{
   
    dispatch_async(dispatch_get_main_queue(), ^{
    
        self.linkTitleButton.hidden= NO;
        
    });

}

-(void)xmppHidenState{

  
    dispatch_async(dispatch_get_main_queue(), ^{
    
     self.linkTitleButton.hidden= YES;
    
    });

}

-(void)xmppOtherLogin{


    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        [self.linkTitleButton setTitle:@"您的账号在其他终端上登录，如果这不是你的操作，请访问www.hsxt.net，修改登录密码" forState:UIControlStateNormal];
        self.linkTitleButton.hidden= NO;
        
    });

}
-(void)searchPop{
    
    NSString*indexStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"navindex"];
    self.msgBtn.selected=NO;
    self.msgBtn.userInteractionEnabled=YES;
    self.companyBtn.selected=NO;
    self.companyBtn.userInteractionEnabled=YES;
    self.selectButton = self.customerBtn;
    self.selectButton.selected=YES;
    self.selectButton.userInteractionEnabled=NO;
    self.scrollView.contentOffset = CGPointMake([indexStr integerValue] * (kScreenWidth ), 0);
}

@end
