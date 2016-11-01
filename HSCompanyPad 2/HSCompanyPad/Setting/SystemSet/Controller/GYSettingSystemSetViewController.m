//
//  GYHSSystemSetViewController.m
//
//  Created by apple on 16/8/1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYSettingSystemSetViewController.h"

@interface GYSettingSystemSetViewController ()

@property (nonatomic, strong) NSArray* timeArray;
@property (nonatomic, strong) NSArray* languageArray;

@property (nonatomic, strong) NSMutableArray* timeButtonArray;
@property (nonatomic, strong) NSMutableArray* languageButtonArray;

@property (nonatomic, strong) UILabel* lockTimeLabel;
@property (nonatomic, strong) UILabel* languageLabel;
@property (nonatomic, strong) UIView* bottomBackView;
@property (nonatomic, strong) UIButton* comfirmButtom;
@property (nonatomic, strong) UIButton* timeButton;
@property (nonatomic, copy) NSString* timeStr;
@property (nonatomic, copy) NSString* languageStr;
@property (nonatomic, assign) NSInteger defaultTime, defaultLanguage;

@end

@implementation GYSettingSystemSetViewController

#pragma mark - lazy load

- (UILabel*)lockTimeLabel
{
    if (!_lockTimeLabel) {
        _lockTimeLabel = [[UILabel alloc] init];
        _lockTimeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _lockTimeLabel.text = kLocalized(@"GYSetting_Lock_Time");
        _lockTimeLabel.font = kFont32;
    }
    return _lockTimeLabel;
}

- (UILabel*)languageLabel
{
    if (!_languageLabel) {
        _languageLabel = [[UILabel alloc] init];
        _languageLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _languageLabel.text = kLocalized(@"GYSetting_Languages");
        _languageLabel.font = kFont32;
    }
    return _languageLabel;
}

- (UIView*)bottomBackView
{
    if (!_bottomBackView) {
        _bottomBackView = [[UIView alloc] init];
        _bottomBackView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.16];
    }
    return _bottomBackView;
}

