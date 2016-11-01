//
//  GYEnsureQualificationViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/7/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEnsureQualificationViewController.h"
#import "GYualificationTableViewCell.h"
#import "GYAccidentPromptTableViewCell.h"
#import "GYSecurityFailureTableViewCell.h"
#import "GYAccidentInfoController.h"
#import "GYNetRequest.h"

@interface GYEnsureQualificationViewController () <UITableViewDataSource, UITableViewDelegate, GYHSbtnAccidentInfoShowDelegate, GYNetRequestDelegate>
@property (nonatomic, strong) UITableView* EnsureTableView;

@property (nonatomic, assign) CGFloat labelheight; //温馨提示文本高度
@property (nonatomic, assign) CGFloat allFailureDateheight; //失效日期文本高度
@property (nonatomic, copy) NSString* datelb; //保障时间
@property (nonatomic, copy) NSString* allFailureDateListlb; //失效日期
@property (nonatomic, copy) NSString* tipLable; //温馨提示语
@property (nonatomic, copy) NSString* SecurityQualificationlb; //是否有保障资格
@property (nonatomic) BOOL isallFailureDate; //是否有实效日期
@end

@implementation GYEnsureQualificationViewController
#pragma mark-- The life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.datelb = @"-";
    self.allFailureDateListlb = @"";
    self.SecurityQualificationlb = @"";
    self.tipLable = kLocalized(@"GYHS_BP_Alternate_Accident_Harm_Security_Warm_Prompt_No_Permit");
    self.labelheight = 0;
    self.allFailureDateheight = 0;
    [self requestData];
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    [self.EnsureTableView registerNib:[UINib nibWithNibName:@"GYualificationTableViewCell" bundle:nil] forCellReuseIdentifier:@"GYualificationTableViewCell"];
    [self.EnsureTableView registerNib:[UINib nibWithNibName:@"GYSecurityFailureTableViewCell" bundle:nil] forCellReuseIdentifier:@"GYSecurityFailureTableViewCell"];
    [self.EnsureTableView registerNib:[UINib nibWithNibName:@"GYAccidentPromptTableViewCell" bundle:nil] forCellReuseIdentifier:@"GYAccidentPromptTableViewCell"];
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
    self.tipLable = kLocalized(@"GYHS_BP_Alternate_Accident_Harm_Security_Warm_Prompt_No_Permit");

    if (![dataDic isKindOfClass:[NSNull class]] && dataDic && dataDic.count) {
        if ([dataDic[@"isvalid"] isEqualToNumber:kreplyNoQualification]) {
            self.SecurityQualificationlb = kLocalized(@"GYHS_BP_Not_Accident_Harm_Security_Qualification");
        }
        else if ([dataDic[@"isvalid"] isEqualToNumber:kreplyHaveQualification]) {
            if ([dataDic[@"welfareType"] isEqualToNumber:kreplyTypeAccidt]) { //意外伤害
                self.tipLable = kLocalized(@"GYHS_BP_Alternate_Accident_Harm_Security_Warm_Prompt");
                self.SecurityQualificationlb = kLocalized(@"GYHS_BP_Have_Got_Certificate_Accident_Harm_Security");
            }
            else if ([dataDic[@"welfareType"] isEqualToNumber:kreplyTypeCare]) { // 免费医疗
                self.tipLable = kLocalized(@"GYHS_BP_Now_You_Have_Enjoying_Alternate_Medical_Subsidy_Scheme_Alternate_Accident_Harm_Ensure_No_Enjoy");
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

    CGSize size = [GYUtils sizeForString:self.tipLable font:[UIFont systemFontOfSize:14.0] width:kScreenWidth - 70];
    self.labelheight = size.height;

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

#pragma mark-- GYHSbtnAccidentInfoShowDelegate 意外伤害保障条款
- (void)btnAccidentInfoShow
{
    GYAccidentInfoController* vc = [[GYAccidentInfoController alloc] init];
    [self.nav pushViewController:vc animated:YES];
}
#pragma mark-- UITableView代理
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if (self.isallFailureDate == YES) {
        return 3;
    }
    return 2;
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        return 150;
    }
    if (self.isallFailureDate == YES) {
        if (indexPath.section == 2) {
            return self.labelheight + 150;
        }
        return self.allFailureDateheight + 110;
    }
    else {
        return self.labelheight + 150;
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
            GYAccidentPromptTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYAccidentPromptTableViewCell" forIndexPath:indexPath];
            [self dequeueReusableCell:cell];
            return cell;
        }
    }
    else {
        GYAccidentPromptTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYAccidentPromptTableViewCell" forIndexPath:indexPath];
        [self dequeueReusableCell:cell];
        return cell;
    }
}
- (void)dequeueReusableCell:(GYAccidentPromptTableViewCell*)cell
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.btnAccidentInfoShowDelegate = self;
    cell.contentView.backgroundColor = kDefaultVCBackgroundColor;
    cell.tipLable.text = self.tipLable;
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:cell.tipLable.text];
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5]; //调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [cell.tipLable.text length])];
    cell.tipLable.attributedText = attributedString;
    [cell.tipLable sizeToFit];
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.backgroundColor = kDefaultVCBackgroundColor;
    return view;
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

@end
