//
//  GYOrderQuickPayConfirmVC.m
//  HSConsumer
//
//  Created by sqm on 16/5/3.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOrderQuickPayConfirmVC.h"
#import "GYQRPayModel.h"
#import "NSString+YYAdd.h"
#import "UIView+Extension.h"
#import "GYQuickPayModel.h"
#import "GYBankTableViewCell.h"
#import "UIButton+GYTimeOut.h"
#import "UIButton+GYExtension.h"

static NSString* const GYTableViewCellID = @"GYOrderQuickPayConfirmVC";
static NSString* const GYBankTableViewCellID = @"GYBankTableViewCellID";

@interface GYOrderQuickPayConfirmVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* titleArr;
@property (nonatomic, strong) NSArray* valueArr;
@property (nonatomic, weak) UITextField* tradepwdTf;

@property (nonatomic, copy) NSString* smsCode;
@property (nonatomic, weak) GYBankTableViewCell* selectedCell;
@property (nonatomic, assign) BOOL isForwordMsg;
@end

@implementation GYOrderQuickPayConfirmVC

#pragma mark - 懒加载

- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kDefaultVCBackgroundColor;

        [_tableView registerNib:[UINib nibWithNibName:@"GYBankTableViewCell" bundle:nil] forCellReuseIdentifier:GYBankTableViewCellID];
    }
    return _tableView;
}

- (NSArray*)titleArr
{

    if (!_titleArr) {
        _titleArr = @[ kLocalized(@"GYHS_QR_posDealTime"), kLocalized(@"GYHS_QR_posDealTransAmount"), kLocalized(@"GYHS_QR_proportionalIntegral"), kLocalized(@"GYHS_QR_posDealPointTransAmount"), kLocalized(@"GYHS_QR_posShouldPayHsbAmount") ];
    }
    return _titleArr;
}

- (NSArray*)valueArr
{

    if (!_valueArr) {

        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyyMMddHHmmss"]; //设定时间格式,这里可以设置成自己需要的格式
        NSDate* date = [dateFormat dateFromString:self.model.date];
        _valueArr = @[ [GYUtils dateToString:date], [GYUtils formatCurrencyStyle:self.model.tradeAmount.doubleValue], [NSString stringWithFormat:@"%.4f", self.model.pointRate.doubleValue], [NSString stringWithFormat:@"%.2f", self.model.acceptScore.doubleValue], [GYUtils formatCurrencyStyle:self.model.hsbAmount.doubleValue] ];
    }

    return _valueArr;
}

