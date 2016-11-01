//
//  GYOrderTakeOutViewController.m
//  GYRestaurant
//
//  Created by ios007 on 15/10/10.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOrderTakeOutViewController.h"
#import "GYOrderTableViewCell.h"
#import "GYTakeOutOrderOperateCell.h"
#import "GYOderTakeOutSendingCell.h"
#import "GYOrderOperateCell.h"
#import "GYOderInPaidCell.h"
#import "GYOrderTakeOutDetailViewController.h"
#import "GYOrderManagerViewModel.h"
#import "GYOrderTakeOutModel.h"
#import "GYAlertView.h"
#import "GYOutPaidViewController.h"
#import "GYOutOrderPayViewController.h"
#import "GYOutOrderPayView.h"
#import "GYOutConfirmViewController.h"
#import "GYOutDetailViewController.h"
#import "GYOutCancelViewController.h"
#import "GYOrderViewController.h"
#import "GYRefreshFooter.h"
#import "GYRefreshHeader.h"
#import "MJRefresh.h"
#import "GYGIFHUD.h"
#import "GYReasonAlertView.h"
#import "GYOrderInAllViewCell.h"

typedef NS_OPTIONS(NSInteger, TableViewType)
{
    TableViewTypeToConfirm,//待接订单
    TableViewTypeToSend,//待送餐
    TableViewTypeSending,//送餐中
    TableViewTypePaid,//已结账
    TableViewTypeCustomCancel,//消费者已取消
    TableViewTypeAll//全部
};


@interface GYOrderTakeOutViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,TabViewCellDelegate,CellDelegate,PayDelegate>{
   
    NSMutableArray *headerArray;
    UIView *_headView;
    NSArray *chooseBtnArry;
   
}

@property (nonatomic, copy) NSString *ordStatus;//订单状态
@property (nonatomic, strong) GYOrderTakeOutModel *outOrderModel;//订单返回模型
@property (nonatomic, assign)TableViewType type;
@property (nonatomic, strong) GYOutOrderPayView *outPayView;
@property (nonatomic, strong) NSMutableArray *detailDataArr;
@property (nonatomic, strong) UITableView *outOrderTableView;
@property (nonatomic, strong) UIButton *currentButton;
@property (nonatomic, strong) NSString *dateStatus; //查询时间标示
@property (nonatomic, copy) NSString *currentPageIndex;
@property (nonatomic, strong) GYRefreshHeader *header;
@property (nonatomic, strong) GYRefreshFooter *footer;
@property (nonatomic, strong) UILabel *noDataLabel;

@property (nonatomic, strong) UIImageView *noDataImageView;

@end

