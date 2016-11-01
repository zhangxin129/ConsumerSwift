//
//  GYOutCancelViewController.m
//  GYRestaurant
//
//  Created by apple on 15/11/3.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOutCancelViewController.h"
#import "GYOdrOutDetailCell.h"
#import "GYOrderManagerViewModel.h"
#import "GYOrdDetailModel.h"
#import "FoodListInModel.h"
#import "GYFoodPicUrlModel.h"
#import "GYOutOrderPayViewController.h"
#import "GYOrderTakeOutModel.h"
#import "GYAlertView.h"
#import "NSString+GYJSONObject.h"


@interface GYOutCancelViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
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

@property (nonatomic, strong) UILabel *remarLable;
//联系人标题
@property (nonatomic, strong) UILabel *dinersTitleLabel;
//联系电话标题
@property (nonatomic, strong) UILabel *numberLabel;
//地址标题
@property (nonatomic, strong) UILabel *addLabel;
//送达时间标题
@property (nonatomic, strong) UILabel *arTimeLabel;
//配送费标题
@property (nonatomic, strong) UILabel *payLabel;
//互生币图像
@property (nonatomic, strong) UIImageView *coView;
//配送优惠标题
@property (nonatomic, strong) UILabel *reLabel;
@property (nonatomic, strong) UILabel *remLabel;

@end

@implementation GYOutCancelViewController

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
    
    _ordStartTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(560 + 3*x, 5, 140, 40)];
    [titleView addSubview:_ordStartTimeLabel];
    
    UILabel *ordTypeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(700 + 4*x, 5, 40, 40)];
    ordTypeTitleLabel.text = kLocalizedAddParams(kLocalized(@"Types"), @":");
    [titleView addSubview:ordTypeTitleLabel];
    
    _ordTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(740 + 4*x, 5, 40, 40)];
   // _ordTypeLabel.text = @"店内";
    [titleView addSubview:_ordTypeLabel];
    
    UILabel *ordStatusTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(780 + 5*x, 5, 40, 40)];
    ordStatusTitleLabel.text = kLocalizedAddParams(kLocalized(@"Status"), @":");
    [titleView addSubview:ordStatusTitleLabel];
    
    _ordStatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(820 + 5*x, 5, 120, 40)];
    _ordStatusLabel.textColor = kRedFontColor;
    [titleView addSubview:_ordStatusLabel];


    
