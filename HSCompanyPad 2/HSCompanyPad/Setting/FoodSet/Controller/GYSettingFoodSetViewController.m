//
//  GYHSFoodSetViewController.m
//
//  Created by apple on 16/8/1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYSettingFoodSetViewController.h"
#import "GYSelectedButton.h"

@interface GYSettingFoodSetViewController ()

@property (nonatomic, strong) NSArray* maxFoodNumArray;
/*!
 *    容纳点菜最大数量按钮的数组
 */
@property (nonatomic, strong) NSMutableArray* maxFoodButtonArray;

@property (nonatomic, strong) NSArray* updateFrequencyArray;
/*!
 *    容纳更新频率按钮的数组
 */
@property (nonatomic, strong) NSMutableArray* updateButtonArray;

@property (nonatomic, strong) UIButton* choseBussinessButton;
@property (nonatomic, strong) UILabel* choseBussinessLabel;
@property (nonatomic, strong) UILabel* choseMaxFoodLabel;
@property (nonatomic, strong) UILabel* updateFrequencyLabel;
@property (nonatomic, strong) UIButton* clearCacheButton;
@property (nonatomic, strong) UIButton* updateNowButton;
@property (nonatomic, strong) UIButton* saveButton;
@end

@implementation GYSettingFoodSetViewController

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

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.choseBussinessButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
    self.choseBussinessButton.imageEdgeInsets = UIEdgeInsetsMake(0, self.choseBussinessButton.bounds.size.width - 40, 0, 0);
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
}

// #pragma mark - SystemDelegate
// #pragma mark TableView Delegate

//#pragma mark - GYSelectedButtonDelegate

