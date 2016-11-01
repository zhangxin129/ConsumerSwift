//
//  GYOrderTakeOutDetailViewController.m
//  GYRestaurant
//
//  Created by ios007 on 15/10/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOrderTakeOutDetailViewController.h"
#import "GYOdrOutDetailCell.h"
#import "GYOrderManagerViewModel.h"
#import "GYOrdDetailModel.h"
#import "FoodListInModel.h"
#import "GYFoodPicUrlModel.h"
#import "GYSelectPostModel.h"
#import "GYPostDataModel.h"
#import "GYTabAlertView.h"
#import "GYAlertView.h"
#import "GYOrderTakeOutViewController.h"
#import "GYSelectedButton.h"
#import "GYHEFoodTitleViewController.h"
#import "NSString+GYJSONObject.h"


@interface GYOrderTakeOutDetailViewController ()<UITableViewDelegate,UITableViewDataSource,GYHEFoodTitleViewControllerDelegate>{
    
    UITableView *_orderDetailTableView;
    UIView *_headView;
    NSArray *_headArray;
}
//用户名
@property (nonatomic, strong) UILabel *detailUseIdLabel;
//订单号
@property (nonatomic, strong) UILabel *ordIdLabel;
//下单时间
@property (nonatomic, strong) UILabel *ordStartTimeLabel;
//订单类型
@property (nonatomic, strong) UILabel *ordTypeLabel;
//订单状态
@property (nonatomic, strong) UILabel *ordStatusLabel;
//联系人
@property (nonatomic, strong) UILabel *nameLable;
//联系电话
@property (nonatomic, strong) UILabel *phoneLable;
//地址
@property (nonatomic, strong) UILabel *addressLable;
//送达时间
@property (nonatomic, strong) UILabel *arriveTimeLable;
//定金数
@property (nonatomic, strong) UILabel *paymentLabel;

//备注内容
@property (nonatomic, strong) UILabel *remarkLabel;
//数量
@property (nonatomic, strong) UILabel *countLable;
//总额
@property (nonatomic ,strong) UILabel *totalPayLable;
//积分
@property (nonatomic ,strong) UILabel *pointLable;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSMutableArray *foodListArr;

@property (nonatomic, strong) NSMutableArray *picUrlArr;

@property (nonatomic, strong) NSMutableArray *postDataArr;

@property (nonatomic, strong) NSMutableArray *postNameArr;

@property (nonatomic, strong) NSMutableArray *postIdArr;

@property (nonatomic, strong) NSMutableArray *postContactArr;

@property (nonatomic, strong) GYPostDataModel *model;

//@property (nonatomic, strong) GYSelectedButton *selectPostBtn;

@property (nonatomic, strong) GYSelectedButton *selectPostBtn;

//@property (nonatomic, strong) NSString *postStr;
@property (nonatomic, strong) UILabel *remarLable;

@end


@implementation GYOrderTakeOutDetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
    
        _orderDetailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 150, kScreenWidth, kScreenHeight-150-64)];
        _headArray = @[kLocalized(@"DishesInformation"),kLocalized(@"Specification"),kLocalized(@"UnitPrice"),kLocalized(@"Quantity"),kLocalized(@"Money"),kLocalized(@"Integration")];
        
        _orderDetailTableView.delegate = self;
        _orderDetailTableView.dataSource = self;
        _orderDetailTableView.rowHeight = 100;
        _orderDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_orderDetailTableView registerNib:[UINib nibWithNibName:@"GYOdrOutDetailCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    }
    return self;
}
#pragma mark - 懒加载
- (NSMutableArray *)postDataArr
{
    if (_postDataArr ==  nil) {
        _postDataArr = [NSMutableArray array];
    }
    return _postDataArr;
}

