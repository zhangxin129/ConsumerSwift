//
//  GYMainViewController.m
//  HSCompanyPad
//
//  Created by User on 16/7/26.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYMainViewController.h"

#import "GYMainHeadController.h"
#import "GYGIFHUD.h"

@interface GYMainViewController ()
@property (weak, nonatomic) IBOutlet UIView* headContainerView;

@property (weak, nonatomic) IBOutlet UIView* bodyContainerView;

@property (nonatomic, strong) UIView* maskView;

@property (nonatomic, strong) GYMainHeadController* headVC;

@end

@implementation GYMainViewController

#pragma mark - life cycle

- (void)viewDidLoad
{

    [super viewDidLoad];

    self.view.backgroundColor = kPurple00002B;

    [self configUI];

    [self addCustomStatusBar];
}

#pragma mark - method
- (void)configUI
{

    @weakify(self);
    [self.headContainerView mas_remakeConstraints:^(MASConstraintMaker* make) {
          @strongify(self);
        
        make.left.right.equalTo(self.view).mas_equalTo(0);
        make.top.equalTo(self.view).mas_equalTo(20);
        make.height.mas_equalTo(kMainHeadNavHeight);

    }];

    [self.bodyContainerView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.equalTo(self.headContainerView.mas_bottom).offset(12);
        make.left.right.bottom.equalTo(self.view).mas_equalTo(0);

    }];
}

- (void)addCustomStatusBar
{

    UIView* statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    statusBarView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:statusBarView];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
