//
//  GYHSMyPayYearFreeVC.m
//
//  Created by apple on 16/8/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMyPayYearFreeVC.h"
#import "GYHSMyPayYearFeeCell.h"
#import "GYHSMyPayYearFeeModel.h"
#import "GYNetwork.h"
#import "GYHSToolPayModel.h"
#import "GYPayViewController.h"

static NSString* idCell = @"myPayYearFeeCell";

@interface GYHSMyPayYearFreeVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* payYearTableView;
@property (nonatomic, strong) UILabel* rightTipLabel;
@property (nonatomic, strong) UIButton* payButton;
@property (nonatomic, strong) NSArray* titleArray;
@property (nonatomic, strong) NSArray* contentArray;
@property (nonatomic, strong) GYHSMyPayYearFeeModel* model;
@end

@implementation GYHSMyPayYearFreeVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    [self loadInitViewType:GYStopTypeLogout :^{
        @strongify(self);
        [self initView];
        [self loadYearFeeFromNetwork];
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDLogInfo(@"Show Controller: %@", [self class]);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.payYearTableView.customBorderColor = kGray7D7D7D;
    self.payYearTableView.customBorderLineWidth = @1;
    self.payYearTableView.customBorderType = UIViewCustomBorderTypeAll;
    
    self.rightTipLabel.customBorderColor = kGray7D7D7D;
    self.rightTipLabel.customBorderLineWidth = @0.5;
    self.rightTipLabel.customBorderType = UIViewCustomBorderTypeTop | UIViewCustomBorderTypeBottom | UIViewCustomBorderTypeRight;
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHSMyPayYearFeeCell* cell = [tableView dequeueReusableCellWithIdentifier:idCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = self.titleArray[indexPath.row];
    if (self.contentArray.count > 0) {
        cell.contentLabel.text = self.contentArray[indexPath.row];
    }
    if (indexPath.row == 0) {
        cell.contentLabel.textColor = kRedE50012;
    } else {
        cell.contentLabel.textColor = kGray333333;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return kDeviceProportion(40.0);
}

#pragma mark - event response
/*!
 *    去支付年费按钮
 */
- (void)payButtonAction
{
    [self getOrderNumber];
}

#pragma mark - request
/*!
 *    获取缴纳年费的订单号
 */
- (void)getOrderNumber{

    NSString* orderCashAmount = [@(self.model.annualfeePrice.doubleValue / globalData.config.currencyToHsbRate.doubleValue) stringValue];
    NSDictionary *dicParams = @{ @"orderCashAmount" : orderCashAmount,
                                 @"orderHsbAmount" : [@(self.model.annualfeePrice.doubleValue) stringValue],
                                 @"currencyCode" : globalData.config.currencyCode,
                                 @"orderOperator" : globalData.loginModel.custId,
                                 @"exchangeRate" : globalData.config.currencyToHsbRate,
                                 @"custType" : globalData.loginModel.entResType,
                                 @"areaStartDate" : self.model.areaStartDate,
                                 @"areaEndDate" : self.model.areaEndDate,
                                 @"custId" : globalData.loginModel.entCustId,
                                 @"custName" : globalData.loginModel.entCustName,
                                 @"hsResNo" : globalData.loginModel.entResNo,
                                 @"orderOriginalAmount" : self.model.annualfeePrice,
                                 @"orderChannel" : GYChannelType,
                                 @"orderDerateAmount" : self.model.annualfeePrice,
                                 };
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSCreateAnnualFeeOrder) parameter:dicParams success:^(id returnValue) {
        
        if ([returnValue[GYNetWorkCodeKey] isEqualToNumber:@200]) {
            GYHSToolPayModel *model = [[GYHSToolPayModel alloc] init];
            model.orderNo = kSaftToNSString(returnValue[GYNetWorkDataKey][@"orderNo"]);
            model.hsbAmount = kSaftToNSString(returnValue[GYNetWorkDataKey][@"orderCashAmount"]);
            GYPayViewController *vc = [[GYPayViewController alloc]initWithNibName:NSStringFromClass([GYPayViewController class]) bundle:nil];
            vc.model = model;
            vc.type = GYPaymentServiceTypePayAnnualFee;
            [self.navigationController pushViewController:vc animated:YES];
        }

        
    } failure:^(NSError *error) {
        
    } isIndicator:YES];
}

/*!
 *    请求年费信息
 */
- (void)loadYearFeeFromNetwork
{
    NSDictionary* dicParamas = @{
                                 @"entCustId" : globalData.loginModel.entCustId
                                 };
    @weakify(self);
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSGetAnnualFeeInfo)
         parameter:dicParamas
           success:^(id returnValue) {
               @strongify(self);
               if ([returnValue[GYNetWorkCodeKey] isEqualToNumber:@200]) {
                   self.model = [[GYHSMyPayYearFeeModel alloc] initWithDictionary:returnValue[GYNetWorkDataKey] error:nil];
                   [self tipMake];
                   self.contentArray = @[ [GYUtils formatCurrencyStyle:_model.hsbBalance.doubleValue],
                                          [GYUtils formatCurrencyStyle:_model.price.doubleValue],
                                          [GYUtils formatCurrencyStyle:_model.annualfeePrice.doubleValue],
                                          _model.endDate,
                                          [NSString stringWithFormat:@"%@~%@", _model.areaStartDate, _model.areaEndDate],
                                          @"互生币" ];
                   [self.payYearTableView reloadData];
               } else {
                   [GYUtils showToast:returnValue[@"msg"]];
               }
               
           }
           failure:^(NSError* error) {
               
           }
       isIndicator:YES];
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_Myhs_Pay_Annual_Fee_Use_System");
    self.view.backgroundColor = kWhiteFFFFFF;
    DDLogInfo(@"Load Controller: %@", [self class]);
    
    [self addMiddleView];
    [self addBottomView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

/*!
 *    添加UI中间部分视图
 */
- (void)addMiddleView
{
    [self.view addSubview:self.payYearTableView];
    [self.payYearTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.view).offset(44 + kDeviceProportion(50));
        make.width.equalTo(@(kDeviceProportion(400)));
        make.height.equalTo(@(kDeviceProportion(40 * self.titleArray.count)));
        make.centerX.equalTo(self.view.mas_centerX).offset(kDeviceProportion(-120));
    }];
    
    [self.view addSubview:self.rightTipLabel];
    [self.rightTipLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_payYearTableView.mas_top);
        make.left.equalTo(_payYearTableView.mas_right);
        make.width.equalTo(@(kDeviceProportion(240)));
        make.height.equalTo(_payYearTableView.mas_height);
    }];
}