@implementation GYOrderTakeOutViewController
#pragma mark - 继承系统
- (void)viewDidLoad{
    [super viewDidLoad];
    self.noDataLabel = [[UILabel alloc]init];
    self.noDataLabel.frame =  CGRectMake(kScreenWidth * 0.5 - 64, kScreenHeight * 0.5 + 48 , 128, 30);
    self.noDataLabel.text = kLocalized(@"NoDataCheck");
    self.noDataLabel.backgroundColor = [UIColor clearColor];
    self.noDataLabel.font = [UIFont systemFontOfSize:20.0];
    self.noDataLabel.textColor = [UIColor lightGrayColor];
    self.noDataLabel.textAlignment = NSTextAlignmentCenter;
    self.noDataLabel.hidden = YES;
    [self.view addSubview:self.noDataLabel];
    
    self.noDataImageView = [[UIImageView alloc] init];
    self.noDataImageView.frame = CGRectMake(kScreenWidth * 0.5 - 64, kScreenHeight * 0.5 - 48 , 128, 96);
    [self.noDataImageView setImage:[UIImage imageNamed:@"no_data"]];
    self.noDataImageView.hidden = YES;
    [self.view addSubview:self.noDataImageView];

    [self.view addSubview:_outOrderTableView];
    
    [self addView];
    [self addTableView];
    [self refreshView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, self.view.frame.size.width, 2)];
    lineView.backgroundColor = kRedFontColor;
    
    [self.view addSubview:lineView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestOrderListDataWithButton:self.currentButton withPage:self.currentPageIndex withResNO:self.strResNO withRefresh:YES];
    
}
#pragma mark - 创建视图
-(void)addView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    chooseBtnArry = @[kLocalized(@"PendingOrders"),kLocalized(@"PendingDelivery"),kLocalized(@"Deliveries"),kLocalized(@"AlreadyCheckout"),kLocalized(@"ConsumersHaveBeenCanceled"),kLocalized(@"All")];
    UIView *viewFirst = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 16, 1)];
    viewFirst.backgroundColor = [UIColor colorWithRed:6800/255 *.01 green:13900/255*.01 blue:19100/255*.01 alpha:1];
    [self.view addSubview:viewFirst];
    UIView *viewLast = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 16, 80, 16, 1)];
    viewLast.backgroundColor = [UIColor colorWithRed:6800/255 *.01 green:13900/255*.01 blue:19100/255*.01 alpha:1];
    [self.view addSubview:viewLast];

    //添加选项按钮
    for (int i=0 ; i<chooseBtnArry.count ; i++) {
        UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseBtn.tag = 100 + i;
        
        chooseBtn.frame = CGRectMake(((kScreenWidth-32)/chooseBtnArry.count) * i +16, 30, (kScreenWidth-32)/chooseBtnArry.count, 50);
        [chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [chooseBtn addTarget:self action:@selector(ChooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [chooseBtn setTitle:chooseBtnArry[i] forState:UIControlStateNormal];
        [chooseBtn setTitleColor:kRedFontColor forState:UIControlStateSelected];
        chooseBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [chooseBtn setBackgroundImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
        [self.view addSubview:chooseBtn];
        //添加分割线
        UIView *chooseLineV = [[UIView alloc]initWithFrame:CGRectMake(((kScreenWidth-32)/chooseBtnArry.count) * i +16 - 1, 80, (kScreenWidth-32)/chooseBtnArry.count+2, 1)];
        chooseLineV.tag = 1000 +i;
        chooseLineV.backgroundColor = [UIColor colorWithRed:6800/255 *.01 green:13900/255*.01 blue:19100/255*.01 alpha:1];

        [self.view addSubview:chooseLineV];
        //送餐员权限设置
        if(globalData.currentRole == roleTypeTrusteeshipCompanyDeliveryStaff || globalData.currentRole == roleTypeMemberCompanyDeliveryStaff)
        {
            if (i == 2) {
                [self ChooseAction:chooseBtn];
            }else {
                chooseBtn.hidden = YES;
            
            }
        
        }else {
        if (i==0) {
            
            [self ChooseAction:chooseBtn];
        }
        }
     
        //收银员、服务员权限设置
        if(globalData.currentRole == roleTypeTrusteeshipCompanyWaiter || globalData.currentRole == roleTypeMemberCompanyWaiter || globalData.currentRole == roleTypeTrusteeshipCompanyCashier || globalData.currentRole == roleTypeMemberCompanyCashier)
        {
            if (i == 1) {
               [self ChooseAction:chooseBtn];

          }else if (i == 2){
                //[self ChooseAction:chooseBtn];
//                chooseBtn.hidden = NO;
           }else if (i == 3){
                //  [self ChooseAction:chooseBtn];
//                chooseBtn.hidden = NO;
            }else {
                chooseBtn.hidden = YES;
                
            }
            
        }
        else {
            if (i==0) {
                
                [self ChooseAction:chooseBtn];
            }
        }

    }
}

/**tableview视图*/
- (void)addTableView{
    if(globalData.currentRole == roleTypeTrusteeshipCompanyDeliveryStaff || globalData.currentRole == roleTypeMemberCompanyDeliveryStaff ||  globalData.currentRole == roleTypeTrusteeshipCompanyWaiter || globalData.currentRole == roleTypeMemberCompanyWaiter)
    {
        self.type = TableViewTypeSending;
    }else if (globalData.currentRole == roleTypeTrusteeshipCompanyCashier || globalData.currentRole == roleTypeMemberCompanyCashier){
        self.type = TableViewTypeToSend;
    }else{
        self.type = TableViewTypeToConfirm;
    }
   
    self.ordStatus = [self orderStatusType];
    self.dateStatus = [self dateStatusType];
    _outOrderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 81, kScreenWidth, kScreenHeight - 64 - 80 - 50)];
    _outOrderTableView.delegate = self;
    _outOrderTableView.dataSource = self;
    _outOrderTableView.rowHeight = 50;
    _outOrderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_outOrderTableView];
    
    headerArray = [self headerArray];
    
    [_outOrderTableView registerNib:[UINib nibWithNibName:@"GYOderTakeOutSendingCell" bundle:nil] forCellReuseIdentifier:@"sendingCell"];
    [_outOrderTableView registerNib:[UINib nibWithNibName:@"GYTakeOutOrderOperateCell" bundle:nil] forCellReuseIdentifier:@"takeOutOrderOperateCell"];
    [_outOrderTableView registerNib:[UINib nibWithNibName:@"GYOrderOperateCell" bundle:nil] forCellReuseIdentifier:@"OperateCell"];
    [_outOrderTableView registerNib:[UINib nibWithNibName:@"GYOderInPaidCell" bundle:nil] forCellReuseIdentifier:@"paidCell"];
    [_outOrderTableView registerNib:[UINib nibWithNibName:@"GYOrderInAllViewCell" bundle:nil] forCellReuseIdentifier:@"inAllCell"];
    [self refreshView];
}
- (NSMutableArray *)headerArray
{
    switch (self.type) {
        case TableViewTypeToConfirm:
        case TableViewTypeToSend:
            return [@[kLocalized(@"OrderNumber"),kLocalized(@"AlternateNumber/MobilePhoneNumber"),kLocalized(@"OrderTime"),kLocalized(@"ArrivalsTime"),kLocalized(@"OrderAmount"),kLocalized(@"Operating")] mutableCopy];
            break;
            
        case TableViewTypeCustomCancel:
            return [@[kLocalized(@"OrderNumber"),kLocalized(@"AlternateNumber/MobilePhoneNumber"),kLocalized(@"OrderTime"),kLocalized(@"CancelApplicationTime"),kLocalized(@"OrderAmount"),kLocalized(@"Operating")] mutableCopy];
            break;
        case TableViewTypeSending:
            return [@[kLocalized(@"OrderNumber"),kLocalized(@"AlternateNumber/MobilePhoneNumber"),kLocalized(@"OrderTime"),kLocalized(@"OrderAmount"),kLocalized(@"DeliveryStaff"),kLocalized(@"DeliveryTime"),kLocalized(@"Operating")] mutableCopy];
            break;
        case TableViewTypePaid:
            return [@[kLocalized(@"OrderNumber"),kLocalized(@"AlternateNumber/MobilePhoneNumber"),kLocalized(@"OrderTime"),kLocalized(@"OrderAmount"),kLocalized(@"CheckoutTime")]mutableCopy];
            break;
        case TableViewTypeAll:
            return [@[kLocalized(@"OrderNumber"),kLocalized(@"AlternateNumber/MobilePhoneNumber"),kLocalized(@"OrderTime"),kLocalized(@"OrderStatus"),kLocalized(@"OrderAmount"),kLocalized(@"DeliveryTime")]mutableCopy];
            break;
            
        default:
            break;
    }
    return nil;
}

