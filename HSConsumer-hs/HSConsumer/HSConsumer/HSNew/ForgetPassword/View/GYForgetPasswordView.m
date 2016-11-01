//
//  GYForgetPasswordView.m
//  HSConsumer
//
//  Created by lizp on 16/9/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kMarginLeft 16.0f
#define kMarginTop kScreenWidth / 4
#define kBackgroundHeight 347.0f
#define kBackWayBtnTag 600

#import "GYForgetPasswordView.h"
#import "GYPasswordSelectButton.h"
#import "YYKit.h"
#import "GYPasswordTextFieldCell.h"

@interface GYForgetPasswordView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView* backgroundView; //背景层
@property (nonatomic, strong) GYPasswordSelectButton* backPasswordBtn; //密码找回
@property (nonatomic, strong) GYPasswordSelectButton* noCardBtn; //非持卡人用户注册
@property (nonatomic, strong) UIButton* dismissButton;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* registArr; //tableView  注册数据源
@property (nonatomic, strong) NSArray* backPwdArr; // 密码找回数据源

@property (nonatomic, strong) UIView* footerView;
@property (nonatomic, strong) UIView* headerView;
@property (nonatomic, strong) UIButton* registedButton; //注册

@property (nonatomic, assign) BOOL isBackPassword; //是否选中密码找回按钮

@end

@implementation GYForgetPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{

    //背景层
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(kMarginLeft, kMarginTop, kScreenWidth - 2 * kMarginLeft, kBackgroundHeight)];
    self.backgroundView.layer.cornerRadius = 5;
    self.backgroundView.clipsToBounds = YES;
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backgroundView];

    //取消
    self.dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dismissButton.backgroundColor = [UIColor clearColor];
    self.dismissButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 15, self.backgroundView.bottom + 14, 30, 30);
    [self.dismissButton setBackgroundImage:[UIImage imageNamed:@"gyhs_account_delete_view"] forState:UIControlStateNormal];
    [self.dismissButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.dismissButton];

    //密码找回
    self.backPasswordBtn = [GYPasswordSelectButton buttonWithType:UIButtonTypeCustom];
    self.backPasswordBtn.type = GYPasswordSelectButtonTypeBack;
    self.backPasswordBtn.backgroundColor = [UIColor whiteColor];
    self.backPasswordBtn.frame = CGRectMake(0, 0, self.backgroundView.bounds.size.width / 2, 46);
    [self.backPasswordBtn setTitle:kLocalized(@"密码找回") forState:UIControlStateNormal];
    [self.backPasswordBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    [self.backPasswordBtn setTitleColor:UIColorFromRGB(0xef4136) forState:UIControlStateSelected];
    self.backPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.backPasswordBtn addTarget:self action:@selector(passwordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:self.backPasswordBtn];
    self.backPasswordBtn.selected = NO;

    //非持卡人用户注册
    self.noCardBtn = [GYPasswordSelectButton buttonWithType:UIButtonTypeCustom];
    self.noCardBtn.type = GYPasswordSelectButtonTypeRegisted;
    self.noCardBtn.backgroundColor = [UIColor whiteColor];
    self.noCardBtn.frame = CGRectMake(self.backPasswordBtn.right, self.backPasswordBtn.top, self.backgroundView.bounds.size.width / 2, self.backPasswordBtn.height);
    [self.noCardBtn setTitle:kLocalized(@"非持卡人用户注册") forState:UIControlStateNormal];
    [self.noCardBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    [self.noCardBtn setTitleColor:UIColorFromRGB(0xef4136) forState:UIControlStateSelected];
    self.noCardBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.noCardBtn addTarget:self action:@selector(passwordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:self.noCardBtn];
    self.noCardBtn.selected = YES;
    self.isBackPassword = NO;

    [self.backgroundView addSubview:self.tableView];
}

- (UIView*)addHeaderView
{

    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.backgroundView.bounds.size.width, 95)];

    CGFloat btnWidth = (self.headerView.bounds.size.width - 2 * kMarginLeft) / 3;
    CGFloat btnHeigth = 39;

    for (NSInteger i = 0; i < 3; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;

        btn.frame = CGRectMake(kMarginLeft + i * btnWidth, 14, btnWidth, btnHeigth);
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        [btn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xef4136) forState:UIControlStateSelected];
        btn.tag = kBackWayBtnTag + i;
        if (i == 0) {
            [btn setTitle:kLocalized(@"手机号找回") forState:UIControlStateNormal];
        }
        else if (i == 1) {
            [btn setTitle:kLocalized(@"密保问题找回") forState:UIControlStateNormal];
            btn.selected = YES;
        }
        else if (i == 2) {
            [btn setTitle:kLocalized(@"邮箱找回") forState:UIControlStateNormal];
        }

        [btn addTarget:self action:@selector(backWay:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:btn];
    }

    return self.headerView;
}

