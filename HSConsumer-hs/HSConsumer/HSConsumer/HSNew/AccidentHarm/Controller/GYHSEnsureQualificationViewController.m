//
//  GYHSEnsureQualificationViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSEnsureQualificationViewController.h"
#import "GYualificationTableViewCell.h"
#import "GYHSTools.h"
#import "GYSecurityFailureTableViewCell.h"
#import "GYHSAccidentInfoController.h"
#import "GYNetRequest.h"
#import "GYHSTableViewWarmCell.h"

@interface GYHSEnsureQualificationViewController ()<UITableViewDataSource,UITableViewDelegate,GYNetRequestDelegate>
@property (nonatomic,strong)UITableView *EnsureTableView;
@property (nonatomic,strong)NSMutableArray *warmArray;
@property (nonatomic, assign)CGFloat labelheight;//温馨提示文本高度
@property (nonatomic, assign)CGFloat allFailureDateheight;//失效日期文本高度
@property (nonatomic,copy)NSString * datelb;//保障时间
@property (nonatomic,copy)NSString *allFailureDateListlb;//失效日期

@property (nonatomic,copy)NSString *SecurityQualificationlb;//是否有保障资格
@property (nonatomic)BOOL isallFailureDate;//是否有实效日期
@property (nonatomic,assign)NSInteger welfareType;
@end

@implementation GYHSEnsureQualificationViewController
#pragma mark -- The life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.datelb = @"-";
    self.allFailureDateListlb = @"";
    self.SecurityQualificationlb = @"";
   
    self.warmArray  = [NSMutableArray arrayWithObjects:
                       kLocalized(@"GYHS_MyAccounts_WellTip"),
                       @"您未获得平台赠送的意外伤害保障资格；",
                       @"互生卡实名注册成功起，累计积分总数达到300分以上获得本意外伤害保障；",
                       @"互生卡未实名注册期间产生的积分不作为本保障所参考的积分累计范畴；",
                       @"互生卡注册身份类型为企业的，不享受平台提供给消费者的相关积分福利；",
                       @"凡存在虚构交易恶意刷积分、利用慈善名义为持卡受益人募集积分等非正常积分行为，平台不予以保障；同时还将追究所有参与方（持卡人和提供积分企业）的一切法律责任。",
                       @"点击查看《互生意外伤害保障条款》",nil];
    self.labelheight = 0;
    self.allFailureDateheight = 0;
    [self requestData];
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    [self.EnsureTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYualificationTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"GYualificationTableViewCell"];
    [self.EnsureTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYSecurityFailureTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"GYSecurityFailureTableViewCell"];
    
    [self.EnsureTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSTableViewWarmCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSTableViewWarmCell"];
}
#pragma mark-- 网络请求
- (void)requestData
{
    NSDictionary* dict = @{
                           @"resNo" : kSaftToNSString(globalData.loginModel.resNo),
                           @"applyType" : @"1" //applyType：0，后台验证实名认证，实名注册、1，后台只验证实名注册
                           };
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlFindWelfareQualify parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
}

- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    NSDictionary* dataDic = responseObject[@"data"];
    
    [self.warmArray removeAllObjects];
    if (![dataDic isKindOfClass:[NSNull class]] && dataDic && dataDic.count) {
        if ([dataDic[@"isvalid"] isEqualToNumber:kreplyNoQualification]) {
            self.SecurityQualificationlb = kLocalized(@"GYHS_BP_Not_Accident_Harm_Security_Qualification");
            self.warmArray  = [NSMutableArray arrayWithObjects:
                               kLocalized(@"GYHS_MyAccounts_WellTip"),
                               @"您未获得平台赠送的互生意外伤害保障资格；",
                               @"互生卡实名注册成功起，累计积分总数达到300分以上获得本意外伤害保障；",
                               @"互生卡未实名注册期间产生的积分不作为本保障所参考的积分累计范畴；",
                               @"互生卡注册身份类型为企业的，不享受平台提供给消费者的相关积分福利；",
                               @"凡存在虚构交易恶意刷积分、利用慈善名义为持卡受益人募集积分等非正常积分行为，平台不予以保障；同时还将追究所有参与方（持卡人和提供积分企业）的一切法律责任。",
                               @"点击查看《互生意外伤害保障条款》",nil];
        }
        else if ([dataDic[@"isvalid"] isEqualToNumber:kreplyHaveQualification]) {
            if ([dataDic[@"welfareType"] isEqualToNumber:kreplyTypeAccidt]) { //意外伤害
                
                self.warmArray  = [NSMutableArray arrayWithObjects:
                                   kLocalized(@"GYHS_MyAccounts_WellTip"),
                                   @"您已获得平台赠送的互生意外伤害保障资格；",
                                   @"您在本年内累计积分总数达到300分以上,获得本意外伤害保障；",
                                   @"未参加医保的消费者，医疗机构出具的医疗费用原始结算发票、费用清单、诊断证明及病历等相关治疗资料原件需寄回平台；",
                                   @"凡存在虚构交易恶意刷积分、利用慈善名义为持卡受益人募集积分等非正常积分行为，平台不予以保障；同时还将追究所有参与方（持卡人和提供积分企业）的一切法律责任。",
                                   @"点击查看《互生意外伤害保障条款》",nil];
                self.SecurityQualificationlb = kLocalized(@"GYHS_BP_Have_Got_Certificate_Accident_Harm_Security");
            }
            else if ([dataDic[@"welfareType"] isEqualToNumber:kreplyTypeCare]) {//免费医疗
                
                self.warmArray = [NSMutableArray arrayWithObjects:kLocalized(@"GYHS_MyAccounts_WellTip"),kLocalized(@"GYHS_BP_Now_You_Have_Enjoying_Alternate_Medical_Subsidy_Scheme_Alternate_Accident_Harm_Ensure_No_Enjoy"),
                    @"点击查看《互生意外伤害保障条款》",nil];
                
                self.SecurityQualificationlb = kLocalized(@"GYHS_BP_Not_Accident_Harm_Security_Qualification");
            }
        }
        NSString* strStart, *strEnd;
        strStart = [self cutTimeShort:dataDic[@"effectDate"]];
        strEnd = [self cutTimeShort:dataDic[@"failureDate"]];
        if (!(strEnd == nil || [strEnd isEqualToString:@""])) {
            self.datelb = [NSString stringWithFormat:@"%@%@%@", strStart, kLocalized(@"GYHS_BP_To"), strEnd];
        }
        if (![dataDic[@"allFailureDateList"] isKindOfClass:[NSNull class]] && dataDic[@"allFailureDateList"] && [dataDic[@"allFailureDateList"] count]) {
            self.allFailureDateListlb = [dataDic[@"allFailureDateList"] componentsJoinedByString:@" ,"];
            self.isallFailureDate = YES;
        }
        else {
            self.isallFailureDate = NO;
        }
    }
    
   
    
    [self.EnsureTableView reloadData];
}
- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    WS(weakSelf)
    [GYUtils parseNetWork:error resultBlock:^(NSInteger retCode) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}