//刷新页面
-(void)refreshView{
    @weakify(self);
    __block int page;
    __block NSString *pageStr;
// header刷新
    // 下拉刷新(进入刷新状态就会调用self的headerRereshing)
    _header = [GYRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if ([_outOrderTableView.mj_header isRefreshing]) {
            self.currentPageIndex = @"1";
            [self requestOrderListDataWithButton:self.currentButton withPage: self.currentPageIndex withResNO:self.strResNO withRefresh:NO];
        }
    }];
    
    _outOrderTableView.mj_header = _header;
    
// footer更新
    _footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if ([_outOrderTableView.mj_footer isRefreshing]) {
            page = [self.currentPageIndex intValue] + 1;
            pageStr = [NSString stringWithFormat:@"%d",page];
            [self requestOrderListDataWithButton:self.currentButton withPage:pageStr withResNO:self.strResNO withRefresh:NO];
        }
    }];

    _outOrderTableView.mj_footer = _footer;
}
/**改变表头的名字*/
- (void)chageHeaderName:(NSString *)titleArr withBtn:(UIButton*)btn{
    switch (self.type) {
        case TableViewTypeToConfirm:
            [btn setTitle:[NSString stringWithFormat:kLocalizedAddParams(kLocalized(@"PendingOrders"), @"(%@)"),titleArr] forState:UIControlStateNormal];
            break;
        case TableViewTypeToSend:
            [btn setTitle:[NSString stringWithFormat:kLocalizedAddParams(kLocalized(@"PendingDelivery"), @"(%@)"),titleArr] forState:UIControlStateNormal];
            break;
        case TableViewTypeSending:
            [btn setTitle:[NSString stringWithFormat:kLocalizedAddParams(kLocalized(@"Deliveries"), @"(%@)"),titleArr] forState:UIControlStateNormal];
            break;
        case TableViewTypePaid:
            [btn setTitle:[NSString stringWithFormat:kLocalizedAddParams(kLocalized(@"AlreadyCheckout"), @"(%@)"),titleArr] forState:UIControlStateNormal];
            break;
        case TableViewTypeCustomCancel:
            [btn setTitle:[NSString stringWithFormat:kLocalizedAddParams(kLocalized(@"ConsumersHaveBeenCanceled"), @"(%@)"),titleArr] forState:UIControlStateNormal];
            break;
        case TableViewTypeAll:
            [btn setTitle:[NSString stringWithFormat:kLocalizedAddParams(kLocalized(@"All"), @"(%@)"),titleArr] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

#pragma mark - btnAction
-(void)ChooseAction:(UIButton*)btn{
    
    self.currentButton = btn;
    self.type = btn.tag - 100;
   // DDLogCInfo(@"%ld",type);
    if (btn.selected) {
        return;
        
    }
    self.strResNO = nil;
    
    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[UIButton class]] && v.tag != btn.tag) {
            ((UIButton *)v).selected = NO;
        }
    }
    for (int i = 1000; i < 1000+ chooseBtnArry.count; i++) {
        UIView *viewLine = [self.view viewWithTag:i];
        viewLine.hidden = NO;
        if (i - 900 == btn.tag) {
            UIView *chooseLine = [self.view viewWithTag:i];
            chooseLine.hidden = YES;
        }
    }
    btn.selected = !btn.selected;
    self.ordStatus = [self orderStatusType];
    self.dateStatus = [self dateStatusType];
    [_dataArr removeAllObjects];
    headerArray = [self headerArray];
    [_outOrderTableView reloadData];
   
    [self requestOrderListDataWithButton:btn withPage:@"1" withResNO:self.strResNO withRefresh:YES];
 
}

//懒加载
- (NSMutableArray *)dataArray
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    
    return _dataArr;
}

