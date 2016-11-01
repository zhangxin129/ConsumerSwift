//
//  GYHSMyAccountMainViewController.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSMyAccountMainViewController.h"
#import "GYHSRedSelectBtn.h"
#import "GYHSTools.h"
#import "GYHSCoinAccountViewController.h"
#import "GYPvAccountViewController.h"
#import "GYHSCashAccountViewController.h"
#import "GYInvestmentAccountViewController.h"
#import "GYHSOtherMainViewController.h"
#import "GYTicketAccountViewController.h"
#import "GYHSPointInvestmentViewController.h"
#import "Masonry.h"
#import "GYHSCashToBankBalanceViewController.h"
#import "GYHSLoginMainVC.h"
#define kOneLevelBtnTag 200
#define kTwoLevelBtnTag 210
#define isCardHolder globalData.loginModel.cardHolder ? YES : NO
//积分变化
#define kPvCountChange @"pvCountChange"
//互生币变化
#define kHsCoinChange @"hsCoinChange"
//货币变化
#define kCurrencyChange @"currencyChange"

@interface GYHSMyAccountMainViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView* accountMainScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView* scrollview;
//主界面按钮
@property (weak, nonatomic) IBOutlet GYHSRedSelectBtn* pvInvestmentBtn;
@property (weak, nonatomic) IBOutlet GYHSRedSelectBtn* pvToHSCoinBtn;
@property (weak, nonatomic) IBOutlet GYHSRedSelectBtn* hsCoinToCashBtn;
@property (weak, nonatomic) IBOutlet GYHSRedSelectBtn* cashToBankBtn;
@property (weak, nonatomic) IBOutlet UIButton* hsAccountBtn;
//我的账户按钮
@property (weak, nonatomic) IBOutlet GYHSRedSelectBtn* hsCoinAccountBtn;
@property (weak, nonatomic) IBOutlet GYHSRedSelectBtn* pvAccountBtn;
@property (weak, nonatomic) IBOutlet GYHSRedSelectBtn* cashAccountBtn;
@property (weak, nonatomic) IBOutlet GYHSRedSelectBtn* investmentAccountBtn;
@property (weak, nonatomic) IBOutlet GYHSRedSelectBtn* ticketAccountBtn;
//非持卡人
@property (weak, nonatomic) IBOutlet GYHSRedSelectBtn* noCardHSCoinToCashBtn;
@property (weak, nonatomic) IBOutlet GYHSRedSelectBtn* noCardCashToBankBtn;
@property (weak, nonatomic) IBOutlet UIButton* noCardHSAccount;
@property (weak, nonatomic) IBOutlet GYHSRedSelectBtn* noCardHSCoinAccountBtn;
@property (weak, nonatomic) IBOutlet GYHSRedSelectBtn* noCardcashAccountBtn;

//添加子控制器的视图
@property (weak, nonatomic) IBOutlet UIView* sonVCView;
@property (weak, nonatomic) IBOutlet UIButton* toMainBtn;

//持卡，非持卡
@property (strong, nonatomic) IBOutlet UIView* haveCardView;
@property (strong, nonatomic) IBOutlet UIView* noCardView;

//五个子控制器 + 主控制器
@property (nonatomic, strong) GYHSCoinAccountViewController* hsCoinAccountVC;
@property (nonatomic, strong) GYPvAccountViewController* pvAccountVC;
@property (nonatomic, strong) GYHSCashAccountViewController* cashAccountVC;
@property (nonatomic, strong) GYInvestmentAccountViewController* investmentAccountVC;
@property (nonatomic, strong) GYTicketAccountViewController* ticketAccountVC;
@property (nonatomic, strong) GYHSOtherMainViewController* otherMainVC;
//积分投资   积分转互生币  互生转互生币
@property (nonatomic, strong) GYHSPointInvestmentViewController* pointInvestmentVC;
@property (nonatomic, strong) GYHSPointInvestmentViewController* pointHSBVC;
@property (nonatomic, strong) GYHSPointInvestmentViewController* HSBCurrencyVC;
@property (nonatomic, strong) GYHSCashToBankBalanceViewController* cashToBankVC;

