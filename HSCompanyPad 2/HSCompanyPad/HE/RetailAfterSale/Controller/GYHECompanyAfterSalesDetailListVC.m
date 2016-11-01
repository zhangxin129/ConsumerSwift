//
//  GYHECompanyAfterSalesDetailListVC.m
//
//  Created by 吴文超 on 16/8/10.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHECompanyAfterSalesDetailListVC.h"
#import "GYHEAfterSaleListTopPartView.h"
#import "GYHERetailOrderComonHeader.h"
//临时借用
//#import "GYHERetailOrderCommonCell.h"
#import "GYHERetailAfterSaleListCommonCell.h"
#import "GYHECheckListSixSubTitleView.h"
#import "GYHESaleAfterModel.h"
#import "GYHSPointHttpTool.h"
#import <MJExtension/MJExtension.h>
#import "GYHEReturnGoodsVC.h"
#import "GYHSCunsumeTextField.h"
#import "GYDatePickView.h"
#import "GYHSPublicMethod.h"
#import "GYHSPublicMethod.h"
#define kCheckViewHeight kDeviceProportion(38)
#define kCheckViewBackgroundHeight kDeviceProportion(12)
#define kSmallImageWideHeight  kDeviceProportion(15)

#define kRemoveViewTag 1011
#define kRemoveNoMessage 1233
static NSString* idCell = @"retailOrderCommonCell";
@interface GYHECompanyAfterSalesDetailListVC ()<GYHEAfterSaleListTopPartViewDelegate,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, GYHETransDataDelegate,GYNetworkReloadDelete>

@property (nonatomic, strong) UIImageView* topBackView;
@property (nonatomic, strong) UITableView* tableView;
//GYHEAfterSaleListTopPartView
@property (nonatomic, strong) UITextField* inputSerialNumberTextField;
@property (nonatomic, strong) UITextField* inputAfterSaleServiceNumberTextField;
@property (nonatomic, strong) GYHEAfterSaleListTopPartView* checkView;

@property (nonatomic, strong) UITextField* orderNumTextField;
@property (nonatomic, strong) UITextField* swipeCardOrInputNum;
@property (nonatomic, strong) UITextField* allSaleOrderTextField;
@property (nonatomic, strong) GYHSCunsumeTextField* startDateTextField;
@property (nonatomic, strong) GYHSCunsumeTextField* endDateTextField;
@property (nonatomic, strong) UIButton* queryButton;
@property (nonatomic, strong) NSMutableArray* returnDataArray;  //线下退货数据源
@property (nonatomic, strong) GYHECheckListSixSubTitleView* headerView;
@end

@implementation GYHECompanyAfterSalesDetailListVC

#pragma mark - lazy load
- (NSMutableArray *)returnDataArray{
    if (!_returnDataArray) {
        _returnDataArray = [[NSMutableArray alloc] init];
    }
    return _returnDataArray;
}

- (UIView*)topBackView
{
    if (!_topBackView) {
        _topBackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gycom_safe_queryBakcground"]];
        _topBackView.userInteractionEnabled = YES;
    }
    return _topBackView;
}

- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHERetailOrderCommonCell class]) bundle:nil] forCellReuseIdentifier:idCell];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kWhiteFFFFFF;
    }
    return _tableView;
}