- (UIButton*)comfirmButtom
{
    if (!_comfirmButtom) {
        _comfirmButtom = [[UIButton alloc] init];
        _comfirmButtom.layer.cornerRadius = 5;
        _comfirmButtom.layer.borderWidth = 1;
        _comfirmButtom.layer.borderColor = kRedE50012.CGColor;
        _comfirmButtom.layer.masksToBounds = YES;
        [_comfirmButtom setTitle:kLocalized(@"GYSetting_Comfirm") forState:UIControlStateNormal];
        [_comfirmButtom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_comfirmButtom setBackgroundColor:kRedE50012];
        [_comfirmButtom addTarget:self action:@selector(comfirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _comfirmButtom;
}

- (NSMutableArray*)timeButtonArray
{
    if (!_timeButtonArray) {
        _timeButtonArray = [[NSMutableArray alloc] init];
    }
    return _timeButtonArray;
}

- (NSMutableArray*)languageButtonArray
{
    if (!_languageButtonArray) {
        _languageButtonArray = [[NSMutableArray alloc] init];
    }
    return _languageButtonArray;
}

- (NSArray*)timeArray
{
    if (!_timeArray) {
        _timeArray = @[ kLocalized(@"GYSetting_Not_Set"), kLocalized(@"GYSetting_One_Minute"), kLocalized(@"GYSetting_Five_Minute"), kLocalized(@"GYSetting_Ten_Minute"), kLocalized(@"GYSetting_Thirty_Minute"), kLocalized(@"GYSetting_One_Hour") ];
    }
    return _timeArray;
}

- (NSArray*)languageArray
{
    if (!_languageArray) {
        _languageArray = @[ kLocalized(@"GYSetting_Set_Simplified_Chinese"), kLocalized(@"GYSetting_Set_Traditional_Chinese"), kLocalized(@"GYSetting_Set_English") ];
    }
    return _languageArray;
}

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getDefaultTimeAndLanguage];
    [self initView];
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

// #pragma mark - SystemDelegate
// #pragma mark TableView Delegate
// #pragma mark - CustomDelegate
// #pragma mark - event response

#pragma mark - private methods
- (void)getDefaultTimeAndLanguage {
    
    switch ([kGetNSUser(@"time") integerValue]) {
        case 60:{
             self.defaultTime = 1;
        }break;
        case 300:{
            self.defaultTime = 2;
        }break;
        case 600:{
            self.defaultTime = 3;
        }break;
        case 1800:{
            self.defaultTime = 4;
        }break;
        case 3600:{
            self.defaultTime = 5;
        }break;
        default:
            self.defaultTime = 0;
        break;
    }
    
    switch ([kGetNSUser(@"language") integerValue]) {
        case 150:{
            self.defaultLanguage = 0;
        }break;
        case 151:{
            self.defaultLanguage = 1;
        }break;
        case 152:{
            self.defaultLanguage = 2;
        }break;
        default:
            break;
    }
    
}

- (void)initView
{
    self.title = kLocalized(@"GYSetting_System_Set");
    self.view.backgroundColor = [UIColor whiteColor];
    DDLogInfo(@"Load Controller: %@", [self class]);
    
    [self.view addSubview:self.lockTimeLabel];
    [self.lockTimeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view).offset(kDeviceProportion(142));
        make.top.equalTo(self.view).offset(44 + kDeviceProportion(50));
        make.height.equalTo(@(kDeviceProportion(40)));
    }];
    
    for (int i = 0; i < self.timeArray.count; i++) {
        UIButton* timeButton = [[UIButton alloc] init];
        timeButton.tag = 100 + i;
        timeButton.layer.borderColor = kGrayCCCCCC.CGColor;
        timeButton.layer.borderWidth = 1;
        timeButton.layer.masksToBounds = YES;
        timeButton.titleLabel.font = kFont32;
        [timeButton setTitle:self.timeArray[i] forState:UIControlStateNormal];
        [timeButton setTitleColor:kGray333333 forState:UIControlStateNormal];
        [timeButton setBackgroundImage:[UIImage imageNamed:@"gyset_no_select"] forState:UIControlStateNormal];
        [timeButton addTarget:self action:@selector(timeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:timeButton];
        [timeButton mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(self.lockTimeLabel.mas_top);
            make.left.equalTo(self.lockTimeLabel.mas_right).offset(kDeviceProportion((93 + 20) * i + 20));
            make.width.equalTo(@(kDeviceProportion(93)));
            make.height.equalTo(@(kDeviceProportion(40)));
        }];
        
        if (i == self.defaultTime) {
            //在此处设置默认的自动锁屏时间
            [timeButton setBackgroundImage:[UIImage imageNamed:@"gyset_select"] forState:UIControlStateNormal];
            [timeButton setTitleColor:kRedE50012 forState:UIControlStateNormal];
            
        }
        [self.timeButtonArray addObject:timeButton];
        self.timeButton = timeButton;
    }
    
    [self.view addSubview:self.languageLabel];
    [self.languageLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view).offset(kDeviceProportion(142));
        make.top.equalTo(self.lockTimeLabel.mas_bottom).offset(kDeviceProportion(20));
        make.height.equalTo(@(kDeviceProportion(40)));
    }];
    
    for (int i = 0; i < self.languageArray.count; i++) {
        UIButton* languageButton = [[UIButton alloc] init];
        languageButton.tag = 200 + i;
        languageButton.layer.borderColor = kGrayCCCCCC.CGColor;
        languageButton.layer.borderWidth = 1;
        languageButton.layer.masksToBounds = YES;
        languageButton.titleLabel.font = kFont32;
        [languageButton setTitle:self.languageArray[i] forState:UIControlStateNormal];
        [languageButton setTitleColor:kGray333333 forState:UIControlStateNormal];
        [languageButton setBackgroundImage:[UIImage imageNamed:@"gyset_no_select"] forState:UIControlStateNormal];
        [languageButton addTarget:self action:@selector(languageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:languageButton];
        [languageButton mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(self.languageLabel.mas_top);
            make.left.equalTo(self.languageLabel.mas_right).offset(kDeviceProportion((93 + 20) * i + 20));
            make.width.equalTo(@(kDeviceProportion(93)));
            make.height.equalTo(@(kDeviceProportion(40)));
        }];
        if (i == self.defaultLanguage) {
            //在此处设置默认的语言
            [languageButton setBackgroundImage:[UIImage imageNamed:@"gyset_select"] forState:UIControlStateNormal];
            [languageButton setTitleColor:kRedE50012 forState:UIControlStateNormal];
        }
        [self.languageButtonArray addObject:languageButton];
    }
    
    [self.view addSubview:self.bottomBackView];
    [self.bottomBackView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kDeviceProportion(70)));
    }];
    
    [self.bottomBackView addSubview:self.comfirmButtom];
    [self.comfirmButtom mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@(kDeviceProportion(33)));
        make.width.equalTo(@(kDeviceProportion(120)));
        make.centerX.centerY.equalTo(self.bottomBackView);
    }];
}