- (NSMutableArray *)postNameArr{
    if (!_postNameArr) {
        _postNameArr = [NSMutableArray array];
    }
    return _postNameArr;

}
-(NSMutableArray *)postIdArr{
    if (!_postIdArr) {
        _postIdArr = [[NSMutableArray alloc] init];
    }
    return _postIdArr;

}
- (NSMutableArray *)postContactArr{
    if (!_postContactArr) {
        _postContactArr = [[NSMutableArray alloc] init];
    }

    return _postContactArr;
}
#pragma mark - 继承系统
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_orderDetailTableView];
    [self creatUI];
    [self RequestOderDetailData];
}

#pragma mark-创建视图
-(void)creatUI{

    self.navigationItem.leftBarButtonItem = [Utils createBackButtonWithTitle:kLocalized(@"Orderdetails") withTarget:self withAction:@selector(popBack)];
    
    //详情视图
    UIView *ordDetailView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    //    ordDetailView.backgroundColor = kBlueFontColor;
    [self.view addSubview:ordDetailView];
    //红色分割线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 2)];
    line.backgroundColor = kRedFontColor;
    [self.view addSubview:line];
    //表头底图
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 2, kScreenWidth, 50)];
    titleView.backgroundColor = [UIColor colorWithRed:207/255.0 green:234/255.0 blue:254/255.0 alpha:1.0];
    [self.view addSubview:titleView];
    float x = (kScreenWidth - 120 - 120 - 60 - 180 - 80 - 140 - 40 - 40 - 40 - 120)/6;
    //订单详情表头内容
    UILabel *detailUseTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, 5, 120, 40)];
    detailUseTitleLabel.text = kLocalized(@"Alternatenumber/phonenumber");
    [titleView addSubview:detailUseTitleLabel];
    _detailUseIdLabel = [[UILabel alloc]initWithFrame:CGRectMake(120 + x, 5, 120, 40)];
    [titleView addSubview:_detailUseIdLabel];
    UILabel *ordIdTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(240 + 2*x, 5, 60, 40)];
    ordIdTitleLabel.text = kLocalized(@"ordernumber");
    [titleView addSubview:ordIdTitleLabel];
    _ordIdLabel = [[UILabel alloc]initWithFrame:CGRectMake(300 + 2 * x, 5, 180, 40)];
    _ordIdLabel.adjustsFontSizeToFitWidth = YES;
    [titleView addSubview:_ordIdLabel];
    
    UILabel *ordStartTimeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(480 + 3*x, 5, 80, 40)];
    ordStartTimeTitleLabel.text = kLocalizedAddParams(kLocalized(@"OrderTime"), @":");
    [titleView addSubview:ordStartTimeTitleLabel];
    
    _ordStartTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(560 + 3*x, 5, 150, 40)];
    [titleView addSubview:_ordStartTimeLabel];
    
    UILabel *ordTypeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(700 + 4*x, 5, 40, 40)];
    ordTypeTitleLabel.text = kLocalizedAddParams(kLocalized(@"Types"), @":");
    [titleView addSubview:ordTypeTitleLabel];
    
    _ordTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(740 + 4*x, 5, 40, 40)];
    _ordTypeLabel.text = kLocalized(@"Store");
    [titleView addSubview:_ordTypeLabel];
    
    UILabel *ordStatusTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(780 + 5*x, 5, 40, 40)];
    ordStatusTitleLabel.text = kLocalizedAddParams(kLocalized(@"Status"), @":");
    [titleView addSubview:ordStatusTitleLabel];
    
    _ordStatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(820 + 5*x, 5, 120, 40)];
    _ordStatusLabel.textColor = kRedFontColor;
    [titleView addSubview:_ordStatusLabel];

    
    
