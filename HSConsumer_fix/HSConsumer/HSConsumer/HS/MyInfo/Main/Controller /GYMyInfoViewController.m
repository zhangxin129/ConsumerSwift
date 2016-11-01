//
//  GYMyInfoViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#import "GYMyInfoViewController.h"
#import "GYMyInfoTableViewCell.h"
#import "GYChangeLoginPwdViewController.h"
#import "GYGetGoodViewController.h"
#import "GYSetupPasswdQuestionViewController.h"
#import "GYRegisterAuthViewController.h"
#import "GYHSImportantChangeApprovingVC.h"
#import "GYHSBindCardInfoVC.h"
#import "GYHSInfoTipViewController.h"
#import "GYHSNoPermissionToImportantChangeVC.h"
#import "GYHSLoginViewController.h"
#import "GYHSImportantChangeApproveStateVC.h"
#import "GYHSLoginManager.h"
#import "GYHSTradingPasswordViewController.h"
#import "GYHSResetTradingPasswordViewController.h"


#import "GYHSImportantChangeLicenceViewController.h"
#import "GYHSImportantChangePassportViewController.h"
#import "GYHSImportantChangeIdentifyViewController.h"

#define sectionNumber 4

@interface GYMyInfoViewController ()
@property (strong, nonatomic) UITableView* tableView;
@property (nonatomic, retain) NSArray* arrSourceArrForSectionTitle;
@property (nonatomic, retain) NSArray* imgArr;
@property (nonatomic, retain) NSArray* titleArr;
@property (nonatomic, copy) NSArray* towSectionTitleArr;
@property (nonatomic, copy) NSArray* towSectionImageArr;

@property (nonatomic, copy) NSString* address; //是否设置地址
@property (nonatomic, copy) NSString* secret; //是否设置密保
@property (nonatomic, assign) NSInteger isSetTradePwd; //设置还是修改交易密码
@end

@implementation GYMyInfoViewController {
    GlobalData* data; //获取单例对象调用通用方法
    BOOL already;
}

- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49 - 20 - 64) style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }

    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = kLocalized(@"GYHS_MyInfo_My_Profile");
    data = globalData;

    //cell title数组
    _titleArr = @[ kLocalized(@"GYHS_MyInfo_Card_Info_Banding"),
        kLocalized(@"GYHS_MyInfo_Realname_Register_Auth"),
        kLocalized(@"GYHS_MyInfo_Important_Informatiron_Change"),
        kLocalized(@"GYHS_MyInfo_My_Receive_Addresss"),
        kLocalized(@"GYHS_MyInfo_Pwd_Change"),
        kLocalized(@"GYHS_MyInfo_Change_Trade_Pwd"),
        kLocalized(@"GYHS_MyInfo_Hs_Set_Pwd_Prompt_Question") ];
    //cell 图片数组
    _imgArr = @[ @"hs_cell_img_realname_register.png",
        @"hs_cell_img_real_name_authentication.imageset.png",
        @"hs_cell_img_change_important_info.png",
        @"hs_cell_img_shipping_address_manage.png",
        @"hs_cell_img_change_login_pwd.png",
        @"hs_cell_question_answer.png",
        @"hs_cell_trade password.png" ];
    
   
    

    //根据不同屏幕适配，对应的cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GYMyInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    UIView* bview = [[UIView alloc] init];
    bview.backgroundColor = kDefaultVCBackgroundColor;
    [self.tableView setBackgroundView:bview];

    if (globalData.loginModel.resNo.length > 3) {
        [self loadPersonDataRequest];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPersonDataRequest) name:@"refreshPersonInfo" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.tableView.userInteractionEnabled = YES;
    if (globalData.isLogined && globalData.loginModel.cardHolder) {
        [self loadcheckInfoStatusUrlString];
    }
}

//加载网络数据
- (void)loadPersonDataRequest
{
    if (!globalData.isLogined) {
        return;
    }

    [self.tableView reloadData];
}

#pragma mark TableViewDateSourceDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 75.0f;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    else {
#pragma mark- 暂时屏蔽重置交易密码
//        if( self.isSetTradePwd == GYHSTradingPasswordTypeSet) {
            return 3;
