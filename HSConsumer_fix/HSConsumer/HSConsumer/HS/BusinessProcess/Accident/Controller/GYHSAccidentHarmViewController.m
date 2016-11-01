//
//  GYHSAccidentHarmViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/7/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSAccidentHarmViewController.h"
#import "GYEnsureQualificationViewController.h"
#import "GYApplicationSecurityViewController.h"
#import "MenuTabView.h"

@interface GYHSAccidentHarmViewController ()<GYViewControllerDelegate,UIScrollViewDelegate,MenuTabViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *AccidentscrllView;
@property (strong, nonatomic)GYEnsureQualificationViewController *EnsureQualificationVC;//我的保障资格
@property (strong, nonatomic)GYApplicationSecurityViewController *ApplicationSecurityVC;//申请保障金
@property (nonatomic, strong) MenuTabView* menu; //菜单视图
@property (nonatomic, strong) NSArray* menuTitles; //菜单标题数组
@property (nonatomic, strong) NSMutableArray* arrParentViews;

@end

@implementation GYHSAccidentHarmViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    _menuTitles = @[ kLocalized(@"GYHS_BP_I_Guarantee_Qualification"),
                     kLocalized(@"GYHS_BP_Application_Security") ];
    [self.AccidentscrllView setPagingEnabled:YES];
    [self.AccidentscrllView setBounces:NO];
    [self.AccidentscrllView setShowsHorizontalScrollIndicator:NO];
    self.AccidentscrllView.delegate = self;
    [self.AccidentscrllView setContentSize:CGSizeMake(kScreenWidth * _menuTitles.count, 150)];
    [self.AccidentscrllView setBackgroundColor:kDefaultVCBackgroundColor];
    //添加 tableview
    self.ApplicationSecurityVC = kLoadVcFromClassStringName(NSStringFromClass([GYApplicationSecurityViewController class]));
    self.ApplicationSecurityVC.nav = self.navigationController;
    self.EnsureQualificationVC = kLoadVcFromClassStringName(NSStringFromClass([GYEnsureQualificationViewController class]));
    self.EnsureQualificationVC.nav = self.navigationController;
    _arrParentViews = [@[ self.EnsureQualificationVC, self.ApplicationSecurityVC ] mutableCopy];
    CGRect tableViewFrame = CGRectMake(0, 0, kScreenWidth, self.AccidentscrllView.bounds.size.height-10);
    for (int i = 0; i < _menuTitles.count; i++) {
        tableViewFrame.origin.x = kScreenWidth * i;
        GYEnsureQualificationViewController* vc = _arrParentViews[i];
        vc.view.frame = tableViewFrame;
        [self.AccidentscrllView addSubview:vc.view];
    }
    _menu = [[MenuTabView alloc] initMenuWithTitles:_menuTitles withFrame:CGRectMake(0, 0, kScreenWidth, 40) isShowSeparator:YES];
    _menu.delegate = self;
    //必须设置menu的delegate 及 _scrollV delegate后才可以设置默认显示
    [_menu setDefaultItem:self.index % 2];
    [self.view addSubview:_menu];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //只有返回首页才隐藏NavigationBarHidden
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) { //返回
        if ([self.navigationController.topViewController isKindOfClass:[GYHSAccidentHarmViewController class]]) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark -GYViewControllerDelegate
- (void)pushVC:(id)vc animated:(BOOL)ani
{
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark -MenuTabViewDelegate
- (void)changeViewController:(NSInteger)index
{
    CGFloat contentOffsetX = self.AccidentscrllView.contentOffset.x;
    NSInteger viewIndex = (NSInteger)(contentOffsetX / self.view.frame.size.width);
    if (viewIndex == index)
        return;
    CGFloat _x = self.AccidentscrllView.frame.size.width * index;
    [self.AccidentscrllView scrollRectToVisible:CGRectMake(_x,
                                             self.AccidentscrllView.frame.origin.y,
                                             self.AccidentscrllView.frame.size.width,
                                             self.AccidentscrllView.frame.size.height)
                         animated:NO];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (scrollView == self.AccidentscrllView) { //因为tableview 中的scrollView 也使用同一代理，所以要判断，否则取得x值不是预期的
        CGFloat _x = scrollView.contentOffset.x; //滑动的即时位置x坐标值
        NSInteger index = (NSInteger)(_x / self.view.frame.size.width); //所偶数当前视图
        //设置滑动过渡位置
        if (index < _menu.selectedIndex) {
            if (_x < _menu.selectedIndex * self.view.frame.size.width - 0.5 * self.view.frame.size.width) {
                [_menu updateMenu:index];
            }
        }
        else if (index == _menu.selectedIndex) {
            if (_x > _menu.selectedIndex * self.view.frame.size.width + 0.5 * self.view.frame.size.width) {
                [_menu updateMenu:index + 1];
            }
        } else {
            [_menu updateMenu:index];
        }
    }
}


@end
