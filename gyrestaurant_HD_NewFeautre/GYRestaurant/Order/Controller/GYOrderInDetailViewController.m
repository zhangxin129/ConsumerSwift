//
//  GYOrderInDetailViewController.m
//  GYRestaurant
//
//  Created by ios007 on 15/10/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOrderInDetailViewController.h"
#import "GYOdrInDetailCell.h"
#import "GYOdrInDetailPaidCell.h"
#import "GYOrderManagerViewModel.h"
#import "GYOrdDetailModel.h"
#import "GYAddFoodViewController.h"
#import "FoodListInModel.h"
#import "GYOrderTakeInInvoicingViewController.h"
#import "GYAlertWithFieldView.h"
#import "GYOdrInWithStatusCell.h"

typedef NS_OPTIONS(NSInteger, OrderStatus){
    OrderStatusWithDelete,//带删除单子
    OrderStatusWithStatus, //带状态单子
    OrderStatusOther//其他单子
};

@interface GYOrderInDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, GYOdrInDetailDelegate>{
    
    UITableView *_orderDetailTableView;
    UIView *_headView;
    NSArray *_headArray;
    UILabel *_expectPersonLabel;
    UITextField *_dinerTF;
    UILabel *_tableNumberLabel;
    OrderStatus type;//记录结账状态
    NSMutableArray *dataArray;
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
//预计到店时间
@property (nonatomic, strong) UILabel *estimatedArriveTimeLabel;
//定金数
@property (nonatomic, strong) UILabel *paymentLabel;
//备注内容
@property (nonatomic, strong) UILabel *remarkLabel;

@property (nonatomic, weak)UILabel *totalCountLabel;

@property (nonatomic, strong)GYOrdDetailModel *model;

@property (nonatomic, weak) UILabel *sumNumLabel;
@property (nonatomic, weak) UILabel *sumPayCountLabel;
@property (nonatomic, weak) UILabel *sumPVLabel;

@property (nonatomic, weak) UIButton *payBtn;//多功能按钮
@property (nonatomic, weak) UIButton *saveBtn;
@property (nonatomic, weak) UIButton *btnAddFood;

@property (nonatomic, weak) UILabel *foundingTitleLabel;
@property (nonatomic, weak) UILabel *tableNumberTitleLabel;

@property (nonatomic, weak) UILabel *lbTitleContactNumber;
@property (nonatomic, weak) UILabel *lbContactNumber;

@property (nonatomic, weak) UILabel *estimatedArriveTimeTitleLabel;
@property (nonatomic, weak) UILabel *paymentTitleLabel;

@property (nonatomic, strong) UILabel *dinersTitleLabel;

@property (nonatomic, strong) GYAlertWithFieldView *alert;
@end

@implementation GYOrderInDetailViewController

#pragma mark - 继承系统
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [Utils createBackButtonWithTitle:kLocalized(@"Orderdetails") withTarget:self withAction:@selector(popBack)];
    //根据订单状态区分不同的tableViewCell
    if ([self.status isEqualToString:kLocalized(@"ToBeCheckout")]||[self.status isEqualToString:kLocalized(@"ToBeSelf-created")]){
        type = OrderStatusWithDelete;
    }else if([self.status isEqualToString:kLocalized(@"TransactionComplete")]){
        type = OrderStatusWithStatus;
    }else{
        type = OrderStatusOther;
    }
    [self creatUITopLine1];
    [self creatUITopLine2];
    [self creatUITopLine3];
    [self createUIMidTableview];
    [self creatUIBottom];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self RequestOderDetailData];
}

#pragma mark - 创建视图
/**创建视图上部*/
-(void)creatUITopLine1{
    
    //红色分割线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 2)];
    line.backgroundColor = kRedFontColor;
    [self.view addSubview:line];
    
    //表头底图
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 2, kScreenWidth, 50)];
    titleView.backgroundColor = [UIColor colorWithRed:207/255.0 green:234/255.0 blue:254/255.0 alpha:1.0];
    [self.view addSubview:titleView];
    
    float x = (kScreenWidth - 120 - 120 - 60 - 180 - 80 - 160 - 40 - 40 - 40 - 120)/6;
    
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
    
    _ordStartTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(560 + 3*x, 5, 160, 40)];
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
    
}