//        }else {
//            return 4;
//        }
    }
};

//组头高度
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 16.0f;
    }
    else {
        return 1.0f;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 0;
    }
    else {
        return 15.0f;
    }
}

//设置footview的颜色
- (void)tableView:(UITableView*)tableView willDisplayFooterView:(nonnull UIView*)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
}

//设置headview的颜色
- (void)tableView:(UITableView*)tableView willDisplayHeaderView:(nonnull UIView*)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYMyInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    //第一组中每个cell的内容，分别是图片和titile所对应的数组，根据行号来获取
    if (indexPath.section == 0) {
        switch (indexPath.row) {
        case 0: {
            [cell refreshWithImg:[_imgArr objectAtIndex:indexPath.row] WithTitle:[_titleArr objectAtIndex:indexPath.row]];
            if ([data.loginModel.isBindBank isEqualToString:kAuthHad] && [data.loginModel.isAuthMobile isEqualToString:kAuthHad] && [data.loginModel.isAuthEmail isEqualToString:kAuthHad]) {
                cell.vAccessoryView.text = kLocalized(@"GYHS_MyInfo_Ep_Myorder_Finished");
            }
            else {
                cell.vAccessoryView.text = kLocalized(@"GYHS_MyInfo_Unfinished");
            }
        } break;
        case 1: {
            [cell refreshWithImg:[_imgArr objectAtIndex:indexPath.row] WithTitle:[_titleArr objectAtIndex:indexPath.row]];
            if ([globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusHadCertify]) {
                cell.vAccessoryView.text = kLocalized(@"GYHS_MyInfo_Ep_Myorder_Finished");
            }
            else {
                cell.vAccessoryView.text = kLocalized(@"GYHS_MyInfo_Unfinished");
            }
        } break;
        case 2: {
            [cell refreshWithImg:[_imgArr objectAtIndex:indexPath.row] WithTitle:[_titleArr objectAtIndex:indexPath.row]];
            cell.vAccessoryView.hidden = YES;
        } break;
        case 3: {
            [cell refreshWithImg:[_imgArr objectAtIndex:indexPath.row] WithTitle:[_titleArr objectAtIndex:indexPath.row]];

            cell.vAccessoryView.text = self.address;

        } break;
        case 4:
        default:
            break;
        }
    }
    else if (indexPath.section == 1) {
        //第一组中每个cell的内容，分别是图片和titile所对应的数组，根据行号来获取
        switch (indexPath.row) {
        case 0: {
            [cell refreshWithImg:[_imgArr objectAtIndex:indexPath.row + sectionNumber] WithTitle:[_titleArr objectAtIndex:indexPath.row + sectionNumber]];
            cell.vAccessoryView.hidden = YES;
        } break;
        case 1: {
            if (self.isSetTradePwd  == GYHSTradingPasswordTypeModify) {
                [cell refreshWithImg:[_imgArr objectAtIndex:indexPath.row + sectionNumber] WithTitle:[_titleArr objectAtIndex:indexPath.row + sectionNumber]];
            }else {
                [cell refreshWithImg:[_imgArr objectAtIndex:indexPath.row + sectionNumber] WithTitle:kLocalized(@"GYHS_MyInfo_Set_Trading_Password")];
            }
            

            cell.vAccessoryView.hidden = YES;
        } break;
        case 2: {
            
            [cell refreshWithImg:[_imgArr objectAtIndex:indexPath.row + sectionNumber] WithTitle:[_titleArr objectAtIndex:indexPath.row + sectionNumber]];
            cell.vAccessoryView.text = self.secret;
            
        } break;
        case 3: {
            
            [cell refreshWithImg:[_imgArr objectAtIndex:indexPath.row + sectionNumber] WithTitle:[_titleArr objectAtIndex:indexPath.row + sectionNumber]];
            cell.vAccessoryView.text = self.secret;
        } break;
        default:
            break;
        }
    }

    return cell;
};
#pragma mark tableviewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    kCheckLogined
        id __block sender = nil;

    if (indexPath.section == 0) {
        switch (indexPath.row) {
        case 0: { //卡信息绑定vc
            GYHSBindCardInfoVC* vcInfoBanding = [[GYHSBindCardInfoVC alloc] init];
            sender = vcInfoBanding;
        } break;
        case 1: {
            GYRegisterAuthViewController* vcRegisterAuth = [[GYRegisterAuthViewController alloc] initWithNibName:@"GYRegisterAuthViewController" bundle:nil];
            sender = vcRegisterAuth;
        } break;
        case 2: { //已经完成重要信息变更 出来的页面。
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
                    GYHSImportantChangeApprovingVC *vcImportantChange = [[GYHSImportantChangeApprovingVC alloc] initWithNibName:@"GYHSImportantChangeApprovingVC" bundle:nil];
                    sender = vcImportantChange;
                }
                else {
                    NSString *apprDate = [NSString stringWithFormat:@"%@", serverDic[@"apprDate"]];
                    NSString *apprRemark = [NSString stringWithFormat:@"%@", serverDic[@"apprRemark"]];
                    NSString *status = [NSString stringWithFormat:@"%@", serverDic[@"status"]];
                    
                    if ([GYUtils checkStringInvalid:apprDate] &&
                        [GYUtils checkStringInvalid:apprRemark] &&
                        [GYUtils checkStringInvalid:status]) {
                        
                        if ([globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusHadCertify]) {
                            // 已经进行过实名认证
                            if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {
                                GYHSImportantChangeIdentifyViewController *vcImportChange = [[GYHSImportantChangeIdentifyViewController alloc] init];
                                vcImportChange.title = kLocalized(@"GYHS_MyInfo_ImportantInformationChanges");
                                sender = vcImportChange;
                                
                            }else if ([globalData.loginModel.creType isEqualToString:kCertypePassport]){
                                GYHSImportantChangePassportViewController *vcImportChange = [[GYHSImportantChangePassportViewController alloc] init];
                                vcImportChange.title = kLocalized(@"GYHS_MyInfo_ImportantInformationChanges");
                                sender = vcImportChange;
                            }
                            else if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]){
                                GYHSImportantChangeLicenceViewController *vcImportChange = [[GYHSImportantChangeLicenceViewController alloc] init];
                                vcImportChange.title = kLocalized(@"GYHS_MyInfo_ImportantInformationChanges");
                                sender = vcImportChange;
                            }
                      
                        }
                        else if ([globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusHadRes]) {
                            // 进行实名认证操作
                            GYHSNoPermissionToImportantChangeVC *vcNoPermit = [[GYHSNoPermissionToImportantChangeVC alloc] initWithNibName:@"GYHSNoPermissionToImportantChangeVC" bundle:nil];
                            vcNoPermit.title = kLocalized(@"GYHS_MyInfo_ImportantInformationChanges");
                            sender = vcNoPermit;
                        }
                        else {
                            // 进行实名注册
                            GYHSInfoTipViewController *vcNoPermit = [[GYHSInfoTipViewController alloc] initWithNibName:@"GYHSInfoTipViewController" bundle:nil];
                            vcNoPermit.title = kLocalized(@"GYHS_MyInfo_ImportantInformationChanges");
                            vcNoPermit.strSource = kLocalized(@"GYHS_MyInfo_PleaseCompleteReal_NameAuthenticationAfterApplicationRegardingTheChangeImportantInformation");
                            sender = vcNoPermit;
                        }
                    }
                    else {
                        GYHSImportantChangeApproveStateVC *vcSatate = [[GYHSImportantChangeApproveStateVC alloc] init];
                        vcSatate.approveDate = apprDate;
                        vcSatate.approveRemark = apprRemark;
                        vcSatate.approvestatus = status;
                        sender = vcSatate;
                    }
                }
                
                if (sender && [_delegate respondsToSelector:@selector(pushVC:animated:)]) {
                    UIViewController *vc = (UIViewController *)sender;
                    vc.hidesBottomBarWhenPushed = YES;
                    [_delegate pushVC:vc animated:YES];
                    tableView.userInteractionEnabled = NO;
                }
            }];
            [request commonParams:[GYUtils netWorkCommonParams]];
            [request start];
            

        } break;
        case 3: {
            GYGetGoodViewController* vcContactInfo = [[GYGetGoodViewController alloc] init];
            sender = vcContactInfo;
        } break;

        default:
            break;
        }
    }
    else if (indexPath.section == 1) {
        switch (indexPath.row) {
        case 0: {
            //修改登录密码
            GYChangeLoginPwdViewController* vcChangePasswd = [[GYChangeLoginPwdViewController alloc] initWithNibName:@"GYChangeLoginPwdViewController" bundle:nil];
            sender = vcChangePasswd;
        } break;
        case 1: {
            //交易密码。
            GYHSTradingPasswordViewController* vcCardBanding = [[GYHSTradingPasswordViewController alloc] init];
            vcCardBanding.tradingPasswordType = self.isSetTradePwd;
            sender = vcCardBanding;
        } break;
        case 2: {
#pragma mark- 暂时屏蔽重置交易密码
//            if(self.isSetTradePwd == GYHSTradingPasswordTypeSet) {
                //问题密码找回。
                GYSetupPasswdQuestionViewController* vcCardBanding = [[GYSetupPasswdQuestionViewController alloc] initWithNibName:@"GYSetupPasswdQuestionViewController" bundle:nil];
                sender = vcCardBanding;
//            }else {
//                GYHSResetTradingPasswordViewController *resetVC = [[GYHSResetTradingPasswordViewController alloc] init];
//                sender = resetVC;
//            }
            
        } break;
        case 3: {
            //问题密码找回。
            GYSetupPasswdQuestionViewController* vcCardBanding = [[GYSetupPasswdQuestionViewController alloc] initWithNibName:@"GYSetupPasswdQuestionViewController" bundle:nil];
            sender = vcCardBanding;

        } break;

        default:
            break;
        }
    }
    //通过代理 将 controller 传到 navigation push
    if (sender && [_delegate respondsToSelector:@selector(pushVC:animated:)]) {
        UIViewController *vc =(UIViewController *)sender;
        vc.hidesBottomBarWhenPushed = YES;
        [_delegate pushVC:vc animated:YES];
        tableView.userInteractionEnabled = NO;
    }
}