//    UILabel *dinersTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 70, 30)];
//    dinersTitleLabel.text = kLocalizedAddParams(kLocalized(@"Contacts"), @":");
//    [ordDetailView addSubview:dinersTitleLabel];
//    //联系人
//    _nameLable=[[UILabel alloc]initWithFrame:CGRectMake(80, 50, 80, 30)];
//    _nameLable.text=@"小明";
//    [ordDetailView addSubview:_nameLable];
    
    //联系电话
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 90, 30)];
    numberLabel.text = kLocalizedAddParams(kLocalized(@"contactNumber"), @":");
    [ordDetailView addSubview:numberLabel];
    
    _phoneLable = [[UILabel alloc]initWithFrame:CGRectMake(100, 50, 120, 30)];
    _phoneLable.text = @"13800138000";
    
    [ordDetailView addSubview:_phoneLable];
    
    //地址
    UILabel *addLabel = [[UILabel alloc]initWithFrame:CGRectMake(270, 50, 50, 30)];
    addLabel.text = kLocalizedAddParams(kLocalized(@"Address"), @":");
    [ordDetailView addSubview:addLabel];
    
    _addressLable = [[UILabel alloc]initWithFrame:CGRectMake(320, 50, kScreenWidth - 320, 30)];
   // _addressLable.text = @"深圳市南山区学府路百度国际大厦205";
    [ordDetailView addSubview:_addressLable];
    
    
    //送达时间
    UILabel *arTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 100, 30)];
    arTimeLabel.text = kLocalizedAddParams(kLocalized(@"ArrivalsTime"), @":");
    [ordDetailView addSubview:arTimeLabel];
    
    _arriveTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(110, 80, 180, 30)];
    _arriveTimeLable.text = @"2015-09-10 15:30:18";
    [_arriveTimeLable setNumberOfLines:0];
    [ordDetailView addSubview:_arriveTimeLable];
    
    //配送费
    UILabel *payLabel = [[UILabel alloc]initWithFrame:CGRectMake(270, 80, 70, 30)];
    payLabel.text = kLocalizedAddParams(kLocalized(@"Shipment"), @":");
    [ordDetailView addSubview:payLabel];
    
    UIImageView *coView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coin"]];
    coView.frame=CGRectMake(340, 85, 20, 20);
    [ordDetailView addSubview:coView];
    
    _paymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(360, 80, 120, 30)];
    _paymentLabel.text = @"0.00";
    _paymentLabel.textColor=kRedFontColor;
    [_paymentLabel setNumberOfLines:0];
    [ordDetailView addSubview:_paymentLabel];
    
    //配送优惠
    UILabel *reLabel = [[UILabel alloc]initWithFrame:CGRectMake(480, 80, 80, 30)];
    reLabel.text = kLocalizedAddParams(kLocalized(@"DistributionDeals"), @":");
    [ordDetailView addSubview:reLabel];
    
    _remarLable = [[UILabel alloc]initWithFrame:CGRectMake(560, 80, 400, 30)];
    _remarLable.text = @"1000.00";
    //    paymentLabel.backgroundColor = [UIColor purpleColor];
    [ordDetailView addSubview:_remarLable];
    
    //备注
    UILabel *remLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 110, 50, 30)];
    remLabel.text = kLocalizedAddParams(kLocalized(@"Remark"), @":");
    [ordDetailView addSubview:remLabel];
    
    _remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 110, 400, 30)];
   // _remarkLabel.text = @"少辣，准备一个儿童凳子";
    //    paymentLabel.backgroundColor = [UIColor purpleColor];
    [ordDetailView addSubview:_remarkLabel];

    //下边视图
    UIView *downView = [[UIView alloc]init];
    [self.view addSubview:downView];
    downView.backgroundColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1.0];
    @weakify(self);
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@49);
        make.width.equalTo(self.view.mas_width);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    //底栏分割线
    UIView *bottomLine  = [[UIView alloc]init];
    bottomLine.backgroundColor = [UIColor colorWithRed:139/255.0 green:141/255.0 blue:142/255.0 alpha:1.0];
    
    bottomLine.frame = CGRectMake(0, kScreenHeight-50-64, kScreenWidth, 1);
    [self.view addSubview:bottomLine];
    
    //数量：
    UILabel *numberTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 75, 40)];
    numberTitleLabel.text = kLocalizedAddParams(kLocalized(@"Quantity"), @":");
    numberTitleLabel.font = [UIFont systemFontOfSize:25];
    [downView addSubview:numberTitleLabel];
    
    //数量数
    _countLable= [[UILabel alloc]initWithFrame:CGRectMake(96, 5, 50, 40)];
    _countLable.text =@"5";
    _countLable.textColor = kRedFontColor;
    _countLable.font = [UIFont systemFontOfSize:25];
    [downView addSubview:_countLable];
    
    //总额
    UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 5, 75, 40)];
    totalLabel.text = kLocalizedAddParams(kLocalized(@"Total"), @":");
    totalLabel.font = [UIFont systemFontOfSize:25];
    [downView addSubview:totalLabel];
    
    UIImageView *coinView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coin"]];
    coinView.frame=CGRectMake(225, 15, 20, 20);
    [downView addSubview:coinView];
    
    //总额数
    _totalPayLable = [[UILabel alloc] initWithFrame:CGRectMake(245, 5, 100, 40)];
    _totalPayLable.text =@"5";
    _totalPayLable.textColor = kRedFontColor;
    _totalPayLable.font =[UIFont systemFontOfSize:25];
    [downView addSubview:_totalPayLable];
    
    //积分
    UILabel *integralLabel = [[UILabel alloc]initWithFrame:CGRectMake(350, 5, 60, 40)];
    integralLabel.text = kLocalizedAddParams(kLocalized(@"Integration"), @":");
    integralLabel.font =[UIFont systemFontOfSize:25];
    [downView addSubview:integralLabel];
    
    //积分背景图
    UIImageView *integralImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PV"]];
    integralImageView.frame = CGRectMake(410, 15, 20, 20);
    [downView addSubview:integralImageView];
    
    //积分数
    _pointLable = [[UILabel alloc]initWithFrame:CGRectMake(430, 5, 100, 40)];
    _pointLable.text = @"18.00";;
    _pointLable.textColor = kBlueFontColor;
    _pointLable.font = [UIFont systemFontOfSize:25];
    [downView addSubview:_pointLable];
    
    //送餐员按钮
    _selectPostBtn = [[GYSelectedButton alloc]init];
    _selectPostBtn.frame = CGRectMake(590, 5, 140, 40);
    [_selectPostBtn setBackgroundImage:[UIImage imageNamed:@"blueBox"] forState:UIControlStateNormal];
    [_selectPostBtn addTarget:self action:@selector(showTabAlert) forControlEvents:UIControlEventTouchUpInside];
    _selectPostBtn.tag = 100;
    [_selectPostBtn setTitle:kLocalized(@"DeliveryStaff") forState:UIControlStateNormal];
    [_selectPostBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [downView addSubview:_selectPostBtn];
    
    //送餐按钮
    UIButton *SendDishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    SendDishBtn.frame = CGRectMake(780, 5, 100, 40);
    SendDishBtn.backgroundColor = kRedFontColor;
    [SendDishBtn.layer setCornerRadius:15.0];
    [SendDishBtn setTitle:kLocalized(@"Delivery") forState:UIControlStateNormal];
    [SendDishBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    SendDishBtn.titleLabel.textColor = kBlueFontColor;
    SendDishBtn.titleLabel.font = [UIFont systemFontOfSize:25];
    [downView addSubview:SendDishBtn];
    
}
#pragma mark - 按钮的触发事件
-(void)btnClick:(UIButton *)sender{
    @weakify(self);
        if (_model.deliverName.length > 0) {
        
        __block UIButton *dBtn = sender;
        GYAlertView *alertView=[[GYAlertView alloc] initWithTitle:kLocalizedAddParams(kLocalized(@"AreYouSureToDelivery"), @"?") contentText:nil leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Confirm")];
        alertView.rightBlock=^(){
            
            GYOrderManagerViewModel *viewModel=[[GYOrderManagerViewModel alloc] init];
                if (!kGetNSUser(@"shopId")) {
                return ;
            }
            [dBtn controlTimeOut];
            [self modelRequestNetwork:viewModel :^(id resultDic) {
                @strongify(self);
                DDLogCInfo(kLocalized(@"DeliverySuccess"));
                if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
                    [self notifyWithText:kLocalized(@"DeliverySuccess")];
                    // [NSThread sleepForTimeInterval:10.0];
                    
                    [self performSelector:@selector(popBack) withObject:nil afterDelay:1.5];
                }else{
                
                [self notifyWithText:kLocalized(@"DeliveryFailure")];
                }
            } isIndicator:YES];
            [viewModel postOrderWithkey:globalData.loginModel.token userId:_infoDic[@"userId"] orderId:_infoDic[@"orderId"] shopId:kGetNSUser(@"shopId") expressID:_model.deliveryId deliverName:_model.deliverName deliverContact:_model.deliverContact];
            
        };
        [alertView show];

    }else{
     [self notifyWithText:kLocalized(@"PleaseSelectDelivery")];
    
    }
}
- (void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  选择送餐员
 */
-(void)showTabAlert{
    [self httpGetdeliverQuery];
}

#pragma mark-TableViewDelegate && UITableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYOdrOutDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    FoodListInModel *md = _foodListArr[indexPath.row];
    cell.foodNameLable.text = md.foodName;
    cell.foodPriceLable.text = md.foodPrice;
    cell.foodNumLable.text = md.foodNum;
//    cell.pointLable.text = md.foodPv;
//    cell.totalPayLable.text = [NSString stringWithFormat:@"%.2f",[md.foodPrice floatValue] * [md.foodNum floatValue]];
    cell.pointLable.text = [NSString stringWithFormat:@"%0.2f",[md.foodPv floatValue] * [md.foodNum floatValue]];
    cell.totalPayLable.text = [NSString stringWithFormat:@"%0.2f",[md.foodPrice floatValue] * [md.foodNum floatValue] ];
   
    if (md.picUrl.length > 0) {
        NSData *data = [md.picUrl dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSDictionary *dic = arr.firstObject;
        
        NSString *url = [NSString stringWithFormat:@"%@%@",picHttpUrl,dic[@"name"]];
        NSString *picNameStr = [dic[@"name"] substringToIndex:4];
        if ([picNameStr isEqualToString:@"null"]) {
            [cell.headImageView setImage:[UIImage imageNamed:@"dafauftPicture"]];
        }else{
            [cell.headImageView setImageWithURL:[NSURL URLWithString:url] placeholder:nil options:kNilOptions completion:nil];
        }

    }else {
        [cell.headImageView setImage:[UIImage imageNamed:@"dafauftPicture"]];
        
    }
    if (md.foodSpec.pVName.length > 0) {
        cell.foodLableLable.text =  md.foodSpec.pVName ;
    }else{
        cell.foodLableLable.text = @"";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
 
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _foodListArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    
    _headView.backgroundColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1.0];
    
    // 选项Label间距
    int x = (kScreenWidth-120*_headArray.count)/(_headArray.count+1);
    
    
    for (int i=0; i<_headArray.count ; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20+120*i+x*(i+1), 0, 120, 50)];
        label.text = _headArray[i];
        label.font = [UIFont systemFontOfSize:18];
        [_headView addSubview:label];
    }
    
    return _headView;
}