/**时间截取到日*/
- (NSString*)cutTimeShort:(NSString*)str
{
    if (str == nil || [str isEqualToString:@""]) {
        return nil;
    }
    else {
        str = [str substringToIndex:10];
    }
    return str;
}

#pragma mark--  意外伤害保障条款
- (void)accidentInfoShow
{
    GYHSAccidentInfoController* vc = [[GYHSAccidentInfoController alloc] init];
    [self.nav pushViewController:vc animated:YES];
}
#pragma mark-- UITableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if (self.isallFailureDate == YES) {
        return 3;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isallFailureDate == YES) {
        if (section == 2) {
            return self.warmArray.count;
        }
        return 1;
    }else{
        if (section == 1) {
            return self.warmArray.count;
        }
        return 1;
    }
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        return 150;
    }
    if (self.isallFailureDate == YES) {
        if (indexPath.section == 2) {
           
            return self.labelheight;
        }
        return self.allFailureDateheight + 110;
    }
    else {
        
        return self.labelheight;
    }
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0) {
        GYualificationTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYualificationTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell lbcontenttext:kLocalized(@"GYHS_BP_Security_Content") lbcontentColor:kTitleBlackColor lbTimetext:self.datelb lbTimeColor:kTitleBlackColor SecurityQualificationlbtext:self.SecurityQualificationlb SecurityQualificationlbColor:kNumRednColor];
        return cell;
    }
    if (self.isallFailureDate == YES) {
        if (indexPath.section == 1) {
            GYSecurityFailureTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYSecurityFailureTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.allFailureDateListlb.text = self.allFailureDateListlb;
            cell.allFailureDateListlb.textColor = kNumRednColor;
            //高度自适应
            cell.allFailureDateListlb.lineBreakMode = NSLineBreakByWordWrapping;
            CGSize size = [cell.allFailureDateListlb sizeThatFits:CGSizeMake(cell.allFailureDateListlb.frame.size.width, MAXFLOAT)];
            self.allFailureDateheight = size.height;
            return cell;
        }
        else {
            GYHSTableViewWarmCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSTableViewWarmCell" forIndexPath:indexPath];
            [self dequeueReusableCell:cell indexPath:indexPath];
            return cell;
        }
    }
    else {
        GYHSTableViewWarmCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSTableViewWarmCell" forIndexPath:indexPath];
        [self dequeueReusableCell:cell indexPath:indexPath];
        return cell;
    }
}
- (void)dequeueReusableCell:(GYHSTableViewWarmCell*)cell indexPath:(NSIndexPath*)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kDefaultVCBackgroundColor;
    if (indexPath.row == 0 ) {
        cell.redImage.hidden = YES;
        cell.labelspacing.constant = -10;
    }
    if (indexPath.row == self.warmArray.count-1) {
        cell.redImage.hidden = YES;
        [cell.label setTextColor:kotherPayBtnCorlor];
    }
    if (self.warmArray.count > indexPath.row) {
        cell.label.text = self.warmArray[indexPath.row];
        CGSize size = [GYUtils sizeForString:self.warmArray[indexPath.row] font:kWarmCellFont width:kScreenWidth - 70];
        self.labelheight = size.height;
    }
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.backgroundColor = kDefaultVCBackgroundColor;
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isallFailureDate == YES) {
            if (indexPath.section == 2 && indexPath.row == self.warmArray.count-1) {
                [self accidentInfoShow];
            }
    }else{
            if (indexPath.section == 1 && indexPath.row == self.warmArray.count-1) {
                [self accidentInfoShow];
            }
    }
}
//组头高度
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return kDefaultMarginToBounds;
    }
    else {
        return 1.0f;
    }
}
#pragma mark-- 懒加载
- (UITableView*)EnsureTableView
{
    if (!_EnsureTableView) {
        _EnsureTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 44) style:UITableViewStyleGrouped];
        _EnsureTableView.delegate = self;
        _EnsureTableView.dataSource = self;
        [self.view addSubview:_EnsureTableView];
    }
    return _EnsureTableView;
}
-(NSMutableArray*)warmArray
{
    if (!_warmArray) {
        _warmArray = [[NSMutableArray alloc] init];
    }
    return _warmArray;
}
@end