//这段代码不起作用
//- (UITextField*)orderNumTextField
//{
//    if (!_orderNumTextField) {
//        _orderNumTextField = [[UITextField alloc] init];
//        _orderNumTextField.textColor = kGrayCCCCCC;
//        _orderNumTextField.font = kFont24;
//        _orderNumTextField.keyboardType = UIKeyboardTypeNumberPad;
//        _orderNumTextField.placeholder = @"订单编号";
//        _orderNumTextField.delegate = self;
//        _orderNumTextField.leftViewMode = UITextFieldViewModeAlways;
//        UIImageView* leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
//        _orderNumTextField.leftView = leftView;
//    }
//    return _orderNumTextField;
//}
#pragma mark-----添加一个扫码器
- (UITextField*)swipeCardOrInputNum
{
    if (!_swipeCardOrInputNum) {
        _swipeCardOrInputNum = [[UITextField alloc] init];
        _swipeCardOrInputNum.textColor = kGrayCCCCCC;
        _swipeCardOrInputNum.font = kFont24;
        if (self.checkType == kUntreatedAfterSaleOrder || self.checkType == kOfflineTransactionReturnGoods) {
            _swipeCardOrInputNum.placeholder = @"请刷卡或输入互生卡号";
        }
        else
        {
        _swipeCardOrInputNum.placeholder = @"05 001 08 1408";
        }
        _swipeCardOrInputNum.delegate = self;
        _swipeCardOrInputNum.keyboardType = UIKeyboardTypeNumberPad;
        _swipeCardOrInputNum.leftViewMode = UITextFieldViewModeAlways;
        UIImageView* leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        _swipeCardOrInputNum.leftView = leftView;
        _swipeCardOrInputNum.userInteractionEnabled = YES;
        //_swipeCardOrInputNum.layer.cornerRadius = 0.1;
        _swipeCardOrInputNum.layer.borderWidth = 1;
        _swipeCardOrInputNum.layer.borderColor = kGrayDDDDDD.CGColor;
        //cornerRadius
        
        if (self.checkType == kUntreatedAfterSaleOrder || self.checkType == kOfflineTransactionReturnGoods) {
        UIButton* swipeBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_swipeCardOrInputNum addSubview:swipeBut];
        //@weakify(self);
        [swipeBut mas_makeConstraints:^(MASConstraintMaker* make) {
            //@strongify(self);
            make.right.equalTo(_swipeCardOrInputNum).offset(-kDeviceProportion(5));
            make.centerY.equalTo(_swipeCardOrInputNum.mas_centerY);
            make.width.equalTo(@(kSmallImageWideHeight));
            make.height.equalTo(@(kSmallImageWideHeight));
        }];
        [swipeBut setImage:[UIImage imageNamed:@"gyhe_swipeCard_small_btn"] forState:UIControlStateNormal];
        [swipeBut addTarget:self action:@selector(clickSwipeBtn) forControlEvents:UIControlEventTouchUpInside];
        }

    }
    return _swipeCardOrInputNum;
}
#pragma mark----- 一个流水号输入框
-(UITextField *)inputSerialNumberTextField{
    if (!_inputSerialNumberTextField) {
        _inputSerialNumberTextField = [[UITextField alloc] init];
        _inputSerialNumberTextField.textColor = kGrayCCCCCC;
        _inputSerialNumberTextField.font = kFont24;
        _inputSerialNumberTextField.placeholder = @"请输入流水号";
        _inputSerialNumberTextField.delegate = self;
        _inputSerialNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
        _inputSerialNumberTextField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView* leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        _inputSerialNumberTextField.leftView = leftView;
        _inputSerialNumberTextField.userInteractionEnabled = YES;
        _inputSerialNumberTextField.layer.borderWidth = 1;
        _inputSerialNumberTextField.layer.borderColor = kGrayDDDDDD.CGColor;
        
    }
    return _inputSerialNumberTextField;
}

#pragma mark-----售后单号
-(UITextField *)inputAfterSaleServiceNumberTextField{
    if (!_inputAfterSaleServiceNumberTextField) {
        _inputAfterSaleServiceNumberTextField = [[UITextField alloc] init];
        _inputAfterSaleServiceNumberTextField.textColor = kGrayCCCCCC;
        _inputAfterSaleServiceNumberTextField.font = kFont24;
        _inputAfterSaleServiceNumberTextField.placeholder = @"请输入售后单号";
        _inputAfterSaleServiceNumberTextField.delegate = self;
        _inputAfterSaleServiceNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
        _inputAfterSaleServiceNumberTextField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView* leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        _inputAfterSaleServiceNumberTextField.leftView = leftView;
        _inputAfterSaleServiceNumberTextField.userInteractionEnabled = YES;
        _inputAfterSaleServiceNumberTextField.layer.borderWidth = 1;
        _inputAfterSaleServiceNumberTextField.layer.borderColor = kGrayDDDDDD.CGColor;
        
    }
    return _inputAfterSaleServiceNumberTextField;
}


- (UITextField*)startDateTextField
{
    if (!_startDateTextField) {
        _startDateTextField = [[GYHSCunsumeTextField alloc] init];
        _startDateTextField.textColor = kGrayCCCCCC;
        _startDateTextField.font = kFont24;
        _startDateTextField.placeholder = @"开始日期";
        _startDateTextField.delegate = self;
        _startDateTextField.userInteractionEnabled = YES;
        _startDateTextField.multipleTouchEnabled = YES;
        _startDateTextField.rightViewMode = UITextFieldViewModeAlways;
        _startDateTextField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView* leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        _startDateTextField.leftView = leftView;
        UIImageView* rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gycom_date_icon"]];
        rightView.userInteractionEnabled = YES;
        rightView.contentMode = UIViewContentModeCenter;
        rightView.frame = CGRectMake(0, 0, kDeviceProportion(25), kDeviceProportion(25));
        rightView.userInteractionEnabled = YES;
        
        _startDateTextField.rightView = rightView;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] init];
        tap.delegate = self;
        [_startDateTextField addGestureRecognizer:tap];
        _startDateTextField.layer.borderWidth = 1;
        _startDateTextField.layer.borderColor = kGrayDDDDDD.CGColor;
    }
    return _startDateTextField;
}

