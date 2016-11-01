//
//  GYNoAuthNoImportantChangeVC.m
//  HSConsumer
//
//  Created by apple on 15-4-21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSNoPermissionToImportantChangeVC.h"
#import "UIButton+GYExtension.h"
#import "GYHSRealNameWithIdentifyAuthViewController.h"
#import "GYHSRealNameWithPassportAuthViewController.h"
#import "GYHSRealNameWithLicenceAuthViewController.h"
#import "GYFinishAuthViewController.h"
#import "GYApproveThreePicViewController.h"
#import "GYAlertView.h"
#import "GYHSLoginManager.h"
#import "YYKit.h"

@implementation GYHSNoPermissionToImportantChangeVC {
    IBOutlet UILabel* lbTips;
    __weak IBOutlet UIButton* btnToNameAuth;
    __weak IBOutlet UIImageView *noDataImageView;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kDefaultVCBackgroundColor;

    
    noDataImageView.frame = CGRectMake(kScreenWidth*0.4, 155, kScreenWidth*0.2, kScreenWidth*0.2);
    lbTips.frame = CGRectMake(15, CGRectGetMaxY(noDataImageView.frame)+15, kScreenWidth-30, lbTips.frame.size.height);
    btnToNameAuth.frame = CGRectMake((kScreenWidth-btnToNameAuth.frame.size.width)/2, CGRectGetMaxY(lbTips.frame)+15, btnToNameAuth.frame.size.width, btnToNameAuth.frame.size.height);

    lbTips.textColor = UIColorFromRGB(0x5A5A5A);
    
     NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",kLocalized(@"GYHS_MyInfo_You_Not_Completed_Real_Name_Certification_Please_Again_After_Real_Name_Certification_To_Deal_With_This_Business")]];
    text.lineSpacing = 10.0f;
    text.font = [UIFont systemFontOfSize:15];
    lbTips.attributedText = text;
    [btnToNameAuth setTitle:kLocalized(@"GYHS_MyInfo_Real_Name_Authentication") forState:UIControlStateNormal];
    [btnToNameAuth setBorderWithWidth:1.0 andRadius:2 andColor:kDefaultViewBorderColor];
    [btnToNameAuth setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
}

- (IBAction)btnActionToNameAuth:(id)sender
{
    [self getRealNameAuthStatusGotoRelateController];
}

//查询实名认证状态
- (void)getRealNameAuthStatusGotoRelateController
{

    if ([globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusHadCertify]) {
        //已完成实名认证
        UIViewController* vc = kLoadVcFromClassStringName(NSStringFromClass([GYFinishAuthViewController class]));
        vc.navigationItem.title = kLocalized(@"GYHS_MyInfo_Real_Name_Authentication");
        [self pushVC:vc animated:YES];
        return;
    }

    //实名认证状态查询
    NSMutableDictionary* allParas = [NSMutableDictionary dictionary];
    [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"perCustId"];
    [GYGIFHUD show];
     GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kQueryRealNameAuthInfoUrlString parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
         [GYGIFHUD dismiss];
         if (error) {
             DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
             [GYUtils parseNetWork:error resultBlock:nil];
             return ;
         }
         UIViewController *vc = nil;
         NSString *vcName;
         NSDictionary *dicData = responseObject[@"data"];
         
         if ([GYUtils checkDictionaryInvalid:dicData]) {
             // 返回空为未申请实名认证, 进入实名认证申请
             vcName = [self getNextVCName];
             vc = kLoadVcFromClassStringName(vcName);
             vc.navigationItem.title = kLocalized(@"GYHS_MyInfo_Real_Name_Authentication");
             [self pushVC:vc animated:YES];
             return;
         }
         
         //已经实名注册，查询实名认证信息
         globalData.personInfo.creFaceImg = kSaftToNSString(dicData[@"cerpica"]);
         globalData.personInfo.creBackImg = kSaftToNSString(dicData[@"cerpicb"]);
         globalData.personInfo.creHoldImg = kSaftToNSString(dicData[@"cerpich"]);
         NSString *state = [NSString stringWithFormat:@"%@", dicData[@"status"]];
         
         if ([kRealNameAuthStatusApproveLastSuccuss isEqualToString:state] ) {
             
             //审核通过
             vcName = NSStringFromClass([GYFinishAuthViewController class]);
             vc = kLoadVcFromClassStringName(vcName);
             vc.navigationItem.title = kLocalized(@"GYHS_MyInfo_Real_Name_Authentication");
             [self pushVC:vc animated:YES];
         }
         else if ([kRealNameAuthStatusApproveWait isEqualToString: state] ||
                  [kRealNameAuthStatusApproveFistSuccuss isEqualToString: state]) {
             
             GYApproveThreePicViewController *vc = [[GYApproveThreePicViewController alloc] init];
             vc.status = kRealNameAuthStatusApproveWait;
             vc.navigationItem.title = kLocalized(@"GYHS_MyInfo_Real_Name_Authentication");
             [self pushVC:vc animated:YES];
         }
         else if ([kRealNameAuthStatusApproveRefuse isEqualToString: state]) {
             
             GYApproveThreePicViewController *vc = [[GYApproveThreePicViewController alloc] init];
             vc.status = kRealNameAuthStatusApproveRefuse;
             vc.refuseReason = dicData[@"apprContent"];
             vc.navigationItem.title = kLocalized(@"GYHS_MyInfo_Real_Name_Authentication");
             [self pushVC:vc animated:YES];
         }

     }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

//获取下一个控制器的名称
- (NSString*)getNextVCName
{
    if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {
        return NSStringFromClass([GYHSRealNameWithIdentifyAuthViewController class]);
    }
    else if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {
        return NSStringFromClass([GYHSRealNameWithPassportAuthViewController class]);
    }
    else {
        return NSStringFromClass([GYHSRealNameWithLicenceAuthViewController class]);
    }
}

- (void)pushVC:(id)sender animated:(BOOL)ani
{
    [self.navigationController pushViewController:sender animated:ani];
}

@end
