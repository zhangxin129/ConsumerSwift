//
//  GYOrderInViewController.m
//  GYRestaurant
//
//  Created by ios007 on 15/10/10.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOrderInViewController.h"
#import "Network.h"
#import "GYOrderTableViewCell.h"
#import "GYOderInPaidCell.h"
#import "GYOrderInDetailViewController.h"
#import "GYOrderManagerViewModel.h"
#import "GYOrderListModel.h"
#import "GYOrdDetailModel.h"
#import "GYAlertWithFieldView.h"
#import "GYOrderTakeInInvoicingViewController.h"
#import "GYGIFHUD.h"
#import "GYRefreshFooter.h"
#import "GYRefreshHeader.h"
#import "MJRefresh.h"
#import "GYOrderConfirmTableViewCell.h"

#import "GYOrderInToPayViewCell.h"
#import "GYOrderInToEatViewCell.h"
#import "GYOrderInAllViewCell.h"
#import "GYOrderInCancelCell.h"
#import "GYOutCancelViewController.h"

#define kBorder 150
#define kTitleFont [UIFont systemFontOfSize:17]


typedef NS_ENUM(NSInteger, TableViewType)
{
    TableViewTypeToConfirm,//待确认
    TableViewTypeToEat,//待用餐
    TableViewTypeToPay,//待结账
    TableViewTypePaid,//已结账
    TableViewTypeToGet,//待自提
    TableViewTypeCustomCancel,//取消未确认
    TableViewTypeAll//全部店内
    
};

typedef NS_ENUM(NSInteger, DateStatus) {
    DateStatusADay = 1,//一天
    DateStatusThreeDays = 2,//三天
    DateStatusAWeek = 3,//一周
    DateStatusAMonth = 4,//一月
    DateStatusAYear = 5,//一年
    DateStatusAll = 6// 全部
};

@interface GYOrderInViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate, TableViewCellDelegate,ConfirmCellDelegate,ToPayViewCellDelegate,ToEatViewCellDelegate,CancelDelegate,UITextFieldDelegate>
{
    UITableView *orderTableView;
    
    NSMutableArray *headerArray;
    
    UIView *_headView;
    
    NSArray *chooseBtnArray;//按钮头数组
}

@property (nonatomic, strong)NSMutableArray *dataArr;

@property (nonatomic, assign)TableViewType type;

@property (nonatomic, copy) NSString *ordStatus;//订单状态

@property (nonatomic, copy) NSString *ordCount;//全部订单数

@property (nonatomic, strong) GYOrderListModel *ordListModel;//订单返回模型

@property (nonatomic, strong) UIButton *currentButton;

@property (nonatomic, assign) DateStatus dateStatus;

@property (nonatomic, strong) GYRefreshFooter *footer;
@property (nonatomic, strong) GYRefreshHeader *header;

@property (nonatomic, copy) NSString *pageCurrent;

@property (nonatomic, strong) NSMutableArray *titleArr;

@property (nonatomic, strong) UILabel *noDataLabel;

@property (nonatomic, strong) UIImageView *noDataImageView;

@property (nonatomic, strong) GYAlertWithFieldView *alert;
@end

@implementation GYOrderInViewController