- (UITextField*)endDateTextField
{
    if (!_endDateTextField) {
        _endDateTextField = [[GYHSCunsumeTextField alloc] init];
        _endDateTextField.textColor = kGrayCCCCCC;
        _endDateTextField.font = kFont24;
        _endDateTextField.placeholder = @"结束日期";
        _endDateTextField.delegate = self;
        _endDateTextField.rightViewMode = UITextFieldViewModeAlways;
        _endDateTextField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView* leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        _endDateTextField.leftView = leftView;
        UIImageView* rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gycom_date_icon"]];
        rightView.contentMode = UIViewContentModeCenter;
        rightView.frame = CGRectMake(0, 0, kDeviceProportion(25), kDeviceProportion(25));
        rightView.userInteractionEnabled = YES;
        _endDateTextField.rightView = rightView;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] init];
        tap.delegate = self;
        [_endDateTextField addGestureRecognizer:tap];
        _endDateTextField.layer.borderWidth = 1;
        _endDateTextField.layer.borderColor = kGrayDDDDDD.CGColor;
    }
    return _endDateTextField;
}

- (UITextField*)allSaleOrderTextField
{
    if (!_allSaleOrderTextField) {
        _allSaleOrderTextField = [[UITextField alloc] init];
        _allSaleOrderTextField.textColor = kGrayCCCCCC;
        _allSaleOrderTextField.font = kFont24;
        _allSaleOrderTextField.placeholder = @"全部";
        _allSaleOrderTextField.delegate = self;
        _allSaleOrderTextField.rightViewMode = UITextFieldViewModeAlways;
        _allSaleOrderTextField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView* leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        _allSaleOrderTextField.leftView = leftView;
        UIImageView* rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gycom_blue_pullDowm"]];
        rightView.contentMode = UIViewContentModeCenter;
        rightView.frame = CGRectMake(0, 0, kDeviceProportion(25), kDeviceProportion(25));
        rightView.userInteractionEnabled = YES;
        _allSaleOrderTextField.rightView = rightView;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] init];
        tap.delegate = self;
        [_allSaleOrderTextField addGestureRecognizer:tap];
        _allSaleOrderTextField.layer.borderWidth = 1;
        _allSaleOrderTextField.layer.borderColor = kGrayDDDDDD.CGColor;
    }
    return _allSaleOrderTextField;
}

- (UIButton*)queryButton
{
    if (!_queryButton) {
        _queryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_queryButton setTitleColor:kRedE50012 forState:UIControlStateNormal];
        [_queryButton setTitle:@"查询" forState:UIControlStateNormal];
        _queryButton.titleLabel.font = kFont28;
        [_queryButton setImage:[UIImage imageNamed:@"gycom_search_icon"] forState:UIControlStateNormal];
        [_queryButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _queryButton;
}

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
}

// #pragma mark - SystemDelegate
// #pragma mark TableView Delegate
// #pragma mark - CustomDelegate
// #pragma mark - event response

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"售后");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = kBlue0A59C2;
    
    //第一个上部4个状态选择器
    GYHEAfterSaleListTopPartView * checkView = [[GYHEAfterSaleListTopPartView alloc]initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kCheckViewHeight + kCheckViewBackgroundHeight)];
    checkView.delegate = self;
    UIColor *checkColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"gyhs_point_fold1"]];
    checkView.backgroundColor = checkColor;
    [self.view addSubview:checkView];
    self.checkView = checkView;
    
    self.checkType = kUntreatedAfterSaleOrder; //先进行默认处理
    [self setUpTheSecondAndThirdPartContentWith:self.checkType];
    
}

#pragma mark-----根据状态进行添加第二部分和第三部分的自定义菜单栏
-(void)setUpTheSecondAndThirdPartContentWith:(kListViewCheck)type{
    //添加之前先进行清除
    for (int i = 0; i < 3; i++) {
        UIView* view = [self.view viewWithTag:kRemoveViewTag];
        if (view) {
            [view removeFromSuperview];
        }
        
    }
    _swipeCardOrInputNum = nil;
    _inputSerialNumberTextField = nil;
    _inputAfterSaleServiceNumberTextField = nil;
    _topBackView = nil;
    _tableView = nil;
    //先进行状态判断 再进行添加
    if (self.checkType == kUntreatedAfterSaleOrder || self.checkType == kDidtreatedAfterSaleOrder) {
        //添加中间部分
        
        [self.view addSubview:self.topBackView];
        self.topBackView.tag = kRemoveViewTag;
        @weakify(self);
        [self.topBackView mas_makeConstraints:^(MASConstraintMaker* make) {
            @strongify(self);
            make.left.right.equalTo(self.view);
            make.top.equalTo(_checkView.mas_bottom);
            make.height.equalTo(@(kDeviceProportion(48)));
        }];
        [self addTopView];  //添加细节内容

        //添加子标题
        GYHECheckListSixSubTitleView* headerView = [[GYHECheckListSixSubTitleView alloc] init];
        headerView.tag = kRemoveViewTag;
        UIColor *headerViewColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"gyhs_point_fold3"]];
        headerView.backgroundColor = headerViewColor;
        [headerView setSixCommonTitle];
        self.headerView = headerView;
        
        [self.view addSubview:headerView];
        [headerView mas_makeConstraints:^(MASConstraintMaker* make) {
            @strongify(self);
            make.top.equalTo(self.topBackView.mas_bottom);
            make.left.equalTo(self.view).offset(kDeviceProportion(10));
            make.right.equalTo(self.view).offset(kDeviceProportion(-10));
            make.height.equalTo(@(kDeviceProportion(30)));
        }];
        
        //添加表格
        [self.view addSubview:self.tableView];
        self.tableView.tag = kRemoveViewTag;
        [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
            @strongify(self);
            make.top.equalTo(headerView.mas_bottom);
            make.left.equalTo(self.view).offset(kDeviceProportion(10));
            make.right.equalTo(self.view).offset(kDeviceProportion(-10));
            make.bottom.equalTo(self.view);
        }];

    }
