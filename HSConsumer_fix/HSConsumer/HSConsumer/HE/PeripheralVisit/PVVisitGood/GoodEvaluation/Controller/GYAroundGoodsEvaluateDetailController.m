//
//  GYAroundGoodsEvaluateDetailController.m
//  HSConsumer
//
//  Created by apple on 14-10-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//全部订单

#define kCellSubCellHeight 80.f

#import "GYAroundGoodsEvaluateDetailController.h"
#import "MenuTabView.h"

#import "GYAroundEvaluateDetailViewController.h"

@interface GYAroundGoodsEvaluateDetailController () <UIScrollViewDelegate, MenuTabViewDelegate> {
    //    GlobalData *data;   //全局单例
    MenuTabView* menu; //菜单视图
    NSArray* menuTitles; //菜单标题数组
    UIScrollView* _scrollV; //滚动视图，用于装载各vc view
    NSMutableArray* arrParentViews; //parentView array
    GYAroundEvaluateDetailViewController* vcWellEvaluation;
    GYAroundEvaluateDetailViewController* vcBadEvaluation;
    GYAroundEvaluateDetailViewController* vcAllEvalution;
}

@end

@implementation GYAroundGoodsEvaluateDetailController


#pragma mark 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    self.view.frame = CGRectMake(0, 44, kScreenWidth, kScreenHeight - 40);
    menuTitles = @[ kLocalized(@"GYHE_SurroundVisit_All"),
        kLocalized(@"GYHE_SurroundVisit_GoodComments"),
        kLocalized(@"GYHE_SurroundVisit_BadComments") ];
    //初始化menu
    menu = [[MenuTabView alloc] initMenuWithTitles:menuTitles withFrame:CGRectMake(0, 0, kScreenWidth, 40) isShowSeparator:YES];
    menu.delegate = self;
    //必须设置menu的delegate 及 _scrollV delegate后才可以设置默认显示

    [self.view addSubview:menu];

    _scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(menu.frame), kScreenWidth, self.view.frame.size.height - CGRectGetMaxY(menu.frame))];
    [self.view addSubview:_scrollV];
    DDLogDebug(@"_scrollV.frame = %@", NSStringFromCGRect(_scrollV.frame));
    [_scrollV setPagingEnabled:YES];
    [_scrollV setBounces:NO];
    [_scrollV setShowsHorizontalScrollIndicator:NO];
    _scrollV.delegate = self;
    [_scrollV setContentSize:CGSizeMake(_scrollV.frame.size.width * menuTitles.count, 150)];
    [_scrollV setBackgroundColor:kDefaultVCBackgroundColor];
    //添加 tableview

    CGRect tableViewFrame = _scrollV.bounds;
    vcWellEvaluation = kLoadVcFromClassStringName(NSStringFromClass([GYAroundEvaluateDetailViewController class]));
    vcWellEvaluation.strGoodId = self.strGoodId;
    vcWellEvaluation.nav = self.navigationController;
    vcWellEvaluation.EvaluteStatus = @"0";
    vcWellEvaluation.view.frame = tableViewFrame;
    [_scrollV addSubview:vcWellEvaluation.view];
    [arrParentViews addObject:vcWellEvaluation];

    tableViewFrame.origin.x += tableViewFrame.size.width;
    vcBadEvaluation = kLoadVcFromClassStringName(NSStringFromClass([GYAroundEvaluateDetailViewController class]));
    vcBadEvaluation.nav = self.navigationController;
    vcBadEvaluation.strGoodId = self.strGoodId;
    vcBadEvaluation.EvaluteStatus = @"1";
    vcBadEvaluation.view.frame = tableViewFrame;
    [_scrollV addSubview:vcBadEvaluation.view];
    [arrParentViews addObject:vcBadEvaluation];

    tableViewFrame.origin.x += tableViewFrame.size.width;
    vcAllEvalution = kLoadVcFromClassStringName(NSStringFromClass([GYAroundEvaluateDetailViewController class]));
    vcAllEvalution.nav = self.navigationController;
    vcAllEvalution.strGoodId = self.strGoodId;
    vcAllEvalution.EvaluteStatus = @"3";
    vcAllEvalution.view.frame = tableViewFrame;
    [_scrollV addSubview:vcAllEvalution.view];
    [arrParentViews addObject:vcAllEvalution];
}

#pragma mark - GYViewControllerDelegate

- (void)pushVC:(id)vc animated:(BOOL)ani
{

    [self.navigationController pushViewController:vc animated:ani];
}

#pragma mark - MenuTabViewDelegate
- (void)changeViewController:(NSInteger)index
{

    CGFloat contentOffsetX = _scrollV.contentOffset.x;
    NSInteger viewIndex = (NSInteger)(contentOffsetX / self.view.frame.size.width);
    if (viewIndex == index)
        return;

    CGFloat _x = _scrollV.frame.size.width * index;
    [_scrollV scrollRectToVisible:CGRectMake(_x,
                                      _scrollV.frame.origin.y,
                                      _scrollV.frame.size.width,
                                      _scrollV.frame.size.height)
                         animated:NO];
    //设置当前导航条标题
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (scrollView == _scrollV) { //因为tableview 中的scrollView 也使用同一代理，所以要判断，否则取得x值不是预期的
        CGFloat _x = scrollView.contentOffset.x; //滑动的即时位置x坐标值
        NSInteger index = (NSInteger)(_x / self.view.frame.size.width); //所偶数当前视图

        //设置滑动过渡位置
        if (index < menu.selectedIndex) {
            if (_x < menu.selectedIndex * self.view.frame.size.width - 0.5 * self.view.frame.size.width) {
                [menu updateMenu:index];
                
            }
        }
        else if (index == menu.selectedIndex) {
            if (_x > menu.selectedIndex * self.view.frame.size.width + 0.5 * self.view.frame.size.width) {
                [menu updateMenu:index + 1];
//
            }
        } else {
            [menu updateMenu:index];
            
        }
    }
}

@end
