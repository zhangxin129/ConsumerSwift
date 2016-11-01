//
//  GYHSMyImportantInfoChageFinishVC.m
//
//  Created by apple on 16/8/30.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMyImportantInfoChageFinishVC.h"
#import "GYHSMemberProgressView.h"

@interface GYHSMyImportantInfoChageFinishVC ()

@end

@implementation GYHSMyImportantInfoChageFinishVC

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

/*!
 *    重写父类的返回按钮点击方法
 */
-(void)leftBtnAction {
    
    for (GYBaseViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"GYHSMyCompanyInfoVC")]) {
             [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_Myhs_Important_Info_Chage");
    self.view.backgroundColor = kWhiteFFFFFF;
    DDLogInfo(@"Load Controller: %@", [self class]);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addLeftView];
}

/*!
 *    添加UI左半部分视图
 */
- (void)addLeftView
{
    
    GYHSMemberProgressView* progressView = [[GYHSMemberProgressView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kDeviceProportion(225), kDeviceProportion(400)) array:@[ kLocalized(@"GYHS_Myhs_Click_Modify_Info"), kLocalized(@"GYHS_Myhs_Upload_Related_Image"), kLocalized(@"GYHS_Myhs_Finish_Chage") ]];
    progressView.index = 3;
    [self.view addSubview:progressView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(progressView.frame), kDeviceProportion(106) + 44, kScreenWidth - CGRectGetMaxX(progressView.frame), 40)];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = kLocalized(@"GYHS_Myhs_Now_You_Chaging_No_This_Bussniss");
    
    [self.view addSubview:tipLabel];
}

@end