#pragma mark-----全部售后单的状态
                  //判断是否是全部售后单的状态切换
    else if (self.checkType == kAllAfterSaleOrder) {
        //添加中间部分
        
        [self.view addSubview:self.topBackView];
        self.topBackView.tag = kRemoveViewTag;
        @weakify(self);
        [self.topBackView mas_makeConstraints:^(MASConstraintMaker* make) {
            @strongify(self);
            make.left.right.equalTo(self.view);
            make.top.equalTo(_checkView.mas_bottom);
            make.height.equalTo(@(kDeviceProportion(48)));
        }];
        [self addTopViewAnotherMethod];  //添加细节内容
        
        //添加子标题
        GYHECheckListSixSubTitleView* headerView = [[GYHECheckListSixSubTitleView alloc] init];
        headerView.tag = kRemoveViewTag;
        UIColor *headerViewColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"gyhs_point_fold3"]];
        headerView.backgroundColor = headerViewColor;
        self.headerView = headerView;
         [headerView setSixCommonTitle];
        
        
        [self.view addSubview:headerView];
        [headerView mas_makeConstraints:^(MASConstraintMaker* make) {
            @strongify(self);
            make.top.equalTo(self.topBackView.mas_bottom);
            make.left.equalTo(self.view).offset(kDeviceProportion(10));
            make.right.equalTo(self.view).offset(kDeviceProportion(-10));
            make.height.equalTo(@(kDeviceProportion(30)));
        }];
        
        //添加表格
        [self.view addSubview:self.tableView];
        self.tableView.tag = kRemoveViewTag;
        [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
            @strongify(self);
            make.top.equalTo(headerView.mas_bottom);
            make.left.equalTo(self.view).offset(kDeviceProportion(10));
            make.right.equalTo(self.view).offset(kDeviceProportion(-10));
            make.bottom.equalTo(self.view);
        }];

    }
#pragma mark-----线下交易退货的状态
    //线下交易退货
    else if (self.checkType == kOfflineTransactionReturnGoods){
        
        [self.view addSubview:self.topBackView];
        self.topBackView.tag = kRemoveViewTag;
        @weakify(self);
        [self.topBackView mas_makeConstraints:^(MASConstraintMaker* make) {
            @strongify(self);
            make.left.right.equalTo(self.view);
            make.top.equalTo(_checkView.mas_bottom);
            make.height.equalTo(@(kDeviceProportion(48)));
        }];
        [self addTopViewTheThirdMethod];  //添加细节内容
        
        //添加子标题
        GYHECheckListSixSubTitleView* headerView = [[GYHECheckListSixSubTitleView alloc] init];
        headerView.tag = kRemoveViewTag;
        UIColor *headerViewColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"gyhs_point_fold3"]];
        headerView.backgroundColor = headerViewColor;
        [headerView setSixTitle];
        self.headerView = headerView;
        
        
        [self.view addSubview:headerView];
        [headerView mas_makeConstraints:^(MASConstraintMaker* make) {
            @strongify(self);
            make.top.equalTo(self.topBackView.mas_bottom);
            make.left.equalTo(self.view).offset(kDeviceProportion(10));
            make.right.equalTo(self.view).offset(kDeviceProportion(-10));
            make.height.equalTo(@(kDeviceProportion(30)));
        }];
        
        //添加表格
        [self.view addSubview:self.tableView];
        self.tableView.tag = kRemoveViewTag;
        [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
            @strongify(self);
            make.top.equalTo(headerView.mas_bottom);
            make.left.equalTo(self.view).offset(kDeviceProportion(10));
            make.right.equalTo(self.view).offset(kDeviceProportion(-10));
            make.bottom.equalTo(self.view);
        }];
    }
}