-(void)creatUITopLine2{
    float X = (kScreenWidth - 120 - 40 - 80 - 85 - 40 - 60 - 120 - 160 - 120 -80)/6.0f;
    //预计就餐人数
    _dinersTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(X, 60, 120, 40)];
    _dinersTitleLabel.textAlignment = NSTextAlignmentLeft;
    _dinersTitleLabel.text = kLocalized(@"TheNumberOfMeals:");
    _dinersTitleLabel.hidden = YES;
    [self.view addSubview:_dinersTitleLabel];
    
    _expectPersonLabel = [[UILabel alloc] initWithFrame:CGRectMake(X + 120, 60, 40, 40)];
    _expectPersonLabel.hidden = YES;
    _expectPersonLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_expectPersonLabel];
    
    //开台人数
    UILabel *foundingTitleLabel = [[UILabel alloc]init];
    foundingTitleLabel.text = kLocalizedAddParams(kLocalized(@"FoundingListings"), @":");
    foundingTitleLabel.hidden = YES;
    [self.view addSubview:foundingTitleLabel];
    self.foundingTitleLabel = foundingTitleLabel;
    //输入框
    _dinerTF = [[UITextField alloc]init];
    [_dinerTF setBorderStyle:UITextBorderStyleBezel];
    _dinerTF.layer.masksToBounds = YES;
    _dinerTF.layer.borderColor=[kBlueFontColor CGColor];
    _dinerTF.layer.borderWidth= 1.0f;
    _dinerTF.clearsOnBeginEditing = YES;
   // _dinerTF.placeholder = kLocalized(@"Enterthenumber");
    _dinerTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_dinerTF];
    _dinerTF.hidden = YES;
    _dinerTF.delegate = self;
    
    //开台号
    UILabel *tableNumberTitleLabel = [[UILabel alloc]init];
    tableNumberTitleLabel.text = kLocalizedAddParams(kLocalized(@"Tablenumber"), @":");
    tableNumberTitleLabel.hidden = YES;
    [self.view addSubview:tableNumberTitleLabel];
    self.tableNumberTitleLabel = tableNumberTitleLabel;
    
    _tableNumberLabel = [[UILabel alloc] init];
    _tableNumberLabel.hidden = YES;
    [self.view addSubview:_tableNumberLabel];
    
    //联系电话
    UILabel *lbTitleContactNumber = [[UILabel alloc]init];
    lbTitleContactNumber.text = kLocalizedAddParams(kLocalized(@"contactNumber"), @"：");
  //  lbTitleContactNumber.hidden = YES;
    [self.view addSubview:lbTitleContactNumber];
    self.lbTitleContactNumber = lbTitleContactNumber;
    
    UILabel *lbContactNumber = [[UILabel alloc] init];
   // lbContactNumber.hidden = YES;
    [self.view addSubview:lbContactNumber];
    self.lbContactNumber = lbContactNumber;
    
    //到店时间
    UILabel *estimatedArriveTimeTitleLabel = [[UILabel alloc]init];
    if ([self.status isEqualToString:kLocalized(@"ToBeSelf-created")]) {
        estimatedArriveTimeTitleLabel.text = kLocalized(@"ToBeSelf-createdTime");
    }else{
        estimatedArriveTimeTitleLabel.text = kLocalized(@"Appointment:");
    }
    
    [self.view addSubview:estimatedArriveTimeTitleLabel];
    self.estimatedArriveTimeTitleLabel = estimatedArriveTimeTitleLabel;
    _estimatedArriveTimeLabel = [[UILabel alloc]init];
    _estimatedArriveTimeLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_estimatedArriveTimeLabel];
    
    //预付定金
    UILabel *paymentTitleLabel = [[UILabel alloc]init];
    paymentTitleLabel.text = kLocalizedAddParams(kLocalized(@"DownPayment"), @":");
    [self.view addSubview:paymentTitleLabel];
    self.paymentTitleLabel = paymentTitleLabel;
    
    _paymentLabel = [[UILabel alloc]init];
    _paymentLabel.textColor = kRedFontColor;
    _paymentLabel.font = [UIFont systemFontOfSize:22];
    [self.view addSubview:_paymentLabel];
    
    if (![self.status isEqualToString:kLocalized(@"ToBeSelf-created")]) {
        
        if ([self.status isEqualToString:kLocalized(@"ToBeConfirmed")]||[self.status isEqualToString:kLocalized(@"ToBeDining")]) {
            if (![self.strType isEqualToString:kLocalized(@"Store")]) {
                _dinersTitleLabel.hidden = NO;
                _expectPersonLabel.hidden = NO;
                lbTitleContactNumber.hidden = NO;
                lbContactNumber.hidden = NO;
                
                _dinersTitleLabel.frame = CGRectMake(X, 60, 100, 40);
                _dinersTitleLabel.textAlignment = NSTextAlignmentLeft;
                _expectPersonLabel.frame = CGRectMake(X+100, 60, 60, 40);
                _expectPersonLabel.textAlignment = NSTextAlignmentLeft;
                estimatedArriveTimeTitleLabel.frame = CGRectMake(X+200, 60, 120, 40);
                estimatedArriveTimeTitleLabel.textAlignment = NSTextAlignmentRight;
                _estimatedArriveTimeLabel.frame = CGRectMake(X+320, 60, 160, 40);
                _estimatedArriveTimeLabel.textAlignment = NSTextAlignmentLeft;
                lbTitleContactNumber.frame = CGRectMake(500 +  X, 60, 100, 40);
                lbContactNumber.frame = CGRectMake(600 +  X, 60, 120, 40);
                _paymentTitleLabel.frame = CGRectMake(740 +  X, 60, 120, 40);
                _paymentTitleLabel.textAlignment = NSTextAlignmentRight;
                _paymentLabel.frame = CGRectMake(860 +  X, 60, 120, 40);
            }else{
                _dinersTitleLabel.hidden = NO;
                _expectPersonLabel.hidden = NO;
                estimatedArriveTimeTitleLabel.frame = CGRectMake(X *2 +160, 60, 120, 40);
                _estimatedArriveTimeLabel.frame = CGRectMake(X *2 + 280, 60, 160, 40);
                _estimatedArriveTimeLabel.textAlignment = NSTextAlignmentLeft;
                paymentTitleLabel.frame = CGRectMake(430 + 3 * X, 60, 80, 40);
                _paymentLabel.frame = CGRectMake(510 + 3 * X, 60, 120, 40);
            }
        }else if ([self.status isEqualToString:kLocalized(@"ToBeCheckout")]) {
            _dinersTitleLabel.hidden = NO;
            _expectPersonLabel.hidden = NO;
            foundingTitleLabel.hidden = NO;
            _dinerTF.hidden = NO;
            tableNumberTitleLabel.hidden = NO;
            _tableNumberLabel.hidden = NO;
            
            _dinersTitleLabel.frame = CGRectMake(X , 60, 130, 40);
            _dinersTitleLabel.textAlignment = NSTextAlignmentLeft;
            _dinersTitleLabel.text = kLocalizedAddParams(kLocalized(@"Estimatednumberofmeals"), @"：");
            _expectPersonLabel.frame = CGRectMake(X + 130 , 60, 20, 40);;
            
            foundingTitleLabel.frame = CGRectMake(X * 2 + 150, 60, 80, 40);
            _dinerTF.frame = CGRectMake(X * 2  + 230, 65, 50, 30);
            _dinerTF.userInteractionEnabled = YES;
            tableNumberTitleLabel.frame = CGRectMake(X * 3 + 280, 60, 40, 40);
            _tableNumberLabel.frame = CGRectMake(X * 3 + 320, 60, 160, 40);
            estimatedArriveTimeTitleLabel.frame = CGRectMake(X * 4 + 480, 60, 90, 40);
            _estimatedArriveTimeLabel.frame = CGRectMake(X * 4 + 570, 60, 160, 40);
            _estimatedArriveTimeLabel.textAlignment = NSTextAlignmentLeft;
            paymentTitleLabel.frame = CGRectMake(730 + 5 * X, 60, 80, 40);
            _paymentLabel.frame = CGRectMake(820 + 5 * X, 60, 120, 40);
            paymentTitleLabel.hidden = NO;
            _paymentLabel.hidden = NO;
        }else if ([self.status isEqualToString:kLocalized(@"TransactionComplete")]) {
            _dinersTitleLabel.hidden = YES;
            _expectPersonLabel.hidden = YES;
            foundingTitleLabel.hidden = NO;
            _dinerTF.hidden = NO;
            tableNumberTitleLabel.hidden = NO;
            _tableNumberLabel.hidden = NO;
            foundingTitleLabel.frame = CGRectMake(X, 60, 80, 40);
            _dinerTF.frame = CGRectMake(X + 80, 65, 40, 30);
            _dinerTF.userInteractionEnabled = NO;
            tableNumberTitleLabel.frame = CGRectMake(2 * X + 120 , 60, 40, 40);
            _tableNumberLabel.frame = CGRectMake(2 * X + 160 , 60, 180, 40);
            estimatedArriveTimeTitleLabel.frame = CGRectMake(3 * X + 320, 60, 90, 40);
            _estimatedArriveTimeLabel.frame = CGRectMake(3 * X + 410, 60, 160, 40);
            _estimatedArriveTimeLabel.textAlignment = NSTextAlignmentLeft;
            paymentTitleLabel.frame = CGRectMake(4 * X + 570, 60, 80, 40);
            _paymentLabel.frame = CGRectMake(4 * X + 650, 60, 120, 40);
        }else if([self.status isEqualToString:kLocalized(@"Cancelled")]){
                        _dinersTitleLabel.hidden = YES;
                        _expectPersonLabel.hidden = YES;
                        foundingTitleLabel.hidden = YES;
                        _dinerTF.hidden = YES;
                        tableNumberTitleLabel.hidden = YES;
                        _tableNumberLabel.hidden = YES;
//            foundingTitleLabel.frame = CGRectMake(X, 60, 80, 40);
//            _dinerTF.frame = CGRectMake(X + 80, 65, 85, 30);
//            _dinerTF.userInteractionEnabled = NO;
//            tableNumberTitleLabel.frame = CGRectMake(2 * X + 165 , 60, 40, 40);
//            _tableNumberLabel.frame = CGRectMake(2 * X + 205 , 60, 60, 40);
            estimatedArriveTimeTitleLabel.frame = CGRectMake(X , 60, 90, 40);
            _estimatedArriveTimeLabel.frame = CGRectMake(X + 90, 60, 160, 40);
            _estimatedArriveTimeLabel.textAlignment = NSTextAlignmentLeft;
            paymentTitleLabel.frame = CGRectMake(2 * X + 270, 60, 90, 40);
            _paymentLabel.frame = CGRectMake(2 * X + 360, 60, 120, 40);
            lbTitleContactNumber.frame = CGRectMake(3 * X + 500, 60, 90, 40);
            _lbContactNumber.frame = CGRectMake(3 * X + 590, 60, 120, 40);
        }
        
    }else{
//        lbContactNumber.hidden = NO;
//        lbTitleContactNumber.hidden = NO;
        estimatedArriveTimeTitleLabel.frame = CGRectMake(X, 60, 90, 40);
        _estimatedArriveTimeLabel.frame = CGRectMake(X+90, 60, 160, 40);
        _estimatedArriveTimeLabel.textAlignment = NSTextAlignmentLeft;
        lbTitleContactNumber.frame = CGRectMake(270 + 2 * X, 60, 100, 40);
        lbContactNumber.frame = CGRectMake(370 + 2 * X, 60, 120, 40);
    }
}