//查看是否已设置收货地址及密保问题
- (void)loadcheckInfoStatusUrlString
{
    NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
                            @"perResNo" : kSaftToNSString(globalData.loginModel.resNo),
                             @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard};
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kHScardcheckInfoStatusUrlString parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary *dic = responseObject[@"data"];
        if ([dic[@"address"] isEqualToNumber:@1]) {
            self.address = kLocalized(@"GYHS_MyInfo_Already_Setting");
        }
        else {
            self.address = kLocalized(@"GYHS_MyInfo_Non_Setting");
        }
        
        if ([dic[@"secret"] isEqualToNumber:@1]) {
            self.secret = kLocalized(@"GYHS_MyInfo_Already_Setting");
        }
        else {
            self.secret = kLocalized(@"GYHS_MyInfo_Non_Setting");
        }
        if ([dic[@"isSetTradePwd"] isEqualToNumber:@1]) {
            self.isSetTradePwd = GYHSTradingPasswordTypeModify;
#pragma mark -暂时屏蔽 重置交易密码
            //                _titleArr = @[ kLocalized(@"card_info_banding"),
            //                               kLocalized(@"realname_register_auth"),
            //                               kLocalized(@"important_informatiron_change"),
            //                               kLocalized(@"my_receive_addresss"),
            //                               kLocalized(@"pwd_change"),
            //                               kLocalized(@"修改交易密码"),
            //                               kLocalized(@"重置交易密码"),
            //                               kLocalized(@"hs_set_pwd_prompt_question") ];
            //                //cell 图片数组
            //                _imgArr = @[ @"cell_img_realname_register.png",
            //                             @"cell_img_real_name_authentication.png",
            //                             @"cell_img_change_important_info.png",
            //                             @"cell_img_shipping_address_manage.png",
            //                             @"cell_img_change_login_pwd.png",
            //                             @"cell_trade_password.png",
            //                             @"reset_trade_password",
            //                             @"cell_question_answernew.png" ];
        }else {
            self.isSetTradePwd = GYHSTradingPasswordTypeSet;
        }
        [self.tableView reloadData];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

@end