- (void)addTopView
{

    
    //可以做多种状态判断
    //小图片
//    UIImageView* imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhe_cardreader_small_icon"]];
    UIImageView* imageV = [[UIImageView alloc] init];
    if (self.checkType == kUntreatedAfterSaleOrder) {
        imageV.image = [UIImage imageNamed:@"gyhe_cardreader_small_icon"];
    }
    //imageV.backgroundColor = [UIColor clearColor];
    [self.topBackView addSubview:imageV];
    //imageV.tag = kRemoveViewTag;
    @weakify(self);
    [imageV mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.left.equalTo(self.view).offset(kDeviceProportion(218));
        make.centerY.equalTo(_topBackView.mas_centerY);
        make.width.equalTo(@(kSmallImageWideHeight));
        make.height.equalTo(@(kSmallImageWideHeight));
    }];
    
    //添加 互生号 手机号 并加上扫码小图片
    [self.topBackView addSubview:self.swipeCardOrInputNum];
    //self.swipeCardOrInputNum.tag = kRemoveViewTag;
    [self.swipeCardOrInputNum mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.left.equalTo(imageV.mas_right).offset(kDeviceProportion(10));
//        make.top.equalTo(_topBackView).offset(kDeviceProportion(11));
        make.centerY.equalTo(_topBackView.mas_centerY);
        make.width.equalTo(@(kDeviceProportion(210)));
        make.height.equalTo(@(kDeviceProportion(25)));
    }];
    
    
    //输入流水号
    [self.topBackView addSubview:self.inputSerialNumberTextField];
   // self.inputSerialNumberTextField.tag = kRemoveViewTag;
    [self.inputSerialNumberTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(_swipeCardOrInputNum.mas_right).offset(kDeviceProportion(10));
//        make.top.equalTo(_topBackView).offset(kDeviceProportion(11));
        make.centerY.equalTo(_topBackView.mas_centerY);
        make.width.equalTo(@(kDeviceProportion(165)));
        make.height.equalTo(@(kDeviceProportion(25)));
    }];
    
    //输入售后单号
    [self.topBackView addSubview:self.inputAfterSaleServiceNumberTextField];
    //self.inputAfterSaleServiceNumberTextField.tag = kRemoveViewTag;
    [self.inputAfterSaleServiceNumberTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(_inputSerialNumberTextField.mas_right).offset(kDeviceProportion(10));
//        make.top.equalTo(_topBackView).offset(kDeviceProportion(11));
        make.centerY.equalTo(_topBackView.mas_centerY);
        make.width.equalTo(@(kDeviceProportion(125)));
        make.height.equalTo(@(kDeviceProportion(25)));
    }];
    
    
//    //订单状态
//    [self.topBackView addSubview:self.allSaleOrderTextField];
//    [self.allSaleOrderTextField mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.left.equalTo(_swipeCardOrInputNum.mas_right).offset(kDeviceProportion(10));
//        make.top.equalTo(_topBackView).offset(kDeviceProportion(11));
//        make.width.equalTo(@(kDeviceProportion(160)));
//        make.height.equalTo(@(kDeviceProportion(25)));
//    }];
    