#pragma mark - 懒加载
//懒加载
-(NSMutableArray *)dataArray{
    if (!_dataArr){
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

#pragma mark - 系统方法
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
   
    [self addView];
    [self addTableView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self requestOrderListDataWithButton:self.currentButton withPage:self.pageCurrent withResNO:self.strResNO withRefresh:YES];
}


#pragma mark - 创建视图
/**按钮*/
-(void)addView{
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, self.view.frame.size.width, 2)];
    lineView.backgroundColor = kRedFontColor;
    
    [self.view addSubview:lineView];
    
    chooseBtnArray = @[kLocalized(@"ToBeConfirmed"),kLocalized(@"ToBeDining"),kLocalized(@"ToBeCheckout"),kLocalized(@"AlreadyCheckout"),kLocalized(@"ToBeSelf-created"),kLocalized(@"ConsumersHaveBeenCanceled"),kLocalized(@"All")];

    
    UIView *viewFirst = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 16, 1)];
    viewFirst.backgroundColor = [UIColor colorWithRed:6800/255 *.01 green:13900/255*.01 blue:19100/255*.01 alpha:1];
    [self.view addSubview:viewFirst];
    UIView *viewLast = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 16, 80, 16, 1)];
    viewLast.backgroundColor = [UIColor colorWithRed:6800/255 *.01 green:13900/255*.01 blue:19100/255*.01 alpha:1];
    [self.view addSubview:viewLast];
    for (int i=0 ; i<chooseBtnArray.count ; i++) {
        UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseBtn.tag = 100 + i;
        chooseBtn.frame = CGRectMake(((kScreenWidth-32)/chooseBtnArray.count) * i + 16, 30, (kScreenWidth-32)/chooseBtnArray.count, 50);
        [chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [chooseBtn addTarget:self action:@selector(ChooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [chooseBtn setTitle:chooseBtnArray[i] forState:UIControlStateNormal];
        [chooseBtn setTitleColor:kRedFontColor forState:UIControlStateSelected];
        [chooseBtn setBackgroundImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
        chooseBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        
        UIView *chooseLineV = [[UIView alloc]initWithFrame:CGRectMake(((kScreenWidth-32)/chooseBtnArray.count) * i +16 - 1, 80, (kScreenWidth-32)/chooseBtnArray.count+2, 1)];
        chooseLineV.tag = 1000 +i;
        chooseLineV.backgroundColor = [UIColor colorWithRed:6800/255 *.01 green:13900/255*.01 blue:19100/255*.01 alpha:1];
        [self.view addSubview:chooseLineV];
        
        [self.view addSubview:chooseBtn];
        
        //服务员权限设置
        if(globalData.currentRole == roleTypeTrusteeshipCompanyWaiter || globalData.currentRole == roleTypeMemberCompanyWaiter)
        {
            if (i == 1) {
            [self ChooseAction:chooseBtn];
            }else if (i == 2){
            }else if (i == 3){

           }else {
            chooseBtn.hidden = YES;
            }
        }else {
            if (i == 0) {
             [self ChooseAction:chooseBtn];
            }
        }
        
        //收银员权限设置
        if(globalData.currentRole == roleTypeTrusteeshipCompanyCashier || globalData.currentRole == roleTypeMemberCompanyCashier)
        {
            if (i == 1) {

            [self ChooseAction:chooseBtn];
                
            }else if (i == 2){
                
            }else if (i == 3){
               
            }else if(i == 4){
            
            }else {
                chooseBtn.hidden = YES;
            }
            
        }else {
            if (i==0) {
            [self ChooseAction:chooseBtn];
            }
        }
    }
}

/**tableview视图*/
- (void)addTableView{
    if (globalData.currentRole == roleTypeTrusteeshipCompanyWaiter || globalData.currentRole == roleTypeMemberCompanyWaiter || globalData.currentRole == roleTypeTrusteeshipCompanyCashier || globalData.currentRole == roleTypeMemberCompanyCashier) {
        self.type = TableViewTypeToEat;
    }else{
        self.type = TableViewTypeToConfirm;
    }
    
    
    self.ordStatus = [self orderStatusType];
    self.dateStatus = [self dateStatusType];
    orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 81, kScreenWidth, kScreenHeight-64-80-50)];
    orderTableView.delegate = self;
    orderTableView.dataSource = self;
    orderTableView.rowHeight = 50;
    orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    orderTableView.rowHeight = 51.f;
    [self.view addSubview:orderTableView];
    headerArray = [self headerArray];
    
    [orderTableView registerNib:[UINib nibWithNibName:@"GYOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [orderTableView registerNib:[UINib nibWithNibName:@"GYOderInPaidCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [orderTableView registerNib:[UINib nibWithNibName:@"GYOrderConfirmTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
    [orderTableView registerNib:[UINib nibWithNibName:@"GYOrderInToPayViewCell" bundle:nil] forCellReuseIdentifier:@"cell3"];
    [orderTableView registerNib:[UINib nibWithNibName:@"GYOrderInToEatViewCell" bundle:nil] forCellReuseIdentifier:@"cell4"];
    [orderTableView registerNib:[UINib nibWithNibName:@"GYOrderInAllViewCell" bundle:nil] forCellReuseIdentifier:@"cell5"];
    [orderTableView registerNib:[UINib nibWithNibName:@"GYOrderInCancelCell" bundle:nil] forCellReuseIdentifier:@"CancelCell"];
    
    [self addRefreshView];
}
/**添加刷新视图*/
- (void)addRefreshView{
    @weakify(self);
    //上拉加载
    __block int page;
    __block NSString *pageStr;
    self.footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if ([orderTableView.mj_footer isRefreshing]) {
            page = [self.pageCurrent intValue] + 1;
            pageStr = [NSString stringWithFormat:@"%d",page];
            [self requestOrderListDataWithButton:self.currentButton withPage:pageStr withResNO:self.strResNO withRefresh:NO];
        }
    }];

    orderTableView.mj_footer = self.footer;
    
    //下拉刷新
    self.header = [GYRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if ([orderTableView.mj_header isRefreshing]) {
            self.pageCurrent = @"1";
            [self requestOrderListDataWithButton:self.currentButton withPage:self.pageCurrent withResNO:self.strResNO withRefresh:NO];
        }
    }];
   
    orderTableView.mj_header = self.header;
}

#pragma mark - btnAction
//选项卡触发事件
-(void)ChooseAction:(UIButton*)btn{
     self.currentButton = btn;
    self.type = btn.tag-100;
   
    if (btn.selected) {
        return;
    }
    
    self.strResNO = nil;
    
    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[UIButton class]] && v.tag != btn.tag) {
            ((UIButton *)v).selected = NO;
        }
    }
    
    for (int i = 1000; i < 1000+ chooseBtnArray.count; i++) {
        UIView *viewLine = [self.view viewWithTag:i];
        viewLine.hidden = NO;
        if (i - 900 == btn.tag) {
            UIView *chooseLine = [self.view viewWithTag:i];
            chooseLine.hidden = YES;
        }
            
    }
    
    _dataArr = [self dataArray];
    btn.selected = !btn.selected;
    self.ordStatus = [self orderStatusType];
    self.dateStatus = [self dateStatusType];
     [_dataArr removeAllObjects];
    headerArray = [self headerArray];
    [orderTableView reloadData];
    self.pageCurrent = @"1";
    [self requestOrderListDataWithButton:btn withPage:self.pageCurrent withResNO:self.strResNO withRefresh:YES];
}

#pragma mark - private methods
/**时间*/
-(DateStatus)dateStatusType{
    
    switch (self.type) {
        case TableViewTypeToConfirm:
        case TableViewTypeToEat:
        case TableViewTypeToPay:
        case TableViewTypePaid:
        case TableViewTypeToGet:
        case TableViewTypeCustomCancel:
        {
            return DateStatusAll;
            
        }
            break;
            
        case TableViewTypeAll:
        {
            
            return DateStatusAll;
            
        }
            break;
            
        default:
            break;
    }
    
    return DateStatusThreeDays;
}

