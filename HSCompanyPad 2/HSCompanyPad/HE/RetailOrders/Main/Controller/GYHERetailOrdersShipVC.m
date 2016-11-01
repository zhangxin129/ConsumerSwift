//
//  GYHERetailOrderOwnDeliveryVC.m
//
//  Created by apple on 16/8/8.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHERetailOrdersShipVC.h"
#import "GYHERetailOrderCommonCell.h"
#import "GYHERetailOrderComonHeader.h"

static NSString* idCell = @"retailOrderCommonCell";

@interface GYHERetailOrdersShipVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView* topBackView;
@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) UITextField* orderNumTextField;
@property (nonatomic, strong) UITextField* resNoOrPhoneTextField;
@property (nonatomic, strong) UITextField* orderStutasTextField;
@property (nonatomic, strong) UITextField* startDateTextField;
@property (nonatomic, strong) UITextField* endDateTextField;
@property (nonatomic, strong) UIButton* queryButton;

@end

@implementation GYHERetailOrdersShipVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDLogInfo(@"Show Controller: %@", [self class]);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.customBorderColor = kGrayCFCFDA;
    self.tableView.customBorderType = UIViewCustomBorderTypeLeft | UIViewCustomBorderTypeRight;
    
    self.orderNumTextField.customBorderColor = kGrayDDDDDD;
    self.orderNumTextField.customBorderType = UIViewCustomBorderTypeAll;
    
    self.resNoOrPhoneTextField.customBorderColor = kGrayDDDDDD;
    self.resNoOrPhoneTextField.customBorderType = UIViewCustomBorderTypeAll;
    
    self.startDateTextField.customBorderColor = kGrayDDDDDD;
    self.startDateTextField.customBorderType = UIViewCustomBorderTypeAll;
    
    self.endDateTextField.customBorderColor = kGrayDDDDDD;
    self.endDateTextField.customBorderType = UIViewCustomBorderTypeAll;
    
    self.orderStutasTextField.customBorderColor = kGrayDDDDDD;
    self.orderStutasTextField.customBorderType = UIViewCustomBorderTypeAll;
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
}

// #pragma mark - SystemDelegate
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHERetailOrderCommonCell* cell = [tableView dequeueReusableCellWithIdentifier:idCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 60.0;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    if (textField == self.endDateTextField || textField == self.startDateTextField || textField == self.orderStutasTextField) {
        return NO;
    }
    return YES;
}
#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
    
    if ([touch.view isKindOfClass:[UITextField class]] || [touch.view isKindOfClass:[UIView class]]) {
        
        id view = (UITextField*)touch.view;
        
        if (view == _startDateTextField || view == _startDateTextField.rightView) {
            //点击开始日期
            DDLogInfo(@"点击开始日期");
            return YES;
        }
        
        if (view == _endDateTextField || view == _endDateTextField.rightView) {
            //点击结束日期
            DDLogInfo(@"点击结束日期");
            return YES;
        }
        
        if (view == _orderStutasTextField || view == _orderStutasTextField.rightView) {
            //点击订单状态
            DDLogInfo(@"点击订单状态");
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - event response
- (void)searchAction
{
    [self.view endEditing:YES];
    DDLogInfo(@"搜索按钮");
}

//#pragma mark - request

#pragma mark - private methods
- (void)initView
{
    self.view.backgroundColor = kWhiteFFFFFF;
    DDLogInfo(@"Load Controller: %@", [self class]);
    
    [self.view addSubview:self.topBackView];
    [self.topBackView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(kDeviceProportion(48)));
    }];
    
    GYHERetailOrderComonHeader* headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHERetailOrderComonHeader class]) owner:self options:nil] lastObject];
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.topBackView.mas_bottom);
        make.left.equalTo(self.view).offset(kDeviceProportion(10));
        make.right.equalTo(self.view).offset(kDeviceProportion(-10));
        make.height.equalTo(@(kDeviceProportion(30)));
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.equalTo(self.view).offset(kDeviceProportion(10));
        make.right.equalTo(self.view).offset(kDeviceProportion(-10));
        make.bottom.equalTo(self.view);
    }];
    
    [self addTopView];
}