//    //开始日期
//    [self.topBackView addSubview:self.startDateTextField];
//    [self.startDateTextField mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.left.equalTo(_allSaleOrderTextField.mas_right).offset(kDeviceProportion(10));
//        make.top.equalTo(_topBackView).offset(kDeviceProportion(11));
//        make.width.equalTo(@(kDeviceProportion(125)));
//        make.height.equalTo(@(kDeviceProportion(25)));
//    }];
//    
//    //结束日期
//    [self.topBackView addSubview:self.endDateTextField];
//    [self.endDateTextField mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.left.equalTo(_startDateTextField.mas_right).offset(kDeviceProportion(10));
//        make.top.equalTo(_topBackView).offset(kDeviceProportion(11));
//        make.width.equalTo(@(kDeviceProportion(125)));
//        make.height.equalTo(@(kDeviceProportion(25)));
//    }];
    
    
    //查询按钮
    [self.topBackView addSubview:self.queryButton];
    //self.queryButton.tag = kRemoveViewTag;
    [self.queryButton mas_makeConstraints:^(MASConstraintMaker* make) {
        //@strongify(self);
        make.left.equalTo(_inputAfterSaleServiceNumberTextField.mas_right).offset(kDeviceProportion(10));
//        make.top.equalTo(_topBackView).offset(kDeviceProportion(11));
        make.centerY.equalTo(_topBackView.mas_centerY);
        //make.right.equalTo(self.view).offset(kDeviceProportion(-40));
        make.height.equalTo(@(kDeviceProportion(20)));
        make.width.equalTo(@(kDeviceProportion(50)));
    }];
}
//添加头部状态的第二种方法
-(void)addTopViewAnotherMethod{
    //添加 互生号 手机号 并加上扫码小图片
    [self.topBackView addSubview:self.swipeCardOrInputNum];
    //self.swipeCardOrInputNum.tag = kRemoveViewTag;
    @weakify(self);
    [self.swipeCardOrInputNum mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.left.equalTo(self.view).offset(kDeviceProportion(180));
        //        make.top.equalTo(_topBackView).offset(kDeviceProportion(11));
        make.centerY.equalTo(_topBackView.mas_centerY);
        make.width.equalTo(@(kDeviceProportion(200)));
        make.height.equalTo(@(kDeviceProportion(25)));
    }];
    
    
    //输入流水号
    [self.topBackView addSubview:self.inputSerialNumberTextField];
    //self.inputSerialNumberTextField.tag = kRemoveViewTag;
    [self.inputSerialNumberTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(_swipeCardOrInputNum.mas_right).offset(kDeviceProportion(10));
        //        make.top.equalTo(_topBackView).offset(kDeviceProportion(11));
        make.centerY.equalTo(_topBackView.mas_centerY);
        make.width.equalTo(@(kDeviceProportion(165)));
        make.height.equalTo(@(kDeviceProportion(25)));
    }];
    
    //输入售后单号
    [self.topBackView addSubview:self.inputAfterSaleServiceNumberTextField];
    //self.inputAfterSaleServiceNumberTextField.tag = kRemoveViewTag;
    [self.inputAfterSaleServiceNumberTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(_inputSerialNumberTextField.mas_right).offset(kDeviceProportion(10));
        //        make.top.equalTo(_topBackView).offset(kDeviceProportion(11));
        make.centerY.equalTo(_topBackView.mas_centerY);
        make.width.equalTo(@(kDeviceProportion(125)));
        make.height.equalTo(@(kDeviceProportion(25)));
    }];
    
    
        //全部状态
        [self.topBackView addSubview:self.allSaleOrderTextField];
    //self.allSaleOrderTextField.tag = kRemoveViewTag;
        [self.allSaleOrderTextField mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(_inputAfterSaleServiceNumberTextField.mas_right).offset(kDeviceProportion(10));
            make.centerY.equalTo(_topBackView.mas_centerY);
            make.width.equalTo(@(kDeviceProportion(125)));
            make.height.equalTo(@(kDeviceProportion(25)));
        }];
    //查询按钮
    [self.topBackView addSubview:self.queryButton];
    //self.queryButton.tag = kRemoveViewTag;
    [self.queryButton mas_makeConstraints:^(MASConstraintMaker* make) {
        //@strongify(self);
        make.left.equalTo(_allSaleOrderTextField.mas_right).offset(kDeviceProportion(10));
        //        make.top.equalTo(_topBackView).offset(kDeviceProportion(11));
        make.centerY.equalTo(_topBackView.mas_centerY);
        //make.right.equalTo(self.view).offset(kDeviceProportion(-40));
        make.height.equalTo(@(kDeviceProportion(20)));
        make.width.equalTo(@(kDeviceProportion(50)));
    }];
}

