//
//  GYHSMainViewController.m
//
//  Created by apple on 16/8/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMainViewController.h"
#import "GYHSMainLeftBottomView.h"
#import "GYHSMainLeftTopView.h"
#import "GYHSMainRightBottomView.h"
#import "GYHSMainRightTopView.h"
#import "GYHSMyHSMainModel.h"
#import "GYNetwork.h"
#import <YYKit/YYKit.h>

#import "GYHSBankAccountMainVC.h"
#import "GYHSMemberCompanyMainVC.h"
#import "GYHSMyCompanyInfoVC.h"
#import "GYHSMyContactInfoVC.h"
#import "GYHSMyMainChageHeadImageVC.h"
#import "GYHSMyPayYearFreeVC.h"
#import "GYHSPointActivityMainVC.h"
#import "GYHSQuickPaymentVC.h"
#import "GYHSRealNameMainVC.h"
//#import "GYHSTerminalManagerVC.h"

#import <MJExtension/MJExtension.h>
#import <YYKit/YYLabel.h>

@interface GYHSMainViewController () <GYNetRequestDelegate>

@property (nonatomic, strong) GYHSMyHSMainModel* model;

@property (nonatomic, strong) GYHSMainLeftTopView* leftTopView;
@property (nonatomic, strong) GYHSMainRightTopView* rightTopView;
@property (nonatomic, strong) GYHSMainLeftBottomView* leftBottomView;
@property (nonatomic, strong) GYHSMainRightBottomView* rightBottomView;
/*!
 *    业务办理按钮
 */
//@property (nonatomic, strong) UIButton* businessButton;

@end

@implementation GYHSMainViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    
    
    [kDefaultNotificationCenter addObserver:self selector:@selector(queryEntInfo) name:GYChangeBankCardOrChageMainHSNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self queryEntInfo];
    DDLogInfo(@"Show Controller: %@", [self class]);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //kGrayE3E3EA
    self.leftTopView.customBorderType = UIViewCustomBorderTypeAll;
    self.leftTopView.customBorderColor = kGrayE3E3EA;
    self.leftTopView.customBorderLineWidth = @1;
    
    self.rightTopView.customBorderType = UIViewCustomBorderTypeTop | UIViewCustomBorderTypeRight | UIViewCustomBorderTypeBottom;
    self.rightTopView.customBorderColor = kGrayE3E3EA;
    self.rightTopView.customBorderLineWidth = @1;
    
    self.leftBottomView.customBorderType = UIViewCustomBorderTypeAll;
    self.leftBottomView.customBorderColor = kGrayE3E3EA;
    self.leftBottomView.customBorderLineWidth = @1;
    
    self.rightBottomView.customBorderType = UIViewCustomBorderTypeAll;
    self.rightBottomView.customBorderColor = kGrayE3E3EA;
    self.rightBottomView.customBorderLineWidth = @1;
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
    [kDefaultNotificationCenter removeObserver:self];
}

#pragma mark - event response
///*!
// *    业务办理按钮点击事件
// */
//- (void)businessButtonAction
//{
//    GYHSTerminalManagerVC* mangerVc = [[GYHSTerminalManagerVC alloc] init];
//    [self.navigationController pushViewController:mangerVc animated:YES];
//}

/*!
 *    左上部分视图的block点击事件
 */