//按钮切换效果而已
- (void)switchEffectWithButtonArray:(NSMutableArray*)array button:(UIButton*)btn
{
    for (UIButton* button in array) {
        [button setBackgroundImage:[UIImage imageNamed:@"gyset_no_select"] forState:UIControlStateNormal];
        [button setTitleColor:kGray333333 forState:UIControlStateNormal];
    }
    
    [btn setTitleColor:kRedE50012 forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"gyset_select"] forState:UIControlStateNormal];
    
    switch (btn.tag) {
        case 100: {
            self.timeStr = kLocalized(@"GYSetting_Not_Set");
        } break;
        case 101: {
            self.timeStr = kLocalized(@"GYSetting_One_Minute");
        } break;
        case 102: {
            self.timeStr = kLocalized(@"GYSetting_Five_Minute");
        } break;
        case 103: {
            self.timeStr = kLocalized(@"GYSetting_Ten_Minute");
        } break;
            
        case 104: {
            self.timeStr = kLocalized(@"GYSetting_Thirty_Minute");
        } break;
        case 105: {
            self.timeStr = kLocalized(@"GYSetting_One_Hour");
        } break;
               default:
            break;
    }
    
    switch (btn.tag) {
        case 200: {
            self.languageStr = kLocalized(@"GYSetting_Set_Simplified_Chinese");
        } break;
        case 201: {
            self.languageStr = kLocalized(@"GYSetting_Set_Traditional_Chinese");
        } break;
        case 202: {
            self.languageStr = kLocalized(@"GYSetting_Set_English");
        } break;
        default:
            break;
    }
}

//#pragma mark - event
- (void)timeButtonAction:(UIButton*)btn
{
    DDLogInfo(@"切换锁屏时间");
    [self switchEffectWithButtonArray:self.timeButtonArray button:btn];
}
- (void)languageButtonAction:(UIButton*)btn
{
    DDLogInfo(@"切换语言");
    [self switchEffectWithButtonArray:self.languageButtonArray button:btn];
}

- (void)comfirmButtonAction
{
    [GYUtils showToast:kLocalized(@"GYSetting_Set_Success")];
    DDLogInfo(@"点击确定");
    if ([self.timeStr isEqualToString:kLocalized(@"GYSetting_Not_Set")]) {
        kSetNSUser(@"time", @0);
    } else if ([self.timeStr isEqualToString:kLocalized(@"GYSetting_One_Minute")]) {
        kSetNSUser(@"time", @60);
    } else if ([self.timeStr isEqualToString:kLocalized(@"GYSetting_Five_Minute")]) {
        kSetNSUser(@"time", @300);
    } else if ([self.timeStr isEqualToString:kLocalized(@"GYSetting_Ten_Minute")]) {
        kSetNSUser(@"time", @600);
    }else if ([self.timeStr isEqualToString:kLocalized(@"GYSetting_Thirty_Minute")]){
        kSetNSUser(@"time", @1800);
    }else if ([self.timeStr isEqualToString:kLocalized(@"GYSetting_One_Hour")]){
        kSetNSUser(@"time", @3600);
    }

    if ([self.languageStr isEqualToString:kLocalized(@"GYSetting_Set_Simplified_Chinese")]) {
        kSetNSUser(@"language", @150);
    }else if ([self.languageStr isEqualToString:kLocalized(@"GYSetting_Set_Traditional_Chinese")]){
    kSetNSUser(@"language", @151);
    }else if ([self.languageStr isEqualToString:kLocalized(@"GYSetting_Set_English")]){
        kSetNSUser(@"language", @152);
    }
 
}

#pragma mark - request

@end
