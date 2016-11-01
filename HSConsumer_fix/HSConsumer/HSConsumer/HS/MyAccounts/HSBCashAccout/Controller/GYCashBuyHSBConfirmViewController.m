//
//  GYCashBuyHSBConfirmViewController.m
//  HSConsumer
//
//  Created by apple on 15/12/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYCashBuyHSBConfirmViewController.h"
#import "GYOtherPayStyleViewController.h"
#import "GYBankTableViewCell.h"
#import "GYQuickPayModel.h"
#import "UIButton+GYExtension.h"
#import "ViewTipBkgView.h"
#import "GYAlertView.h"

@interface GYCashBuyHSBConfirmViewController () {

    GlobalData* data;
}

@property (nonatomic, assign) int leftTime;
@property (weak, nonatomic) IBOutlet UIScrollView* svBackView;
@property (weak, nonatomic) IBOutlet UITableView* tvBankList;
@property (weak, nonatomic) IBOutlet UIButton* btnConfirm;
@property (weak, nonatomic) IBOutlet UILabel* lbOrderShow;
@property (weak, nonatomic) IBOutlet UILabel* lbOrderValue;
@property (weak, nonatomic) IBOutlet UITextField* tfPayPassword;
@property (weak, nonatomic) IBOutlet UITextField* tfSmsCode;
@property (weak, nonatomic) IBOutlet UIView* view2;
@property (weak, nonatomic) IBOutlet UILabel* messageAuthenticationCodeLabel; //短信验证码
@property (weak, nonatomic) IBOutlet UIView* view0;
@property (weak, nonatomic) IBOutlet UILabel* amountPayableLabel; //应付金额:

@property (weak, nonatomic) IBOutlet UIButton* btnSms;
@property (weak, nonatomic) IBOutlet UIButton* btnChoseOthor;

/**存放银行列表*/
@property (nonatomic, strong) NSMutableArray* marrDatasoure;
@property (nonatomic, copy) NSString* strBindingNo;
@property (nonatomic, assign) BOOL isFarword;
@property (nonatomic, strong) ViewTipBkgView* viewTipBkg;

@end

@implementation GYCashBuyHSBConfirmViewController

