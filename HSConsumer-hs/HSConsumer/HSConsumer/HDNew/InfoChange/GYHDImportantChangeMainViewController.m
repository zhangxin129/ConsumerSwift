//
//  GYHDImportantChangeMainViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDImportantChangeMainViewController.h"
#import "GYHDImportantChangeIdentifyViewController.h"
#import "GYHDImportantChangePassportViewController.h"
#import "GYHDImportantChangeLicenceViewController.h"
#import "Masonry.h"
#import "GYHDImportChangeConfirmViewController.h"
#import "GYHDImportantChangeApprovingViewController.h"
#import "GYHDImportantChangeResultsViewController.h"

@interface GYHDImportantChangeMainViewController ()<GYHDImportantChangeIdentifyDelegate,GYHDImportantChangePassportDelegate,GYHDImportantChangeLicenceDelegate,GYHDImportantChangeResultsDelegate>
@property (weak, nonatomic) IBOutlet UIView *childView;
@property (nonatomic,strong)UIViewController *currentVC;
//重要信息变更
@property (nonatomic,strong)GYHDImportantChangeIdentifyViewController *changeIdentifyVC;
@property (nonatomic,strong)GYHDImportantChangePassportViewController *changePassportVC;
@property (nonatomic,strong)GYHDImportantChangeLicenceViewController *changeLicenceVC;
@property (nonatomic,strong)GYHDImportChangeConfirmViewController *changeConfirmVC;
@property (nonatomic,strong)GYHDImportantChangeApprovingViewController *changeApproveVC;
@property (nonatomic,strong)GYHDImportantChangeResultsViewController *changeResultsVC;

@property (nonatomic,copy)NSString* apprDate;
@property (nonatomic,copy)NSString* changeItem;
@property (nonatomic,copy)NSString* status;
@end

@implementation GYHDImportantChangeMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalized(@"GYHD_InfoChange_Changes_Application");
    [self informationChangeStage];
    [self setNav];
}
-(void)setNav
{
    self.navigationController.navigationBar.barTintColor = kNavigationBarColor;
    NSMutableDictionary* attDict = [NSMutableDictionary dictionary];
    attDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:attDict];
    UIImageView* leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    leftImage.contentMode = UIViewContentModeScaleAspectFit;
    leftImage.image = [UIImage imageNamed:@"gycommon_nav_back"];
    leftImage.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapSetting = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backClickBtn)];
    [leftImage addGestureRecognizer:tapSetting];
    UIBarButtonItem* leftBackBtn = [[UIBarButtonItem alloc] initWithCustomView:leftImage];
    self.navigationItem.leftBarButtonItem = leftBackBtn;
}
-(void)backClickBtn
{
    for (UIView *view in self.childView.subviews) {
        if (view == self.changeConfirmVC.view) {
            [self  goImportantChange];
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)informationChangeStage
{
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kImportantChangeWarmingUrlString parameters:@{ @"custId" : kSaftToNSString(globalData.loginModel.custId) } requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary *serverDic = responseObject[@"data"];
        if ([GYUtils checkDictionaryInvalid:serverDic]) {
            [GYUtils showToast:kLocalized(@"GYHS_MyInfo_QueryWhetherPersonalFailureDuringImportantInformationChanges")];
            DDLogDebug(@"The serverDic:%@ is invalid.", serverDic);
            return;
        }
        NSString *isChange = [NSString stringWithFormat:@"%@", serverDic[@"isChange"]];
        //重要信息变更审批
        if ([isChange isEqualToString:@"1"]) {
            [self addSonViewController:self.changeApproveVC];
            [self.changeApproveVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.equalTo(self.childView);
            }];
        }
        else {
            self.apprDate = [NSString stringWithFormat:@"%@", serverDic[@"apprDate"]];
            self.changeItem = [NSString stringWithFormat:@"%@", serverDic[@"changeItem"]];
            self.status = [NSString stringWithFormat:@"%@", serverDic[@"status"]];
             
//            [self addSonViewController:self.changeResultsVC];
//            [self.changeResultsVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//                               make.top.bottom.left.right.equalTo(self.childView);
//            }];
            if ([GYUtils isBlankString:self.status] ) {
                [self goImportantChange];
            }
            else {
               [self addSonViewController:self.changeResultsVC];
                [self.changeResultsVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.right.equalTo(self.childView);
                }];
            }
        }
        
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];

}
-(void)goImportantChange
{
    if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {
        [self addSonViewController:self.changeIdentifyVC];
        [self.changeIdentifyVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self.childView);
        }];
    }
    else if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {
        [self addSonViewController:self.changePassportVC];
        [self.changePassportVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self.childView);
        }];
    }
    else {
        [self addSonViewController:self.changeLicenceVC];
        [self.changeLicenceVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self.childView);
        }];
    }
}
#pragma mark -- GYHDImportantChangeIdentifyDelegate 信息变更下一步
-(void)importantChangeIdentify:(NSMutableDictionary *)dictInside olddic:(NSMutableDictionary *)oldmdictParams changeItem:(NSMutableArray *)changeItem
{

    [self addSonViewController:self.changeConfirmVC];
    self.changeConfirmVC.dictInside = dictInside;
    self.changeConfirmVC.oldmdictParams = oldmdictParams;
    self.changeConfirmVC.changeItem = changeItem;
    [self.changeConfirmVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.childView);
    }];
}
-(void)importantChangePassport:(NSMutableDictionary *)dictInside olddic:(NSMutableDictionary *)oldmdictParams changeItem:(NSMutableArray *)changeItem
{
    [self addSonViewController:self.changeConfirmVC];
    self.changeConfirmVC.dictInside = dictInside;
    self.changeConfirmVC.oldmdictParams = oldmdictParams;
    self.changeConfirmVC.changeItem = changeItem;
    [self.changeConfirmVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.childView);
    }];
}
-(void)importantChangeLicence:(NSMutableDictionary *)dictInside olddic:(NSMutableDictionary *)oldmdictParams changeItem:(NSMutableArray *)changeItem
{
    [self addSonViewController:self.changeConfirmVC];
    self.changeConfirmVC.dictInside = dictInside;
    self.changeConfirmVC.oldmdictParams = oldmdictParams;
    self.changeConfirmVC.changeItem = changeItem;
    [self.changeConfirmVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.childView);
    }];
}
#pragma mark -- 再次申请
-(void)againImportantChange
{
    [self goImportantChange];
}
#pragma mark - private methods
- (void)addSonViewController:(UIViewController*)vc
{
    if (self.currentVC == vc) {
        return;
    }
    self.currentVC = vc;
    if (self.childViewControllers.count >= 1) {
        for (UIViewController* v in self.childViewControllers) {
            [v.view removeFromSuperview];
            [v removeFromParentViewController];
        }
    }
    vc.view.frame = self.childView.bounds;
    [self addChildViewController:vc];
    [self.childView addSubview:vc.view];
}