-(void)creatUITopLine3{
    float X = (kScreenWidth - 120 - 40 - 80 - 85 - 40 - 60 - 120 - 160 - 120 -80)/6.0f;
    
    //备注
    UILabel *remarkTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(X, 110, 45, 40)];
    remarkTitleLabel.text = kLocalizedAddParams(kLocalized(@"Remark"), @":");
    [self.view addSubview:remarkTitleLabel];
    
    _remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 110, kScreenWidth - 120, 40)];
   // _remarkLabel.text = @"少辣，准备一个儿童凳子";
    [self.view addSubview:_remarkLabel];
}

/**创建中部TableView*/
- (void)createUIMidTableview{
    _orderDetailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 150, kScreenWidth, kScreenHeight - 150 - 64 - 49)];
    if (type == OrderStatusWithDelete) {
        _headArray = @[kLocalized(@"Dishesinformation"),kLocalized(@"Specification"),kLocalized(@"unitprice"),kLocalized(@"Quantity"),kLocalized(@"Money"),kLocalized(@"Integration"),kLocalized(@"Status"),kLocalized(@"Operating")];
    }else if(type == OrderStatusWithStatus){
        _headArray = @[kLocalized(@"Dishesinformation"),kLocalized(@"Specification"),kLocalized(@"unitprice"),kLocalized(@"Quantity"),kLocalized(@"Money"),kLocalized(@"Integration"),kLocalized(@"Status")];
    }else{
        _headArray = @[kLocalized(@"Dishesinformation"),kLocalized(@"Specification"),kLocalized(@"unitprice"),kLocalized(@"Quantity"),kLocalized(@"Money"),kLocalized(@"Integration")];
    }
    _orderDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _orderDetailTableView.delegate = self;
    _orderDetailTableView.dataSource = self;
    _orderDetailTableView.rowHeight = 100;
    [_orderDetailTableView registerNib:[UINib nibWithNibName:@"GYOdrInDetailCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [_orderDetailTableView registerNib:[UINib nibWithNibName:@"GYOdrInDetailPaidCell" bundle:nil] forCellReuseIdentifier:@"CpLL"];
    [_orderDetailTableView registerNib:[UINib nibWithNibName:@"GYOdrInWithStatusCell" bundle:nil] forCellReuseIdentifier:@"CLLLL"];
    [self.view addSubview:_orderDetailTableView];
}

/**下边视图*/
- (void)creatUIBottom{
    
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
    numberTitleLabel.font = [UIFont systemFontOfSize:18];
    [downView addSubview:numberTitleLabel];
    
    //数量数
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(96, 5, 40, 40)];
    self.sumNumLabel = countLabel;
    countLabel.text = @"5";
    countLabel.textColor = kRedFontColor;
    countLabel.font = [UIFont systemFontOfSize:22];
    [downView addSubview:countLabel];
    
    //总额
    UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 5, 75, 40)];
    totalLabel.text = kLocalized(@"lumpsum");
    totalLabel.font = [UIFont systemFontOfSize:18];
    [downView addSubview:totalLabel];
    
    //积分背景图
    UIImageView *totalImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"coin"]];
    totalImageView.frame = CGRectMake(190, 14, 21, 21);
    [downView addSubview:totalImageView];
    
    //总额数
    UILabel *totalCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 5, 100, 40)];
    totalCountLabel.text = @"5";
    self.sumPayCountLabel = totalCountLabel;
    totalCountLabel.textColor = kRedFontColor;
    totalCountLabel.font =[UIFont systemFontOfSize:22];
    [downView addSubview:totalCountLabel];
    self.totalCountLabel = totalCountLabel;
    
    //积分
    UILabel *integralLabel = [[UILabel alloc]initWithFrame:CGRectMake(315, 5, 50, 40)];
    integralLabel.text = kLocalizedAddParams(kLocalized(@"Integration"), @":");
    integralLabel.font =[UIFont systemFontOfSize:18];
    [downView addSubview:integralLabel];
    
    //积分背景图
    UIImageView *integralImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PV"]];
    integralImageView.frame = CGRectMake(365, 14, 21, 21);
    [downView addSubview:integralImageView];
    
    //积分数
    UILabel *integralCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(386, 5, 75, 40)];
    self.sumPVLabel = integralCountLabel;
    integralCountLabel.textColor = kBlueFontColor;
    integralCountLabel.font = [UIFont systemFontOfSize:22];
    [downView addSubview:integralCountLabel];
    
    //保存按钮
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(kScreenWidth/2 - 40, 5, 100, 40);
    
    saveBtn.backgroundColor = [UIColor colorWithRed:209/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];
    [saveBtn setTitle:kLocalized(@"Save") forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [saveBtn.layer setCornerRadius:10.0];
    [saveBtn addTarget:self action:@selector(saveListBtnAction) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:25];
    [downView addSubview:saveBtn];
    self.saveBtn = saveBtn;
    //加菜按钮
    UIButton *btnAddFood = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAddFood.frame = CGRectMake(640, 5, 100, 40);
    btnAddFood.backgroundColor = [UIColor colorWithRed:209/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];
    [btnAddFood.layer setCornerRadius:10.0];
    [btnAddFood setTitleColor:[UIColor colorWithRed:0/255.0 green:67/255.0 blue:149/255.0 alpha:1.0] forState:UIControlStateNormal];
    btnAddFood.titleLabel.font = [UIFont systemFontOfSize:25];
    [btnAddFood addTarget:self action:@selector(addFood:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:btnAddFood];
    self.btnAddFood = btnAddFood;
    
    
    //结单按钮
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(800, 5, 100, 40);
    
    payBtn.backgroundColor = [UIColor colorWithRed:216/255.0 green:4/255.0 blue:32/255.0 alpha:1.0];
    [payBtn setTitle:@"" forState:UIControlStateNormal];
    payBtn.titleLabel.textColor = [UIColor whiteColor];
    [payBtn.layer setCornerRadius:10.0];
    [payBtn addTarget:self action:@selector(operatertionAct:) forControlEvents:UIControlEventTouchUpInside];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:25];
    [downView addSubview:payBtn];
    self.payBtn = payBtn;
}
#pragma mark - 数据源
/**刷新视图详情*/
- (void)refreshUI:(NSArray *)arr
{
    if (arr.count == 0) {
        return;
    }
    _model = arr[0];
    _detailUseIdLabel.text = _model.resNo;
    _ordIdLabel.text = _model.orderId;
    _ordTypeLabel.text = kLocalized(@"Store");
    _ordStartTimeLabel.text = _model.orderStartTime;
    NSString *strOrderStatus = [self AccordingToTheStateReturnValueString];
    if (strOrderStatus.length > 0) {
        
        [self.payBtn setTitle:strOrderStatus forState:UIControlStateNormal];
        if ([strOrderStatus isEqualToString:kLocalized(@"Confirm")]) {
            if (globalData.currentRole == roleTypeTrusteeshipCompanyWaiter || globalData.currentRole == roleTypeMemberCompanyWaiter||globalData.currentRole == roleTypeTrusteeshipCompanyCashier || globalData.currentRole == roleTypeMemberCompanyCashier ) {
                self.payBtn.hidden = YES;
            }else{
                self.payBtn.hidden = NO;
            }
        }else if([strOrderStatus isEqualToString:kLocalized(@"Receivables")]){
            if (globalData.currentRole == roleTypeTrusteeshipCompanyWaiter || globalData.currentRole == roleTypeMemberCompanyWaiter) {
                self.payBtn.hidden = YES;
            }else{
                self.payBtn.hidden = NO;
            }
        }else{
            self.payBtn.hidden = NO;
        }
        
    }else{
        self.payBtn.hidden = YES;
    }
    if ([self.status isEqualToString:kLocalized(@"ToBeSelf-created")]) {
        [self.btnAddFood setTitle:kLocalized(@"CancelAppointment") forState:UIControlStateNormal];
        if (globalData.currentRole == roleTypeTrusteeshipCompanyWaiter || globalData.currentRole == roleTypeMemberCompanyWaiter||globalData.currentRole == roleTypeTrusteeshipCompanyCashier || globalData.currentRole == roleTypeMemberCompanyCashier ) {
            self.btnAddFood.hidden = YES;
        }else{
            self.btnAddFood.hidden = NO;
        }
            self.saveBtn.hidden = YES;
    }else if([self.status isEqualToString:kLocalized(@"ToBeDining")]){
        [self.btnAddFood setTitle:kLocalized(@"CancelAppointment") forState:UIControlStateNormal];
        if (globalData.currentRole == roleTypeTrusteeshipCompanyWaiter || globalData.currentRole == roleTypeMemberCompanyWaiter||globalData.currentRole == roleTypeTrusteeshipCompanyCashier || globalData.currentRole == roleTypeMemberCompanyCashier ) {
            self.btnAddFood.hidden = YES;
        }else{
            self.btnAddFood.hidden = NO;
        }
        self.saveBtn.hidden = YES;
    }else if ([self.status isEqualToString:kLocalized(@"ToBeCheckout")]) {
        [self.btnAddFood setTitle:kLocalized(@"Plusfood") forState:UIControlStateNormal];
        self.saveBtn.hidden = NO;
        self.btnAddFood.hidden = NO;
        _tableNumberLabel.text = _model.tableNo;
        _dinerTF.text = _model.tableNum;
        if (globalData.currentRole == roleTypeTrusteeshipCompanyWaiter || globalData.currentRole == roleTypeMemberCompanyWaiter) {
            self.payBtn.hidden = YES;
        }else{
            self.payBtn.hidden = NO;
        }
        
    }else{
        self.saveBtn.hidden = YES;
        self.btnAddFood.hidden = YES;
    }
    
    _ordStatusLabel.text = self.status;
    
    if ([self.status isEqualToString:kLocalized(@"TransactionComplete")]) {
        if (_model.tableNum.length > 0 && _model.tableNo.length > 0) {
            _dinerTF.text = _model.tableNum;
            _tableNumberLabel.text = _model.tableNo;
        }else{
            _dinerTF.hidden = YES;
            self.foundingTitleLabel.hidden = YES;
            _tableNumberLabel.hidden = YES;
            self.tableNumberTitleLabel.hidden = YES;
        }
        
    }
    if ([_model.personNum isEqualToString:@""]) {
        _dinerTF.hidden = YES;
        self.foundingTitleLabel.hidden = YES;
        
    }else{
        _dinerTF.hidden = NO;
        self.foundingTitleLabel.hidden = NO;
      
        _dinerTF.text = _model.tableNum;
    }
    
    if ([_model.mealTime isEqualToString:@""]) {
        _estimatedArriveTimeLabel.hidden = YES;
        self.estimatedArriveTimeTitleLabel.hidden = YES;
    }else{
        _estimatedArriveTimeLabel.hidden = NO;
        self.estimatedArriveTimeTitleLabel.hidden = NO;
        _estimatedArriveTimeLabel.text = _model.mealTime;
        _estimatedArriveTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    if ([_model.prePayAmount isEqualToString:@"0.00"]) {
        _paymentTitleLabel.hidden = YES;
        self.paymentTitleLabel.hidden = YES;
    }else{
        _paymentLabel.text = [_model.prePayAmount stringByAppendingString:kLocalized(@"yuan")];
    }
    
    if ([_model.contactPhone isEqualToString:@""]) {
        self.lbContactNumber.hidden = YES;
        self.lbTitleContactNumber.hidden = YES;
        
    }else{
        self.lbContactNumber.hidden = NO;
        self.lbTitleContactNumber.hidden = NO;
        self.lbContactNumber.text = _model.contactPhone;
    }
    
     float X = (kScreenWidth - 120 - 40 - 80 - 85 - 40 - 60 - 120 - 160 - 120 -80)/6.0f;
    
    if ([self.strType isEqualToString:kLocalized(@"In-storeDining")]) {
        if ([self.status isEqualToString:kLocalized(@"ToBeConfirmed")]||[self.status isEqualToString:kLocalized(@"ToBeDining")] || [self.status isEqualToString:kLocalized(@"ToBeCheckout")]) {
            _expectPersonLabel.text = _model.personNum;
        }else{
            _expectPersonLabel.text = _model.tableNum;
            _expectPersonLabel.textAlignment = NSTextAlignmentLeft;
        }

    }else if([self.strType isEqualToString:kLocalized(@"StoresFromMentioning")]){
        
        _expectPersonLabel.hidden = YES;
        _dinersTitleLabel.hidden = YES;
        self.estimatedArriveTimeTitleLabel.frame = _dinersTitleLabel.frame;
        self.estimatedArriveTimeTitleLabel.text = kLocalized(@"ToBeSelf-createdTime");
        self.estimatedArriveTimeTitleLabel.textAlignment = NSTextAlignmentLeft;
        self.estimatedArriveTimeLabel.frame = CGRectMake(X+90, 60, 160, 40);
        _lbTitleContactNumber.frame = CGRectMake(2 * X + 250, 60, 100, 40);
        _lbContactNumber.frame = CGRectMake(2 * X + 350, 60, 120, 40);

    }
    
    _remarkLabel.text = _model.orderRemark;
    self.lbContactNumber.text = _model.contactPhone;
    self.sumNumLabel.text = _model.totalFoodNum;
    self.sumPayCountLabel.text = _model.totalAmount;
    self.sumPayCountLabel.adjustsFontSizeToFitWidth = YES;
    self.sumPVLabel.text = _model.totalPv;
    self.sumPVLabel.adjustsFontSizeToFitWidth = YES;
    dataArray = _model.foodList;
    
    if ([self.strType isEqualToString:kLocalized(@"StoresFromMentioning")]) {
        _dinerTF.hidden = YES;
        self.foundingTitleLabel.hidden = YES;

        
    }

    [_orderDetailTableView reloadData];
}

#pragma mark - Btn点击事件
//保存修改的订单
- (void)saveListBtnAction{
    @weakify(self);
    GYAlertView *alertView = [[GYAlertView alloc] initWithTitle:kLocalized(@"ModifyTheNumberOfMealsOperation") contentText:nil leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Determine")];
    alertView.rightBlock = ^{
    @strongify(self);
        if ([self.model.sendOrderTime isEqualToString:@"5"]) {
            [self customAlertView:kLocalized(@"SingleHitTooManyTimes, TheOrderCanNotBeModified")];
            return;
        }
                
        NSDictionary *dic = [[NSDictionary alloc] init];
        dic = @{@"orderId":_infoDic[@"orderId"],
                @"userId":_infoDic[@"userId"],
                @"personCount":_dinerTF.text,
                };
        [self saveOrderData:dic];
    
    };
    
    [alertView show];
}

//加菜
- (void)addFood:(UIButton *)button
{
    @weakify(self);
    if ([self.status isEqualToString:kLocalized(@"ToBeDining")]) {
        if ([_model.prePayAmount isEqualToString:@"0.00"] || [_model.prePayAmount isEqualToString:@"0"] || [_model.prePayAmount isEqualToString:@"0.0"] || _model.prePayAmount == nil ) {
            GYAlertView *alert = [[GYAlertView alloc] initWithTitle:kLocalized(@"AreYouSureToCancelIt") contentText:nil leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Determine")];
            alert.rightBlock = ^{
                @strongify(self);
                [self requestOrdercancelReservationsWithRefundType:@"2" withMoneyEarnsetRefund:@"0.0" withCancelReason:@""];
            };
            [alert show];
        }else{
            _alert = [[GYAlertWithFieldView alloc] initCancelView:_model.prePayAmount];
            _alert.cancelTF.delegate = self;
            _alert.returnBlock = ^(NSString *returnStatusStr, NSString *TFText, NSString *cancelMoney){
                @strongify(self);
                if (TFText.length > 0 && TFText.length < 20) {
                    [self requestOrdercancelReservationsWithRefundType:returnStatusStr withMoneyEarnsetRefund:cancelMoney withCancelReason:TFText];
                }else if (TFText.length > 20){
                    
                    [self notifyWithText:kLocalized(@"ReasonNotToCancelMoreThan 20 Characters!")];
                }else{
                
                    [self notifyWithText:kLocalized(@"PleaseEnterCancelReason!")];
                }
                
            };
            [_alert show];
        }
    }
    
    if ([self.status isEqualToString:kLocalized(@"ToBeSelf-created")]) {
        GYAlertView *alert = [[GYAlertView alloc] initWithTitle:kLocalized(@"AreYouSureToCancelIt") contentText:nil leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Determine")];
        alert.rightBlock = ^{
            @strongify(self);
            [self requestOrdercancelReservation];
        };
        [alert show];
    }
    
    if([self.status isEqualToString:kLocalized(@"ToBeCheckout")]){
        if ([self.model.sendOrderTime isEqualToString:@"5"]) {
            [self customAlertView:kLocalized(@"SingleHitTooManyTimes, TheOrderCanNotBeModified")];
            return;
        }
        if (self.sumNumLabel.text.intValue == 0) {
            [self notifyWithText:kLocalized(@"Pleaseselectdishes")];
        }
        GYAddFoodViewController *afVC = [[GYAddFoodViewController alloc]init];
        afVC.num = self.sumNumLabel.text.intValue;
        afVC.orderId = _infoDic[@"orderId"];
        afVC.userId = _infoDic[@"userId"];
        afVC.totalAmount = self.sumPayCountLabel.text;
        [self.navigationController pushViewController:afVC animated:YES];
    }
}

//确认，用餐，结账，确定，收款,取消
- (void)operatertionAct:(UIButton *)button{
    @weakify(self);
    
    if ([self.payBtn.currentTitle isEqualToString:kLocalized(@"Confirm")]) {
        if ([self.ordStatusLabel.text isEqualToString:kLocalized(@"TobeconfirmedCancel")]) {
            GYAlertView *alert = [[GYAlertView alloc] initWithTitle:kLocalizedAddParams(kLocalized(@"OKCancelit"), @"?") contentText:nil leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Determine")];
            [alert show];
            alert.rightBlock = ^{
                @strongify(self);
                [self requestOrderICustomerCancel:button];
            };
        }else{
            GYAlertView *alert = [[GYAlertView alloc] initWithTitle:kLocalizedAddParams(kLocalized(@"AreYouSure"), @"?") contentText:nil leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Determine")];
            [alert show];
            alert.rightBlock = ^{
                @strongify(self);
                [self requestOrderInconfirm:button];
            };
        }
    }
    
    if ([self.payBtn.currentTitle isEqualToString:kLocalized(@"PayMoney")]) {
        
        GYOrderTakeInInvoicingViewController *vc = [[GYOrderTakeInInvoicingViewController alloc] init];
        vc.isPush = YES;
        vc.infoDic = _infoDic;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([self.payBtn.currentTitle isEqualToString:kLocalized(@"Dine")]) {
        _alert = [[GYAlertWithFieldView alloc] initWithTitle:kLocalized(@"FoundingOperation") ramadhinTextFieldName:kLocalized(@"NumberOfPeople") numberTextFieldName:kLocalized(@"TableNumber") leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Determine")];
        _alert.ramadhinTextField.delegate = self;
        _alert.numberTextField.delegate = self;
        _alert.rightBlock = ^(NSString *tableNo, NSString *tableNumber){
            @strongify(self);
            if (tableNumber.length > 8) {
                [self notifyWithText:kLocalized(@"DeskSetsNumberCanNotBeMoreThanEightCharacters")];
            }else{
                
                [self requestOrderInConfirmToUse:tableNumber with:tableNo button:button];
                
            }
            
        };
        [_alert show];
    }
    
    
    if ([self.payBtn.currentTitle isEqualToString:kLocalized(@"Receivables")]) {
        GYAlertView *alert = [[GYAlertView alloc]initWithTitle:kLocalizedAddParams(kLocalized(@"AreYouSureToSettleAccounts"), @"?") contentText:nil leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Determine")];
        alert.rightBlock = ^(){
            @strongify(self);
            [self requestOrderToGet:button];
        };
        
        [alert show];
        
    }
    
    if ([self.payBtn.currentTitle isEqualToString:kLocalized(@"Cancellation")]||[self.payBtn.currentTitle isEqualToString:kLocalized(@"CancelAppointment")]) {
        GYAlertView *alert = [[GYAlertView alloc] initWithTitle:kLocalizedAddParams(kLocalized(@"AreYouSure"), @"?") contentText:nil leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Determine")];
        [alert show];
        alert.rightBlock = ^{
            @strongify(self);
            [self requestOrderICustomerCancel:button];
        };
    }
    
}

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - private methods 私有方法
/**根据状态决定按钮名字*/
- (NSString *)AccordingToTheStateReturnValueString{
    NSString *str;
    if ([self.status isEqualToString:kLocalized(@"ToBeSelf-created")]) {
        str = kLocalized(@"Receivables");
    }else if([self.status isEqualToString:kLocalized(@"TobeconfirmedCancel")])
        str = kLocalized(@"Confirm");
    else{
        if ([self.status  isEqualToString:kLocalized(@"ToBeConfirmed")]) {
            str = kLocalized(@"Confirm");
        }else if ([self.status  isEqualToString:kLocalized(@"ToBeDining")]) {
            str = kLocalized(@"Dine");
        }else if ([self.status isEqualToString:kLocalized(@"ToBeCheckout")]) {
            str = kLocalized(@"PayMoney");
        }else{
            str = @"";
        }
    }
    return str;
}
#pragma mark - UITextField的代理方法

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_dinerTF resignFirstResponder];
    
    return YES;
}
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
    
    NSString *personNumStr = _dinerTF.text;
    if (textField == _dinerTF) {
        if ([textField.text intValue] > 50) {
            textField.text = @"50";
            [self notifyWithText:kLocalized(@"FoundingTheNumberMustBeBetween 1-50")];
        }else if([textField.text intValue] > 0 && [textField.text intValue] <= 50){
            textField.text = personNumStr;
        }else if ([textField.text intValue] <= 0){
            textField.text = @"1";
            [self notifyWithText:kLocalized(@"FoundingTheNumberMustBeBetween 1-50")];
        }
    }else if (textField == _alert.numberTextField) {
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

#pragma mark -  UITableViewDataSource && UITableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (type) {
        case OrderStatusWithDelete:
        {
            GYOdrInDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            FoodListInModel *md  = dataArray[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delagete = self;
            if (![md.foodState isEqualToString:kLocalized(@"Normal")]) {
                cell.deleteBtn.hidden = YES;
            }else{
                cell.deleteBtn.hidden = NO;
            }
            
            cell.model = md;
            return cell;
        }
            break;
            
        case OrderStatusWithStatus:{
            GYOdrInWithStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CLLLL" forIndexPath:indexPath];
            FoodListInModel *md  = dataArray[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.model = md;
            return cell;
        }
            break;
        case OrderStatusOther:
        {
            GYOdrInDetailPaidCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CpLL" forIndexPath:indexPath];
            FoodListInModel *md  = dataArray[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
            cell.model = md;
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    
    _headView.backgroundColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1.0];
    float width = (kScreenWidth-80)/_headArray.count;
    for (int i=0; i<_headArray.count ; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(width *i + 70, 0, width, 50)];
        label.text = _headArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18];
        [_headView addSubview:label];
    }
    
    return _headView;
}
#pragma mark - 网络请求
/**
 *  请求订单详情数据
 *  @"userId"  用户ID
 *  @"orderId" 订单ID
 */
-(void)RequestOderDetailData{
    
    GYOrderManagerViewModel *orderListDetail = [[GYOrderManagerViewModel alloc]init];
    [orderListDetail GetOrderDetailWithUserIdId:_infoDic[@"userId"]
                                        orderId:_infoDic[@"orderId"]];
    
    @weakify(self);
    [self modelRequestNetwork:orderListDetail :^(id resultDic) {
         @strongify(self);
        NSArray *array = (NSArray*)resultDic;
        GYOrdDetailModel *model = array.firstObject;
        NSMutableArray *foodList = [model.foodList mutableCopy];
        FoodListInModel *deleteModel = nil;
        for (FoodListInModel *food in foodList) {
            if (food.foodNum.integerValue == 0) {
                deleteModel = food;
            }
        }
        [foodList removeObject:deleteModel];
        model.foodList = foodList;
        resultDic = @[model];
        [self refreshUI:resultDic];
        
    } isIndicator:YES];
}
/**
 *  删除数据
 *  @"userId"  用户ID
 *  @"orderId" 订单ID
 */
- (void)deleteFoodId:(FoodListInModel*)model{
    @weakify(self);
    if ([self.model.sendOrderTime isEqualToString:@"5"]) {
        [self customAlertView:kLocalized(@"SingleHitTooManyTimes, TheOrderCanNotBeModified")];
        return;
    }
    
    float totalCount = [self.totalCountLabel.text floatValue];
    float price = [model.foodPrice floatValue];
    float num = [model.foodNum floatValue];
    float sumPrice = price * num;
    NSString *str = [NSString stringWithFormat:@"%f",sumPrice];
    float sum = [[self siSheWuRuwithString:str] floatValue];
    if (totalCount == sum) {
        [self notifyWithText:kLocalized(@"YouCanNotDeleteAllTheDishesOrder")];
        return;
    }
    
    GYAlertView *alert = [[GYAlertView alloc] initWithTitle:kLocalized(@"ConfirmDeletion?") contentText:nil leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Confirm")];
    [alert  show];
    alert.rightBlock = ^{
        
        GYOrderManagerViewModel *orderListDetail = [[GYOrderManagerViewModel alloc]init];
        [self modelRequestNetwork:orderListDetail :^(id resultDic) {
            @strongify(self);
            if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
                [self notifyWithText:kLocalized(@"Deletesuccessful")];
                [self RequestOderDetailData];
            }else if([resultDic[@"retCode"] isEqualToNumber:@779]){
                [self notifyWithText:kLocalized(@"OrderCheckout, YouCanNotModifyTheOrder!")];
            }else{
                [self notifyWithText:kLocalizedAddParams(kLocalized(@"DeleteFailed"), @"!")];
                
            }
        } isIndicator:YES];
        [orderListDetail deletelOrderDetailWithUseId:_infoDic[@"userId"]
                                               ordId:_infoDic[@"orderId"]
                                                  Id:model.ID];
    };
    
}

/**保存数据*/
- (void) saveOrderData:(NSDictionary *)dic{
    @weakify(self);
    GYOrderManagerViewModel *orderListDetail = [[GYOrderManagerViewModel alloc]init];
   
    [self modelRequestNetwork:orderListDetail :^(id resultDic) {
        @strongify(self);
        if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
            [self notifyWithText:kLocalized(@"ChangeOrderInformationSuccess")];
            [self RequestOderDetailData];
        }else if([resultDic[@"retCode"] isEqualToNumber:@779]){
        [self notifyWithText:kLocalized(@"OrderCheckout, YouCanNotModifyTheOrder!")];
        }else{
            [self notifyWithText:kLocalized(@"SaveFailed!")];
            
        }
    } isIndicator:YES];
     [orderListDetail updateOrderWithParams:dic];
}
/**
 *  订单待确认
 *  @"userId"  用户ID
 *  @"orderId" 订单ID
 */

-(void)requestOrderInconfirm:(UIButton *)button{
    @weakify(self);
    GYOrderManagerViewModel *netLink = [[GYOrderManagerViewModel alloc] init];
    [button controlTimeOut];
    [self modelRequestNetwork:netLink :^(id resultDic) {
        @strongify(self);
        if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
            [self notifyWithText:kLocalizedAddParams(kLocalized(@"OrdersSuccess"), @"！")];
            [self performSelector:@selector(popBack) withObject:nil afterDelay:1];
        }else {
            [self notifyWithText:kLocalizedAddParams(kLocalized(@"OrdersFailure"), @"！")];
        }
        
    } isIndicator:YES];
    [netLink acceptOrderWithuserId:_infoDic[@"userId"] withOrderId:_infoDic[@"orderId"] withIsAccept:YES];
}
/**
 *  企业确认消费者用餐
 *  @"userId"  用户ID
 *  @"orderId" 订单ID
 */
-(void)requestOrderInConfirmToUse:(NSString *)tableNo with:(NSString*)tableNumber button:(UIButton *)button{
    @weakify(self);
    if (tableNo.length == 0 || tableNumber.length == 0) {
        [self notifyWithText:kLocalized(@"TheNumberOfUnitsOrTheNumberOfOpenTablesCanNotBeEmpty")];
        return;
    }
    
    if ([tableNumber integerValue] < 1) {
        [self notifyWithText:kLocalized(@"Thenumberofpeopleeatingatleast1")];
        return;
    }
    
//    if (![Utils checkIsNumber:tableNo]) {
//        [self notifyWithText:kLocalized(@"Tablenumbercannothaveillegalcharacters")];
//        return;
//    }
    
//    if (![self isRightUseTableNum:tableNumber]) {
//        return;
//    }
    
    GYOrderManagerViewModel *ordConfirm = [[GYOrderManagerViewModel alloc]init];
    [button controlTimeOut];
    [self modelRequestNetwork:ordConfirm :^(id resultDic) {
        @strongify(self);
        if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
            [self notifyWithText:kLocalized(@"SuccessfulOperation!")];
            [self performSelector:@selector(popBack) withObject:nil afterDelay:1];
        }else {
            
            [self notifyWithText:kLocalized(@"OperationFailed!")];
            
        }
    } isIndicator:YES];
    [ordConfirm orderInConfirmWithUseId:_infoDic[@"userId"] ordId:_infoDic[@"orderId"] tableNo:tableNo tableNumber:tableNumber];
}
/**
 *  消费者取消订单接口
 *  @"userId"  用户ID
 *  @"orderId" 订单ID
 */
-(void)requestOrderICustomerCancel:(UIButton *)button{
     @weakify(self);
    GYOrderManagerViewModel *netLink = [[GYOrderManagerViewModel alloc] init];
    [button controlTimeOut];
    [self modelRequestNetwork:netLink :^(id resultDic) {
        @strongify(self);
        if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
            
            [self notifyWithText:kLocalized(@"CancelSuccess!")];
            [self performSelector:@selector(popBack) withObject:nil afterDelay:1];
        }else{
            [self notifyWithText:kLocalized(@"CancelFailed!")];
            
        }
    } isIndicator:YES];
    [netLink cancelOrderValidateWithUserId:_infoDic[@"userId"] orderId:_infoDic[@"orderId"]];
}
/**
 *  待自提请求网络
 *  @"userId"     用户ID
 *  @"orderId"    订单ID
 *  @"orderType"  "1":"堂食";"2":"外卖","3":"堂食"
 */
-(void)requestOrderToGet:(UIButton *)button{
    @weakify(self);
    GYOrderManagerViewModel *netLink = [[GYOrderManagerViewModel alloc] init];
    [button controlTimeOut];
    [self modelRequestNetwork:netLink :^(id resultDic) {
        @strongify(self);
        if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
            [self notifyWithText:kLocalized(@"ReceivablesSuccess")];
            [self performSelector:@selector(popBack) withObject:nil afterDelay:1];
        }else{
            [self notifyWithText:kLocalized(@"ReceivablesFailure")];
        }
        
    }isIndicator:YES ];
    [netLink toGetWithOrderId:_infoDic[@"orderId"] userId:_infoDic[@"userId"] orderType:@"3"];
}
/**
 *  企业取消预定
 *  @"userId"              用户ID
 *  @"orderId"             订单ID
 *  @"moneyEarnsetRefund"  退还定金
 *  @"refundType"          退款类型
 *  @"cancelReason"        取消理由
 */

- (void)requestOrdercancelReservationsWithRefundType:(NSString*)refundType withMoneyEarnsetRefund:(NSString*)moneyEarnsetRefund withCancelReason:(NSString*)tftext{
//    NSString *regex = @"^[\u4e00-\u9fa5_,.!?，。！？a-zA-Z0-9]+$";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    if (![pred evaluateWithObject:tftext]) {
//        [self notifyWithText:kLocalized(@"CancelGroundsOnlyByChineseCharacters, Letters, NumbersAndPunctuation, PleaseRe-enter")];
//        return;
//    }
    
    @weakify(self);
    GYOrderManagerViewModel *netLink = [[GYOrderManagerViewModel alloc] init];
    [self modelRequestNetwork:netLink :^(id resultDic) {
        @strongify(self);
        if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
            [self notifyWithText:kLocalized(@"CancelSuccess!")];
            [self performSelector:@selector(popBack) withObject:nil afterDelay:1];
        }else{
        [self notifyWithText:kLocalized(@"CancelFailed!")];
        }
    } isIndicator:YES];
    [netLink cancelReservationswithUserId:_infoDic[@"userId"] withOrderId:_infoDic[@"orderId"] withMoneyEarnsetRefund:moneyEarnsetRefund WithRefundType:refundType withCancelReason:tftext];
}
/**
 *  企业自取取消预定
 *  @"userId"  用户ID
 *  @"orderId" 订单ID
 */
- (void)requestOrdercancelReservation{
    @weakify(self);
    GYOrderManagerViewModel *netLink = [[GYOrderManagerViewModel alloc] init];
    [self modelRequestNetwork:netLink :^(id resultDic) {
        if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
            @strongify(self);
            [self notifyWithText:kLocalized(@"SuccessToCancelTheOrderConfirmation")];
            [self performSelector:@selector(popBack) withObject:nil afterDelay:1];
        }
    } isIndicator:YES];
    [netLink requestOrdercancelReservationWithUserId:_infoDic[@"userId"] withOrder:_infoDic[@"orderId"]];
}
#pragma mark - 四舍五入处理方法
- (NSString *)siSheWuRuwithString:(NSString *)string
{
    float fstring = [string floatValue];
    NSString *sstring = [NSString stringWithFormat:@"%.2f",fstring];
    fstring = [sstring floatValue];
    fstring = roundf(fstring*10);
    fstring = fstring*.1;
    sstring = [NSString stringWithFormat:@"%.2f",fstring];
    return sstring;
}

@end