// #pragma mark - event response

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYSetting_Food_Set");
    self.view.backgroundColor = [UIColor whiteColor];
    DDLogInfo(@"Load Controller: %@", [self class]);
    

    [self.view addSubview:self.choseBussinessButton];
    [self.choseBussinessButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(self.view).offset(kDeviceProportion(-283));
        make.top.equalTo(self.view).offset(kDeviceProportion(100));
        make.width.equalTo(@(kDeviceProportion(340)));
        make.height.equalTo(@(kDeviceProportion(40)));
    }];
    

    [self.view addSubview:self.choseBussinessLabel];
    [self.choseBussinessLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(self.choseBussinessButton.mas_left).offset(kDeviceProportion(-20));
        make.height.equalTo(@(kDeviceProportion(40)));
        make.top.equalTo(self.choseBussinessButton.mas_top);
    }];
    
    for (int i = 0; i < self.maxFoodNumArray.count; i++) {
        UIButton* foodNumBtn = [[UIButton alloc] init];
        foodNumBtn.layer.borderWidth = 1;
        foodNumBtn.layer.borderColor = kGrayCCCCCC.CGColor;
        foodNumBtn.layer.masksToBounds = YES;
        foodNumBtn.titleLabel.font = kFont32;
        foodNumBtn.tag = 100 + self.maxFoodNumArray.count - i - 1;
        [foodNumBtn setTitleColor:kGray333333 forState:UIControlStateNormal];
        [foodNumBtn setBackgroundImage:[UIImage imageNamed:@"gyset_no_select"] forState:UIControlStateNormal];
        [foodNumBtn setTitle:self.maxFoodNumArray[self.maxFoodNumArray.count - i - 1] forState:UIControlStateNormal];
        [foodNumBtn addTarget:self action:@selector(choseFoodNumBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:foodNumBtn];
        [foodNumBtn mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(self.view).offset(kDeviceProportion(-283 - (100+20)*i));
            make.width.equalTo(@(kDeviceProportion(100)));
            make.height.equalTo(@(kDeviceProportion(40)));
            make.top.equalTo(self.choseBussinessButton.mas_bottom).offset(kDeviceProportion(20));
        }];
        if (self.maxFoodNumArray.count - i - 1 == 2) {
            [foodNumBtn setBackgroundImage:[UIImage imageNamed:@"gyset_select"] forState:UIControlStateNormal];
        }
        [self.maxFoodButtonArray addObject:foodNumBtn];
    }
    

    [self.view addSubview:self.choseMaxFoodLabel];
    [self.choseMaxFoodLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(self.choseBussinessLabel.mas_right);
        make.height.equalTo(@(kDeviceProportion(40)));
        make.top.equalTo(self.choseBussinessButton.mas_bottom).offset(kDeviceProportion(20));
    }];
    
    for (int i = 0; i < self.updateFrequencyArray.count; i++) {
        UIButton* updateFrequencyBtn = [[UIButton alloc] init];
        updateFrequencyBtn.layer.borderWidth = 1;
        updateFrequencyBtn.layer.borderColor = kGrayCCCCCC.CGColor;
        updateFrequencyBtn.layer.masksToBounds = YES;
        updateFrequencyBtn.titleLabel.font = kFont32;
        updateFrequencyBtn.tag = 200 + self.updateFrequencyArray.count - i - 1;
        [updateFrequencyBtn setTitleColor:kGray333333 forState:UIControlStateNormal];
        [updateFrequencyBtn setBackgroundImage:[UIImage imageNamed:@"gyset_no_select"] forState:UIControlStateNormal];
        [updateFrequencyBtn setTitle:self.updateFrequencyArray[self.updateFrequencyArray.count - i - 1] forState:UIControlStateNormal];
        [updateFrequencyBtn addTarget:self action:@selector(choseUpdateFrequencyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:updateFrequencyBtn];
        [updateFrequencyBtn mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(self.view).offset(kDeviceProportion(-283 - (160+20)*i));
            make.width.equalTo(@(kDeviceProportion(160)));
            make.height.equalTo(@(kDeviceProportion(40)));
            make.top.equalTo(self.choseMaxFoodLabel.mas_bottom).offset(kDeviceProportion(20));
        }];
        if (self.updateFrequencyArray.count - i - 1 == 0) {
            //设置默认的更新频率
            [updateFrequencyBtn setBackgroundImage:[UIImage imageNamed:@"gyset_select"] forState:UIControlStateNormal];
        }
        [self.updateButtonArray addObject:updateFrequencyBtn];
    }
    

    [self.view addSubview:self.updateFrequencyLabel];
    [self.updateFrequencyLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(self.choseBussinessLabel.mas_right);
        make.height.equalTo(@(kDeviceProportion(40)));
        make.top.equalTo(self.choseMaxFoodLabel.mas_bottom).offset(kDeviceProportion(20));
    }];
    
    UIView* bottomBackView = [[UIView alloc] init];
    bottomBackView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.16];
    [self.view addSubview:bottomBackView];
    [bottomBackView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kDeviceProportion(70)));
    }];
    

    [bottomBackView addSubview:self.clearCacheButton];
    [self.clearCacheButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.centerY.equalTo(bottomBackView);
        make.height.equalTo(@(kDeviceProportion(33)));
        make.width.equalTo(@(kDeviceProportion(120)));
    }];
    

    [bottomBackView addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(self.clearCacheButton.mas_left).offset(kDeviceProportion(-15));
        make.top.equalTo(self.clearCacheButton.mas_top);
        make.height.equalTo(@(kDeviceProportion(33)));
        make.width.equalTo(@(kDeviceProportion(120)));
    }];
    
    [bottomBackView addSubview:self.updateNowButton];
    [self.updateNowButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.clearCacheButton.mas_right).offset(kDeviceProportion(15));
        make.top.equalTo(self.clearCacheButton.mas_top);
        make.height.equalTo(@(kDeviceProportion(33)));
        make.width.equalTo(@(kDeviceProportion(120)));
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
}

#pragma mark - event
- (void)choseFoodNumBtnAction:(UIButton*)btn
{
    //切换点菜最大份数
    [self switchEffectWithButtonArray:self.maxFoodButtonArray button:btn];
}

- (void)choseUpdateFrequencyBtnAction:(UIButton*)btn
{
    //切换更新频率
    [self switchEffectWithButtonArray:self.updateButtonArray button:btn];
}

- (void)updateNowButtonAction
{
    //立即更新
}

- (void)saveButtonAction
{
    //保存
}

- (void)clearCacheButtonAction
{
    //清除缓存
}

#pragma mark - request

#pragma mark - lazy load
- (NSArray*)updateFrequencyArray
{
    if (!_updateFrequencyArray) {
        _updateFrequencyArray = @[ kLocalized(@"GYSetting_Times_Hour"), kLocalized(@"GYSetting_Times_Day") ];
    }
    return _updateFrequencyArray;
}