@end

@implementation GYHSMyAccountMainViewController

#pragma mark - 生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpUI];
    [self addOneLevelChildVC];
    [self addOtherMainVC:self.otherMainVC];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAboutPv) name:kPvCountChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAboutHsCount) name:kHsCoinChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAboutCurrency) name:kCurrencyChange object:nil];
    _toMainBtn.hidden = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 自定义方法
//初始化方法
- (void)setUpUI
{
    _accountMainScrollView.contentSize = CGSizeMake(kScreenWidth * 2, 0);
    _accountMainScrollView.pagingEnabled = YES;
    _accountMainScrollView.showsHorizontalScrollIndicator = NO;
    _accountMainScrollView.showsVerticalScrollIndicator = NO;
    _accountMainScrollView.scrollEnabled = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.scrollview.pagingEnabled = YES;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.showsVerticalScrollIndicator = NO;
    self.scrollview.delegate = self;
    
    self.pvInvestmentBtn.tag = kOneLevelBtnTag;
    self.pvToHSCoinBtn.tag = kOneLevelBtnTag + 1;
    self.hsCoinToCashBtn.tag = kOneLevelBtnTag + 2;
    self.cashToBankBtn.tag = kOneLevelBtnTag + 3;
    self.hsCoinAccountBtn.tag = kTwoLevelBtnTag;
    self.pvAccountBtn.tag = kTwoLevelBtnTag + 1;
    self.cashAccountBtn.tag = kTwoLevelBtnTag + 2;
    self.investmentAccountBtn.tag = kTwoLevelBtnTag + 3;
    self.ticketAccountBtn.tag = kTwoLevelBtnTag + 4;
    
    //非持卡
    self.noCardHSCoinToCashBtn.tag = kOneLevelBtnTag;
    self.noCardCashToBankBtn.tag = kOneLevelBtnTag + 1;
    self.noCardHSCoinAccountBtn.tag = kTwoLevelBtnTag;
    self.noCardcashAccountBtn.tag = kTwoLevelBtnTag + 1;
    //已经登录显示上次主界面状态，未登录显示持卡人主界面
    if (globalData.loginModel) {
        [self refreshIsHaveCard];
    }
    else {
        [self setUpHaveCardUI];
    }
}

//对外接口（用来刷新切换 持卡、非持卡人 时的主界面）
- (void)refreshIsHaveCard
{
    for (UIView* view in _accountMainScrollView.subviews) {
        if (view != _accountMainScrollView) {
            [view removeFromSuperview];
        }
    }
    
    if (isCardHolder) {
        [self setUpHaveCardUI];
    }
    else {
        [self setUpNoCardUI];
    }
    if (self.scrollview) {
        NSInteger offest = self.accountMainScrollView.contentOffset.x / kScreenWidth;
        if (offest == 0) {
            [self addOneLevelChildVC];
            

        }else if (offest == 1){
            [self addTwoLevelChildVC];
        }
    }
    if(_pointInvestmentVC) {
        [self.pointInvestmentVC refreshAccountBalance];
        [self.pointHSBVC refreshAccountBalance];
        [self.HSBCurrencyVC refreshAccountBalance];
        [self.cashToBankVC reloadData];
    }
}

- (void)showMainView
{
    [self addOtherMainVC:self.otherMainVC];
    [self allAccountBtnSelectedNot];
    [self allBtnSelectedNot];
    self.toMainBtn.hidden = YES;

}