- (void)toResponceLeftTopViewAction
{
    @weakify(self)
    
    self.leftTopView.bigImageBlock
    = ^{
        //点击大箭头图标
        @strongify(self);
        GYHSMyCompanyInfoVC* vc = [[GYHSMyCompanyInfoVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    self.leftTopView.tapHeadLogoBlock = ^{
        @strongify(self);
        //点击头像
        GYHSMyMainChageHeadImageVC* vc = [[GYHSMyMainChageHeadImageVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
}

/*!
 *    左下部分视图的block点击事件
 */
- (void)toResponceLeftBottomViewAction
{
    @weakify(self)
    self.leftBottomView.linkmanBlock
    = ^{
        //联系人
        @strongify(self);
        GYHSMyContactInfoVC* vc = [[GYHSMyContactInfoVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    self.leftBottomView.emailBlock = ^{
        //邮件
        @strongify(self);
        
        if (globalData.companyStatus.appStatu == companyStatu_request_logout) {
            [GYUtils showToast:kLocalized(@"GYHS_MyHs_Main_YouHaveSubmittedMembershipCancellation requestAndNotAuthorizedToOperateThisBusiness!")];
        }else{
            [self toSendMailForValidEmail];
        }

    };
    
    self.leftBottomView.bankCardBlock = ^{
        //银行账号
        @strongify(self);
        GYHSBankAccountMainVC* bankVC = [[GYHSBankAccountMainVC alloc] init];
        [self.navigationController pushViewController:bankVC animated:YES];
    };
    
    self.leftBottomView.quickCardBlock = ^{
        //快捷支付卡
        @strongify(self);
        GYHSQuickPaymentVC* quickVC = [[GYHSQuickPaymentVC alloc] init];
        [self.navigationController pushViewController:quickVC animated:YES];
    };
}

/*!
 *    右上部分视图的block点击事件
 */
- (void)toResponceRightTopViewAction
{
    @weakify(self)
    self.rightTopView.toAuthenticateBlock
    = ^(BOOL isAuthenticate) {
        //实名认证
        @strongify(self);
        GYHSRealNameMainVC* realNameVC = [[GYHSRealNameMainVC alloc] init];
        realNameVC.model = self.model;
        [self.navigationController pushViewController:realNameVC animated:YES];
    };
    
    self.rightTopView.stopActivityBlock = ^(BOOL isJoin) {
        //停止积分活动
        @strongify(self);
        GYHSPointActivityMainVC* pointActivityVC = [[GYHSPointActivityMainVC alloc] init];
        pointActivityVC.isJoinAction = isJoin;
        [self.navigationController pushViewController:pointActivityVC animated:YES];
    };
    
    self.rightTopView.joinActivityBlock = ^(BOOL isJoin) {
        //参与积分活动
        @strongify(self);
        GYHSPointActivityMainVC* pointActivityVC = [[GYHSPointActivityMainVC alloc] init];
        pointActivityVC.isJoinAction = isJoin;
        [self.navigationController pushViewController:pointActivityVC animated:YES];
    };
    
    self.rightTopView.logoutSystemBlock = ^{
        //注销系统
        @strongify(self);
        GYHSMemberCompanyMainVC* vc = [[GYHSMemberCompanyMainVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    self.rightTopView.toPayYearFeeBlock = ^{
        //去缴纳年费
        @strongify(self);
        GYHSMyPayYearFreeVC* vc = [[GYHSMyPayYearFreeVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
}

#pragma mark - request
/*!
 *    查询企业信息
 */
- (void)queryEntInfo
{
    NSDictionary* dicParams = @{
                                @"entCustId" : globalData.loginModel.entCustId
                                };
    
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSQueryEntInfo)
         parameter:dicParams
           success:^(id returnValue) {
               
               if ([returnValue[GYNetWorkCodeKey] isEqualToNumber:@200]) {
                   self.model = [GYHSMyHSMainModel modelWithDictionary:returnValue[GYNetWorkDataKey]];
                   self.rightBottomView.model = self.model;
                   self.leftBottomView.model = self.model;
                   self.rightTopView.model = self.model;
               }
           }
           failure:^(NSError* error) {
               
           }
       isIndicator:YES
          MaskType:kMaskViewType_Deault];
}

/*!
 *    验证邮箱
 */
- (void)toSendMailForValidEmail
{
   
    if (!self.model.email.length) {
        [GYUtils showToast:kLocalized(@"GYHS_MyHs_Main_PleaseAddEnterpriseSecureMailboxFirst" )];
    }else{
        NSDictionary* dicParams = @{
                                    @"entResNo" : globalData.loginModel.entResNo,
                                    @"email" : self.model.email,
                                    @"userType" : GYUserTypeCompany,
                                    @"userName" : globalData.loginModel.userName,
                                    @"entCustId" : globalData.loginModel.entCustId,
                                    @"operator" : globalData.loginModel.operName,
                                    @"target" : @"4",
                                    @"custType" : @(globalData.companyType)
                                    };
        @weakify(self);
        [GYNetwork PUT:GY_HSDOMAINAPPENDING(GYHSSendMailForValidEmail)
             parameter:dicParams
               success:^(id returnValue) {
                   @strongify(self);
                   if ([returnValue[GYNetWorkCodeKey] isEqualToNumber:@200]) {
                       [self showAlertView];
                   } else {
                       [GYUtils showToast:returnValue[@"msg"]];
                   }
                   
               }
               failure:^(NSError* error) {
                   
               }
           isIndicator:YES];

    }
    
}

#pragma mark - private methods
/*!
 *    弹出去邮箱认证的提示框
 */
- (void)showAlertView
{
    @weakify(self);
    
    NSString* message = kLocalized(@"GYHS_Myhs_Did_Send_Email_To_Authenticate");
    NSMutableParagraphStyle* paragraph = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
    paragraph.lineSpacing = 10;
    NSMutableAttributedString* attText = [[NSMutableAttributedString alloc] initWithString:message attributes:@{ NSFontAttributeName : kFont32, NSForegroundColorAttributeName : kGray333333, NSParagraphStyleAttributeName : paragraph }];
    YYLabel* label = [[YYLabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    
    label.attributedText = attText;
    
    
    [GYAlertViewWithView alertWithView:label size:CGSizeZero buttonTitle:kLocalized(@"GYHS_Myhs_To_Authenticate") topColor:TopColorBlue comfirmBlock:^{
        @strongify(self);
        NSRange emailRange = [self.model.email rangeOfString:@"@"];
        NSString* urlTail = [self.model.email substringFromIndex:emailRange.location + 1];
        NSString* httpsUrl = [NSString stringWithFormat:@"https://mail.%@", urlTail];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:httpsUrl]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:httpsUrl]];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://"]];
        }
    }];
}

- (void)initView
{
    self.title = kLocalized(@"GYHS_Myhs_Company_HS");
    self.view.backgroundColor = kWhiteFFFFFF;
    DDLogInfo(@"Load Controller: %@", [self class]);
    
    [self.view addSubview:self.leftTopView];
    [self.leftTopView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view).offset(kDeviceProportion(16));
        make.top.equalTo(self.view).offset(kDeviceProportion(16) + 44);
        make.width.equalTo(@(kDeviceProportion(569)));
        make.height.equalTo(@(kDeviceProportion(259)));
    }];
    
    [self.view addSubview:self.rightTopView];
    [self.rightTopView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.view).offset(kDeviceProportion(16) + 44);
        make.left.equalTo(_leftTopView.mas_right);
        make.right.equalTo(self.view).offset(kDeviceProportion(-16));
        make.height.equalTo(@(kDeviceProportion(259)));
    }];
    
    [self.view addSubview:self.leftBottomView];
    [self.leftBottomView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_leftTopView.mas_bottom).offset(kDeviceProportion(12));
        make.left.equalTo(self.view).offset(kDeviceProportion(16));
        make.width.equalTo(@(kDeviceProportion(569)));
        make.bottom.equalTo(self.view).offset(kDeviceProportion(-16));
    }];
    
    [self.view addSubview:self.rightBottomView];
    [self.rightBottomView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(_leftBottomView.mas_right).offset(kDeviceProportion(12));
        make.top.equalTo(_rightTopView.mas_bottom).offset(kDeviceProportion(12));
        make.right.equalTo(self.view).offset(kDeviceProportion(-16));
        make.bottom.equalTo(self.view).offset(-16);
    }];
    
//    [self.view addSubview:self.businessButton];
//    [self.businessButton mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.left.equalTo(_leftBottomView.mas_right).offset(kDeviceProportion(12));
//        make.top.equalTo(_rightBottomView.mas_bottom).offset(kDeviceProportion(12));
//        make.right.bottom.equalTo(self.view).offset(kDeviceProportion(-16));
//    }];
    
    [self toResponceLeftTopViewAction];
    [self toResponceLeftBottomViewAction];
    [self toResponceRightTopViewAction];
}

#pragma mark - lazy load
/*!
 *    左上部分视图
 *
 *    @return   GYHSMainLeftTopView
 */
- (GYHSMainLeftTopView*)leftTopView
{
    if (!_leftTopView) {
        _leftTopView = [[GYHSMainLeftTopView alloc] init];
        _leftTopView.backgroundColor = kWhiteFFFFFF;
    }
    return _leftTopView;
}

/*!
 *    右上部分视图
 *
 *    @return GYHSMainRightTopView
 */
- (GYHSMainRightTopView*)rightTopView
{
    if (!_rightTopView) {
        _rightTopView = [[GYHSMainRightTopView alloc] init];
        _rightTopView.backgroundColor = kWhiteFFFFFF;
    }
    return _rightTopView;
}

/*!
 *    左下部分视图
 *
 *    @return GYHSMainLeftBottomView
 */
- (GYHSMainLeftBottomView*)leftBottomView
{
    if (!_leftBottomView) {
        _leftBottomView = [[GYHSMainLeftBottomView alloc] init];
        _leftBottomView.backgroundColor = kWhiteFFFFFF;
    }
    return _leftBottomView;
}


/*!
 *    右下部分视图
 *
 *    @return rightBottomView
 */
- (GYHSMainRightBottomView*)rightBottomView
{
    if (!_rightBottomView) {
        _rightBottomView = [[GYHSMainRightBottomView alloc] init];
        _rightBottomView.backgroundColor = kWhiteFFFFFF;
    }
    return _rightBottomView;
}

/*!
 *    业务办理按钮
 *
 *    @return businessButton
 */
//- (UIButton*)businessButton
//{
//    if (!_businessButton) {
//        _businessButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_businessButton setImage:[UIImage imageNamed:@"gyhs_business_in"] forState:UIControlStateNormal];
//        [_businessButton setImage:[UIImage imageNamed:@"gyhs_business_in"] forState:UIControlStateHighlighted];
//        [_businessButton addTarget:self action:@selector(businessButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _businessButton;
//}



@end