- (void)addTopView
{
    [self.topBackView addSubview:self.orderNumTextField];
    [self.orderNumTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(_topBackView).offset(kDeviceProportion(40));
        make.top.equalTo(_topBackView).offset(kDeviceProportion(11));
        make.width.equalTo(@(kDeviceProportion(223)));
        make.height.equalTo(@(kDeviceProportion(25)));
    }];
    
    [self.topBackView addSubview:self.resNoOrPhoneTextField];
    [self.resNoOrPhoneTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(_orderNumTextField.mas_right).offset(kDeviceProportion(10));
        make.top.equalTo(_topBackView).offset(kDeviceProportion(11));
        make.width.equalTo(@(kDeviceProportion(210)));
        make.height.equalTo(@(kDeviceProportion(25)));
    }];
    
    [self.topBackView addSubview:self.orderStutasTextField];
    [self.orderStutasTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(_resNoOrPhoneTextField.mas_right).offset(kDeviceProportion(10));
        make.top.equalTo(_topBackView).offset(kDeviceProportion(11));
        make.width.equalTo(@(kDeviceProportion(160)));
        make.height.equalTo(@(kDeviceProportion(25)));
    }];
    
    [self.topBackView addSubview:self.startDateTextField];
    [self.startDateTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(_orderStutasTextField.mas_right).offset(kDeviceProportion(10));
        make.top.equalTo(_topBackView).offset(kDeviceProportion(11));
        make.width.equalTo(@(kDeviceProportion(125)));
        make.height.equalTo(@(kDeviceProportion(25)));
    }];
    
    [self.topBackView addSubview:self.endDateTextField];
    [self.endDateTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(_startDateTextField.mas_right).offset(kDeviceProportion(10));
        make.top.equalTo(_topBackView).offset(kDeviceProportion(11));
        make.width.equalTo(@(kDeviceProportion(125)));
        make.height.equalTo(@(kDeviceProportion(25)));
    }];
    
    [self.topBackView addSubview:self.queryButton];
    [self.queryButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(_endDateTextField.mas_right).offset(kDeviceProportion(10));
        make.top.equalTo(_topBackView).offset(kDeviceProportion(11));
        make.right.equalTo(self.view).offset(kDeviceProportion(-40));
        make.height.equalTo(@(kDeviceProportion(25)));
    }];
}

#pragma mark - lazy load
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
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHERetailOrderCommonCell class]) bundle:nil] forCellReuseIdentifier:idCell];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kWhiteFFFFFF;
    }
    return _tableView;
}

- (UITextField*)orderNumTextField
{
    if (!_orderNumTextField) {
        _orderNumTextField = [[UITextField alloc] init];
        _orderNumTextField.textColor = kGrayCCCCCC;
        _orderNumTextField.font = kFont24;
        _orderNumTextField.keyboardType = UIKeyboardTypeNumberPad;
        _orderNumTextField.placeholder = @"订单编号";
        _orderNumTextField.delegate = self;
        _orderNumTextField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView* leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        _orderNumTextField.leftView = leftView;
    }
    return _orderNumTextField;
}

- (UITextField*)resNoOrPhoneTextField
{
    if (!_resNoOrPhoneTextField) {
        _resNoOrPhoneTextField = [[UITextField alloc] init];
        _resNoOrPhoneTextField.textColor = kGrayCCCCCC;
        _resNoOrPhoneTextField.font = kFont24;
        _resNoOrPhoneTextField.placeholder = @"输入互生号/手机号码";
        _resNoOrPhoneTextField.delegate = self;
        _resNoOrPhoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _resNoOrPhoneTextField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView* leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        _resNoOrPhoneTextField.leftView = leftView;
    }
    return _resNoOrPhoneTextField;
}

- (UITextField*)startDateTextField
{
    if (!_startDateTextField) {
        _startDateTextField = [[UITextField alloc] init];
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
    }
    return _startDateTextField;
}

- (UITextField*)endDateTextField
{
    if (!_endDateTextField) {
        _endDateTextField = [[UITextField alloc] init];
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
    }
    return _endDateTextField;
}

- (UITextField*)orderStutasTextField
{
    if (!_orderStutasTextField) {
        _orderStutasTextField = [[UITextField alloc] init];
        _orderStutasTextField.textColor = kGrayCCCCCC;
        _orderStutasTextField.font = kFont24;
        _orderStutasTextField.placeholder = @"订单状态";
        _orderStutasTextField.delegate = self;
        _orderStutasTextField.rightViewMode = UITextFieldViewModeAlways;
        _orderStutasTextField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView* leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        _orderStutasTextField.leftView = leftView;
        UIImageView* rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gycom_blue_pullDowm"]];
        rightView.contentMode = UIViewContentModeCenter;
        rightView.frame = CGRectMake(0, 0, kDeviceProportion(25), kDeviceProportion(25));
        rightView.userInteractionEnabled = YES;
        _orderStutasTextField.rightView = rightView;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] init];
        tap.delegate = self;
        [_orderStutasTextField addGestureRecognizer:tap];
    }
    return _orderStutasTextField;
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



@end