- (ViewTipBkgView*)viewTipBkg
{
    if (_viewTipBkg) {
        _viewTipBkg = [[ViewTipBkgView alloc] init];
    }
    return _viewTipBkg;
}
- (NSMutableArray*)marrDatasoure
{
    if (!_marrDatasoure) {
        _marrDatasoure = [NSMutableArray array];
    }
    return _marrDatasoure;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    data = globalData;

    self.svBackView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(self.btnConfirm.frame) + 30);
    self.svBackView.backgroundColor = kDefaultVCBackgroundColor;
    [self.tvBankList registerNib:[UINib nibWithNibName:NSStringFromClass([GYBankTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"COOOO"];

    //self.tradePasswordLabel.text = kLocalized(@"GYHS_MyAccounts_trade_pwd");
    self.amountPayableLabel.text = kLocalized(@"GYHS_MyAccounts_order_should_payMoney");

    self.tfPayPassword.placeholder = kLocalized(@"GYHS_MyAccounts_input_trading_pwd");
    [self.btnChoseOthor setTitle:kLocalized(@"GYHS_MyAccounts_chooseOtherBank/Payment") forState:UIControlStateNormal];
    self.messageAuthenticationCodeLabel.text = kLocalized(@"GYHS_MyAccounts_SMS_verification_code");
    self.tfSmsCode.placeholder = kLocalized(@"GYHS_MyAccounts_input_SMS_Verification_code");
    self.tfSmsCode.keyboardType = UIKeyboardTypeNumberPad;
    [self.btnConfirm setTitle:kLocalized(@"GYHS_MyAccounts_confirmThePayment") forState:UIControlStateNormal];

    [self.btnSms setTitle:kLocalized(@"GYHS_MyAccounts_get_verification_code") forState:UIControlStateNormal];

    [self setUIValue];

    [self getQuickBankList];

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void)hidenKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - 私有方法
- (void)setUIValue
{

    self.lbOrderShow.text = [NSString stringWithFormat:@"订单已提交，订单号：%@，请于24小时内完成支付。", self.transNo];
    self.lbOrderValue.text = [NSString stringWithFormat:@"%.2f", self.inputValue];
}

- (void)reFrame
{
    NSInteger row = self.marrDatasoure.count;
    self.tvBankList.frame = CGRectMake(0, CGRectGetMaxY(self.view0.frame) + 20, self.view.frame.size.width, 44 * row);
    self.btnChoseOthor.frame = CGRectMake(self.btnChoseOthor.frame.origin.x, CGRectGetMaxY(self.tvBankList.frame) + 20, self.btnChoseOthor.frame.size.width, self.btnChoseOthor.frame.size.height);
    // self.view1.frame = CGRectMake(0, CGRectGetMaxY(self.btnChoseOthor.frame)+20, self.view1.frame.size.width, self.view1.frame.size.height);
    self.view2.frame = CGRectMake(0, CGRectGetMaxY(self.btnChoseOthor.frame) + 20, self.view2.frame.size.width, self.view2.frame.size.height);
    self.btnConfirm.frame = CGRectMake(self.btnConfirm.frame.origin.x, CGRectGetMaxY(self.view2.frame) + 20, self.btnConfirm.frame.size.width, self.btnConfirm.frame.size.height);
    self.svBackView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(self.btnConfirm.frame) + 30);
}

- (void)gcTimer:(NSTimer*)timer
{
    _leftTime--;
    [self.btnSms setTitle:[NSString stringWithFormat:@"%d", _leftTime] forState:UIControlStateNormal];
    if (_leftTime == 0) {
        [timer invalidate];
        self.btnSms.userInteractionEnabled = YES;
        [self.btnSms setTitle:kLocalized(@"GYHS_MyAccounts_get_verification_code") forState:UIControlStateNormal];
    }
}

#pragma mark - btnAction
- (IBAction)btnAction:(UIButton*)sender
{

    UIViewController* vc = nil;
    if (sender.tag == 100) {

        //选择其他支付方式

        for (UIViewController* popVc in self.navigationController.viewControllers) { //如果栈中有就直接回去
            if ([popVc isKindOfClass:[GYOtherPayStyleViewController class]]) {
                [self.navigationController popToViewController:popVc animated:YES];
                return;
            }
        }

        GYOtherPayStyleViewController* _vc = kLoadVcFromClassStringName(NSStringFromClass([GYOtherPayStyleViewController class]));
        _vc.title = kLocalized(@"GYHS_MyAccounts_chooseOtherPaymentWay");
        _vc.transNo = self.transNo;
        _vc.inputValue = self.inputValue;

        _vc.currentPayStyle = payStyleWithQuickPayment;
        _vc.tradeTitle = self.navigationItem.title;
        vc = _vc;
    }

    if (sender.tag == 101) {
    }
    if (sender.tag == 102) {
        //获取验证码
        if (!self.strBindingNo) {
            [GYUtils showMessage:kLocalized(@"GYHS_MyAccounts_pleaseChooseToPayBankCardFirst")];
            return;
        }
        [self getSmsCode:^{
            _leftTime = 61;
            self.btnSms.userInteractionEnabled = NO;
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(gcTimer:) userInfo:nil repeats:YES];
        }];
    }

    if (sender.tag == 103) {

        if (self.marrDatasoure.count == 0) {
            [GYUtils showToast:@"您暂时还没有快捷支付卡，请选择其它支付方式"];
            return;
        }

        if (self.tfSmsCode.text.length != 6) {
            [GYUtils showMessage:kLocalized(@"GYHS_MyAccounts_pleaseEnterCorrectVerificationCode")];
            return;
        }
        //确认付款
        [self pay];
    }
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.marrDatasoure.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYBankTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"COOOO" forIndexPath:indexPath];
    if (self.marrDatasoure.count > indexPath.row) {
        cell.model = self.marrDatasoure[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYQuickPayModel* model = nil;
    if (self.marrDatasoure.count > indexPath.row) {
        model = self.marrDatasoure[indexPath.row];
    }
    self.strBindingNo = model.signNo;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString* str = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (textField == self.tfPayPassword) {
        if (str.length > 8) {
            textField.text = [str substringToIndex:8];
            return NO;
        }
    }
    else if (textField == self.tfSmsCode) {
        if (str.length > 6) {
            textField.text = [str substringToIndex:6];
            return NO;
        }
    }

    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    self.svBackView.scrollEnabled = YES;
}

#pragma mark - 手势 UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        self.svBackView.scrollEnabled = NO;
    }
    else {
        self.svBackView.scrollEnabled = YES;
    }
    return YES;
}