//持卡人主界面
- (void)setUpHaveCardUI
{
    //设置界面
    [_pvInvestmentBtn setTitle:kLocalized(@"GYHS_HSAccount_pvInvestment") forState:UIControlStateNormal];
    [_pvInvestmentBtn setTitleColor:kSelectedRed forState:UIControlStateSelected];
    _pvInvestmentBtn.titleLabel.font = kSecondTitleFont;
    
    [_pvToHSCoinBtn setTitle:kLocalized(@"GYHS_HSAccount_pvToHSCoin") forState:UIControlStateNormal];
    [_pvToHSCoinBtn setTitleColor:kSelectedRed forState:UIControlStateSelected];
    _pvToHSCoinBtn.titleLabel.font = kSecondTitleFont;
    
    [_hsCoinToCashBtn setTitle:kLocalized(@"GYHS_HSAccount_hsCoinToCash") forState:UIControlStateNormal];
    [_hsCoinToCashBtn setTitleColor:kSelectedRed forState:UIControlStateSelected];
    _hsCoinToCashBtn.titleLabel.font = kSecondTitleFont;
    
    [_cashToBankBtn setTitle:kLocalized(@"GYHS_HSAccount_cashToBank") forState:UIControlStateNormal];
    [_cashToBankBtn setTitleColor:kSelectedRed forState:UIControlStateSelected];
    _cashToBankBtn.titleLabel.font = kSecondTitleFont;
    
    [_hsAccountBtn setTitle:kLocalized(@"GYHS_HSAccount_hsAccountBtn") forState:UIControlStateNormal];
    _hsAccountBtn.titleLabel.font = kSecondTitleFont;
    
    [_hsCoinAccountBtn setTitle:kLocalized(@"GYHS_HSAccount_hsCoinAccount") forState:UIControlStateNormal];
    [_hsCoinAccountBtn setTitleColor:kSelectedRed forState:UIControlStateSelected];
    _hsCoinAccountBtn.titleLabel.font = kSecondTitleFont;
    
    [_pvAccountBtn setTitle:kLocalized(@"GYHS_HSAccount_pvAccountBtn") forState:UIControlStateNormal];
    [_pvAccountBtn setTitleColor:kSelectedRed forState:UIControlStateSelected];
    _pvAccountBtn.titleLabel.font = kSecondTitleFont;
    
    [_cashAccountBtn setTitle:kLocalized(@"GYHS_HSAccount_cashAccount") forState:UIControlStateNormal];
    [_cashAccountBtn setTitleColor:kSelectedRed forState:UIControlStateSelected];
    _cashAccountBtn.titleLabel.font = kSecondTitleFont;
    
    [_investmentAccountBtn setTitle:kLocalized(@"GYHS_HSAccount_investmentAccount") forState:UIControlStateNormal];
    [_investmentAccountBtn setTitleColor:kSelectedRed forState:UIControlStateSelected];
    _investmentAccountBtn.titleLabel.font = kSecondTitleFont;
    
    [_ticketAccountBtn setTitle:kLocalized(@"GYHS_HSAccount_ticketAccount") forState:UIControlStateNormal];
    [_ticketAccountBtn setTitleColor:kSelectedRed forState:UIControlStateSelected];
    _ticketAccountBtn.titleLabel.font = kSecondTitleFont;
    
    [_accountMainScrollView addSubview:self.haveCardView];
    [self.haveCardView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.mas_equalTo(0);
        make.height.mas_equalTo(kScreenWidth/4.0);
        make.width.mas_equalTo(kScreenWidth * 2);
    }];
}