- (NSArray*)maxFoodNumArray
{
    if (!_maxFoodNumArray) {
        _maxFoodNumArray = @[ @"1", @"2", @"3" ];
    }
    return _maxFoodNumArray;
}

- (NSMutableArray*)updateButtonArray
{
    if (!_updateButtonArray) {
        _updateButtonArray = [[NSMutableArray alloc] init];
    }
    return _updateButtonArray;
}

-(NSMutableArray *)maxFoodButtonArray{
    if (!_maxFoodButtonArray) {
        _maxFoodButtonArray  =[[NSMutableArray alloc] init];
    }
    return _maxFoodButtonArray;
}

-(UIButton *)choseBussinessButton{
    if (!_choseBussinessButton) {
        _choseBussinessButton = [[UIButton alloc] init];
        _choseBussinessButton.layer.borderWidth = 1;
        _choseBussinessButton.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
        _choseBussinessButton.layer.masksToBounds = YES;
        _choseBussinessButton.titleLabel.font = kFont32;
        _choseBussinessButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _choseBussinessButton.imageView.contentMode = UIViewContentModeCenter;
        [_choseBussinessButton setImage:[UIImage imageNamed:@"gycom_blue_pullDowm"] forState:UIControlStateNormal];
        [_choseBussinessButton setTitle:@"归一科技有限公司餐厅" forState:UIControlStateNormal];
        [_choseBussinessButton setTitleColor:kGray333333 forState:UIControlStateNormal];
    }
    return _choseBussinessButton;
}
-(UILabel *)choseBussinessLabel{
    if (!_choseBussinessLabel) {
        _choseBussinessLabel = [[UILabel alloc] init];
        _choseBussinessLabel.font = kFont32;
        _choseBussinessLabel.textAlignment = NSTextAlignmentRight;
        _choseBussinessLabel.text = kLocalized(@"GYSetting_Choose_Establishment");
    }
    return _choseBussinessLabel;
}
-(UILabel *)choseMaxFoodLabel{
    if (!_choseMaxFoodLabel) {
        _choseMaxFoodLabel = [[UILabel alloc] init];
        _choseMaxFoodLabel.font = kFont32;
        _choseMaxFoodLabel.textAlignment = NSTextAlignmentRight;
        _choseMaxFoodLabel.text = kLocalized(@"GYSetting_Maximum_Number_Of_Copies");
    }
    return _choseMaxFoodLabel;
}
-(UILabel *)updateFrequencyLabel{
    if (!_updateFrequencyLabel) {
        _updateFrequencyLabel = [[UILabel alloc] init];
        _updateFrequencyLabel.font = kFont32;
        _updateFrequencyLabel.textAlignment = NSTextAlignmentRight;
        _updateFrequencyLabel.text = kLocalized(@"GYSetting_Data_Update_Frequency");
    }
    return _updateFrequencyLabel;
}
-(UIButton *)clearCacheButton{
    if (!_clearCacheButton) {
        _clearCacheButton = [[UIButton alloc] init];
        _clearCacheButton.backgroundColor = [UIColor colorWithHexString:@"#a4a4b7"];
        _clearCacheButton.titleLabel.font = kFont32;
        [_clearCacheButton setTitle:kLocalized(@"GYSetting_Clear_Chace") forState:UIControlStateNormal];
        [_clearCacheButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_clearCacheButton addTarget:self action:@selector(clearCacheButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearCacheButton;
}
-(UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] init];
        _saveButton.backgroundColor = [UIColor colorWithHexString:@"#e50012"];
        [_saveButton setTitle:kLocalized(@"GYSetting_Save") forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveButton.titleLabel.font = kFont32;
        [_saveButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}
-(UIButton *)updateNowButton{
    if (!_updateNowButton) {
        _updateNowButton = [[UIButton alloc] init];
        _updateNowButton.backgroundColor = [UIColor colorWithHexString:@"#a4a4b7"];
        [_updateNowButton setTitle:kLocalized(@"GYSetting_Update_Now") forState:UIControlStateNormal];
        _updateNowButton.titleLabel.font = kFont32;
        [_updateNowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_updateNowButton addTarget:self action:@selector(updateNowButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updateNowButton;
}


@end