//重要信息变更
-(GYHDImportantChangeIdentifyViewController*)changeIdentifyVC
{
    if (!_changeIdentifyVC) {
        _changeIdentifyVC = [[GYHDImportantChangeIdentifyViewController alloc] init];
        _changeIdentifyVC.changeIdentifyDelegate = self;
    }
    return _changeIdentifyVC;
}
-(GYHDImportantChangePassportViewController*)changePassportVC
{
    if (!_changePassportVC) {
        _changePassportVC = [[GYHDImportantChangePassportViewController alloc] init];
        _changePassportVC.changePassportDelegate = self;
    }
    return _changePassportVC;
}
-(GYHDImportantChangeLicenceViewController*)changeLicenceVC
{
    if (!_changeLicenceVC) {
        _changeLicenceVC = [[GYHDImportantChangeLicenceViewController alloc] init];
        _changeLicenceVC.changeLicenceDelegate = self;
    }
    return _changeLicenceVC;
}
//重要信息变更   上传图片
-(GYHDImportChangeConfirmViewController*)changeConfirmVC
{
    if (!_changeConfirmVC) {
        _changeConfirmVC = [[GYHDImportChangeConfirmViewController alloc] init];
    }
    return _changeConfirmVC;
}
//处于重要信息变更期
-(GYHDImportantChangeApprovingViewController*)changeApproveVC
{
    if (!_changeApproveVC) {
        _changeApproveVC = [[GYHDImportantChangeApprovingViewController alloc] init];
    }
    return _changeApproveVC;
}
//重要信息变更审核结果
-(GYHDImportantChangeResultsViewController*)changeResultsVC
{
    if (!_changeResultsVC) {
        _changeResultsVC = [[GYHDImportantChangeResultsViewController alloc] init];
        _changeResultsVC.approveDate = self.apprDate;
        _changeResultsVC.changeItem = self.changeItem;
        _changeResultsVC.approvestatus = self.status;
        _changeResultsVC.changeResultsDelegate = self;
    }
    return _changeResultsVC;
}
@end
