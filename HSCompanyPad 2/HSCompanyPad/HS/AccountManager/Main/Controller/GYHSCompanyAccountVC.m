//
//  GYHSCompanyAccountTotalVC.m
//
//  Created by 吴文超 on 16/8/8.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSCompanyAccountVC.h"
#import "GYHSAccountIconCell.h"
#import "GYHSPointRightView.h"
#import "GYHSCashRightView.h"
#import "GYHSHsbRightView.h"
#import "GYHSInvestmentRightView.h"
#import "GYHSCompanyGeneralDetailCheckVC.h"
#import "GYHSCashToBankVC.h"
#import "GYHSBToCashVC.h"
#import "GYHSCompanyToHSBAndInvestmentVC.h"
#import "GYHSCompanyHSBlDetailCheckVC.h" //流通币和慈善救助基金明细表
#import "GYHSInvestmentBonuslCheckVC.h"
#import "GYHSReturnsHistogramVC.h"
//网络部分
#import "GYHSAccountHttpTool.h"
#import "GYHSAccountIconModel.h"
#import "GYHSExchageHSBViewController.h"
#import "GYHSAccountCenter.h"
#define kRightViewTag 1065
#define kLeftTableViewWidth kDeviceProportion(170)
#define kLeftTableViewFourCellHeight kDeviceProportion((self.view.bounds.size.height - kNavigationHeight) * 0.25)
#define kLeftTableViewThreeCellHeight kDeviceProportion((self.view.bounds.size.height - kNavigationHeight) * 0.3333)
#define kRightTableViewWidth kDeviceProportion(854)
#define kRightTableFirstCellHeight (kDeviceProportion(65) + kNavigationHeight)
#define kRightTableSecendCellHeight kDeviceProportion(75)
#define kRightTableThirdCellHeight kDeviceProportion(90)

#define kRemoveInCellTag 987
@interface GYHSCompanyAccountVC () <UITableViewDataSource, UITableViewDelegate, GYHSPointRightViewDelegate, GYHSCashRightViewDelegate, GYHSHsbRightViewDelegate, GYHSInvestmentRightViewDelegate>

@property (nonatomic, weak) GYHSAccountIconCell *selectedCell;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) GYHSPointRightView *pointView;
@property (nonatomic, strong) GYHSCashRightView *cashView;
@property (nonatomic, strong) GYHSHsbRightView *hsbView;
@property (nonatomic, strong) GYHSInvestmentRightView *investView;
@property (nonatomic, strong) NSMutableArray *icons; //主界面左边的元素数组

@end

@implementation GYHSCompanyAccountVC

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

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
}

// #pragma mark - SystemDelegate
// #pragma mark TableView Delegate
// #pragma mark - CustomDelegate
// #pragma mark - event response

#pragma mark - private methods
/**
 *  初始化视图
 */
- (void)initView
{
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    DDLogInfo(@"Load Controller: %@", [self class]);
    [self.view
     addSubview:self.leftTableView];
    @weakify(self);
    [self.leftTableView
     mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.equalTo(self.view);
        make.width.equalTo(@(kLeftTableViewWidth));
        make.height.equalTo(self.view.mas_height);
    }];

    [self tableView:self.leftTableView
     didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                inSection:0]];//调用一次选中方法
}

#pragma mark - event

#pragma mark----- tableviewdatasource // 表视图数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.icons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYHSAccountIconCell *cell = [GYHSAccountIconCell cellWithTableView:tableView];
    cell.model      = self.icons[indexPath.row];
    cell.cellNumber = self.icons.count;
    if (!indexPath.row)
    {
        cell.select = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.icons.count == 4)
    {
        return kLeftTableViewFourCellHeight; //左边的表视图的小单元高度
    }
    else if (self.icons.count == 3)
    {
        return kLeftTableViewThreeCellHeight;
    }
    return kLeftTableViewFourCellHeight;//其他的目前尺寸未知 暂时返回一个默认值
}

