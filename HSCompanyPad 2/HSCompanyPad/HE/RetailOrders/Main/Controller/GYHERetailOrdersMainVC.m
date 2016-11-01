//
//  GYHERetailOrdersMainVC.m
//
//  Created by apple on 16/8/8.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHERetailOrdersMainVC.h"
#import "GYSettingSafeSetPiecewiseView.h"
#import "GYHERetailOrderOwnDeliveryVC.h"
#import "GYHERetailOrdersAllVC.h"
#import "GYHERetailOrdersShipVC.h"

@interface GYHERetailOrdersMainVC () <PiecewiseViewDelegate>

@property (nonatomic, strong) NSMutableArray* controllerArray;
@property (nonatomic, weak) GYBaseViewController* curruentVC;

@end

@implementation GYHERetailOrdersMainVC

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
    for (GYBaseViewController *vc in self.controllerArray) {
        vc.view.frame = CGRectMake(0, 44 + kDeviceProportion(62), kScreenWidth, self.view.frame.size.height - 44 - kDeviceProportion(62));
    }
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
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
//#pragma mark - request

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"零售订单");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    DDLogInfo(@"Load Controller: %@", [self class]);
    
    UIImageView* topBackgroundView = [[UIImageView alloc] init];
    topBackgroundView.image = [UIImage imageNamed:@"gycom_nav_background"];
    topBackgroundView.userInteractionEnabled = YES;
    [self.view addSubview:topBackgroundView];
    [topBackgroundView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(44);
        make.height.equalTo(@(kDeviceProportion(50)));
    }];
    
    GYSettingSafeSetPiecewiseView* segControlView = [[GYSettingSafeSetPiecewiseView alloc] initWithFrame:CGRectMake(0.5 * (kScreenWidth - kDeviceProportion(405)), kDeviceProportion(12), kDeviceProportion(405), kDeviceProportion(38))];
    segControlView.type = PiecewiseInterfaceTypeBackgroundChange;
    segControlView.delegate = self;
    segControlView.textFont = kFont32;
    segControlView.backgroundSeletedColor = kBlue0A59C2;
    segControlView.backgroundNormalColor = kWhiteFFFFFF;
    segControlView.textNormalColor = kGray333333;
    segControlView.textSeletedColor = kWhiteFFFFFF;
    [segControlView loadTitleArray:@[ @"自提订单", @"发货订单", @"全部订单" ]];
    [topBackgroundView addSubview:segControlView];
    
    UIImageView* navBottomGroundView = [[UIImageView alloc] init];
    navBottomGroundView.image = [UIImage imageNamed:@"gycom_nav_bottom"];
    [self.view addSubview:navBottomGroundView];
    [navBottomGroundView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(topBackgroundView.mas_bottom);
        make.height.equalTo(@(kDeviceProportion(12)));
    }];
    
    GYHERetailOrderOwnDeliveryVC *ownDeliveryVC  =  [[GYHERetailOrderOwnDeliveryVC alloc] init];
    [self addChildViewController:ownDeliveryVC];
    
    GYHERetailOrdersShipVC *shipVC = [[GYHERetailOrdersShipVC alloc] init];
    [self addChildViewController:shipVC];
    
    GYHERetailOrdersAllVC *allVC = [[GYHERetailOrdersAllVC alloc] init];
    [self addChildViewController:allVC];
    
    [self.controllerArray addObject: ownDeliveryVC];
    [self.controllerArray addObject: shipVC];
    [self.controllerArray addObject: allVC];
    
    self.curruentVC = ownDeliveryVC;
    [self.view addSubview:self.curruentVC.view];
}




#pragma mark - lazy load
-(NSMutableArray *)controllerArray{
    if (!_controllerArray) {
        _controllerArray = [[NSMutableArray alloc] init];
    }
    return _controllerArray;
}
@end