-(NSMutableArray *)detailDataArr{
    if (!_detailDataArr) {
        _detailDataArr=[[NSMutableArray alloc] init];
    }
    return _detailDataArr;
    
}

#pragma mark - 切换时间标示输入状态选择参数
-(NSString *)dateStatusType{

    switch (self.type) {
        case TableViewTypeToConfirm:
        case TableViewTypeToSend:
        case TableViewTypeSending:
        case TableViewTypePaid:
        case TableViewTypeCustomCancel:
        {
            return @"6";
            
        }
            break;
            
        case TableViewTypeAll:
        {
            
            return @"6";
        
        }
            break;
            
        default:
            break;
    }

    return nil;
}


#pragma mark - 切换输入状态选择参数
-(NSString *)orderStatusType{
    
    //    return @"1,2,3,4,5,6,7,8";
    switch (self.type) {
        case TableViewTypeToConfirm:
        {
            return   @"1,8";
            
        }
            break;
        case TableViewTypeToSend:
        {
            return @"2";
        }
            break;
        case TableViewTypeSending:
        {
            return @"3,11";
        }
            break;
        case TableViewTypePaid:{
            return @"4";
        }
            break;
        case TableViewTypeCustomCancel:
        {
            return @"10";
        }
            break;
        case TableViewTypeAll:
        {
            return @"";
        }
        default:
            break;
    }
    return nil;
}
#pragma mark - 自定义方法
- (void) hideKeyboard {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
- (void)setStrResNO:(NSString *)strResNO{
    if (strResNO == nil) {
        _strResNO = nil;
        return;
    }
    if (_strResNO != strResNO) {
        _strResNO = strResNO;
        [_dataArr removeAllObjects];
        [self dataArray];
        [self requestOrderListDataWithButton:self.currentButton withPage:self.currentPageIndex withResNO:strResNO withRefresh:YES];
    }
}

#pragma mark -  网络请求
/**请求外卖订单列表数据*/
-(void)requestOrderListDataWithButton:(UIButton *)btn withPage:(NSString*)page withResNO:(NSString*)resNO withRefresh:(BOOL)showLoad{
    @weakify(self);
    if (showLoad) {
        [_outOrderTableView.mj_footer endRefreshing];
        [_outOrderTableView.mj_header endRefreshing];
    }
    
    NSString *shopId = kGetNSUser(@"shopId");
    if (shopId.length == 0) {
        [self notifyWithText:kLocalized(@"PleaseSelectTheBusiness")];
        [_outOrderTableView.mj_header endRefreshing];
        return;
    }
    NSDictionary *dict;
    if (resNO == nil) {
        dict = @{@"curPageNo":page,
                 @"orderStatusStr":_ordStatus,
                 @"dateStatus":_dateStatus,
                 @"orderType":@"2",
                 @"rows":@"20",
                 @"shopId":kGetNSUser(@"shopId")
                 };
    }else{
        dict = @{@"curPageNo":page,
                 @"orderStatusStr":_ordStatus,
                 @"dateStatus":_dateStatus,
                 @"orderType":@"2",
                 @"rows":@"20",
                 @"shopId":kGetNSUser(@"shopId"),
                 @"resNo":resNO
                 };
        
    }
    _currentPageIndex = page;
    GYOrderManagerViewModel *orderList = [[GYOrderManagerViewModel alloc]init];
    [self modelRequestNetwork:orderList :^(id resultDic) {
        @strongify(self);
        if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
            NSMutableArray *orderArr=[[NSMutableArray alloc] init];
            id arr = resultDic[@"data"];
            if ([arr isKindOfClass:[NSNull class]]) {
                [GYGIFHUD dismiss];
            }else if([arr isKindOfClass:[NSArray class]]){
                for(NSDictionary *dataDic in resultDic[@"data"]){
                    GYOrderTakeOutModel *orderModel=[GYOrderTakeOutModel mj_objectWithKeyValues:dataDic];
                    [orderArr addObject:orderModel];
                }}else{
                    
                    [GYGIFHUD dismiss];
                    [self notifyWithText:kLocalized(@"NoRecordsFound")];
                }
            NSString *rowsStr = [NSString stringWithFormat:@"%@",resultDic[@"rows"]];
            if ([rowsStr isEqualToString:@"<null>"]) {
                rowsStr = @"0";
            }else if ([rowsStr intValue] > 100){
                rowsStr = @"99+";
            }
            [self chageHeaderName:rowsStr withBtn:btn];
            //下拉刷新
            if ([page isEqualToString:@"1"]) {
                [_dataArr removeAllObjects];
                if (orderArr.count > 0) {
                    _dataArr = orderArr;
                }
                if (resultDic[@"currentPageIndex"] == resultDic[@"totalPage"]) {
                    [_outOrderTableView.mj_footer endRefreshingWithNoMoreData];
                    
                    [_outOrderTableView.mj_header endRefreshing];
                    [_outOrderTableView reloadData];
                }else{
                    
                    [_outOrderTableView.mj_header endRefreshing];
                    [_outOrderTableView.mj_footer resetNoMoreData];
                    [_outOrderTableView reloadData];
                }
                
            }else{
                [_dataArr addObjectsFromArray:orderArr];
                [_outOrderTableView reloadData];
                if (resultDic[@"currentPageIndex"] == resultDic[@"totalPage"]) {
                    [_outOrderTableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_outOrderTableView.mj_footer endRefreshing];
                }
            }
            self.noDataLabel.hidden = (self.dataArr.count == 0? NO:YES);
            self.noDataImageView.hidden = (self.dataArr.count == 0? NO:YES);
            _outOrderTableView.hidden = !self.noDataLabel.hidden;

        }else if([resultDic[@"retCode"] isEqualToNumber:@205]){
            [_outOrderTableView.mj_header endRefreshing];
            [_outOrderTableView.mj_footer endRefreshing];
            [self notifyWithText:kLocalized(@"UsersAbnormalState")];
        }else{
            [_outOrderTableView.mj_header endRefreshing];
            [_outOrderTableView.mj_footer endRefreshing];
            [self notifyWithText:kLocalized(@"RefreshFailed")];
        
        }
        
    } isIndicator:showLoad];
    [orderList GetOderListWithparams:dict];
}