#pragma mark-----线下交易退货的第二部分的日期及菜单
-(void)addTopViewTheThirdMethod{
    UIImageView* imageV = [[UIImageView alloc] init];
    
    imageV.image = [UIImage imageNamed:@"gyhe_cardreader_small_icon"];
    
    //imageV.backgroundColor = [UIColor clearColor];
    [self.topBackView addSubview:imageV];
    //imageV.tag = kRemoveViewTag;
    @weakify(self);
    [imageV mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.left.equalTo(self.view).offset(kDeviceProportion(119));
        make.centerY.equalTo(_topBackView.mas_centerY);
        make.width.equalTo(@(kSmallImageWideHeight));
        make.height.equalTo(@(kSmallImageWideHeight));
    }];
    
    //添加 互生号 手机号 并加上扫码小图片
    [self.topBackView addSubview:self.swipeCardOrInputNum];
    //self.swipeCardOrInputNum.tag = kRemoveViewTag;
    [self.swipeCardOrInputNum mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.left.equalTo(imageV.mas_right).offset(kDeviceProportion(10));
        //        make.top.equalTo(_topBackView).offset(kDeviceProportion(11));
        make.centerY.equalTo(_topBackView.mas_centerY);
        make.width.equalTo(@(kDeviceProportion(200)));
        make.height.equalTo(@(kDeviceProportion(25)));
    }];
    
    
    //输入流水号
    [self.topBackView addSubview:self.inputSerialNumberTextField];
    // self.inputSerialNumberTextField.tag = kRemoveViewTag;
    [self.inputSerialNumberTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(_swipeCardOrInputNum.mas_right).offset(kDeviceProportion(10));
        //        make.top.equalTo(_topBackView).offset(kDeviceProportion(11));
        make.centerY.equalTo(_topBackView.mas_centerY);
        make.width.equalTo(@(kDeviceProportion(165)));
        make.height.equalTo(@(kDeviceProportion(25)));
    }];
    
    //添加label
    UILabel* label = [[UILabel alloc] init];
    label.text = @"交易日期";
    label.font = kFont20;
    label.textColor = kGray777777;
    label.backgroundColor = [UIColor clearColor];
    [self.topBackView addSubview:label];
    CGSize labelSize = [self giveLabelWith:label.font nsstring:label.text];
    [label mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(_inputSerialNumberTextField.mas_right).offset(kDeviceProportion(15));
        //        make.top.equalTo(_topBackView).offset(kDeviceProportion(11));
        make.centerY.equalTo(_topBackView.mas_centerY);
        make.width.equalTo(@(labelSize.width ));
        make.height.equalTo(@(labelSize.height));
    }];

    
        //开始日期
        [self.topBackView addSubview:self.startDateTextField];
        [self.startDateTextField mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(label.mas_right).offset(kDeviceProportion(5));
           // make.top.equalTo(_topBackView).offset(kDeviceProportion(11));
            make.centerY.equalTo(_topBackView.mas_centerY);
            make.width.equalTo(@(kDeviceProportion(125)));
            make.height.equalTo(@(kDeviceProportion(25)));
        }];
    
        //结束日期
        [self.topBackView addSubview:self.endDateTextField];
        [self.endDateTextField mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(_startDateTextField.mas_right).offset(kDeviceProportion(10));
          //make.top.equalTo(_topBackView).offset(kDeviceProportion(11));
            make.centerY.equalTo(_topBackView.mas_centerY);
            make.width.equalTo(@(kDeviceProportion(125)));
            make.height.equalTo(@(kDeviceProportion(25)));
        }];

    //查询按钮
    [self.topBackView addSubview:self.queryButton];
    //self.queryButton.tag = kRemoveViewTag;
    [self.queryButton mas_makeConstraints:^(MASConstraintMaker* make) {
        //@strongify(self);
        make.left.equalTo(_endDateTextField.mas_right).offset(kDeviceProportion(10));
        //        make.top.equalTo(_topBackView).offset(kDeviceProportion(11));
        make.centerY.equalTo(_topBackView.mas_centerY);
        //make.right.equalTo(self.view).offset(kDeviceProportion(-40));
        make.height.equalTo(@(kDeviceProportion(20)));
        make.width.equalTo(@(kDeviceProportion(50)));
    }];

}



#pragma mark - event
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    UIView* view = [self.view viewWithTag:kRemoveNoMessage];
    if (view) {
        [view removeFromSuperview];
    }
    if (self.returnDataArray.count == 0) {
        UIView *viewC = [GYHSPublicMethod addNoDataTipViewWithSuperView:self.view];
        viewC.frame = self.tableView.frame;
        @weakify(self);
        [viewC mas_makeConstraints:^(MASConstraintMaker* make) {
            @strongify(self);
            make.top.equalTo(_headerView.mas_bottom);
            make.left.equalTo(self.view).offset(kDeviceProportion(10));
            make.right.equalTo(self.view).offset(kDeviceProportion(-10));
            make.bottom.equalTo(self.view);
        }];
        viewC.tag = kRemoveNoMessage;
    }
    if (self.checkType == kOfflineTransactionReturnGoods) {
        return self.returnDataArray.count;
    }else{
        return 20;
    }
    
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    GYHERetailAfterSaleListCommonCell* cell =[GYHERetailAfterSaleListCommonCell cellWithTableView:tableView];
    cell.delegate = self;
    if (self.checkType == kOfflineTransactionReturnGoods) {
        
        GYHESaleAfterModel *model = self.returnDataArray[indexPath.row];
        cell.model = model;
        [cell createSixInformationWithserialNumber:[NSString stringWithFormat:@"%ld",(long)indexPath.row + 1] afterSaleServiceNumber:model.sourceTransNo amountOfMoney:model.sourceTransAmount accumulatedPoints:model.entPoint applicationTime:model.sourceTransDate stateType:@"退货"];
    }
    else
    {
    [cell createEightInformationWithOrderNumber:@"12861048040735744" operatingAdress:@"广东省深圳市福中路福科二路15号" serialNumber:@"1001" afterSaleServiceNumber:@"12861048040735744" HSNumber:@"05 001 08 1408" applicationType:@"退货退款" applicationTime:@"2016-07-08 12:10" stateType:@"处理申请"];
    }
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (self.checkType == kUntreatedAfterSaleOrder ||self.checkType == kDidtreatedAfterSaleOrder || self.checkType == kAllAfterSaleOrder ) {
        return kDeviceProportion(122);
    }else
    {
    return kDeviceProportion(30);
    }
    
}