//非持卡人主界面
- (void)setUpNoCardUI
{
    //设置界面
    [_noCardHSCoinToCashBtn setTitle:kLocalized(@"GYHS_HSAccount_hsCoinToCash") forState:UIControlStateNormal];
    [_noCardHSCoinToCashBtn setTitleColor:kSelectedRed forState:UIControlStateSelected];
    _noCardHSCoinToCashBtn.titleLabel.font = kSecondTitleFont;
    
    [_noCardCashToBankBtn setTitle:kLocalized(@"GYHS_HSAccount_cashToBank") forState:UIControlStateNormal];
    [_noCardCashToBankBtn setTitleColor:kSelectedRed forState:UIControlStateSelected];
    _noCardCashToBankBtn.titleLabel.font = kSecondTitleFont;
    
    [_noCardHSAccount setTitle:kLocalized(@"GYHS_HSAccount_hsAccountBtn") forState:UIControlStateNormal];
    _noCardHSAccount.titleLabel.font = kSecondTitleFont;
    
    [_noCardHSCoinAccountBtn setTitle:kLocalized(@"GYHS_HSAccount_hsCoinAccount") forState:UIControlStateNormal];
    [_noCardHSCoinAccountBtn setTitleColor:kSelectedRed forState:UIControlStateSelected];
    _noCardHSCoinAccountBtn.titleLabel.font = kSecondTitleFont;
    
    [_noCardcashAccountBtn setTitle:kLocalized(@"GYHS_HSAccount_cashAccount") forState:UIControlStateNormal];
    [_noCardcashAccountBtn setTitleColor:kSelectedRed forState:UIControlStateSelected];
    _noCardcashAccountBtn.titleLabel.font = kSecondTitleFont;
    
    [_accountMainScrollView addSubview:self.noCardView];
    [self.noCardView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.mas_equalTo(0);
        make.height.mas_equalTo(kScreenWidth/4.0);
        make.width.mas_equalTo(kScreenWidth * 2);
    }];
}

#pragma mark - 添加一级控制器
- (void)addOneLevelChildVC
{
    for (UIView* view in self.scrollview.subviews) {
        [view removeFromSuperview];
    }
    if (isCardHolder) {
        [self addChildVC:self.pointInvestmentVC index:0];
        [self addChildVC:self.pointHSBVC index:1];
        [self addChildVC:self.HSBCurrencyVC index:2];
        [self addChildVC:self.cashToBankVC index:3];
    }
    else {
        [self addChildVC:self.HSBCurrencyVC index:0];
        [self addChildVC:self.cashToBankVC index:1];
    }
}

#pragma mark - 添加二级控制器
- (void)addTwoLevelChildVC
{
    
    for (UIView* view in self.scrollview.subviews) {
        [view removeFromSuperview];
    }
    if (isCardHolder) {
        [self addChildVC:self.hsCoinAccountVC index:0];
        [self addChildVC:self.pvAccountVC index:1];
        [self addChildVC:self.cashAccountVC index:2];
        [self addChildVC:self.investmentAccountVC index:3];
        [self addChildVC:self.ticketAccountVC index:4];
    }
    else {
        [self addChildVC:self.hsCoinAccountVC index:0];
        [self addChildVC:self.cashAccountVC index:1];
    }
}

#pragma mark - 添加otherMainVC
- (void)addOtherMainVC:(UIViewController*)vc
{

    self.scrollview.contentSize = CGSizeMake(kScreenWidth, 0);
    self.scrollview.contentOffset = CGPointMake(0, 0);
    [self addChildViewController:vc];
    [self.scrollview addSubview:vc.view];
    [vc.view mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(self.scrollview.mas_height);
        make.width.mas_equalTo(kScreenWidth);
    }];
}