//    _dinersTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 70, 30)];
//    _dinersTitleLabel.text = kLocalizedAddParams(kLocalized(@"Contacts"), @":");
//    [ordDetailView addSubview:_dinersTitleLabel];
//    //联系人
//    _nameLable=[[UILabel alloc]initWithFrame:CGRectMake(80, 50, 80, 30)];
//    _nameLable.text=@"小明";
//    [ordDetailView addSubview:_nameLable];
    
    //联系电话
    _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 90, 30)];
    _numberLabel.text = kLocalizedAddParams(kLocalized(@"contactNumber"), @":");
    [ordDetailView addSubview:_numberLabel];
    
    _phoneLable = [[UILabel alloc]initWithFrame:CGRectMake(100, 50, 120, 30)];
    _phoneLable.text = @"13800138000";
    
    [ordDetailView addSubview:_phoneLable];
    
    //地址
    _addLabel = [[UILabel alloc]initWithFrame:CGRectMake(270, 50, 50, 30)];
    _addLabel.text = kLocalizedAddParams(kLocalized(@"Address"), @":");
    [ordDetailView addSubview:_addLabel];
    
    _addressLable = [[UILabel alloc]initWithFrame:CGRectMake(320, 50, kScreenWidth - 320, 30)];
   // _addressLable.text = @"深圳市南山区学府路百度国际大厦205";
    //    paymentLabel.backgroundColor = [UIColor purpleColor];
    [ordDetailView addSubview:_addressLable];
    
    
    //送达时间
    _arTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 100, 30)];
    _arTimeLabel.text = kLocalizedAddParams(kLocalized(@"ArrivalsTime"), @":");
    [ordDetailView addSubview:_arTimeLabel];
    
    _arriveTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(110, 80, 180, 30)];
    _arriveTimeLable.text = @"2015-09-10 15:30:18";
    [_arriveTimeLable setNumberOfLines:0];
    [ordDetailView addSubview:_arriveTimeLable];
    
    //配送费
    _payLabel = [[UILabel alloc]initWithFrame:CGRectMake(270, 80, 70, 30)];
    _payLabel.text = kLocalizedAddParams(kLocalized(@"Shipment"), @":");
    [ordDetailView addSubview:_payLabel];
   
    _coView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coin"]];
    _coView.frame=CGRectMake(340, 85, 20, 20);
    [ordDetailView addSubview:_coView];
    
    _paymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(360, 80, 120, 30)];
    _paymentLabel.text = @"0.00";
    _paymentLabel.textColor=kRedFontColor;
    [_paymentLabel setNumberOfLines:0];
    [ordDetailView addSubview:_paymentLabel];
    
    //配送优惠
    _reLabel = [[UILabel alloc]initWithFrame:CGRectMake(480, 80, 80, 30)];
    _reLabel.text = kLocalizedAddParams(kLocalized(@"DistributionDeals"), @":");
    [ordDetailView addSubview:_reLabel];
    
    _remarLable = [[UILabel alloc]initWithFrame:CGRectMake(560, 80, 400, 30)];
    _remarLable.text = @"1000.00";
    //    paymentLabel.backgroundColor = [UIColor purpleColor];
    [ordDetailView addSubview:_remarLable];
    
    //备注
    _remLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 110, 50, 30)];
    _remLabel.text = kLocalizedAddParams(kLocalized(@"Remark"), @":");
    [ordDetailView addSubview:_remLabel];
    
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
    
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(550, 5, 100, 40);
    sureBtn.backgroundColor = kRedFontColor;
    [sureBtn.layer setCornerRadius:15.0];
    [sureBtn setTitle:kLocalized(@"Confirm") forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.titleLabel.textColor = kBlueFontColor;
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:25];
    [downView addSubview:sureBtn];
    
    if (globalData.currentRole == roleTypeTrusteeshipCompanyWaiter || globalData.currentRole == roleTypeMemberCompanyWaiter ||
        globalData.currentRole == roleTypeTrusteeshipCompanyDeliveryStaff || globalData.currentRole == roleTypeMemberCompanyDeliveryStaff|| globalData.currentRole == roleTypeTrusteeshipCompanyCashier || globalData.currentRole == roleTypeMemberCompanyCashier) {
        sureBtn.hidden = YES;
    }else{
        sureBtn.hidden = NO;
    }
    
}

#pragma mark - 按钮的触发事件