- (UIView*)addFooteView
{
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.backgroundView.bounds.size.height - self.tableView.bottom)];
    self.registedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.registedButton.frame = CGRectMake(kMarginLeft, 16, self.backgroundView.bounds.size.width - 2 * kMarginLeft, 41);
    self.registedButton.layer.cornerRadius = 8;
    self.registedButton.clipsToBounds = YES;
    if (self.isBackPassword) {
        [self.registedButton setTitle:kLocalized(@"下一步") forState:UIControlStateNormal];
    }
    else {
        [self.registedButton setTitle:kLocalized(@"注册") forState:UIControlStateNormal];
    }

    self.registedButton.backgroundColor = UIColorFromRGB(0x1d7dd6);
    [self.registedButton setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [self.registedButton addTarget:self action:@selector(registedInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:self.registedButton];

    return self.footerView;
}

//找回方式
- (void)backWay:(UIButton*)sender
{

    if (sender.selected == YES) {
        return;
    }

    for (UIView* view in self.headerView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* btn = (UIButton*)view;
            btn.selected = NO;
        }
    }
    sender.selected = YES;
}

//注册
- (void)registedInfo
{
}

//取消叉叉
- (void)cancel
{

    //    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismiss)]) {
        [self.delegate dismiss];
    }
}

//密码找回和非持卡人用户注册 点击事件
- (void)passwordBtnClick:(GYPasswordSelectButton*)sender
{

    if (sender.selected == YES) {
        return;
    }
    for (UIView* view in self.backgroundView.subviews) {
        if ([view isKindOfClass:[GYPasswordSelectButton class]]) {
            GYPasswordSelectButton* button = (GYPasswordSelectButton*)view;
            button.selected = NO;
        }
    }

    sender.selected = YES;

    if (sender.type == GYPasswordSelectButtonTypeBack) {
        self.isBackPassword = YES;
        self.tableView.tableHeaderView = [self addHeaderView];
    }
    else if (sender.type == GYPasswordSelectButtonTypeRegisted) {
        self.isBackPassword = NO;
        self.tableView.tableHeaderView = [[UIView alloc] init];
    }

    self.tableView.tableFooterView = [self addFooteView];
    [self.tableView reloadData];
}

//点击获取
- (void)codeObtain
{
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isBackPassword) {
        return self.backPwdArr.count;
    }
    else {
        return self.registArr.count;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    GYPasswordTextFieldCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYPasswordTextFieldCellIdentifier];
    if (!cell) {
        cell = [[GYPasswordTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYPasswordTextFieldCellIdentifier];
    }

    if (indexPath.row == 1) {
        cell.codeButton.hidden = NO;
        cell.lineView.hidden = NO;
        cell.detailTextField.frame = CGRectMake(cell.titleLabel.right + 40, 0, cell.bounds.size.width - cell.titleLabel.right - 40 - 108, cell.bounds.size.height);
        [cell.codeButton addTarget:self action:@selector(codeObtain) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        cell.codeButton.hidden = YES;
        cell.lineView.hidden = YES;
        cell.detailTextField.frame = CGRectMake(cell.titleLabel.right + 40, 0, cell.bounds.size.width - cell.titleLabel.right - 40 - 20, cell.bounds.size.height);
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.isBackPassword) {
        NSDictionary* dict = self.backPwdArr[indexPath.row];
        [cell refleshTitle:dict[@"title"] placehold:dict[@"placehold"] detail:dict[@"detail"] codeTitle:nil];
    }
    else {
        NSDictionary* dict = self.registArr[indexPath.row];
        [cell refleshTitle:dict[@"title"] placehold:dict[@"placehold"] detail:nil codeTitle:dict[@"btnTitle"]];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 46;
}

#pragma mark - set or get
- (UITableView*)tableView
{

    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.backPasswordBtn.bottom, self.backgroundView.bounds.size.width, self.backgroundView.bounds.size.height - self.backPasswordBtn.bottom) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[GYPasswordTextFieldCell class] forCellReuseIdentifier:kGYPasswordTextFieldCellIdentifier];
    }
    return _tableView;
}

- (NSArray*)registArr
{
    if (!_registArr) {
        _registArr = @[ @{ @"title" : kLocalized(@"手机号"),
            @"placehold" : kLocalized(@"输入手机号"),
            @"btnTitle" : @""
        },
            @{ @"title" : kLocalized(@"验证码"),
                @"placehold" : kLocalized(@"输入验证码"),
                @"btnTitle" : kLocalized(@"点击获取")
            },
            @{ @"title" : kLocalized(@"密码"),
                @"placehold" : kLocalized(@"输入密码"),
                @"btnTitle" : kLocalized(@"")
            },
            @{ @"title" : kLocalized(@"确定新密码"),
                @"placehold" : kLocalized(@"重复输入密码"),
                @"btnTitle" : kLocalized(@"")
            } ];
    }
    return _registArr;
}

- (NSArray*)backPwdArr
{

    if (_backPwdArr == nil) {
        _backPwdArr = @[ @{ @"title" : kLocalized(@"互生号"),
            @"placehold" : kLocalized(@"输入互生号"),
            @"detail" : @""
        },
            @{ @"title" : kLocalized(@"问题"),
                @"placehold" : kLocalized(@""),
                @"detail" : kLocalized(@"您的幸运数字?")
            },
            @{ @"title" : kLocalized(@"答案"),
                @"placehold" : kLocalized(@"输入答案"),
                @"detail" : kLocalized(@"")
            },
        ];
    }
    
    return _backPwdArr;
}

@end