#pragma mark - 系统方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = kLocalized(@"GYHS_QR_order_payConfirm");
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = kDefaultVCBackgroundColor;

    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 40, kScreenWidth - 2 * 20, 40);
    [btn setTitle:kLocalized(@"GYHS_QR_immediatePayment") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:kDefaultButtonColor];

    [footerView addSubview:btn];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footerView;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{

    return 2;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return section == 0 ? self.valueArr.count : self.quickBankListArrM.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    UITableViewCell* cell = nil;
    if (indexPath.section == 0) {
        UITableViewCell* cell0 = [tableView dequeueReusableCellWithIdentifier:GYTableViewCellID];
        if (!cell0) {
            cell0 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:GYTableViewCellID];
        }
        cell0.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.tradepwdTf removeFromSuperview]; //防止重用
        cell0.textLabel.textColor = kCellItemTitleColor;
        cell0.detailTextLabel.textColor = kCellItemTextColor;
        cell0.textLabel.text = self.titleArr[indexPath.row];
        cell0.detailTextLabel.text = self.valueArr[indexPath.row];
        if (indexPath.row == self.titleArr.count - 1) {
            cell0.detailTextLabel.textColor = kValueRedCorlor;
        }
        cell = cell0;
    }
    else {

        GYBankTableViewCell* cell1 = [tableView dequeueReusableCellWithIdentifier:GYBankTableViewCellID];
        GYQuickPayModel* model = self.quickBankListArrM[indexPath.row];
        cell1.model = model;

        cell = cell1;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {

        UIView* backView = [[UIView alloc] init];
        backView.backgroundColor = kDefaultVCBackgroundColor;
        backView.frame = CGRectMake(0, 0, kScreenWidth, 100);

        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10, 0, kScreenWidth, 30);
        btn.backgroundColor = kDefaultVCBackgroundColor;
        [btn setTitle:kLocalized(@"GYHS_QR_chooseOtherBank/Payment") forState:UIControlStateNormal];
        [btn setTitleColor:kValueRedCorlor forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [backView addSubview:btn];
        [btn addTarget:self action:@selector(BackToSelectedPayMethod) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];

        UIView* codeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame) + 5, kScreenWidth, 40)];
        codeView.backgroundColor = [UIColor whiteColor];
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = kCellItemTitleColor;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.text = @"短信验证码";
        [codeView addSubview:titleLabel];

        UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame) + 5, 0, 140, 40)];
        textField.placeholder = @"输入短信验证码";
        textField.textAlignment = NSTextAlignmentLeft;
        textField.textColor = kCellItemTextColor;
        textField.font = [UIFont systemFontOfSize:14];
        [codeView addSubview:textField];
        self.tradepwdTf = textField;
        textField.keyboardType = UIKeyboardTypeNumberPad;

        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textField.frame) + 5, 5, 0.5, 30)];
        lineView.backgroundColor = [UIColor grayColor];
        [codeView addSubview:lineView];

        UIButton* btnGetCode = [UIButton buttonWithType:UIButtonTypeCustom];
        btnGetCode.frame = CGRectMake(CGRectGetMaxX(lineView.frame) + 5, 0, kScreenWidth - 10 - CGRectGetMaxX(lineView.frame) + 5, 40);
        [btnGetCode setTitle:@"获取" forState:UIControlStateNormal];
        [btnGetCode setTitleColor:kValueRedCorlor forState:UIControlStateNormal];
        [btnGetCode addTarget:self action:@selector(getSmsCode:) forControlEvents:UIControlEventTouchUpInside];
        btnGetCode.titleLabel.font = [UIFont systemFontOfSize:14];
        [codeView addSubview:btnGetCode];

        [backView addSubview:codeView];

        return backView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{

    return section == 0 ? 0 : 100;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{

    return indexPath.section == 0 ? 40 : 44;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSArray* visiableCells = [tableView visibleCells];
    for (GYBankTableViewCell* cell in visiableCells) {
        if (cell.isSelected) {
            self.selectedCell = cell;
        }
    }
}

#pragma mark 返回选择支付方式
- (void)BackToSelectedPayMethod
{

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textfield代理

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString* toBeStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeStr.length > 8) {
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
}

- (void)click:(UIButton*)btn
{

    kCheckLogined
        [self.view endEditing:YES];

    if (!self.selectedCell) {
        [GYUtils showToast:@"请先选择银行卡"];
        return;
    }

    if (!self.isForwordMsg) {
        [GYUtils showToast:@"请先获取短信验证码"];
        return;
    }

    if (self.tradepwdTf.text.length == 0) {
        [GYUtils showToast:@"请输入正确的验证码"];
        return;
    }

    [btn controlTimeOut];

    WS(weakSelf)
        [GYGIFHUD show];
    [Network Post:[HSReconsitutionUrl stringByAppendingString:@"/customer/pointQuickPayUrl"] hidenHUD:YES parameters:@{ @"bindingNo" : self.selectedCell.model.signNo,
        @"transNo" : self.transNo,
        @"smsCode" : self.tradepwdTf.text,
        @"bindingChannel" : @"P"}
        completion:^(id responseObject, NSError* error) {
            
                if (!error && [responseObject[@"retCode"] isEqualToNumber:@200]) {
                    [GYUtils showToast:@"恭喜，您的交易支付成功！"];
                    [GYGIFHUD dismiss];
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                } else if (!error &&[responseObject[@"retCode"] isEqualToNumber:@220]) {
                    [GYUtils showToast:kLocalized(@"GYHS_QR_thisDealIsPaid")];
                    [GYGIFHUD dismiss];
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    
                } else if ([responseObject[@"retCode"] isEqualToNumber:@201]){
                
                    [GYGIFHUD show];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
                        
                        [dateFormat setDateFormat:@"yyyyMMddHHmmss"];//设定时间格式,这里可以设置成自己需要的格式
                        
                        NSDate *date = [dateFormat dateFromString:self.model.date];
                        [Network Post:[HSReconsitutionUrl stringByAppendingString:@"/customer/checkOrderIsPay"] hidenHUD:YES parameters:@{ @"entResNo":self.model.entResNo, @"entCustId":self.model.entCustId,  @"sourcePosDate":[GYUtils dateToString:date], @"equipmentNo":self.model.posDeviceNo, @"sourceBatchNo":self.model.batchNo,  @"equipmentType":@"2", @"termRunCode":self.model.voucherNo, @"bindingChannel" : @"P"} completion:^(id responseObject, NSError *error) {
                             [GYGIFHUD dismiss];
                            if (!error && [responseObject[@"retCode"] isEqualToNumber:@200]) {
                                if ([responseObject[@"data"] isEqualToString:@"1"]) {
                                    [GYUtils showToast:@"您的交易支付成功！"];
                                   
                                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                }else {
                                    [GYUtils showToast:@"您的交易支付失败，请重试"];
                                    
                                }
                            }
                            
                        }];
                    });
         
                
                }else {
                    [GYGIFHUD dismiss];
                    [GYUtils showToast:kErrorMsg];
                    
                    
                    
                }

        }];
}

- (void)getSmsCode:(UIButton*)button
{

    if (!self.selectedCell) {
        [GYUtils showToast:@"请先选择银行卡"];
        return;
    }
    [button controlTimeOut];

    [GYGIFHUD show];
    WS(weakSelf)
        [Network GET:[HSReconsitutionUrl stringByAppendingString:@"/customer/pointFinishBanking"] parameters:@{ @"bindingNo" : self.selectedCell.model.signNo,
            @"transNo" : self.transNo, @"bindingChannel" : @"P"}
            completion:^(id responseObject, NSError* error) {
       [GYGIFHUD dismiss];
       if(!error &&[responseObject[@"retCode"] isEqualToNumber:@200])
       {
           [button startTime:60 title:@"获取" waitTittle:@"s"];
           [GYUtils showToast:@"验证码已发送"];
           weakSelf.isForwordMsg = YES;
     
       }else {
        [GYUtils showToast:kErrorMsg];
       
       }
            }];
}

@end