/*!
 *    年费提示信息
 */
- (void)tipMake
{
    
    NSTextAttachment* attachment = [[NSTextAttachment alloc] init];
    UIImage* image = [UIImage imageNamed:@"gyhs_tip_family"];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, -3, image.size.width, image.size.height);
    NSMutableAttributedString* imageStr = [NSAttributedString attributedStringWithAttachment:attachment].mutableCopy;
    
    NSString* str1 = kLocalized(@"GYHS_Myhs_Tips_Colon");
    NSAttributedString* tipText = [[NSAttributedString alloc] initWithString:str1 attributes:@{ NSFontAttributeName : kFont30, NSForegroundColorAttributeName : kBlue2d89f0 }];
    
    NSString* str2 = [NSString stringWithFormat:@"%@%@%@", kLocalized(@"GYHS_Myhs_Year_Fee_Tips_Front"), [GYUtils formatCurrencyStyle:_model.annualfeePrice.doubleValue], kLocalized(@"GYHS_Myhs_Year_Fee_Tips_Tail")];
    NSAttributedString* text = [[NSAttributedString alloc] initWithString:str2 attributes:@{ NSFontAttributeName : kFont28, NSForegroundColorAttributeName : kGray666666 }];
    
    [imageStr appendAttributedString:tipText];
    [imageStr appendAttributedString:text];
    
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.headIndent = kDeviceProportion(30);
    paragraphStyle.tailIndent = kDeviceProportion(-30);
    paragraphStyle.paragraphSpacingBefore = 10;
    paragraphStyle.lineHeightMultiple = 1.5;
    paragraphStyle.firstLineHeadIndent = 30;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    [imageStr addAttributes:@{ NSParagraphStyleAttributeName : paragraphStyle } range:NSMakeRange(0, imageStr.length)];
    
    self.rightTipLabel.attributedText = imageStr;
}

/*!
 *    添加UI底部部分视图
 */
- (void)addBottomView
{
    UIView* bottomBackView = [[UIView alloc] init];
    bottomBackView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.16];
    [self.view addSubview:bottomBackView];
    [bottomBackView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kDeviceProportion(70)));
    }];
    
    [bottomBackView addSubview:self.payButton];
    [self.payButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@(kDeviceProportion(33)));
        make.width.equalTo(@(kDeviceProportion(120)));
        make.centerX.centerY.equalTo(bottomBackView);
    }];
}

#pragma mark - lazy load
- (UILabel*)rightTipLabel
{
    if (!_rightTipLabel) {
        _rightTipLabel = [[UILabel alloc] init];
        _rightTipLabel.backgroundColor = kDefaultVCBackgroundColor;
        _rightTipLabel.numberOfLines = 0;
    }
    return _rightTipLabel;
}

- (NSArray*)titleArray
{
    if (!_titleArray) {
        _titleArray = @[
                        kLocalized(@"GYHS_Myhs_HSB_Enable_Number_Colon"),
                        kLocalized(@"GYHS_Myhs_System_Use_Year_Fee_Colon"),
                        kLocalized(@"GYHS_Myhs_Need_Pay_Fee_Colon"),
                        kLocalized(@"GYHS_Myhs_Current_Year_Fee_Validity_Colon"),
                        kLocalized(@"GYHS_Myhs_Need_Pay_Fee_Interval_Colon"),
                        kLocalized(@"GYHS_Myhs_Billing_Currency_Colon")
                        ];
    }
    return _titleArray;
}

- (NSArray*)contentArray
{
    if (!_contentArray) {
        _contentArray = [NSArray array];
    }
    return _contentArray;
}

- (UITableView*)payYearTableView
{
    if (!_payYearTableView) {
        _payYearTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _payYearTableView.scrollEnabled = NO;
        _payYearTableView.showsHorizontalScrollIndicator = NO;
        _payYearTableView.showsVerticalScrollIndicator = NO;
        [_payYearTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSMyPayYearFeeCell class]) bundle:nil] forCellReuseIdentifier:idCell];
        _payYearTableView.delegate = self;
        _payYearTableView.dataSource = self;
        _payYearTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _payYearTableView.sectionFooterHeight = 0;
        _payYearTableView.sectionHeaderHeight = 0;
    }
    return _payYearTableView;
}

- (UIButton*)payButton
{
    if (!_payButton) {
        _payButton = [[UIButton alloc] init];
        _payButton.layer.cornerRadius = 5;
        _payButton.layer.borderWidth = 1;
        _payButton.layer.borderColor = kRedE50012.CGColor;
        _payButton.layer.masksToBounds = YES;
        [_payButton setTitle:kLocalized(@"GYHS_Myhs_To_Pay") forState:UIControlStateNormal];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payButton setBackgroundColor:kRedE50012];
        [_payButton addTarget:self action:@selector(payButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
}

@end