#pragma mark - TabViewCell的代理方法

- (void)operateBtn:(GYOrderTakeOutModel *)model withTableViewType:(NSInteger)tableViewType button:(UIButton *)btn{
    [self hideKeyboard];
    @weakify(self);
    if (tableViewType == TableViewTypeToConfirm) {
        GYAlertView *alertView=[[GYAlertView alloc] initWithTitle:kLocalizedAddParams(kLocalized(@"AreYouSureToTakeOrders") , @"?") contentText:nil leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Determine")];
        
        alertView.rightBlock=^(){
                       GYOrderManagerViewModel *viewModel=[[GYOrderManagerViewModel alloc] init];
            [btn controlTimeOut];
            [self modelRequestNetwork:viewModel :^(id resultDic) {
                @strongify(self);
                if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
                    [self notifyWithText:kLocalized(@"OrdersSuccess")];
                    UIButton *button = (UIButton *)[self.view viewWithTag:100];
                    [self requestOrderListDataWithButton:button withPage:self.currentPageIndex withResNO:self.strResNO withRefresh:YES];
                    [_outOrderTableView reloadData];
                }else{
                    [self notifyWithText:kLocalized(@"OrdersFailure")];
                }
                
                [_outOrderTableView reloadData];
            } isIndicator:YES];
            
            [viewModel acceptOrderWithuserId:model.userId withOrderId:model.orderId withIsAccept:YES];
            
        };
        [alertView show];
    }
    
}
- (void)refuseBtn:(GYOrderTakeOutModel *)model withTableViewType:(NSInteger)tableViewType button:(UIButton *)btn{
    [self hideKeyboard];
    @weakify(self);
    if (tableViewType == TableViewTypeToConfirm) {
        GYReasonAlertView *alertView = [[GYReasonAlertView alloc] initWithTitle:kLocalizedAddParams(kLocalized(@"AreYouSureToRefuseOrders"), @"?") resonTextFieldName:kLocalized(@"RefuseReason:") leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Determine")];
        
        alertView.rightBlock= ^(NSString *reasonStr){
            
            if (reasonStr.length == 0) {
                [self notifyWithText:kLocalized(@"PleaseEnterReasonToRefuse!")];
            }else if(reasonStr.length > 0 && reasonStr.length < 20){
               
                NSString *regex = @"^[\u4e00-\u9fa5_,.!?，。！？a-zA-Z0-9]+$";
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                if (![pred evaluateWithObject:reasonStr]) {
                    [self notifyWithText:kLocalized(@"CancelGroundsOnlyByChineseCharacters, Letters, NumbersAndPunctuation, PleaseRe-enter")];
                    return;
                }

                GYOrderManagerViewModel *viewModel=[[GYOrderManagerViewModel alloc] init];
                [btn controlTimeOut];
                [self modelRequestNetwork:viewModel :^(id resultDic) {
                  //  DDLogCInfo(kLocalized(@"RefuseOrders"));
                   @strongify(self);
                    if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
                        [self notifyWithText:kLocalized(@"RefuseOrdersSuccess")];
                        UIButton *button = (UIButton *)[self.view viewWithTag:100];
                        [self requestOrderListDataWithButton:button withPage:self.currentPageIndex withResNO:self.strResNO withRefresh:YES];
                        [_outOrderTableView reloadData];
                    }else{
                        [self notifyWithText:kLocalized(@"RefuseOrdersFailure")];
                    }
                    [_outOrderTableView reloadData];
                    
                } isIndicator:YES];
                [viewModel putRefuseOrderWithUserId:model.userId withOrderId:model.orderId withReason:reasonStr];
            }else if (reasonStr.length > 20){
            
                [self notifyWithText:kLocalized(@"RefuseReasonNotMoreThan 20 Characters!")];
            }
            
        };
        [alertView show];

    }
   
}