/**订单*/
-(NSString *)orderStatusType{
    
    switch (self.type) {
        case TableViewTypeToConfirm:
        {
            return @"-3,1,8";
    
        }
            break;
        case TableViewTypeToEat:
        {
            return @"2,9";
        }
            break;
        case TableViewTypeToPay:
        {
            return @"6,7";
        }
            break;
        case TableViewTypePaid:
        {
            return @"4";
        }
            break;
        case TableViewTypeAll:
        {
         
            return @"";
        }
            break;
        case TableViewTypeToGet:
        {
            return @"2";
        }
            break;
        case TableViewTypeCustomCancel:
        {
            return @"10";
        }
            break;

        default:
            break;
    }
    return nil;
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
        self.pageCurrent = @"1";
        [self requestOrderListDataWithButton:self.currentButton withPage:self.pageCurrent withResNO:strResNO withRefresh:YES];
    }
}

/**表头*/
- (NSMutableArray *)headerArray
{
    switch (self.type) {
        case TableViewTypeToConfirm:
            
        {
            return [@[kLocalized(@"OrderNumber"),kLocalized(@"AlternateNumber/MobilePhoneNumber"),kLocalized(@"OrderTime"),kLocalized(@"Appointment"),kLocalized(@"DiningType"),kLocalized(@"OrderAmount"),kLocalized(@"Operating")] mutableCopy];
        }
            break;
        case TableViewTypeToEat:
        {
            return [@[kLocalized(@"OrderNumber"),kLocalized(@"AlternateNumber/MobilePhoneNumber"),kLocalized(@"OrderTime"),kLocalized(@"Appointment"),kLocalized(@"OrderAmount"),kLocalized(@"Operating")] mutableCopy];
        }
            break;
            
            
        case TableViewTypeToPay:
            
            return [@[kLocalized(@"OrderNumber"),kLocalized(@"AlternateNumber/MobilePhoneNumber"),kLocalized(@"DiningTime"),kLocalized(@"TableNum/PersonNumber"),kLocalized(@"OrderAmount"),kLocalized(@"Operating")] mutableCopy];
            break;
            
                case TableViewTypePaid:
            
            return [@[kLocalized(@"OrderNumber"),kLocalized(@"AlternateNumber/MobilePhoneNumber"),kLocalized(@"OrderTime"),kLocalized(@"OrderAmount"),kLocalized(@"CheckoutTime")] mutableCopy];
            break;
            
            
        case TableViewTypeToGet:
            return [@[kLocalized(@"OrderNumber"),kLocalized(@"AlternateNumber/MobilePhoneNumber"),kLocalized(@"OrderTime"),kLocalized(@"OrderAmount"),kLocalized(@"Operating")] mutableCopy];
            break;
            
        case TableViewTypeCustomCancel:
            
            return
           [@[kLocalized(@"OrderNumber"),kLocalized(@"AlternateNumber/MobilePhoneNumber"),kLocalized(@"OrderTime"),kLocalized(@"CancelApplicationTime"),kLocalized(@"OrderAmount"),kLocalized(@"Operating")] mutableCopy];
            break;
        case TableViewTypeAll:
            
            return [@[kLocalized(@"OrderNumber"),kLocalized(@"AlternateNumber/MobilePhoneNumber"),kLocalized(@"OrderTime"),kLocalized(@"OrderStatus"),kLocalized(@"OrderAmount"),kLocalized(@"CheckoutTime")] mutableCopy];
            break;
        default:
            break;
    }
    return nil;
}

