//
//  GYLanguageController.m
//  HSConsumer
//
//  Created by kuser on 16/3/7.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYLanguageController.h"
#import "GYSelectLanguageCell.h"
#import "GYHSGeneralController.h"
#import "GYTabBarController.h"
#import "GYSlideMenuController.h"
#import "GYHDUserSetingViewController.h"
#import "GYAppDelegate.h"
#import "CALayer+Transition.h"

static NSString* const GYTableViewCellID = @"GYLanguageController";

#define APPDELEGATE ((GYAppDelegate*)[UIApplication sharedApplication].delegate)
@interface GYLanguageController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* iconDataArray; //图标数据源
@property (nonatomic, strong) NSMutableArray* titleDataArray; //标题数据源

@property (nonatomic, strong) GYSelectLanguageCell* cell1;
@property (nonatomic, strong) GYSelectLanguageCell* cell2;
@property (nonatomic, strong) GYSelectLanguageCell* cell3;

@end

@implementation GYLanguageController

#pragma mark - life cycle
+ (void)initialize
{
    [super initialize];
}

- (void)viewDidLoad
{
    [self initUI];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _titleDataArray = [NSMutableArray arrayWithObjects:
                       kLocalized(@"GYHS_General_Chinese_Simplified"),
                       kLocalized(@"GYHS_General_Chinese_Traditional"),
                       kLocalized(@"GYHS_General_English"), nil];
    _iconDataArray = [NSMutableArray arrayWithObjects:@"hs_cell_img_language_sim", @"hs_cell_img_language_tra", @"hs_cell_img_language_en", nil];
}

#pragma mark - SystemDelegate

#pragma mark TableView Delegate
//设置Section 个数 组头高度 组尾高度 组头背景图 组尾背景图
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16.0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 16.0;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 16)];
    view.backgroundColor = kDefaultVCBackgroundColor;
    //设置下边框
    [view addBottomBorder];
    
    return view;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    view.backgroundColor = kDefaultVCBackgroundColor;
    //设置上边框
    [view addTopBorder];
    return view;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    //隐藏英文切换
    //return 3;
    return 2;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    if (indexPath.row == 0) {
        _cell1 = [tableView dequeueReusableCellWithIdentifier:GYTableViewCellID];
        if (_titleDataArray.count > indexPath.row) {
            _cell1.titleLabel.text = _titleDataArray[indexPath.row];
        }
        if (_iconDataArray.count > indexPath.row) {
            _cell1.languageImageView.image = [UIImage imageNamed:_iconDataArray[indexPath.row]];
        }
        _cell1.confirmImageView.hidden = YES;
        return _cell1;
    }
    else if (indexPath.row == 1) {
        _cell2 = [tableView dequeueReusableCellWithIdentifier:GYTableViewCellID];
        if (_titleDataArray.count > indexPath.row) {
            _cell2.titleLabel.text = _titleDataArray[indexPath.row];
        }
        if (_iconDataArray.count > indexPath.row) {
            _cell2.languageImageView.image = [UIImage imageNamed:_iconDataArray[indexPath.row]];
        }
        _cell2.confirmImageView.hidden = YES;
        return _cell2;
    }
    else if (indexPath.row == 2) {
        _cell3 = [tableView dequeueReusableCellWithIdentifier:GYTableViewCellID];
        if (_titleDataArray.count > indexPath.row) {
            _cell3.titleLabel.text = _titleDataArray[indexPath.row];
        }
        if (_iconDataArray.count > indexPath.row) {
            _cell3.languageImageView.image = [UIImage imageNamed:_iconDataArray[indexPath.row]];
        }
        _cell3.confirmImageView.hidden = YES;
        return _cell3;
    }
    return nil;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        _cell1.confirmImageView.hidden = NO;
        _cell2.confirmImageView.hidden = YES;
        _cell3.confirmImageView.hidden = YES;
        [GYLocalizableTool setUserlanguage:CHINESE];
    }
    else if (indexPath.row == 1) {
        _cell1.confirmImageView.hidden = YES;
        _cell2.confirmImageView.hidden = NO;
        _cell3.confirmImageView.hidden = YES;
        [GYLocalizableTool setUserlanguage:Traditonal];
    }
    else if (indexPath.row == 2) {
        _cell1.confirmImageView.hidden = YES;
        _cell2.confirmImageView.hidden = YES;
        _cell3.confirmImageView.hidden = NO;
        [GYLocalizableTool setUserlanguage:ENGLISH];
    }
    
    if ([self.delegate respondsToSelector:@selector(tableViewdidSelected:withTitle:withIcon:)]) {
        [self.delegate tableViewdidSelected:indexPath.row withTitle:_titleDataArray[indexPath.row] withIcon:_iconDataArray[indexPath.row]];
    }
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, -64, kScreenWidth, kScreenHeight + 64)];
    view.backgroundColor = [UIColor clearColor];
    [self.navigationController.view addSubview:view];
    
    //只显示文字
    [UIView animateWithDuration:2.0 animations:^{
        view.alpha = 0.0;
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(Jump) userInfo:nil repeats:NO];
}


#pragma mark - CustomDelegate

#pragma mark - event response
- (void)Jump
{
    globalData.viewController = [[GYSlideMenuController alloc] init];
    GYHDUserSetingViewController* leftView = [[GYHDUserSetingViewController alloc] init];
    globalData.viewController.mainViewController = [[GYTabBarController alloc] init];
    globalData.viewController.leftViewController = leftView;
    APPDELEGATE.window.rootViewController = globalData.viewController;
    [APPDELEGATE.window.layer transitionWithAnimType:TransitionAnimTypeRippleEffect subType:TransitionSubtypesFromLeft curve:TransitionCurveLinear duration:0.5f];
    UITabBarController* tabBarVc = (UITabBarController*)globalData.viewController.mainViewController;
    tabBarVc.selectedIndex = tabBarVc.childViewControllers.count - 1;
    GYNavigationController* nav = tabBarVc.childViewControllers.lastObject;
    
    GYHSGeneralController *generalVc = [[GYHSGeneralController alloc] init];
    generalVc.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:generalVc animated:YES];
}


#pragma mark - private methods
- (void)initUI
{
    //注册自定义cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GYSelectLanguageCell" bundle:nil] forCellReuseIdentifier:GYTableViewCellID];
    [self.view addSubview:self.tableView];
}

#pragma mark - getters and setters
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

@end