#pragma mark - CellTabView的代理方法
- (void)postBtn:(GYOrderTakeOutModel *)model withTableViewType:(NSInteger)tableViewType button:(UIButton *)btn{
    [self hideKeyboard];
    @weakify(self);
    if (tableViewType == TableViewTypeToSend) {
        GYOrderTakeOutDetailViewController *outDetailCtl=[[GYOrderTakeOutDetailViewController alloc] init];
        
        outDetailCtl.infoDic = @{@"userId":model.userId,@"orderId":model.orderId};
        
        [self.navigationController pushViewController:outDetailCtl animated:YES];
    }else if(tableViewType == TableViewTypeCustomCancel){
       
        GYAlertView *alertView=[[GYAlertView alloc] initWithTitle:kLocalized(@"CancelReservationConfirmation") contentText:nil leftButtonTitle:kLocalized(@"Cancel")  rightButtonTitle:kLocalized(@"Determine")];
        alertView.rightBlock=^(){
            @strongify(self);
            [btn controlTimeOut];
            GYOrderManagerViewModel *viewModel=[[GYOrderManagerViewModel alloc] init];
          
            [self modelRequestNetwork:viewModel :^(id resultDic) {
            @strongify(self);
                if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
                    [self notifyWithText:kLocalized(@"SuccessToCancelTheOrderConfirmation")];
                   UIButton *button = (UIButton *)[self.view viewWithTag:104];
                    [self requestOrderListDataWithButton:button withPage:self.currentPageIndex withResNO:self.strResNO withRefresh:YES];
                    [_outOrderTableView reloadData];
                }else{
                    [self notifyWithText:kLocalized(@"FailureToCancelTheOrderConfirmation")];
                }
              [_outOrderTableView reloadData];
            }  isIndicator:YES];
           [viewModel cancelOrderValidateWithUserId:model.userId orderId:model.orderId]; 
        };
        [alertView show];

    
    }
}

#pragma mark - PayDelegate的代理方法
-(void)payBtn:(GYOrderTakeOutModel *)model withTableViewType:(NSInteger)tableViewType button:(UIButton *)btn{
    [self hideKeyboard];
    @weakify(self);
    if (tableViewType == TableViewTypeSending) {
        
        GYAlertView *alert=[[GYAlertView alloc] initWithTitle:kLocalizedAddParams(kLocalized(@"AreYouSureToSettleAccounts"), @"?") contentText:nil leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Determine")];
        alert.rightBlock = ^(){
            @strongify(self);
            [btn controlTimeOut];
            GYOrderManagerViewModel *viewModel=[[GYOrderManagerViewModel alloc] init];
            
            [self modelRequestNetwork:viewModel :^(id resultDic) {
                //    DDLogCInfo(@"现金结算成功");
                 @strongify(self);
                if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
                    
                    [self notifyWithText:kLocalized(@"ReceivablesSuccess")];
                    
                    UIButton *button = (UIButton *)[self.view viewWithTag:102];
                    [self requestOrderListDataWithButton:button withPage:self.currentPageIndex withResNO:self.strResNO withRefresh:YES];
                    [_outOrderTableView reloadData];
//                    [self performSelector:@selector(popBack) withObject:nil afterDelay:1.5];
                    
                    
                }else if ([resultDic[@"retCode"] isEqualToNumber:@590]){
                    [self notifyWithText:kLocalized(@"EnterprisePrepaidAccountBalanceIsRunningLow!")];
                    
                }else{
                    [self notifyWithText:kLocalized(@"ReceivablesFailure")];
                }
                
                
            } isIndicator:YES];
            
            [viewModel outOrderPayWithkey:globalData.loginModel.token userId:model.userId orderId:model.orderId orderType:@"2"];
            
        };
        
        [alert show];
        
    }

}


#pragma mark -TableViewDelegate && UITableViewDataSource