#pragma mark - 添加子控制器
- (void)addChildVC:(UIViewController*)vc index:(NSInteger)index
{
    NSInteger offest = self.accountMainScrollView.contentOffset.x / kScreenWidth;
    if (isCardHolder) {
        if (offest == 0) {
            self.scrollview.contentSize = CGSizeMake(kScreenWidth * 4, 0);
        }
        else {
            self.scrollview.contentSize = CGSizeMake(kScreenWidth * 5, 0);
        }
    }
    else {
        self.scrollview.contentSize = CGSizeMake(kScreenWidth * 2, 0);
    }
    [self addChildViewController:vc];
    [self.scrollview addSubview:vc.view];
    [vc.view mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(kScreenWidth * index);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(self.scrollview.mas_height);
        make.width.mas_equalTo(kScreenWidth);
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{

    if (scrollView == self.accountMainScrollView) {
        if (isCardHolder) {
            //刚滑动过来，默认选中互生币账户
            if (_hsCoinAccountBtn.selected) {
                //添加子控制器
                [self addChildVC:self.hsCoinAccountVC index:0];
            }
        }
        else {
            //刚滑动过来，默认选中互生币账户
            if (_noCardHSCoinAccountBtn.selected) {
                //添加子控制器
                [self addChildVC:self.hsCoinAccountVC index:0];
            }
        }
    }
    else if (scrollView == self.scrollview) {
        [self allBtnSelectedNot];
        [self allAccountBtnSelectedNot];
        NSInteger mainOffset = self.accountMainScrollView.contentOffset.x / kScreenWidth;
        NSInteger offset = scrollView.contentOffset.x / kScreenWidth;
        if (mainOffset == 0) {
            [self removeCashToBankChildVC];
            GYHSRedSelectBtn* btn = [self.view viewWithTag:offset + kOneLevelBtnTag];
            btn.selected = YES;
        }
        else if (mainOffset == 1) {
            GYHSRedSelectBtn* btn = [self.view viewWithTag:offset + kTwoLevelBtnTag];
            btn.selected = YES;
        }
    }
}

#pragma mark - 点击事件
//积分投资
- (IBAction)pvInvestment:(UIButton*)sender
{
    kRootCheckLogined
        [self removeOtherMainVC];
    self.scrollview.contentOffset = CGPointMake(0, 0);
    [self allBtnSelectedNot];
    sender.selected = YES;
    _toMainBtn.hidden = NO;
}

//积分转互生币
- (IBAction)pvTohsCoin:(UIButton*)sender
{
    kRootCheckLogined
        [self removeOtherMainVC];
    self.scrollview.contentOffset = CGPointMake(kScreenWidth, 0);
    
    [self allBtnSelectedNot];
    sender.selected = YES;
    _toMainBtn.hidden = NO;
}

//互生币转货币
- (IBAction)hsCoinToCash:(UIButton*)sender
{
    kRootCheckLogined
        [self removeOtherMainVC];
    if (isCardHolder) {
        self.scrollview.contentOffset = CGPointMake(kScreenWidth * 2, 0);
    }
    else {
        self.scrollview.contentOffset = CGPointMake(0, 0);
    }
    
    [self allBtnSelectedNot];
    sender.selected = YES;
    _toMainBtn.hidden = NO;
}

//货币转银行
- (IBAction)cashToBank:(UIButton*)sender
{
    kRootCheckLogined
        [self removeOtherMainVC];
    if (isCardHolder) {
        self.scrollview.contentOffset = CGPointMake(kScreenWidth * 3, 0);
    }
    else {
        self.scrollview.contentOffset = CGPointMake(kScreenWidth, 0);
    }
    [self removeCashToBankChildVC];
    [self allBtnSelectedNot];
    sender.selected = YES;
    
    _toMainBtn.hidden = NO;
}

#pragma 移除子视图的子控制器
- (void)removeCashToBankChildVC
{
    if (self.cashToBankVC.childViewControllers.count) {
        for (UIViewController* vc in self.cashToBankVC.childViewControllers) {
            [vc removeFromParentViewController];
            [vc.view removeFromSuperview];
        }
    }
}

- (IBAction)hsAccount:(UIButton*)sender
{
    kRootCheckLogined
        [self removeOtherMainVC];
    self.scrollview.contentOffset = CGPointMake(0, 0);
    [self addTwoLevelChildVC];
    [self allBtnSelectedNot];
    if (isCardHolder) {
        //滑过去默认选中互生币账户
        _hsCoinAccountBtn.selected = YES;
    }
    else {
        _noCardHSCoinAccountBtn.selected = YES;
    }

    [UIView animateWithDuration:0.5 animations:^{
        _accountMainScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
        _toMainBtn.hidden = NO;
        _toMainBtn.backgroundColor = [UIColor whiteColor];
        
    }];
}

//我的账户
- (IBAction)hsCoinAccount:(UIButton*)sender
{
    kRootCheckLogined
        [self removeOtherMainVC];
    self.scrollview.contentOffset = CGPointMake(0, 0);
    [self allAccountBtnSelectedNot];
    sender.selected = YES;
    
    _toMainBtn.hidden = NO;
}

- (IBAction)pvAccount:(UIButton*)sender
{
    kRootCheckLogined
        [self removeOtherMainVC];
    self.scrollview.contentOffset = CGPointMake(kScreenWidth * 1, 0);
    [self allAccountBtnSelectedNot];
    sender.selected = YES;
    
    _toMainBtn.hidden = NO;
}

- (IBAction)cashAccount:(UIButton*)sender
{
    kRootCheckLogined
        [self removeOtherMainVC];
    if (isCardHolder) {
        self.scrollview.contentOffset = CGPointMake(kScreenWidth * 2, 0);
    }
    else {
        self.scrollview.contentOffset = CGPointMake(kScreenWidth * 1, 0);
    }
    [self allAccountBtnSelectedNot];
    sender.selected = YES;
    _toMainBtn.hidden = NO;
}

- (IBAction)investmentAccount:(UIButton*)sender
{
    kRootCheckLogined
        [self removeOtherMainVC];
    self.scrollview.contentOffset = CGPointMake(kScreenWidth * 3, 0);
    [self allAccountBtnSelectedNot];
    sender.selected = YES;
    _toMainBtn.hidden = NO;
}

- (IBAction)ticketAccount:(UIButton*)sender
{

    kRootCheckLogined
        [self removeOtherMainVC];
    self.scrollview.contentOffset = CGPointMake(kScreenWidth * 4, 0);
    [self allAccountBtnSelectedNot];
    sender.selected = YES;
    _toMainBtn.hidden = NO;
}

- (IBAction)toLeftAction:(id)sender
{
    [self removeOtherMainVC];
    [self addOneLevelChildVC];
    [self addOtherMainVC:self.otherMainVC];
    [self allAccountBtnSelectedNot];
    [UIView animateWithDuration:0.5 animations:^{
        _accountMainScrollView.contentOffset = CGPointMake(0, 0);
        _toMainBtn.hidden = YES;
        _toMainBtn.backgroundColor = [UIColor clearColor];
        kRootCheckLogined
        
    }];
}

- (IBAction)hideVC:(UIButton*)sender
{
    [self showMainView];
}

//移除主控制器
- (void)removeOtherMainVC
{
    if (self.otherMainVC) {
        [self.otherMainVC removeFromParentViewController];
        [self.otherMainVC.view removeFromSuperview];
    }
    NSInteger offest = self.accountMainScrollView.contentOffset.x / kScreenWidth;
    if (isCardHolder) {
        if (offest == 0) {
            self.scrollview.contentSize = CGSizeMake(kScreenWidth * 4, 0);
        }
        else {
            self.scrollview.contentSize = CGSizeMake(kScreenWidth * 5, 0);
        }
    }else {
        self.scrollview.contentSize = CGSizeMake(kScreenWidth * 2, 0);
    }
}

//取消主界面二级目录选中
- (void)allBtnSelectedNot
{
    if (isCardHolder || !globalData.loginModel) {
        _pvInvestmentBtn.selected = NO;
        _pvToHSCoinBtn.selected = NO;
        _hsCoinToCashBtn.selected = NO;
        _cashToBankBtn.selected = NO;
    }
    else {
        _noCardHSCoinToCashBtn.selected = NO;
        _noCardCashToBankBtn.selected = NO;
    }
}

//取消账户的选中
- (void)allAccountBtnSelectedNot
{
    if (isCardHolder || !globalData.loginModel) {
        _hsCoinAccountBtn.selected = NO;
        _pvAccountBtn.selected = NO;
        _cashAccountBtn.selected = NO;
        _investmentAccountBtn.selected = NO;
        _ticketAccountBtn.selected = NO;
    }
    else {
        _noCardHSCoinAccountBtn.selected = NO;
        _noCardcashAccountBtn.selected = NO;
    }
}

#pragma mark - 通知
- (void)updateAboutPv {
//    NSInteger offset = _scrollview.contentOffset.x / kScreenWidth;
//    if (offset == 0) {
        [_pointInvestmentVC refreshAccountBalance];
        [_pointHSBVC refreshAccountBalance];
        
//    }
}

- (void)updateAboutHsCount {
//    NSInteger offset = _scrollview.contentOffset.x / kScreenWidth;
//    if (offset == 0) {
        [_pointHSBVC refreshAccountBalance];
        [_HSBCurrencyVC refreshAccountBalance];
//    }
}

- (void)updateAboutCurrency {
//    NSInteger offset = _scrollview.contentOffset.x / kScreenWidth;
//    if (offset == 0) {
        [_HSBCurrencyVC refreshAccountBalance];
        [_cashToBankVC reloadData];
//    }
}

#pragma mark - 懒加载
- (GYHSCoinAccountViewController*)hsCoinAccountVC
{
    if (!_hsCoinAccountVC) {
        _hsCoinAccountVC = [[GYHSCoinAccountViewController alloc] init];
    }
    return _hsCoinAccountVC;
}

- (GYPvAccountViewController*)pvAccountVC
{
    if (!_pvAccountVC) {
        _pvAccountVC = [[GYPvAccountViewController alloc] init];
    }
    return _pvAccountVC;
}

- (GYHSCashAccountViewController*)cashAccountVC
{
    if (!_cashAccountVC) {
        _cashAccountVC = [[GYHSCashAccountViewController alloc] init];
        }
    return _cashAccountVC;
}

- (GYInvestmentAccountViewController*)investmentAccountVC
{
    if (!_investmentAccountVC) {
        _investmentAccountVC = [[GYInvestmentAccountViewController alloc] init];
    }
    return _investmentAccountVC;
}

- (GYHSOtherMainViewController*)otherMainVC
{
    if (!_otherMainVC) {
        _otherMainVC = [[GYHSOtherMainViewController alloc] init];
    }
    return _otherMainVC;
}

- (GYTicketAccountViewController*)ticketAccountVC
{
    if (!_ticketAccountVC) {
        _ticketAccountVC = [[GYTicketAccountViewController alloc] init];
    }
    return _ticketAccountVC;
}

- (GYHSPointInvestmentViewController*)pointInvestmentVC
{
    if (!_pointInvestmentVC) {
        _pointInvestmentVC = [[GYHSPointInvestmentViewController alloc] init];
        _pointInvestmentVC.accountOperationType = GYHSPointInvestmentType;
    }
    return _pointInvestmentVC;
}

- (GYHSPointInvestmentViewController*)pointHSBVC
{
    if (!_pointHSBVC) {
        _pointHSBVC = [[GYHSPointInvestmentViewController alloc] init];
        _pointHSBVC.accountOperationType = GYHSPointHSBType;
    }
    return _pointHSBVC;
}

- (GYHSPointInvestmentViewController*)HSBCurrencyVC
{
    if (!_HSBCurrencyVC) {
        _HSBCurrencyVC = [[GYHSPointInvestmentViewController alloc] init];
        _HSBCurrencyVC.accountOperationType = GYHSHSBCurrencyType;
    }
    return _HSBCurrencyVC;
}

- (GYHSCashToBankBalanceViewController *)cashToBankVC {

    if(!_cashToBankVC) {
        _cashToBankVC = [[GYHSCashToBankBalanceViewController alloc] init];
    }
    return _cashToBankVC;
}

@end