- (void)chageHeaderName:(NSString *)titleArr withBtn:(UIButton*)btn{
    switch (self.type) {
        case TableViewTypeToConfirm:
            [btn setTitle:[NSString stringWithFormat:kLocalizedAddParams(kLocalized(@"ToBeConfirmed"), @"(%@)"),titleArr] forState:UIControlStateNormal];
            break;
        case TableViewTypeToEat:
            [btn setTitle:[NSString stringWithFormat:kLocalizedAddParams(kLocalized(@"ToBeDining"), @"(%@)"),titleArr] forState:UIControlStateNormal];
            break;
        case TableViewTypeToPay:
            [btn setTitle:[NSString stringWithFormat:kLocalizedAddParams(kLocalized(@"ToBeCheckout"), @"(%@)"),titleArr] forState:UIControlStateNormal];
            break;
        case TableViewTypePaid:
            [btn setTitle:[NSString stringWithFormat:kLocalizedAddParams(kLocalized(@"AlreadyCheckout"), @"(%@)"),titleArr] forState:UIControlStateNormal];
            break;
     
        case TableViewTypeToGet:
            [btn setTitle:[NSString stringWithFormat:kLocalizedAddParams(kLocalized(@"ToBeSelf-created"), @"(%@)"),titleArr] forState:UIControlStateNormal];
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
/**判断开台人数是否正确*/
- (BOOL)isRightUseTableNum:(NSString*)tableNum{
    
    if (tableNum.length == 0) {
        [self notifyWithText:kLocalized(@"Foundingnumberenteredcannotbeempty")];
        return NO;
    }
    if ([tableNum floatValue] > 50) {
        [self notifyWithText:kLocalized(@"FoundingTheNumberMustBeBetween 1-50")];
        return NO;
    }
    if ([tableNum floatValue] == 0 && [Utils checkIsNumber:tableNum]) {
        [self notifyWithText:kLocalized(@"FoundingTheNumberMustBeBetween 1-50")];
        return NO;
    }
    
    if (![Utils checkIsNumber:tableNum]) {
        [self notifyWithText:kLocalized(@"FoundingTheNumberOfIllegalInput")];
        return NO;
    }
    return YES;
}

- (void) hideKeyboard {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (self.type) {
        case TableViewTypeToConfirm:
    
        {
            GYOrderConfirmTableViewCell *cell = [orderTableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
            cell.delegate = self;
           _ordListModel  = _dataArr[indexPath.row];
            cell.model = _ordListModel;
            cell.tableViewType = TableViewTypeToConfirm;
            
            [cell.operateButton setTitle:kLocalized(@"Confirm") forState:UIControlStateNormal];
            if (globalData.currentRole == roleTypeTrusteeshipCompanyWaiter || globalData.currentRole == roleTypeMemberCompanyWaiter||globalData.currentRole == roleTypeTrusteeshipCompanyCashier || globalData.currentRole == roleTypeMemberCompanyCashier ||globalData.currentRole == roleTypeTrusteeshipCompanyDeliveryStaff || globalData.currentRole == roleTypeMemberCompanyDeliveryStaff) {
                cell.operateButton.hidden = YES;
            
            }else{
                cell.operateButton.hidden = NO;
            }
           
            
            return cell;
        }
              break;
        case TableViewTypeToEat:{
            
            GYOrderInToEatViewCell *cell = [orderTableView dequeueReusableCellWithIdentifier:@"cell4" forIndexPath:indexPath];
            _ordListModel  = _dataArr[indexPath.row];
            cell.delegate = self;
            cell.model = _ordListModel;
            if (globalData.currentRole == roleTypeTrusteeshipCompanyWaiter || globalData.currentRole == roleTypeMemberCompanyWaiter||globalData.currentRole == roleTypeTrusteeshipCompanyCashier || globalData.currentRole == roleTypeMemberCompanyCashier ||globalData.currentRole == roleTypeTrusteeshipCompanyDeliveryStaff || globalData.currentRole == roleTypeMemberCompanyDeliveryStaff) {
                cell.cancelBtn.hidden = YES;
                cell.LineView.hidden = YES;
                cell.startBtn.frame = CGRectMake(kScreenWidth - cell.startBtn.frame.size.width - 55 , cell.startBtn.frame.origin.y, cell.startBtn.frame.size.width, cell.startBtn.frame.size.height);
            }else{
                cell.cancelBtn.hidden = NO;
            }

           
            
            return cell;
        }
            break;
            
        case TableViewTypeToPay:
        {
           GYOrderInToPayViewCell *cell = [orderTableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
            cell.delegate =self;
            _ordListModel  = _dataArr[indexPath.row];
            cell.model = _ordListModel;
            if ( globalData.currentRole == roleTypeTrusteeshipCompanyWaiter || globalData.currentRole == roleTypeMemberCompanyWaiter||globalData.currentRole == roleTypeTrusteeshipCompanyDeliveryStaff || globalData.currentRole == roleTypeMemberCompanyDeliveryStaff) {
                cell.payBtn.hidden = YES;
                cell.centerLineView.hidden = YES;
                
                cell.changeBtn.frame = CGRectMake(kScreenWidth - cell.changeBtn.frame.size.width - 45, cell.changeBtn.frame.origin.y, cell.changeBtn.frame.size.width, cell.changeBtn.frame.size.height) ;
            }else{
                cell.payBtn.hidden = NO;
                cell.centerLineView.hidden = NO;
            }
            
            return cell;
        }
            break;
        case TableViewTypePaid:
       
        {  GYOderInPaidCell *cell = [orderTableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            _ordListModel = _dataArr[indexPath.row];
         
            cell.ordIdLabel.text = _ordListModel.orderId;
            cell.useIdLabel.text = _ordListModel.resNo;
            cell.orderStartDatetimeLabel.text = _ordListModel.orderStartDatetime;
          //  cell.orderStatusLabel.text = _ordListModel.orderStatusN;
            cell.orderPayCountLabel.text = _ordListModel.orderPayCount;
            cell.ordFinishTimeLabel.text = _ordListModel.payOrderDate;
            return cell;
        }
            break;
        case TableViewTypeToGet:{
            
            GYOrderTableViewCell *cell = [orderTableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.delegate = self;
            _ordListModel  = _dataArr[indexPath.row];
            cell.model = _ordListModel;
            cell.tableViewType = TableViewTypeToGet;
            if ([_ordListModel.orderStatus isEqualToString:@"2"]) {
                [cell.oprateBtn setTitle:kLocalized(@"Receivables") forState:UIControlStateNormal];
            }else{
                [cell.oprateBtn setTitle:kLocalized(@"Cancel") forState:UIControlStateNormal];
            }
            if ([cell.model.moneyEarnest intValue] > 0 || globalData.currentRole == roleTypeTrusteeshipCompanyWaiter || globalData.currentRole == roleTypeMemberCompanyWaiter ||globalData.currentRole == roleTypeTrusteeshipCompanyDeliveryStaff || globalData.currentRole == roleTypeMemberCompanyDeliveryStaff) {
                cell.oprateBtn.hidden = YES;
                
            }else{
                cell.oprateBtn.hidden = NO;
            }
            
            return cell;
        }
            break;
        case TableViewTypeCustomCancel:{
            
            GYOrderInCancelCell *cell = [orderTableView dequeueReusableCellWithIdentifier:@"CancelCell" forIndexPath:indexPath];
            _ordListModel = _dataArr[indexPath.row];
            cell.canceldelegate=self;
            cell.model=_ordListModel;
            [cell.confirmBtn setTitle:kLocalized(@"Confirm") forState:UIControlStateNormal];
            if (globalData.currentRole == roleTypeTrusteeshipCompanyWaiter || globalData.currentRole == roleTypeMemberCompanyWaiter||globalData.currentRole == roleTypeTrusteeshipCompanyCashier || globalData.currentRole == roleTypeMemberCompanyCashier ) {
                cell.confirmBtn.hidden = YES;
            }else{
                cell.confirmBtn.hidden = NO;
            }
            
            return cell;
        }
            
            break;

        case TableViewTypeAll:
        {
            GYOrderInAllViewCell *cell = [orderTableView dequeueReusableCellWithIdentifier:@"cell5" forIndexPath:indexPath];
            _ordListModel = _dataArr[indexPath.row];
            if (_dataArr.count > 0) {
                self.noDataLabel.hidden = YES;
                cell.orderIdLable.text = _ordListModel.orderId;
                cell.resNoLable.text = _ordListModel.resNo;
                cell.orderStartLable.text = _ordListModel.orderStartDatetime;
                cell.orderStatusLable.text = _ordListModel.orderStatusN;
                cell.orderAcountLable.text = _ordListModel.orderPayCount;
                cell.orderPaymentLable.text = _ordListModel.payOrderDate;
                
                
                return cell;
            }
           
        }
            break;
                default:
            break;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    _headView.backgroundColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1.0];
    float width = (kScreenWidth - 40)/headerArray.count;
    // 选项Label间距
    for (int i=0; i<headerArray.count ; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(width * i +40, 0, width, 50)];
        label.text = headerArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18];
        [_headView addSubview:label];
    }
    
    return _headView;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _ordListModel = _dataArr[indexPath.row];
    if (_dataArr.count > 0) {
        
        if (self.type == TableViewTypeCustomCancel) {
            GYOutCancelViewController *outCancelCtl=[[GYOutCancelViewController alloc] init];
            outCancelCtl.infoDic = @{@"userId":_ordListModel.userId,@"orderId":_ordListModel.orderId};
            [self.navigationController pushViewController:outCancelCtl animated:YES];
        }else if(self.type == TableViewTypeAll){
            
            if ([_ordListModel.orderStatusN isEqualToString:kLocalized(@"CancelUnconfirmed")]) {
                GYOutCancelViewController *outCancelCtl=[[GYOutCancelViewController alloc] init];
                outCancelCtl.infoDic = @{@"userId":_ordListModel.userId,@"orderId":_ordListModel.orderId};
                [self.navigationController pushViewController:outCancelCtl animated:YES];
            }else{
                GYOrderInDetailViewController *orderInDetailVC = [[GYOrderInDetailViewController alloc]init];
                
                GYOrderListModel *listModel = _dataArr[indexPath.row];
                
                orderInDetailVC.infoDic = @{@"userId":listModel.userId,@"orderId":listModel.orderId};
                orderInDetailVC.status = listModel.orderStatusN;
                orderInDetailVC.strType = listModel.orderType;
                [self.navigationController pushViewController:orderInDetailVC animated:YES];
            }
        
        }else{
            GYOrderInDetailViewController *orderInDetailVC = [[GYOrderInDetailViewController alloc]init];
            
            GYOrderListModel *listModel = _dataArr[indexPath.row];
            
            orderInDetailVC.infoDic = @{@"userId":listModel.userId,@"orderId":listModel.orderId};
            orderInDetailVC.status = listModel.orderStatusN;
            orderInDetailVC.strType = listModel.orderType;
            [self.navigationController pushViewController:orderInDetailVC animated:YES];
            
        }
        
    }
}


#pragma mark - TableViewCellDelegate 中按钮代理方法
- (void)operateBtn:(GYOrderListModel*)model withTableViewType:(NSInteger)tableViewType button:(UIButton *)button
{
    [self hideKeyboard];
    @weakify(self);
    //1.待确认
    if (tableViewType == TableViewTypeToConfirm) {
        GYAlertView *alert = [[GYAlertView alloc] initWithTitle:kLocalizedAddParams(kLocalized(@"AreYouSure"), @"?") contentText:nil leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Determine")];
        [alert show];
        alert.rightBlock = ^{
            @strongify(self);
            [self requestOrderInconfirm:model button:button];
        };
    }
  
    //7.待自提
    if (tableViewType == TableViewTypeToGet) {
        if ([model.orderStatus isEqualToString:@"2"]) {
            GYAlertView *alert = [[GYAlertView alloc]initWithTitle:kLocalizedAddParams(kLocalized(@"AreYouSureToSettleAccounts"), @"?") contentText:nil leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Determine")];
            alert.rightBlock = ^(){
                @strongify(self);
                [self requestOrderToGet:model button:button];
            };
            [alert show];
        }else{
            GYAlertView *alert = [[GYAlertView alloc] initWithTitle:kLocalizedAddParams(kLocalized(@"OKCancelit"), @"?") contentText:nil leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Determine")];
            [alert show];
            alert.rightBlock = ^{
                @strongify(self);
                [self requestOrderICustomerCancel:model button:button];
            };
        }
    }
}
#pragma mark - ToPayViewCellDelegate 中按钮代理方法
/**
 *  结账
 */
-(void)payBtn:(GYOrderListModel *)model{
    [self hideKeyboard];
    GYOrderTakeInInvoicingViewController *vc = [[GYOrderTakeInInvoicingViewController alloc] init];
    vc.infoDic = @{@"userId":model.userId,@"orderId":model.orderId};
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 *  修改订单
 */
-(void)changeBtn:(GYOrderListModel *)model{
    [self hideKeyboard];
    GYOrderInDetailViewController *orderInDetailCtl = [[GYOrderInDetailViewController alloc] init];
    orderInDetailCtl.infoDic = @{@"userId":model.userId,@"orderId":model.orderId};
    orderInDetailCtl.status = model.orderStatusN;
    orderInDetailCtl.strType = model.orderType;
    [self.navigationController pushViewController:orderInDetailCtl animated:YES];
}

#pragma mark - ToEatViewCellDelegate 中按钮代理方法
/**
 *  开台
 *  @"tableNo"      桌台号
 *  @"tableNumber"  开台人数
 */
-(void)startBtn:(GYOrderListModel *)model button:(UIButton *)button{
    [self hideKeyboard];
    @weakify(self);
    _alert = [[GYAlertWithFieldView alloc] initWithTitle:kLocalized(@"FoundingOperation") ramadhinTextFieldName:kLocalized(@"NumberOfPeople") numberTextFieldName:kLocalized(@"TableNumber") leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Determine")];
    _alert.ramadhinTextField.delegate = self;
    _alert.numberTextField.delegate = self;
    //tableNo--台号  tableNumber-- 人数
    _alert.rightBlock = ^(NSString *tableNo, NSString *tableNumber){
        @strongify(self);
        if (tableNumber.length > 8) {
            [self notifyWithText:kLocalized(@"DeskSetsNumberCanNotBeMoreThanEightCharacters")];
        }else{
            [self requestOrderInConfirmToUse:tableNumber with:tableNo with:model button:button];
        }
    };
    [_alert show];
    
}

#pragma  mark --- CancelDelegate
/**
 *  取消订单
 *  @"userId"   用户ID
 *  @"orderId"  订单ID
 */
-(void)confirmBtn:(GYOrderListModel *)model button:(UIButton *)sender{
    [self hideKeyboard];
    @weakify(self);
    GYAlertView *alertView=[[GYAlertView alloc] initWithTitle:kLocalized(@"CancelReservationConfirmation") contentText:nil leftButtonTitle:kLocalized(@"Cancel")  rightButtonTitle:kLocalized(@"Determine")];
    alertView.rightBlock=^(){
               GYOrderManagerViewModel *viewModel=[[GYOrderManagerViewModel alloc] init];
        [sender controlTimeOut];
        [self modelRequestNetwork:viewModel :^(id resultDic) {
           @strongify(self);
            if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
                [self notifyWithText:kLocalized(@"SuccessToCancelTheOrderConfirmation")];
                UIButton *button = (UIButton *)[self.view viewWithTag:105];
                [self requestOrderListDataWithButton:button withPage:self.pageCurrent withResNO:self.strResNO withRefresh:YES];
                [orderTableView reloadData];
            }else{
                [self notifyWithText:kLocalized(@"FailureToCancelTheOrderConfirmation")];
            }
        } isIndicator:YES];
                   [viewModel cancelOrderValidateWithUserId:model.userId orderId:model.orderId];
    };
    [alertView show];
    
}
/**
 *  取消预约
 *  @"RefundType"         退款类型
 *  @"CancelReason"       取消理由
 *  @"MoneyEarnsetRefund" 退还定金
 */
-(void)cancelBtn:(GYOrderListModel *)model button:(UIButton *)button{
    [self hideKeyboard];
    @weakify(self);
    if (model.moneyEarnest == nil || [model.moneyEarnest isEqualToString:@"0"] || [model.moneyEarnest isEqualToString:@"0.0"]|| [model.moneyEarnest isEqualToString:@"0.00"]) {
        GYAlertView *alert = [[GYAlertView alloc] initWithTitle:kLocalized(@"AreYouSureToCancelIt") contentText:nil leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Determine")];
        alert.rightBlock = ^{
            @strongify(self);
            [self requestOrdercancelReservationsWithRefundType:@"2" withMoneyEarnsetRefund:@"0.0" withCancelReason:@"" withModel:model button:button];
        };
        [alert show];
    }else{
        _alert = [[GYAlertWithFieldView alloc] initCancelView:model.moneyEarnest];
        _alert.cancelTF.delegate = self;
        _alert.returnBlock = ^(NSString *returnStatusStr, NSString *TFText, NSString *cancelMoney){
            @strongify(self);
            if (TFText.length > 0 && TFText.length < 20) {
                [self requestOrdercancelReservationsWithRefundType:returnStatusStr withMoneyEarnsetRefund:cancelMoney withCancelReason:TFText withModel:model button:button];
            }else if(TFText.length > 20){
                [self notifyWithText:kLocalized(@"ReasonNotToCancelMoreThan 20 Characters!")];
            }else{
            
                [self notifyWithText:kLocalized(@"PleaseEnterCancelReason!")];
            }
            
        };
        [_alert show];
    }
    
    
}
/**
 *  企业取消预定
 *  @"RefundType"         退款类型
 *  @"CancelReason"       取消理由
 *  @"MoneyEarnsetRefund" 退还定金
 */
- (void)requestOrdercancelReservationsWithRefundType:(NSString*)refundType withMoneyEarnsetRefund:(NSString*)moneyEarnsetRefund withCancelReason:(NSString*)tftext withModel:(GYOrderListModel*)model button:(UIButton *)button{
    @weakify(self);
    GYOrderManagerViewModel *netLink = [[GYOrderManagerViewModel alloc] init];
    [button controlTimeOut];
    [self modelRequestNetwork:netLink :^(id resultDic) {
        
        if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
             @strongify(self);
            [self notifyWithText:kLocalized(@"CancelSuccess!")];
            UIButton *button = (UIButton *)[self.view viewWithTag:101
                                            ];
            [self requestOrderListDataWithButton:button withPage:self.pageCurrent withResNO:self.strResNO withRefresh:YES];
        }else{
        [self notifyWithText:kLocalized(@"CancelFailed!")];
        
        }
    } isIndicator:YES];
    
    [netLink cancelReservationswithUserId:model.userId withOrderId:model.orderId withMoneyEarnsetRefund:moneyEarnsetRefund WithRefundType:refundType withCancelReason:tftext ];
}


#pragma mark -  网络请求
/**
 *  请求店内订单列表数据
 */
-(void)requestOrderListDataWithButton:(UIButton *)btn withPage:(NSString*)page withResNO:(NSString*)resNO withRefresh:(BOOL)showLoad{
    if (showLoad) {
        [orderTableView.mj_header endRefreshing];
        [orderTableView.mj_footer endRefreshing];
    }
    @weakify(self);
    NSString *orderTypeStr ;
    if (btn.tag == 104 || btn.tag == 105) {
        orderTypeStr = @"3";
    }else if(btn.tag == 100 || btn.tag == 106 ){
       orderTypeStr = @"1,3";
    }else{
        orderTypeStr = @"1";
    }
    NSString *shopId = kGetNSUser(@"shopId");
    if (shopId.length == 0) {
        [self notifyWithText:kLocalized(@"PleaseSelectTheBusiness")];
        [orderTableView.mj_header endRefreshing];
        return;
    }
    
    NSDictionary *dict ;
    if (resNO == nil) {
        dict = @{@"curPageNo":page,
                 @"orderStatusStr":_ordStatus,
                 @"dateStatus":[NSString stringWithFormat:@"%ld", (long)self.dateStatus],
                 @"orderType":orderTypeStr,
                 @"rows":@"20",
                 @"shopId":kGetNSUser(@"shopId")
                 };
    }else{
        dict = @{@"curPageNo":page,
                 @"orderStatusStr":_ordStatus,
                 @"dateStatus":[NSString stringWithFormat:@"%ld", (long)self.dateStatus],
                 @"orderType":orderTypeStr,
                 @"rows":@"20",
                 @"shopId":kGetNSUser(@"shopId"),
                 @"resNo":resNO
                 };
    }
    self.pageCurrent = page;
    GYOrderManagerViewModel *orderList = [[GYOrderManagerViewModel alloc]init];
    [self modelRequestNetwork:orderList :^(id resultDic) {
        @strongify(self);
        if ([resultDic[@"retCode"] isEqualToNumber:@200]){
            NSMutableArray *orderArr=[[NSMutableArray alloc] init];
            id arr = resultDic[@"data"];
            if ([arr isKindOfClass:[NSNull class]]) {
                [GYGIFHUD dismiss];
            }else if ( [arr isKindOfClass:[NSArray class]]){
                for(NSDictionary *dataDic in resultDic[@"data"]){
                    GYOrderListModel *orderModel=[GYOrderListModel mj_objectWithKeyValues:dataDic];
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
           
            if ([page isEqualToString:@"1"]) {
                [_dataArr removeAllObjects];
                if (orderArr.count > 0) {
                    _dataArr = orderArr;
                   }

                if (resultDic[@"currentPageIndex"] == resultDic[@"totalPage"]) {
                    [orderTableView.mj_footer endRefreshingWithNoMoreData];
                    [orderTableView.mj_header endRefreshing];
                    [orderTableView reloadData];
                }else{
                    [orderTableView.mj_header endRefreshing];
                    [orderTableView.mj_footer resetNoMoreData];
                    [orderTableView reloadData];
                }
            }else{
                [_dataArr addObjectsFromArray:orderArr];
                [orderTableView reloadData];
                //判断加载更多是否达到最大页面
                if (resultDic[@"currentPageIndex"] == resultDic[@"totalPage"]) {
                    [orderTableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [orderTableView.mj_footer endRefreshing];
                }
            }
            self.noDataLabel.hidden = (self.dataArr.count == 0? NO:YES);
            self.noDataImageView.hidden = (self.dataArr.count == 0? NO:YES);
             orderTableView.hidden = !self.noDataLabel.hidden;
            
        }else if([resultDic[@"retCode"] isEqualToNumber:@205]){
            [orderTableView.mj_header endRefreshing];
            [orderTableView.mj_footer endRefreshing];
            [self notifyWithText:kLocalized(@"UsersAbnormalState")];
        }else{
        
            [orderTableView.mj_header endRefreshing];
            [orderTableView.mj_footer endRefreshing];
            [self notifyWithText:kLocalized(@"RefreshFailed")];
        }
    } isIndicator:showLoad];
    [orderList GetOderListWithparams:dict];
}
/**
 *  订单待确认
 *  @"userId"   用户ID
 *  @"orderId"  订单ID
 */
-(void)requestOrderInconfirm:(GYOrderListModel*)model button:(UIButton *)button{
    @weakify(self);
    GYOrderManagerViewModel *netLink = [[GYOrderManagerViewModel alloc] init];
    [button controlTimeOut];
    [self modelRequestNetwork:netLink :^(id resultDic) {
        if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
            @strongify(self);
            [self notifyWithText:kLocalizedAddParams(kLocalized(@"OrdersSuccess"), @"！")];
            UIButton *button = (UIButton *)[self.view viewWithTag:100
                                            ];
            [self requestOrderListDataWithButton:button withPage:self.pageCurrent withResNO:self.strResNO withRefresh:YES];
        }else {
            [self notifyWithText:kLocalizedAddParams(kLocalized(@"OrdersFailure"), @"！")];
        }
        
    } isIndicator:YES];
    
    [netLink acceptOrderWithuserId:model.userId withOrderId:model.orderId withIsAccept:YES];
}
/**
 *  企业确认消费者用餐
 *  @"userId"   用户ID
 *  @"orderId"  订单ID
 *  @"tableNo"      桌台号
 *  @"tableNumber"  开台人数
 */

-(void)requestOrderInConfirmToUse:(NSString *)tableNo with:(NSString*)tableNumber with:(GYOrderListModel*)model button:(UIButton *)sender{
    @weakify(self);
    if (tableNo.length == 0 || tableNumber.length == 0) {
        [self notifyWithText:kLocalized(@"TheNumberOfUnitsOrTheNumberOfOpenTablesCanNotBeEmpty")];
        return;
    }
    
    if ([tableNumber integerValue] < 1) {
        [self notifyWithText:kLocalized(@"Thenumberofpeopleeatingatleast1")];
        return;
    }
    
    if (![self isRightUseTableNum:tableNumber]) {
        return;
    }
   
    GYOrderManagerViewModel *ordConfirm = [[GYOrderManagerViewModel alloc]init];
    [sender controlTimeOut];
    [self modelRequestNetwork:ordConfirm :^(id resultDic) {
        
        if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
            @strongify(self);
            [self notifyWithText:kLocalized(@"SuccessfulOperation!")];
            UIButton *button = (UIButton *)[self.view viewWithTag:101];
            [self requestOrderListDataWithButton:button withPage:self.pageCurrent withResNO:self.strResNO withRefresh:YES];
        }else {
            
            [self notifyWithText:kLocalized(@"OperationFailed!")];
            
        }
    //    _dataArr = resultDic;
    } isIndicator:YES];
    
    [ordConfirm orderInConfirmWithUseId:model.userId ordId:model.orderId tableNo:tableNo tableNumber:tableNumber];
}
/**
 *  待自提请求网络
 *  @"userId"     用户ID
 *  @"orderId"    订单ID
 *  @"orderType"  "1":"堂食";"2":"外卖","3":"堂食"
 */
-(void)requestOrderToGet:(GYOrderListModel*)model button:(UIButton *)sender{
    @weakify(self);
    GYOrderManagerViewModel *netLink = [[GYOrderManagerViewModel alloc] init];
    [sender controlTimeOut];
    [self modelRequestNetwork:netLink :^(id resultDic) {
        @strongify(self);
        if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
            
            [self notifyWithText:kLocalized(@"ReceivablesSuccess")];
            UIButton *button = (UIButton *)[self.view viewWithTag:104];
            [self requestOrderListDataWithButton:button withPage:self.pageCurrent withResNO:self.strResNO withRefresh:YES];
        }else{
            [self notifyWithText:kLocalized(@"ReceivablesFailure")];
        }
    } isIndicator:YES ] ;
    [netLink toGetWithOrderId:model.orderId userId:model.userId orderType:@"3"];
}
/**
 *  消费者取消订单接口
 *  @"userId"  用户ID
 *  @"orderId" 订单ID
 */
-(void)requestOrderICustomerCancel:(GYOrderListModel*)model button:(UIButton *)sender{
    @weakify(self);
    GYOrderManagerViewModel *netLink = [[GYOrderManagerViewModel alloc] init];
    [sender controlTimeOut];
    [self modelRequestNetwork:netLink :^(id resultDic) {
        @strongify(self);
        if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
            
            [self notifyWithText:kLocalized(@"CancelSuccess!")];
            UIButton *button = (UIButton *)[self.view viewWithTag:101
                                            ];
            [self requestOrderListDataWithButton:button withPage:self.pageCurrent withResNO:self.strResNO withRefresh:YES];
        }else{
            [self notifyWithText:kLocalized(@"CancelFailed!")];
        }
        
    } isIndicator:YES];
    [netLink cancelOrderValidateWithUserId:model.userId orderId:model.orderId];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == _alert.ramadhinTextField) {
        if ([toBeString intValue] > 50) {
            textField.text = @"50";
            [textField resignFirstResponder];
            kNotice(kLocalized(@"FoundingTheNumberMustBeBetween 1-50"));
        }else{
            return YES;
        }
    }
    
        if (textField == _alert.numberTextField) {
            if (toBeString.length > 8) {
               [textField resignFirstResponder];
            }else{
                return YES;
            }
        }
    
        if (textField == _alert.cancelTF) {
            if (toBeString.length > 20) {
                [textField resignFirstResponder];
                
            }else{
                return YES;
            }
        }
    
    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _alert.numberTextField) {
        if (textField.text.length > 8 ) {
            [self notifyWithText:kLocalized(@"DeskSetsNumberCanNotBeMoreThanEightCharacters")];
            textField.text = [textField.text substringToIndex:8];
        }
    }else if (textField == _alert.cancelTF){
        if (textField.text.length > 20 ) {
            [self notifyWithText:kLocalized(@"ReasonNotToCancelMoreThan 20 Characters!")];
            textField.text = [textField.text substringToIndex:20];
        }
    }

}

@end