#pragma mark - 网络请求
-(void)RequestOderDetailData{
    GYOrderManagerViewModel *orderListDetail = [[GYOrderManagerViewModel alloc]init];
    __weak typeof(self) weakSelf = self;
    [self modelRequestNetwork:orderListDetail :^(id resultDic) {
        
        _dataArr = resultDic;
        GYOrdDetailModel *mdoel = _dataArr[0];
        _foodListArr = mdoel.foodList;
//        FoodListInModel *model = _foodListArr[0];
//        _picUrlArr = model.picUrl;
        
        [weakSelf refreshUI];
        [_orderDetailTableView reloadData];
    }isIndicator:YES];
       [orderListDetail GetOrderDetailWithUserIdId:_infoDic[@"userId"] orderId:_infoDic[@"orderId"]];
    
}
/**
 *  查询送餐员
 */
- (void)httpGetdeliverQuery{
    @weakify(self);
    GYOrderManagerViewModel *viewModel = [[GYOrderManagerViewModel alloc]init];
    
    [_postNameArr removeAllObjects];
    _model = [[GYPostDataModel alloc] init];
    [self modelRequestNetwork:viewModel :^(id resultDic) {
        @strongify(self);
        for (GYPostDataModel * model in resultDic) {
            
            
            [self.postNameArr addObject:model.deliverName];
            [self.postIdArr addObject:model.deliveryId];
            [self.postContactArr addObject:model.deliverContact];
        }
        
        _postDataArr = resultDic;
        
        GYHEFoodTitleViewController * foodCtl = [[GYHEFoodTitleViewController alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_selectPostBtn.frame),
                                                                                                             kScreenHeight - self.postDataArr.count * 30 - 100 ,250, self.postDataArr.count * 30) titleArray:self.postNameArr heardTitle:kLocalized(@"SelectDeliveryStaff") select:YES];
        foodCtl.delegate = self;
        [self addChildViewController:foodCtl];
        [self.view addSubview:foodCtl.view];
        UIWindow * win = [UIApplication sharedApplication].keyWindow;
        [win addSubview:foodCtl.view];
        
        
    } isIndicator:YES];
    
    
    [viewModel getDeliverList];
    
}
#pragma mark - 数据源
//刷新视图详情
- (void)refreshUI
{
    GYOrdDetailModel *detailModel = [GYOrdDetailModel new];
    detailModel = _dataArr[0];
    
    _foodListArr=detailModel.foodList;
    
    _detailUseIdLabel.text = detailModel.resNo;
    _ordIdLabel.text=_infoDic[@"orderId"];
    
    _ordStartTimeLabel.text = detailModel.orderStartTime;
    _ordTypeLabel.text = detailModel.orderType;
    _ordStatusLabel.text = detailModel.orderStatus;
    
    _nameLable.text = detailModel.contactPerson;
    _phoneLable.text=detailModel.contactPhone;
    _addressLable.text=detailModel.contactAddress;
    _arriveTimeLable.text=detailModel.arriveTime;
    _paymentLabel.text = detailModel.deliverFee;
    
    _remarkLabel.text = detailModel.orderRemark;
    
    _countLable.text = detailModel.totalFoodNum;
    _totalPayLable.text = detailModel.amountActually;
    _pointLable.text = detailModel.totalPv;
    
    NSDictionary *deliDiscountDict =[detailModel.deliDiscount dictionaryValue];
    if ( [deliDiscountDict[@"manPirce"] length] > 0 && [deliDiscountDict[@"jianPrice"] length] > 0) {
        
        _remarLable.text = [NSString stringWithFormat:@"订单满%@减%@元",deliDiscountDict[@"manPirce"],deliDiscountDict[@"jianPrice"]];
    }else{
        _remarLable.text = kLocalized(@"NoDistributionDeals");
    }
}

#pragma GYHEFoodTitleViewControllerDelegate
- (void)foodTitleViewController: (GYHEFoodTitleViewController *) titleVc didSelectedIndex:(int) index
{
    [_selectPostBtn setTitle:self.postNameArr[index] forState:UIControlStateNormal];
    _model.deliverName = _selectPostBtn.titleLabel.text;
    _model.deliveryId = self.postIdArr[index];
    _model.deliverContact = self.postContactArr[index];
}
@end
