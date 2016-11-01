//
//  GYHDRealNameRegisterSuccessViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDRealNameRegisterSuccessViewController.h"
#import "GYHDRegisterSuccessHeaderCell.h"
#import "Masonry.h"
#import "GYHSButtonCell.h"
#import "GYHSLabelTwoTableViewCell.h"
#import "GYHSTools.h"
#import "GYHDRealNameWithPassportAuthViewController.h"
#import "GYHDRealNameWithLicenceAuthViewController.h"
#import "GYHDRealNameWithIdentifyAuthViewController.h"


@interface GYHDRealNameRegisterSuccessViewController ()<GYNetRequestDelegate,UITableViewDataSource,UITableViewDelegate,GYHSButtonCellDelegate>
@property (nonatomic,strong)UITableView *successTableView;
@property (nonatomic,strong)NSMutableArray *titleArray;
@property (nonatomic,strong)NSMutableArray *valueArray;

@end

@implementation GYHDRealNameRegisterSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.successTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHDRegisterSuccessHeaderCell class]) bundle:nil] forCellReuseIdentifier:@"GYHDRegisterSuccessHeaderCell"];
    [self.successTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLabelTwoTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSLabelTwoTableViewCell"];
    [self.successTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSButtonCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSButtonCell"];
    [self get_RealName_Info];
}
#pragma mark -- 网络请求GYNetRequestDelegate
- (void)get_RealName_Info
{
    NSMutableDictionary* allParas = [NSMutableDictionary dictionary];
    [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"custId"];
    GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:kQueryRegisterRealNameUrlString parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
    [GYGIFHUD show];
}
-(void)netRequest:(GYNetRequest *)request didSuccessWithData:(NSDictionary *)responseObject
{
    [GYGIFHUD dismiss];
    NSDictionary *dataDic = responseObject[@"data"];
   [self.valueArray removeAllObjects];
    globalData.loginModel.creNo = kSaftToNSString(dataDic[@"cerNo"]);
    globalData.loginModel.creType = kSaftToNSString(dataDic[@"certype"]);
    globalData.loginModel.custName = kSaftToNSString(dataDic[@"realName"]);
    NSString *strName;
    if (globalData.loginModel.custName.length <= 0) {
                strName = [NSString stringWithFormat:@"%@ ** ", globalData.loginModel.custName];
    }
    else {
                strName = [NSString stringWithFormat:@"%@ ** ", [globalData.loginModel.custName substringToIndex:1 ]];
    }
    if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {
                strName = [NSString stringWithFormat:@"%@", kSaftToNSString(dataDic[@"entName"])];
    }
            //姓名
    [self.valueArray addObject:strName];
            //证件号码
    NSString *numberString = [self setStarMarkCount:globalData.loginModel.creType.integerValue WithCerNumber:globalData.loginModel.creNo];
    [self.valueArray addObject:numberString];
    [self.successTableView reloadData];
}
-(void)netRequest:(GYNetRequest *)request didFailureWithError:(NSError *)error
{
    [GYGIFHUD dismiss];
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
   
}
#pragma mark -- 继续认证
- (void)nextBtn
{
    if ([_continueDelegate respondsToSelector:@selector(ContinueAuthentication)]) {
        [self.continueDelegate  ContinueAuthentication];
    }
}
#pragma mark -- 区分不同国籍的证件号码的掩码规则
- (NSString*)setStarMarkCount:(NSInteger)type WithCerNumber:(NSString*)number
{
    NSString* cerNumber = @"";
    //身份证
    if (type == 1) {
        cerNumber = [GYUtils encryptIdentityCard:number];
    }
    //护照
    else if (type == 2) {
        cerNumber = [GYUtils encryptPassport:number];
    }
    //营业执照
    else if (type == 3) {
        cerNumber = [GYUtils encryptBusinessLicense:number];
    }
    return cerNumber;
}

#pragma mark -- UItableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusHadCertify]){
        return 2;
    }
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 1;
    }else if (section == 1)
    {
        return 2;
    }
    return 1;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.backgroundColor = kDefaultVCBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0) {
        GYHDRegisterSuccessHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDRegisterSuccessHeaderCell" forIndexPath:indexPath];
        if ([globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusHadCertify]) {
            cell.successLb.text = kLocalized(@"GYHD_RealnameRegister_Already_Authentication_Success");
        }else{
            cell.successLb.text = kLocalized(@"GYHD_RealnameRegister_Registration_Successful_Continue_Certification");
        }
        
        return cell;
    }else{
        if (indexPath.section == 1)
        {
            GYHSLabelTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLabelTwoTableViewCell" forIndexPath:indexPath];
            if (self.valueArray.count > indexPath.row) {
                cell.detLabel.text = self.valueArray[indexPath.row];
                cell.detLabel.font = kButtonCellFont;
            }
            if (self.titleArray.count > indexPath.row) {
                cell.titleLabel.text = self.titleArray[indexPath.row];
                cell.titleLabel.font = kButtonCellFont;
            }
            if (indexPath.row != 0) {
                cell.toplb.hidden = YES;
            }
            return cell;
        }else
        {
            GYHSButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSButtonCell" forIndexPath:indexPath];
            [cell.btnTitle setTitle:kLocalized(@"GYHD_RealnameRegister_Continue_Authentication") forState:UIControlStateNormal];
            cell.btnTitle.backgroundColor = kButtonCellBtnCorlor;
            cell.btnDelegate  = self;
            return cell;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
//        if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence] && indexPath.row == 0 ) {
//            return self.textViewheight+28;
//        }
        return 164;
    }else if (indexPath.section == 1) {
        return 44;
    }else {
        return 50;
    }
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
        return 20.0f;
    }
    else {
        return 1.0f;
    }
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}
#pragma mark -- 懒加载
-(UITableView*)successTableView
{
    if (!_successTableView) {
        _successTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _successTableView.delegate = self;
        _successTableView.dataSource = self;
        [self.view addSubview:_successTableView];
        [_successTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
    }
    return _successTableView;
}
-(NSMutableArray*)titleArray
{
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] init];
        if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {
            [_titleArray addObject:kLocalized(@"GYHD_RealnameRegister_Name")];
            [_titleArray addObject:kLocalized(@"GYHD_RealnameRegister_Id_Number")];
        }else if ([globalData.loginModel.creType isEqualToString:kCertypePassport]){
            [_titleArray addObject:kLocalized(@"GYHD_RealnameRegister_Name")];
            [_titleArray addObject:kLocalized(@"GYHD_RealnameRegister_Passport_No")];
        }else{
            [_titleArray addObject:kLocalized(@"GYHD_RealnameRegister_Enterprise_Name")];
            [_titleArray addObject:kLocalized(@"GYHD_RealnameRegister_Business_License_No")];
        }
    }
    return _titleArray;
}
-(NSMutableArray*)valueArray
{
    if (!_valueArray) {
        _valueArray = [[NSMutableArray alloc] init];
        
    }
    return _valueArray;
}
@end