/**
 *  选中状态下 图片和文字状态要做切换
 *
 *  @param tableView 表视图
 *  @param indexPath 点中索引
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedCell && _selectedCell == [tableView cellForRowAtIndexPath:indexPath])
    {
        return;
    } //重复点中就返回
    @weakify(self);
    [tableView.visibleCells
     enumerateObjectsUsingBlock:^(GYHSAccountIconCell *cell, NSUInteger idx, BOOL *stop) {
        @strongify(self);
        cell.cellNumber = self.icons.count;
        cell.select = NO;
    }];
    self.selectedCell = [tableView cellForRowAtIndexPath:indexPath];



    self.selectedCell.select = YES;
    //进行状态切换
    UIView *tempRightView;
    
    switch (indexPath.row)
    {
        case 0: {
            
            self.title    = kLocalized(@"GYHS_Account_Points_Account");
            tempRightView = self.pointView;
            
            [[GYHSAccountCenter defaultCenter] updatePointAccount:^(id returnValue) {
                @strongify(self);
                //实现数据更新
                self.pointView.data = [GYHSAccountCenter defaultCenter];
            }
                                                          failure:^(NSError *error){
            }];
        } break;

        case 1: {
            
            tempRightView = self.cashView;
            self.title    = kLocalized(@"GYHS_Account_Cash_Account");
            [[GYHSAccountCenter defaultCenter] updateCashAccount:^(id returnValue) {
                @strongify(self);
                self.cashView.data = [GYHSAccountCenter defaultCenter];
            }
                                                         failure:^(NSError *error){
            }];
        }

        break;

        case 2: {
            
            tempRightView = self.hsbView;
            self.title    = kLocalized(@"GYHS_Account_HSB_Account");
            [[GYHSAccountCenter defaultCenter] updateHsbAccount:^(id returnValue) {
                @strongify(self);
                self.hsbView.data = [GYHSAccountCenter defaultCenter];
            }
                                                        failure:^(NSError *error){
            }];
        }

        break;

        default: {
            
            tempRightView = self.investView;
            self.title    = kLocalized(@"GYHS_Account_Investment_Account");
            [[GYHSAccountCenter defaultCenter] updateInvestAccount:^(id returnValue) {
                @strongify(self);
                self.investView.data = [GYHSAccountCenter defaultCenter];
            }
                                                           failure:^(NSError *error){
            }];
        } break;
    }
    UIView *view = [self.view
                    viewWithTag:kRightViewTag];
    if (view)
    {
        [view removeFromSuperview];
    }
    tempRightView.tag = kRightViewTag;
    [self.view
     addSubview:tempRightView];
    //@weakify(self);
    [tempRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavigationHeight);
        make.width.equalTo(@(kRightTableViewWidth));
        make.height.mas_equalTo(self.view.height - kNavigationHeight);
    }];
}

#pragma mark-----右边视图的代理问题

#pragma mark-----积分账户上面的点击
/**
 *  积分账户上面的点击
 */

- (void)pointView:(GYHSPointRightView *)pointView didTouchEvent:(kPointAccountTouchEvent)event
{
    switch (event)
    {
        case kPointAccountTouchEventDetail: {
            GYHSCompanyGeneralDetailCheckVC *vc = [[GYHSCompanyGeneralDetailCheckVC alloc] init];
            vc.checkType  = kListViewCheckFiveItems;
            vc.detailType = kPointDetailCheckType;
            [self.navigationController
             pushViewController:vc
                       animated:YES];
        } break;
        case kPointAccountTouchEventPointToHsb: {
            //跳转到积分转互生币
            GYHSCompanyToHSBAndInvestmentVC *vc = [[GYHSCompanyToHSBAndInvestmentVC alloc] init];
            vc.vcType = kPointTransformHSB;

            [self.navigationController
             pushViewController:vc
                       animated:YES];
        } break;
        case kPointAccountTouchEventPointToInvest: {
            GYHSCompanyToHSBAndInvestmentVC *vc = [[GYHSCompanyToHSBAndInvestmentVC alloc] init];
            vc.vcType = kPointInvestment;
            [self.navigationController
             pushViewController:vc
                       animated:YES];
        } break;

        default:
            break;
    }
}

#pragma mark-----货币账户上面的点击

- (void)cashView:(GYHSCashRightView *)cashView didTouchEvent:(kCashAccountTouchEvent)event
{
    switch (event)
    {
        case kCashAccountTouchEventDetail: {
            GYHSCompanyGeneralDetailCheckVC *vc = [[GYHSCompanyGeneralDetailCheckVC alloc] init];
            vc.checkType  = kListViewCheckFiveItems;
            vc.detailType = kCashDetailCheckType;
            [self.navigationController
             pushViewController:vc
                       animated:YES];
        } break;
        case kCashAccountTouchEventCashToBank: {
            //跳转到货币转银行
            GYHSCashToBankVC *vc = [[GYHSCashToBankVC alloc] init];

            [self.navigationController
             pushViewController:vc
                       animated:YES];
        } break;
    }
}

#pragma mark-----互生币账户上面的点击
/**
 *  互生币账户上面的点击
 */