static NSString *reuseIdenty = @"identy";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.type) {
        case TableViewTypeToConfirm:
        {
            GYTakeOutOrderOperateCell *cell = [_outOrderTableView dequeueReusableCellWithIdentifier:@"takeOutOrderOperateCell" forIndexPath:indexPath];
            cell.delegate=self;
            _outOrderModel = _dataArr[indexPath.row];
            cell.model = _outOrderModel;
            [cell.acceptButton setTitle:kLocalized(@"TakeOrders") forState:UIControlStateNormal];
            [cell.refuseButton setTitle:kLocalized(@"RefuseOrders") forState:UIControlStateNormal];
            if (globalData.currentRole == roleTypeTrusteeshipCompanyWaiter || globalData.currentRole == roleTypeMemberCompanyWaiter||globalData.currentRole == roleTypeTrusteeshipCompanyCashier || globalData.currentRole == roleTypeMemberCompanyCashier ) {
                cell.acceptButton.hidden = YES;
                cell.vCenterLine.hidden = YES;
                cell.refuseButton.hidden = YES;
            }else{
                cell.acceptButton.hidden = NO;
                cell.vCenterLine.hidden = NO;
                cell.refuseButton.hidden = NO;
            }
           
            
            
            return cell;
        }
            break;
        case TableViewTypeCustomCancel:{
            
            GYOrderOperateCell *cell = [_outOrderTableView dequeueReusableCellWithIdentifier:@"OperateCell" forIndexPath:indexPath];
            _outOrderModel = _dataArr[indexPath.row];
            cell.celldelegate=self;
            cell.model=_outOrderModel;
            cell.tableViewType = TableViewTypeCustomCancel;
            [cell.confirmBtn setTitle:kLocalized(@"Confirm") forState:UIControlStateNormal];
            if (globalData.currentRole == roleTypeTrusteeshipCompanyWaiter || globalData.currentRole == roleTypeMemberCompanyWaiter||globalData.currentRole == roleTypeTrusteeshipCompanyCashier || globalData.currentRole == roleTypeMemberCompanyCashier ) {
                cell.confirmBtn.hidden = YES;
            }else{
                cell.confirmBtn.hidden = NO;
            }
           
            return cell;
        }
            
            break;
        case TableViewTypeToSend:
        
        {
            GYOrderOperateCell *cell = [_outOrderTableView dequeueReusableCellWithIdentifier:@"OperateCell" forIndexPath:indexPath];
            _outOrderModel = _dataArr[indexPath.row];
            cell.celldelegate=self;
            cell.model=_outOrderModel;
            cell.tableViewType = TableViewTypeToSend;
             [cell.confirmBtn setTitle:kLocalized(@"Delivery") forState:UIControlStateNormal];
            
           
            
            
            return cell;
        }
        case TableViewTypeSending:
            
        {
            GYOderTakeOutSendingCell *cell = [_outOrderTableView dequeueReusableCellWithIdentifier:@"sendingCell" forIndexPath:indexPath];
            
             _outOrderModel = _dataArr[indexPath.row];
            cell.paydelegate = self;
            cell.model = _outOrderModel;
            cell.tableViewType = TableViewTypeSending;
            cell.ordIdLabel.text = _outOrderModel.orderId;
            cell.useIdLabel.text = _outOrderModel.resNo;
            cell.ordStartTimeLabel.text = _outOrderModel.orderStartDatetime;
            cell.payStatusLabel.text = _outOrderModel.payStatus;
            cell.payCountLabel.text = _outOrderModel.orderPayCount;
            cell.postManLabel.text = _outOrderModel.postMan;
            cell.postDateTimeRangeLabel.text = _outOrderModel.postDateTimeRange;
           
            [cell.oparateBtn setTitle:kLocalized(@"Receivables") forState:UIControlStateNormal];
            if (globalData.currentRole == roleTypeTrusteeshipCompanyWaiter || globalData.currentRole == roleTypeMemberCompanyWaiter ||globalData.currentRole == roleTypeTrusteeshipCompanyDeliveryStaff || globalData.currentRole == roleTypeMemberCompanyDeliveryStaff) {
                cell.oparateBtn.hidden = YES;
            }else{
                if ([_outOrderModel.payStatus isEqualToString:kLocalized(@"Unpaid")]) {
                    cell.oparateBtn.hidden = NO;
                    
                 
                }else if ([_outOrderModel.payStatus isEqualToString:kLocalized(@"AlreadyPaid")]){
                    cell.oparateBtn.hidden = YES;
                
                }
            }
            
            return cell;
        }
            break;
        case TableViewTypePaid:
        
        {
            GYOderInPaidCell *cell = [_outOrderTableView dequeueReusableCellWithIdentifier:@"paidCell" forIndexPath:indexPath];
            
            
            _outOrderModel = _dataArr[indexPath.row];
            
            cell.ordIdLabel.text = _outOrderModel.orderId;
            cell.useIdLabel.text = _outOrderModel.resNo;
            cell.orderStartDatetimeLabel.text = _outOrderModel.orderStartDatetime;
      //      cell.orderStatusLabel.text = _outOrderModel.orderStatus;
            cell.orderPayCountLabel.text = _outOrderModel.orderPayCount;
            cell.ordFinishTimeLabel.text = _outOrderModel.payOrderDate;
            
           
            
            
            return cell;
        }
            break;
            case TableViewTypeAll:
        {
            GYOrderInAllViewCell *cell = [_outOrderTableView dequeueReusableCellWithIdentifier:@"inAllCell" forIndexPath:indexPath];
            
            _outOrderModel = _dataArr[indexPath.row];
            
            cell.orderIdLable.text = _outOrderModel.orderId;
            cell.resNoLable.text = _outOrderModel.resNo;
            cell.orderStartLable.text = _outOrderModel.orderStartDatetime;
            cell.orderStatusLable.text = _outOrderModel.orderStatus;
            cell.orderAcountLable.text = _outOrderModel.orderPayCount;
            cell.orderPaymentLable.text = _outOrderModel.postDateTimeRange;
            return cell;

        }
            break;
        default:
            break;
    }
    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    _headView.backgroundColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1.0];

    switch (self.type) {
        case TableViewTypeSending:
            
        {
            
            // 选项Label间距
            for (int i=0; i<headerArray.count ; i++) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 40)/headerArray.count * i +40, 0, (kScreenWidth - 40)/headerArray.count, 50)];
                label.text = headerArray[i];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:18];
                [_headView addSubview:label];
            }
 
            
            
            return _headView;
        }
            break;
        case TableViewTypeToConfirm :
        case TableViewTypeToSend :
        case TableViewTypePaid :
        case TableViewTypeCustomCancel :
        case TableViewTypeAll :
        {
            // 选项Label间距
            // 选项Label间距
            for (int i=0; i<headerArray.count ; i++) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 40)/headerArray.count * i +40, 0, (kScreenWidth - 40)/headerArray.count, 50)];
                label.text = headerArray[i];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:18];
                [_headView addSubview:label];
            }
            
            return _headView;
        }
            break;
        default:
            break;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{        
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _outOrderModel = _dataArr[indexPath.row];
    switch (self.type) {
        case TableViewTypeToSend:
        {
            GYOrderTakeOutDetailViewController *outDetailCtl = [[GYOrderTakeOutDetailViewController alloc]init];
            
            outDetailCtl.infoDic = @{@"userId":_outOrderModel.userId,@"orderId":_outOrderModel.orderId};
            
        [self.navigationController pushViewController:outDetailCtl animated:YES];
        }
            break;
       case TableViewTypeSending:
        {
            GYOutPaidViewController *outPaidCtl = [[GYOutPaidViewController alloc]init];
            
            outPaidCtl.infoDic = @{@"userId":_outOrderModel.userId,@"orderId":_outOrderModel.orderId};
            [self.navigationController pushViewController:outPaidCtl animated:YES];
        }
            break;
            case TableViewTypeToConfirm:
        {
            GYOutConfirmViewController *outConfirmCtl=[[GYOutConfirmViewController alloc] init];
            outConfirmCtl.infoDic = @{@"userId":_outOrderModel.userId,@"orderId":_outOrderModel.orderId};
            [self.navigationController pushViewController:outConfirmCtl animated:YES];
 
        }
            break;
            
           
            case TableViewTypeCustomCancel:
        {
            GYOutCancelViewController *outCancelCtl=[[GYOutCancelViewController alloc] init];
            outCancelCtl.infoDic = @{@"userId":_outOrderModel.userId,@"orderId":_outOrderModel.orderId};
            [self.navigationController pushViewController:outCancelCtl animated:YES];
        }
            break;
            
             case TableViewTypePaid:
        {
            GYOutDetailViewController *orderOutDetailctl=[[GYOutDetailViewController alloc] init];
            orderOutDetailctl.status = _outOrderModel.orderStatus;
            orderOutDetailctl.infoDic = @{@"userId":_outOrderModel.userId,@"orderId":_outOrderModel.orderId};
            [self.navigationController pushViewController:orderOutDetailctl animated:YES];
        }
            break;
            
            case TableViewTypeAll:
        {

            if ([_outOrderModel.orderStatus isEqualToString:kLocalized(@"Unconfirmed")] ) {
                GYOutConfirmViewController *outConfirmCtl=[[GYOutConfirmViewController alloc] init];
                outConfirmCtl.infoDic = @{@"userId":_outOrderModel.userId,@"orderId":_outOrderModel.orderId};
                outConfirmCtl.status = _outOrderModel.orderStatus;
                [self.navigationController pushViewController:outConfirmCtl animated:YES];
            }
            
            if ([_outOrderModel.orderStatus isEqualToString:kLocalized(@"PendingDelivery")]) {
                GYOrderTakeOutDetailViewController *outDetailCtl = [[GYOrderTakeOutDetailViewController alloc]init];
                
                
                outDetailCtl.infoDic = @{@"userId":_outOrderModel.userId,@"orderId":_outOrderModel.orderId};
                
                [self.navigationController pushViewController:outDetailCtl animated:YES];
            }
            if ([_outOrderModel.orderStatus isEqualToString:kLocalized(@"Deliveries")]) {
                GYOutPaidViewController *outPaidCtl = [[GYOutPaidViewController alloc]init];
                
                outPaidCtl.infoDic = @{@"userId":_outOrderModel.userId,@"orderId":_outOrderModel.orderId};
                [self.navigationController pushViewController:outPaidCtl animated:YES];
            }
            if ([_outOrderModel.orderStatus isEqualToString:kLocalized(@"TransactionComplete")] || [_outOrderModel.orderStatus isEqualToString:kLocalized(@"Cancelled")]) {
                GYOutDetailViewController *orderOutDetailctl=[[GYOutDetailViewController alloc] init];
                orderOutDetailctl.status = _outOrderModel.orderStatus;
                orderOutDetailctl.infoDic = @{@"userId":_outOrderModel.userId,@"orderId":_outOrderModel.orderId};
                [self.navigationController pushViewController:orderOutDetailctl animated:YES];
            }
            if ([_outOrderModel.orderStatus isEqualToString:kLocalized(@"CancelUnconfirmed")]) {
                GYOutCancelViewController *outCancelCtl=[[GYOutCancelViewController alloc] init];
                outCancelCtl.infoDic = @{@"userId":_outOrderModel.userId,@"orderId":_outOrderModel.orderId};
                [self.navigationController pushViewController:outCancelCtl animated:YES];
            }
           
        }
            break;
        default:
            break;
    }
    
}

@end