#pragma mark - 网络数据交换
- (void)getQuickBankList
{
    NSDictionary* dict = @{
        @"custId" : kSaftToNSString(globalData.loginModel.custId),
        @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard
    };
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kUrlListQkBanks parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSArray *array = responseObject[@"data"];
        if (array.count==0) {
            self.viewTipBkg.hidden = NO;
            self.viewTipBkg = [[ViewTipBkgView alloc] init];
            [self.viewTipBkg setFrame:self.svBackView.bounds];
            [self.view addSubview:self.viewTipBkg];
            self.lbOrderValue.text =@"抱歉，暂无快捷支付纪录";
            self.lbOrderValue.frame = CGRectMake(self.viewTipBkg.frame.origin.x+self.viewTipBkg.frame.size.width/2-80, self.viewTipBkg.frame.origin.y+self.viewTipBkg.frame.size.height/2-30, 280, 67);
            [self.lbOrderValue setTextColor:[UIColor grayColor]];
            [self.view addSubview:self.lbOrderValue];
            [self.btnChoseOthor setTitle:kLocalized(@"GYHS_MyAccounts_chooseOtherBank/Payment") forState:UIControlStateNormal];
            self.btnChoseOthor.frame = CGRectMake(self.viewTipBkg.frame.origin.x+self.viewTipBkg.frame.size.width/2-80, self.viewTipBkg.frame.origin.y+self.viewTipBkg.frame.size.height/2+15, 160, 30);
            [self.view addSubview:self.btnChoseOthor];
            self.svBackView.hidden = YES;
            self.btnConfirm.hidden = YES;
            return ;
        }else {
            self.viewTipBkg.hidden = YES;
            self.svBackView.hidden = NO;
            self.btnConfirm.hidden = NO;
            
        }
        for (NSDictionary *tempDic in responseObject[@"data"]) {
            GYQuickPayModel *model = [[GYQuickPayModel alloc] initWithDictionary:tempDic error:nil];
            [self.marrDatasoure addObject:model];
        }
        [self reFrame];
        [self.tvBankList reloadData];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

/**手机验证码*/
- (void)getSmsCode:(void (^)())complete
{
    [self.view endEditing:YES];
    NSDictionary* dict = @{
        @"transNo" : kSaftToNSString(self.transNo),
        @"bindingNo" : kSaftToNSString(self.strBindingNo)
    };

    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kUrlhGetQuickPaymentSmsCode parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        WS(weakSelf)
        [GYUtils showMessage:kLocalized(@"GYHS_MyAccounts_verification_code_send_success") confirm:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        
        self.isFarword = YES;
        complete();

    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

/**快捷支付*/
- (void)pay
{
    [self.view endEditing:YES];
    if (!self.isFarword) {
        [GYUtils showToast:@"请先获取验证码"];
        return;
    }

    NSDictionary* dict = @{
        @"transNo" : kSaftToNSString(self.transNo),
        @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard,
        @"custId" : kSaftToNSString(globalData.loginModel.custId),
        //@"transPwd":[self.tfPayPassword.text md5String],
        @"smsCode" : kSaftToNSString(self.tfSmsCode.text),
        @"bindingNo" : kSaftToNSString(self.strBindingNo)
    };
    [GYGIFHUD show];
    [self.btnConfirm controlTimeOut];
    WS(weakSelf)
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kUrlhPaymentByQuickPay parameters:dict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
         [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        [GYAlertView showMessage:kLocalized(@"GYHS_MyAccounts_order_is_pay_success")];
        
        [weakSelf popToViewControllerWithClassName:@"GYHSDToCashAccoutViewController" animated:YES];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

@end