- (void)hsbView:(GYHSHsbRightView *)hsbView didTouchEvent:(kHSBAccountTouchEvent)event
{
    switch (event)
    {
        case kHSBAccountTouchEventDetail: {
            if (globalData.companyType != kCompanyType_Membercom)
            {
                GYHSCompanyHSBlDetailCheckVC *checkVC = [[GYHSCompanyHSBlDetailCheckVC alloc] init];

                [self.navigationController
                 pushViewController:checkVC
                           animated:YES];
            }
            else
            {
                GYHSCompanyGeneralDetailCheckVC *checkVC = [[GYHSCompanyGeneralDetailCheckVC alloc] init];
                checkVC.checkType  = kListViewCheckFiveItems;
                checkVC.detailType = kHsbDetailCheckType;
                [self.navigationController
                 pushViewController:checkVC
                           animated:YES];
            }
        } break;
        case kHSBAccountTouchEventHsbToCash: {
            GYHSBToCashVC *vc = [[GYHSBToCashVC alloc] init];

            [self.navigationController
             pushViewController:vc
                       animated:YES];
        } break;
        case kHSBAccountTouchEventExchangeHsb: {
            GYHSExchageHSBViewController *vc = [[GYHSExchageHSBViewController alloc] init];
            [self.navigationController
             pushViewController:vc
                       animated:YES];
        } break;

        default:
            break;
    }
}

#pragma mark-----投资账户上面的点击
/**
 *  投资账户上面的点击
 */
- (void)investmentView:(GYHSInvestmentRightView *)investmentView didTouchEvent:(kInvestmentAccountTouchEvent)event
{
    switch (event)
    {
        case kInvestmentRateTouchEvent: {
            GYHSReturnsHistogramVC *vc = [[GYHSReturnsHistogramVC alloc] init];

            [self.navigationController
             pushViewController:vc
                       animated:YES];
        } break;
        case kInvestmentDetailTouchEvent: {
            //普通的显示4个子列表
            GYHSCompanyGeneralDetailCheckVC *vc = [[GYHSCompanyGeneralDetailCheckVC alloc] init];
            vc.checkType  = kListViewCheckFourItems;
            vc.detailType = kInvestmentDetailCheckType;
            [self.navigationController
             pushViewController:vc
                       animated:YES];
        } break;
        case kDividendDetailQueryTouchEvent: {
            //显示投资分红特殊表
            GYHSInvestmentBonuslCheckVC *vc = [[GYHSInvestmentBonuslCheckVC alloc] init];
            [self.navigationController
             pushViewController:vc
                       animated:YES];
        } break;
    }
}

#pragma mark - lazy load

- (NSMutableArray *)icons
{
    if (!_icons)
    {
        _icons = @[

            [GYHSAccountIconModel modelWithSelectedImage:kLocalized(@"gyhs_point_account_selected")
                                         unselectedImage:kLocalized(@"gyhs_point_account_unselected")
                                                   title:kLocalized(@"GYHS_Account_Points_Account")],
            [GYHSAccountIconModel modelWithSelectedImage:kLocalized(@"gyhs_coin_account_selected")
                                         unselectedImage:kLocalized(@"gyhs_coin_account_unselected")
                                                   title:kLocalized(@"GYHS_Account_Cash_Account")],
            [GYHSAccountIconModel modelWithSelectedImage:kLocalized(@"gyhs_HSB_account_selected")
                                         unselectedImage:kLocalized(@"gyhs_HSB_account_unselected")
                                                   title:kLocalized(@"GYHS_Account_HSB_Account")],
            [GYHSAccountIconModel modelWithSelectedImage:kLocalized(@"gyhs_investment_account_selected")
                                         unselectedImage:kLocalized(@"gyhs_investment_account_unselected")
                                                   title:kLocalized(@"GYHS_Account_Investment_Account")]

        ].mutableCopy;
        if (globalData.companyType == kCompanyType_Membercom)   //成员企业没有投资账户
        {
            [_icons removeLastObject];
        }
    }
    return _icons;
}

- (UITableView *)leftTableView
{
    if (!_leftTableView)
    {
        _leftTableView                = [[UITableView alloc] init];
        _leftTableView.scrollEnabled  = NO;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.delegate       = self;
        _leftTableView.dataSource     = self;
    }

    return _leftTableView;
}

- (GYHSPointRightView *)pointView
{
    if (!_pointView)
    {
        _pointView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHSPointRightView class])
                                                    owner:self
                                                  options:nil] firstObject];
        _pointView.delegate = self;
    }

    return _pointView;
}

- (GYHSCashRightView *)cashView
{
    if (!_cashView)
    {
        _cashView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHSCashRightView class])
                                                   owner:self
                                                 options:nil] firstObject];

        _cashView.delegate = self;
    }
    return _cashView;
}

- (GYHSHsbRightView *)hsbView
{
    if (!_hsbView)
    {
        _hsbView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHSHsbRightView class])
                                                  owner:self
                                                options:nil] firstObject];
        _hsbView.delegate = self;
    }

    return _hsbView;
}

- (GYHSInvestmentRightView *)investView
{
    if (!_investView)
    {
        _investView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHSInvestmentRightView class])
                                                     owner:self
                                                   options:nil] firstObject];
        _investView.delegate = self;
    }

    return _investView;
}

@end
