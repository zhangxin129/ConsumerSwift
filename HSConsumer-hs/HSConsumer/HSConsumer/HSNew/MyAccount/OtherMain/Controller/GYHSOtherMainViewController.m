//
//  GYHSOtherMainViewController.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSOtherMainViewController.h"
#import "GYHSAccidentHarmMainViewController.h"
#import "GYHSHealthPlanViewController.h"
#import "GYHSScoreWealQueryViewController.h"
#import "GYHSServerOrderViewController.h"
#import "GYHSTakeAwayOrderViewController.h"
#import "GYHSTools.h"

@interface GYHSOtherMainViewController ()

@property (nonatomic, weak) GYHSScoreWealQueryViewController* wealVC;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* hsServerViewTop;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint* hsServerViewHeight;
@property (weak, nonatomic) IBOutlet UIView* hsServerView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnArr;


@end

@implementation GYHSOtherMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    for(int i = 0;i < _btnArr.count;i++) {
        UIButton * btn = _btnArr[i];
        btn.titleLabel.font = kSecondTitleFont;
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    [self refreshWithIsCardUser];
    if (self.wealVC) {
        self.wealVC.view.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)accidentHarmBtn:(id)sender
{
    GYHSAccidentHarmMainViewController* VC = [[GYHSAccidentHarmMainViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

//医疗补贴
- (IBAction)healthPlanClick:(UIButton*)sender
{

    GYHSHealthPlanViewController* vc = [[GYHSHealthPlanViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//积分福利
- (IBAction)scoreWealClick:(UIButton*)sender
{
    GYHSScoreWealQueryViewController* vc = [[GYHSScoreWealQueryViewController alloc] init];
    vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    vc.view.frame = [UIScreen mainScreen].bounds;
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    UIWindow* window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:vc.view];
    self.wealVC = vc;
}

//服务订单
- (IBAction)serverOrderClick:(id)sender
{

    GYHSServerOrderViewController* vc = [[GYHSServerOrderViewController alloc] init];
    vc.shoppingListType = GYHSShopServeringTypeList;
    [self.navigationController pushViewController:vc animated:YES];
}

//外卖订单
- (IBAction)takeAwayOrderClick:(id)sender
{

    GYHSTakeAwayOrderViewController* vc = [[GYHSTakeAwayOrderViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//我的订单
- (IBAction)myOrderClick:(id)sender
{
}

//零售订单
- (IBAction)retailOrderClick:(id)sender
{
    GYHSServerOrderViewController* vc = [[GYHSServerOrderViewController alloc] init];
    vc.shoppingListType = GYHSShopRetailingTypeList;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshWithIsCardUser
{
    if (globalData.loginModel.cardHolder) {
//        _hsServerViewHeight.constant = 80;
        _hsServerViewTop.constant = 15;
        _hsServerView.hidden = NO;
    }
    else {
//        _hsServerViewHeight.constant = 0;
        _hsServerViewTop.constant = 0 - kScreenWidth/4.0;
        _hsServerView.hidden = YES;
//        [self.view layoutIfNeeded];
    }
}

@end