#pragma mark - request
- (void)requestReturnList{
    
    if (_swipeCardOrInputNum.text.length != 11) {
        [_swipeCardOrInputNum tipWithContent:kLocalized(@"GYHE_AfterSale_PleaseEnterTheCorrectHSNumber") animated:YES];
        return;
    }
    if (_startDateTextField.text.length == 0) {
        [_startDateTextField tipWithContent:kLocalized(@"GYHE_AfterSale_PleaseSelectStartDate") animated:YES];
        return;

    }
    
   // @weakify(self);
    //互生卡
//    NSString * cardStr = [self.cardView.textfield deleteSpaceField];
    //业务类型（11：查询撤单，12：查询退货）
//    NSDate * nowDate = [NSDate date];
//    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"YYYY-MM-dd"];
//    NSString *  locationString=[dateformatter stringFromDate:nowDate];
    [self httpRequest];
    
}
/**
 *  网络请求
 */
-(void)httpRequest{
    [GYNetwork sharedInstance].delegate = self;
    @weakify(self);
    [GYHSPointHttpTool checkPointWithEntCustId:globalData.loginModel.entCustId hsResNo:_swipeCardOrInputNum.text startDate:self.startDateTextField.text businessType:@"12" curPage:@"1" pageSize:@"10000" success:^(id responsObject) {
        @strongify(self);
        [self.returnDataArray removeAllObjects];
        if (responsObject[GYNetWorkDataKey]) {
            NSArray * array = responsObject[GYNetWorkDataKey];
            for (NSDictionary * temp in array) {
                GYHESaleAfterModel *model = [GYHESaleAfterModel mj_objectWithKeyValues:temp];
                //                GYHESaleAfterModel *model = [[GYHESaleAfterModel alloc] initWithDictionary:temp error:nil];
                [self.returnDataArray addObject:model];
            }
        }
        [self.tableView reloadData];
        
    } failure:^{
        
    }];
}
/**
 *  无网络上盖视图点击重新加载
 */
- (void)gyNetworkDidTapReloadBtn
{
    [self httpRequest];
}

-(void)clickSwipeBtn{
    DDLogInfo(@"点击了扫码按钮");
}

-(void)searchAction{
    DDLogInfo(@"搜索按钮被点击了");
    if (self.checkType == kOfflineTransactionReturnGoods) {
        [self requestReturnList];
    }
}

- (void)click:(NSInteger)index
{   //DDLogInfo(@"index = %ld",index);
    self.checkType = index;
    [self setUpTheSecondAndThirdPartContentWith:self.checkType];
   // DDLogInfo(@"self.checkType = %ld",self.checkType);
}


- (CGSize)giveLabelWith:(UIFont*)fnt nsstring:(NSString*)string
{
    UILabel* label = [[UILabel alloc] init];
    
    label.text = string;
    
    
    return [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
}

#pragma  mark -- GYHETransDataDelegate
-(void)transReturnModel:(GYHESaleAfterModel *)model{
    GYHEReturnGoodsVC *returnGoodsVC = [[GYHEReturnGoodsVC alloc] init];
    returnGoodsVC.model = model;
    [self.navigationController pushViewController:returnGoodsVC animated:YES];
}
#pragma mark-UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.startDateTextField || textField == self.endDateTextField) {
        [textField endEditing:YES];
        [textField resignFirstResponder];
        if (textField == self.startDateTextField) {
            GYDatePickView * dateView = [[GYDatePickView alloc]initWithDatePickViewType:DatePickViewTypeDate];
            [dateView show];
            @weakify(self);
            dateView.dateBlcok = ^(NSString *dateString){
                @strongify(self);
                NSString * string = [GYHSPublicMethod compareWithTimeString:dateString];
                BOOL isRight = [GYHSPublicMethod compareWithDateString:string ohterDateString:self.endDateTextField.text];
                if (isRight) {
                    self.startDateTextField.text = [GYHSPublicMethod compareWithTimeString:string];
                }else{
                    self.startDateTextField.text = @"";
                }
            };
        }
        if (textField == self.endDateTextField) {
            GYDatePickView * dateEndView = [[GYDatePickView alloc]initWithDatePickViewType:DatePickViewTypeDate];
            [dateEndView show];
            @weakify(self);
            dateEndView.dateBlcok = ^(NSString *dateString){
                @strongify(self);
                NSString * string = [GYHSPublicMethod compareWithTimeString:dateString];
                BOOL isRight = [GYHSPublicMethod compareWithDateString:self.startDateTextField.text ohterDateString:string];
                if (isRight) {
                    self.endDateTextField.text = string;
                }else{
                    self.endDateTextField.text = @"";
                }
            };
        }
    }
}

@end
