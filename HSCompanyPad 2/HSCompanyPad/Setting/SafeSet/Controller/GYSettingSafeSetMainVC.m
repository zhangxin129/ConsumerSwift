//
//  GYHSSafeSetViewController.m
//
//  Created by apple on 16/8/1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYSettingSafeSetMainVC.h"
#import "GYSettingSafeSetPiecewiseView.h"

#import "GYSettingSafeSetModifyLoginPassWordVC.h"
#import "GYSettingSafeSetSetTradePasswordVC.h"
#import "GYSettingSafeSetSetEncryptedVC.h"

#import "GYSettingSafeSetModifyTradePasswordVC.h"
#import "GYSettingSafeSetResetTradePasswordVC.h"

@interface GYSettingSafeSetMainVC () <PiecewiseViewDelegate>

@property (nonatomic, strong) NSMutableArray* controllerArray;
@property (nonatomic, weak) GYBaseViewController* curruentVC;
@property (nonatomic, strong) UIImageView* topBackgroundView;
@property (nonatomic, strong) GYSettingSafeSetPiecewiseView* segControlView;
@end

@implementation GYSettingSafeSetMainVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:GYSetSafeChageVCNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDLogInfo(@"Show Controller: %@", [self class]);
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    for (GYBaseViewController* vc in self.controllerArray) {
        vc.view.frame = CGRectMake(0, 44 + kDeviceProportion(62), kScreenWidth, self.view.frame.size.height - 44 - kDeviceProportion(62));
    }
}

// #pragma mark - SystemDelegate
// #pragma mark TableView Delegate

#pragma mark - PiecewiseViewDelegate
/**
 *  按钮点击事件
 */
- (void)piecewiseView:(GYSettingSafeSetPiecewiseView*)piecewiseView index:(NSInteger)index
{
    GYBaseViewController* vc = self.controllerArray[index];
    if (vc != self.curruentVC) {
        [self transitionFromViewController:self.curruentVC toViewController:vc duration:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
            if (finished) {
                self.curruentVC = vc;
            }
        }];
    }
}

// #pragma mark - event response

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYSetting_Saft_Set");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    DDLogInfo(@"Load Controller: %@", [self class]);
    
    [self.view addSubview:self.topBackgroundView];
    [self.topBackgroundView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(44);
        make.height.equalTo(@(kDeviceProportion(50)));
    }];
    
    UIImageView* navBottomGroundView = [[UIImageView alloc] init];
    navBottomGroundView.image = [UIImage imageNamed:@"gycom_nav_bottom"];
    [self.view addSubview:navBottomGroundView];
    [navBottomGroundView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_topBackgroundView.mas_bottom);
        make.height.equalTo(@(kDeviceProportion(12)));
    }];
    
    [self isSetTradePassword:globalData.loginModel.isSettingTradePwd.boolValue];
}

- (void)isSetTradePassword:(BOOL)isSet
{
    if (self.segControlView.superview) {
        [self.segControlView removeFromSuperview];
        //此处设空是因为GYSettingSafeSetPiecewiseView 的蓝色选中部分不动
        self.segControlView = nil;
    }
    [self.topBackgroundView addSubview:self.segControlView];
    
    for (GYBaseViewController* vc in self.childViewControllers) {
        if (vc.presentedViewController) {
            [vc removeFromParentViewController];
        }
    }
    [self.controllerArray removeAllObjects];
    
    GYSettingSafeSetModifyLoginPassWordVC* loginPassWordVC = [[GYSettingSafeSetModifyLoginPassWordVC alloc] init];
    [self addChildViewController:loginPassWordVC];
    [self.controllerArray addObject:loginPassWordVC];
    
    if (isSet) {
        self.segControlView.frame = CGRectMake(kDeviceProportion(241), kDeviceProportion(12), kDeviceProportion(540), kDeviceProportion(38));
        
        [self.segControlView loadTitleArray:@[ kLocalized(@"GYSetting_Modify_Login_Password"), kLocalized(@"GYSetting_Modify_Trade_Password"), kLocalized(@"GYSetting_Reset_Trade_Password"), kLocalized(@"GYSetting_Set_Encrypted") ]];
        GYSettingSafeSetModifyTradePasswordVC* modifyTradePasswordVC = [[GYSettingSafeSetModifyTradePasswordVC alloc] init];
        [self addChildViewController:modifyTradePasswordVC];
        [self.controllerArray addObject:modifyTradePasswordVC];
        
        GYSettingSafeSetResetTradePasswordVC* resetTradePasswordVC = [[GYSettingSafeSetResetTradePasswordVC alloc] init];
        [self addChildViewController:resetTradePasswordVC];
        [self.controllerArray addObject:resetTradePasswordVC];
    }
    else {
        
        self.segControlView.frame = CGRectMake(kDeviceProportion(309), kDeviceProportion(12), kDeviceProportion(405), kDeviceProportion(38));
        [self.segControlView loadTitleArray:@[ kLocalized(@"GYSetting_Modify_Login_Password"), kLocalized(@"GYSetting_Set_Trade_Password"), kLocalized(@"GYSetting_Set_Encrypted") ]];
        
        GYSettingSafeSetSetTradePasswordVC* tradePasswordVC = [[GYSettingSafeSetSetTradePasswordVC alloc] init];
        [self addChildViewController:tradePasswordVC];
        
        [self.controllerArray addObject:tradePasswordVC];
    }
    
    GYSettingSafeSetSetEncryptedVC* encryptedVC = [[GYSettingSafeSetSetEncryptedVC alloc] init];
    [self addChildViewController:encryptedVC];
    [self.controllerArray addObject:encryptedVC];
    
    self.curruentVC = loginPassWordVC;
    [self.view addSubview:self.curruentVC.view];
}

#pragma mark - event
-(void)notification:(NSNotification*)notification {
    [self isSetTradePassword:YES];
}

#pragma mark - request

#pragma mark - lazy load
- (NSMutableArray*)controllerArray
{
    if (!_controllerArray) {
        _controllerArray = [[NSMutableArray alloc] init];
    }
    return _controllerArray;
}

- (UIImageView*)topBackgroundView
{
    if (!_topBackgroundView) {
        _topBackgroundView = [[UIImageView alloc] init];
        _topBackgroundView.image = [UIImage imageNamed:@"gycom_nav_background"];
        _topBackgroundView.userInteractionEnabled = YES;
    }
    return _topBackgroundView;
}

- (GYSettingSafeSetPiecewiseView*)segControlView
{
    if (!_segControlView) {
        _segControlView = [[GYSettingSafeSetPiecewiseView alloc] init];
        _segControlView.delegate = self;
        _segControlView.textFont = kFont32;
        _segControlView.type = PiecewiseInterfaceTypeBackgroundChange;
        _segControlView.backgroundSeletedColor = kBlue0A59C2;
        _segControlView.backgroundNormalColor = kWhiteFFFFFF;
        _segControlView.textNormalColor = kGray333333;
        _segControlView.textSeletedColor = kWhiteFFFFFF;
    }
    return _segControlView;
}

@end
