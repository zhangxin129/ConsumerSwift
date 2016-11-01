//
//  GYEasybuyEvaluationViewController.m
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/4/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEasybuyEvaluationViewController.h"
#import "UIView+CustomBorder.h"
#import "JSONModel+ResponseObject.h"
#import "GYNetRequest.h"
#import "GYEasybuyEvaluationModel.h"
#import "GYEasybuyEvaluationCell.h"
#import "GYEasybuyEvaluationListViewController.h"

#define kGYEasybuyEvaluationCell @"GYEasybuyEvaluationCell"

@interface GYEasybuyEvaluationViewController () <GYNetRequestDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView* evaluationKindView;

@property (weak, nonatomic) IBOutlet UIButton* allBtn;
@property (weak, nonatomic) IBOutlet UIButton* goodBtn;
@property (weak, nonatomic) IBOutlet UIButton* badBtn;

@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;

@property (nonatomic, strong) GYEasybuyEvaluationListViewController* allTabViewController;
@property (nonatomic, strong) GYEasybuyEvaluationListViewController* goodTabViewController;
@property (nonatomic, strong) GYEasybuyEvaluationListViewController* badTabViewController;

@property (nonatomic, assign) int index;

@property (copy, nonatomic) NSString* count;
@property (copy, nonatomic) NSString* currentPage;

@property (nonatomic, strong) NSMutableArray* dataArray;

@end

@implementation GYEasybuyEvaluationViewController

#pragma mark - 生命周期
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;

    self.automaticallyAdjustsScrollViewInsets = NO;

    _count = @"8";
    _currentPage = @"1";

    _allBtn.selected = YES;

    _index = 1;

    [self setUp];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
}

#pragma mark - scrollView代理

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    UIButton* btn = [_evaluationKindView viewWithTag:_index];
    btn.selected = NO;

    _index = scrollView.contentOffset.x / kScreenWidth + 1;
    UIButton* btn2 = [_evaluationKindView viewWithTag:_index];
    btn2.selected = YES;
}

#pragma mark -点击事件
- (IBAction)allEvaluation:(UIButton*)sender
{

    _allBtn.selected = NO;
    _goodBtn.selected = NO;
    _badBtn.selected = NO;

    sender.selected = YES;

    if (sender.tag != _index) {
        _index = (int)sender.tag;
        [self changeScrollView];
    }
}

- (void)pushBack {
    _scrollView.delegate = nil;
    [_scrollView removeFromSuperview];
    _scrollView = nil;
    _allTabViewController = nil;
    _goodTabViewController = nil;
    _badTabViewController = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 自定义方法
- (void)setNav {
    self.title = kLocalized(@"GYHE_Easybuy_evaluateion_commnet");
    UIButton* backBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBut setImage:[UIImage imageNamed:@"gycommon_nav_back"] forState:UIControlStateNormal];
    backBut.frame = CGRectMake(0, 0, 40, 40);
    backBut.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backBut addTarget:self action:@selector(pushBack) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:backBut];
}

- (void)changeScrollView
{
    WS(weakSelf);
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.scrollView.contentOffset = CGPointMake((weakSelf.index-1)*kScreenWidth, 0);

    }];
}

- (void)setUp
{
    [_evaluationKindView addAllBorder];
    [_evaluationKindView setBottomBorderInset:YES];

    [_allBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_goodBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_badBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_allBtn setTitle:kLocalized(@"GYHE_Easybuy_all") forState:UIControlStateNormal];
    [_goodBtn setTitle:kLocalized(@"GYHE_Easybuy_good_comments") forState:UIControlStateNormal];
    [_badBtn setTitle:kLocalized(@"GYHE_Easybuy_bad_comments") forState:UIControlStateNormal];

    _scrollView.contentSize = CGSizeMake(kScreenWidth * 3, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;

    [_scrollView addSubview:self.allTabViewController.view];
    [_scrollView addSubview:self.goodTabViewController.view];
    [_scrollView addSubview:self.badTabViewController.view];
}

#pragma mark - 懒加载
- (GYEasybuyEvaluationListViewController*)allTabViewController
{
    if (!_allTabViewController) {
        _allTabViewController = [[GYEasybuyEvaluationListViewController alloc] init];
        _allTabViewController.itemId = self.itemId;
        _allTabViewController.status = @"0";
        _allTabViewController.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 104);

        [self addChildViewController:_allTabViewController];
    }
    return _allTabViewController;
}

- (GYEasybuyEvaluationListViewController*)goodTabViewController
{
    if (!_goodTabViewController) {
        _goodTabViewController = [[GYEasybuyEvaluationListViewController alloc] init];
        _goodTabViewController.itemId = self.itemId;
        _goodTabViewController.status = @"1";
        _goodTabViewController.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 104);
        [self addChildViewController:_goodTabViewController];
    }
    return _goodTabViewController;
}

- (GYEasybuyEvaluationListViewController*)badTabViewController
{
    if (!_badTabViewController) {
        _badTabViewController = [[GYEasybuyEvaluationListViewController alloc] init];
        _badTabViewController.itemId = self.itemId;
        _badTabViewController.status = @"3";
        _badTabViewController.view.frame = CGRectMake(kScreenWidth * 2, 0, kScreenWidth, kScreenHeight - 104);
        [self addChildViewController:_badTabViewController];
    }
    return _badTabViewController;
}

@end