-(void)cancel:(UIButton *)sender{
    __block UIButton *dBtn = sender;

    GYAlertView *alertView=[[GYAlertView alloc] initWithTitle:kLocalized(@"CancelReservationConfirmation") contentText:nil leftButtonTitle:kLocalized(@"Cancel")  rightButtonTitle:kLocalized(@"Determine")];
    
           
        alertView.rightBlock=^(){
            
            GYOrderManagerViewModel *viewModel=[[GYOrderManagerViewModel alloc] init];
            [dBtn controlTimeOut];
            [self modelRequestNetwork:viewModel :^(id resultDic) {
                
              //  DDLogCInfo(@"确认取消成功");
                if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
                    [self notifyWithText:kLocalized(@"SuccessToCancelTheOrderConfirmation")];
                     [self performSelector:@selector(popBack) withObject:nil afterDelay:1.5f];
                }else{
                    [self notifyWithText:kLocalized(@"FailureToCancelTheOrderConfirmation")];
                }

            } isIndicator:YES];
            [viewModel cancelOrderValidateWithUserId:_infoDic[@"userId"] orderId:_infoDic[@"orderId"]];
        };
      
    [alertView show];
    
    
}
- (void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-TableViewDelegate && UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYOdrOutDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    FoodListInModel *md = _foodListArr[indexPath.row];
    cell.foodNameLable.text = md.foodName;
    cell.foodPriceLable.text = md.foodPrice;
    cell.foodNumLable.text = md.foodNum;
//    cell.pointLable.text = md.foodPv;
//    cell.totalPayLable.text = [NSString stringWithFormat:@"%ld",[md.foodPrice integerValue] * [md.foodNum integerValue] ];
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
        cell.foodLableLable.text = md.foodSpec.pVName;
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
/**
 *  请求订单详情数据
 */
-(void)RequestOderDetailData{
    
    @weakify(self);
    GYOrderManagerViewModel *orderListDetail = [[GYOrderManagerViewModel alloc]init];
    [self modelRequestNetwork:orderListDetail :^(id resultDic) {
        @strongify(self);
        _dataArr = resultDic;
        GYOrdDetailModel *mdoel = _dataArr[0];
        _foodListArr = mdoel.foodList;
   
        [self refreshUI];
        [_orderDetailTableView reloadData];
    } isIndicator:YES];
    [orderListDetail GetOrderDetailWithUserIdId:_infoDic[@"userId"] orderId:_infoDic[@"orderId"]];
}
#pragma mark - 数据源
//刷新视图详情
- (void)refreshUI
{
    GYOrdDetailModel *detailModel = [GYOrdDetailModel new];
    detailModel = _dataArr[0];
    
    _foodListArr=detailModel.foodList;
    
    _detailUseIdLabel.text = detailModel.resNo;
    _ordIdLabel.text= _infoDic[@"orderId"];
    
    _ordStartTimeLabel.text = detailModel.orderStartTime;
    
    _ordStatusLabel.text = detailModel.orderStatus;
    
    if ([detailModel.orderType isEqualToString:kLocalized(@"Pickup")]) {
        _ordTypeLabel.text = kLocalized(@"Store");
         _arTimeLabel.text = kLocalized(@"ToBeSelf-createdTime");
        _arTimeLabel.frame = CGRectMake(10, 70, 100, 30);
         _arriveTimeLable.frame = CGRectMake(110, 70, 180, 30);
        _numberLabel.frame = CGRectMake(320, 70, 90, 30);
        _phoneLable.frame = CGRectMake(410, 70, 120, 30);
        _remLabel.frame = CGRectMake(10, 100, 50, 30);
         _remarkLabel.frame = CGRectMake(60, 100, 400, 30);
        
        if (detailModel.contactPerson.length > 0) {
            _nameLable.text = detailModel.contactPerson;
        }else{
            _dinersTitleLabel.hidden = YES;
            _nameLable.hidden = YES;
        }
       
        if (detailModel.contactPhone.length > 0) {
           _phoneLable.text = detailModel.contactPhone;
        }else{
            _numberLabel.hidden = YES;
            _phoneLable.hidden = YES;
        }
        
        if (detailModel.arriveTime.length > 0) {
            _arriveTimeLable.text=detailModel.arriveTime;
        }else{
            _arriveTimeLable.hidden = YES;
            _arTimeLabel.hidden = YES;
        }
        _addLabel.hidden = YES;
        _addressLable.hidden = YES;
        _payLabel.hidden = YES;
        _paymentLabel.hidden = YES;
        _coView.hidden = YES;
        _reLabel.hidden = YES;
        _remarLable.hidden = YES;
    }else if ([detailModel.orderType isEqualToString:kLocalized(@"Takeout")]){
        _ordTypeLabel.text = detailModel.orderType;
        _nameLable.text = detailModel.contactPerson;
        _phoneLable.text = detailModel.contactPhone;
        _addressLable.text=detailModel.contactAddress;
        _arriveTimeLable.text=detailModel.arriveTime;
        _paymentLabel.text = detailModel.deliverFee;
        NSDictionary *deliDiscountDict =[detailModel.deliDiscount dictionaryValue];
        if ( [deliDiscountDict[@"manPirce"] length] > 0 && [deliDiscountDict[@"jianPrice"] length] > 0) {
            
            _remarLable.text = [NSString stringWithFormat:@"订单满%@减%@元",deliDiscountDict[@"manPirce"],deliDiscountDict[@"jianPrice"]];
        }else{
            
            _remarLable.text = kLocalized(@"NoDistributionDeals");
            
        }

    
    }
    
        _remarkLabel.text = detailModel.orderRemark;
    
    _countLable.text = detailModel.totalFoodNum;
    _totalPayLable.text = detailModel.amountActually;
    _pointLable.text = detailModel.totalPv;
   
    
}


@end
