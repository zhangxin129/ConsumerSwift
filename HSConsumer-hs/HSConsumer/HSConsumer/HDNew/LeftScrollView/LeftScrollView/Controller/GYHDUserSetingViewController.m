//
//  GYUserSetingViewController.m
//  HSConsumer
//
//  Created by shiang on 16/1/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDUserSetingViewController.h"
#import "Masonry.h"
#import "GYHDSearchFriendViewController.h"
#import "GYHDAttentionCompanyViewController.h"
#import "GYHDUserSetingHeaderCell.h"
#import "GYHDUserSetingFooterCell.h"
#import "GYHDMessageCenter.h"
#import "GYHDUserSetingHeaderModel.h"
#import "GYHDSetingInfoViewController.h"
#import "GYTabBarController.h"

#import "GYHDNavigationController.h"
#import "GYMessageNotifyView.h"
#import "GYHDSetingViewController.h"
#import "GYHSPopView.h"
#import "GYHSLoginMainVC.h"
#import "GYHDSetTradingPasswordViewController.h"
#import "GYHDSetupPasswdQuestionViewController.h"
#import "UIActionSheet+Blocks.h"
#import "GYHDMessageCenter.h"
#import "GYHDPwdChangeViewController.h"
#import "GYAboutsHSViewController.h"
#import "GYMyQRViewController.h"
#import "IQKeyboardManager.h"
#import "GYUtilsMacro.h"
#import "UIButton+GYTimeOut.h"

#define kGYHDUserSetingHeaderCell @"GYHDUserSetingHeaderCell"
#define kGYTableViewCell @"UITableViewCell"
#define kGYHDUserSetingFooterCell @"GYHDUserSetingFooterCell"
#define kCellFont kfont(12)

#define kUrlCustomerLogoutTag 100

@interface GYHDUserSetingViewController () <UITableViewDataSource, UITableViewDelegate, GYHDUserSetingHeaderCellDelegate, UITextFieldDelegate, GYNetRequestDelegate>

@property (nonatomic, strong) UITableView* tabView;
@property (nonatomic, strong) NSArray* textArr;
@property (nonatomic, strong) GYHDUserSetingHeaderModel* model;
@property (nonatomic, assign) EditType type;

@property (nonatomic, assign) BOOL isSetTradePass;

@end

@implementation GYHDUserSetingViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect rect = self.view.frame;
    rect.size.width = kScreenWidth * 0.8;
    self.view.frame = rect;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置默认状态
    _isSetTradePass = YES;
    //接收设置交易密码成功刷新页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadcheckInfoStatusUrlString) name:@"setTransPwdSuccessNotification" object:nil];
    [[GYHDMessageCenter sharedInstance] addDataBaseChangeNotificationObserver:self selector:@selector(messageChange:)];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;

    if (!globalData.isLogined) {
        self.haveToRefresh = YES;
    }
    [self loadcheckInfoStatusUrlString];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor blueColor];

    [self setUpUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.haveToRefresh) {
        if (globalData.networkInfoModel) {
            _model = globalData.networkInfoModel;
            NSIndexPath* index = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tabView reloadRowsAtIndexPaths:@[ index ] withRowAnimation:UITableViewRowAnimationNone];
        }
        else {
            [self requestData];
        }
        self.haveToRefresh = NO;
        [self loadcheckInfoStatusUrlString];
    }
}
- (void)messageChange:(NSNotification*)noti
{
    NSDictionary* dict = noti.object;

    if ([dict[@"friendChange"] integerValue] == GYHDProtobufMessage04102 &&
        [dict[@"toID"] isEqualToString:globalData.loginModel.custId]) {
        [self requestData];
    }
}
#pragma mark - GYHDUserSetingHeaderCellDelegate

- (void)showQR:(GYHDUserSetingHeaderCell*)cell
{
    GYHSPopView* popView = [[GYHSPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    GYMyQRViewController* vc = [[GYMyQRViewController alloc] init];

    vc.title = @"我的二维码";
    NSString* imgUrl;
    if ([_model.headImage hasPrefix:@"http"]) {
        imgUrl = _model.headImage;
    }
    else {
        imgUrl = [NSString stringWithFormat:@"%@%@", globalData.loginModel.picUrl, _model.headImage];
    }
    vc.picUrl = imgUrl;
    [popView showViews:vc withViewFrame:CGRectMake(32, 90, kScreenWidth - 64, kScreenHeight - 100)];
}
- (void)requeatInfo:(GYHDUserSetingHeaderCell*)cell withName:(NSString*)name withSign:(NSString*)sign
{
    //修改签名，昵称
    NSDictionary* dict = @{ @"nickname" : name,
        @"individualSign" : sign };
    [[GYHDMessageCenter sharedInstance] updateSelfInfoWith:dict RequetResult:^(NSDictionary* resultDict) {
        
        if (resultDict) {
            if ([resultDict[@"retCode"] integerValue] == 200) {
                [GYUtils showMessage:@"保存资料成功！"];
                globalData.loginModel.nickName = name;
                self.model.nickName = name;
                self.model.sign = sign;
                
            }else {
                [GYUtils showToast:resultDict[@"message"] duration:2.5f position:CSToastPositionBottom];
            }
        }else {
            [GYUtils showMessage:@"保存资料失败！"];
        }

        
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0) {
        GYHDUserSetingHeaderCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHDUserSetingHeaderCell forIndexPath:indexPath];
        cell.model = self.model;
        cell.delegate = self;
        cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
        return cell;
    }
    else if (indexPath.row == 8) {
        GYHDUserSetingFooterCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHDUserSetingFooterCell forIndexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
        [cell.exitLoginBtn addTarget:self action:@selector(exitLogin:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYTableViewCell forIndexPath:indexPath];

        cell.textLabel.font = kCellFont;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = UIColorFromRGB(0x666666);

        if (indexPath.row < 6) {
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"gyhd_leftScrollView_cell%ld", indexPath.row]];
        }
        if (self.textArr.count > indexPath.row - 1) {
            cell.textLabel.text = self.textArr[indexPath.row - 1];
        }
        if (indexPath.row == 7) {
            UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 30)];
            lab.text = kAppVersion;
            lab.textAlignment = NSTextAlignmentRight;
            lab.font = kCellFont;
            lab.textColor = UIColorFromRGB(0xcccccc);
            cell.accessoryView = lab;
        }
        else {
            UIImageView* imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 7, 13)];
            imgv.image = [UIImage imageNamed:@"gyhd_leftScoll_right"];
            cell.accessoryView = imgv;
        }
        if (indexPath.row == 2) {
            if (_isSetTradePass) {
                cell.hidden = YES;
            }
            else {
                cell.hidden = NO;
            }
        }

        cell.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0) {
        return 130;
    }
    else if (indexPath.row == 8) {
        return 75;
    }
    else {
        if (indexPath.row == 2) {
            if (_isSetTradePass) {
                return 0;
            }
        }

        return 50;
    }
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath*)indexPath
{
    [self.view endEditing:YES];
    if (indexPath.row == 1) {
        //网络信息设置
        kRootMessageCheckLogined
            _haveToRefresh = YES;
 
        [[NSNotificationCenter defaultCenter] postNotificationName:@"com.SetInfoClick" object:self.model];
//        GYHDSetingInfoViewController* setingInfoViewController = [[GYHDSetingInfoViewController alloc] init];
//        setingInfoViewController.model = self.model;
//        GYHDNavigationController* nav = [[GYHDNavigationController alloc] initWithRootViewController:setingInfoViewController];
//        [self presentViewController:nav animated:YES completion:nil];
    }
    else if (indexPath.row == 5) {
        //消息通知
        GYMessageNotifyView* view = [[GYMessageNotifyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        GYHDSetingViewController* vc = [[GYHDSetingViewController alloc] init];
        [view showWithVc:vc];
    }
    else if (indexPath.row == 6) {
        //关于互生
        GYAboutsHSViewController* vc = [[GYAboutsHSViewController alloc] init];
        vc.title = @"关于互生";
        GYHDNavigationController* nav = [[GYHDNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else if (indexPath.row == 4) {
        //密保设置
        kRootMessageCheckLogined
            GYHSPopView* popView = [[GYHSPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        GYHDSetupPasswdQuestionViewController* vc = [[GYHDSetupPasswdQuestionViewController alloc] init];

        [popView showView:vc withViewFrame:CGRectMake(10, 90, kScreenWidth - 20, 271)];
    }
    else if (indexPath.row == 3) {
        //修改密码
        kRootMessageCheckLogined
            GYHSPopView* popView = [[GYHSPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        GYHDPwdChangeViewController* vc = [[GYHDPwdChangeViewController alloc] init];

        if (_isSetTradePass) {
            vc.isFirstNumber = 1; //有交易密码修改
        }
        else {
            vc.isFirstNumber = 2; //无交易密码修改
        }
        [popView showView:vc withViewFrame:CGRectMake(10, 30, kScreenWidth - 20, 333)];
    }
    else if (indexPath.row == 2) {

        //设置交易密码
        kRootMessageCheckLogined
            GYHSPopView* popView = [[GYHSPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        GYHDSetTradingPasswordViewController* vc = [[GYHDSetTradingPasswordViewController alloc] init];
        vc.entranceType = 1;
        [popView showView:vc withViewFrame:CGRectMake(10, 90, kScreenWidth - 20, 241)];
    }
    else if (indexPath.row == 7) {
        //app_key=62e5d193-ccfe-4d55-a3b4-71e480ced02d&version_code=3.1.0.0
        //kConsumerAppId  com.hsxt.hsxt

        GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:@"https://itunes.apple.com/lookup" parameters:@{ @"id" : [NSString stringWithFormat:@"%d", kConsumerAppId] } requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary* responseObject, NSError* error) {
            NSArray *dataArr = responseObject[@"results"];
            NSDictionary *dic = dataArr.firstObject;
            NSString *version = dic[@"version"];
            
            
            NSArray *arr = [kAppVersion componentsSeparatedByString:@"."];
            NSString *str = [arr componentsJoinedByString:@""];
            NSString *subStr;
            if(str.length > 3) {
                subStr = kSaftToNSString([str substringToIndex:3]);
            }else {
                subStr = kSaftToNSString([str substringToIndex:str.length]);
            }
            
            NSArray *arr2 = [version componentsSeparatedByString:@"."];
            NSString *str2 = [arr2 componentsJoinedByString:@""];
            NSString *subStr2;
            if(str2.length > 3) {
                subStr2 = kSaftToNSString([str2 substringToIndex:3]);
            }else {
                subStr2 = kSaftToNSString([str2 substringToIndex:str2.length]);
            }
            
            if([subStr intValue] < [subStr2 intValue]) {
                [GYUtils showMessage:kLocalized(@"有新版本更新，请前往AppStore下载最新版本")];
            }else {
                [GYUtils showMessage:kLocalized(@"无版本更新！")];
            }

        }];

        request.noShowErrorMsg = YES;
        [request start];
    }
}

#pragma mark - 点击事件
- (void)exitLogin:(UIButton *)button
{
    [button controlTimeOut];
    [UIActionSheet showInView:self.view withTitle:kLocalized(@"GYHS_General_Confirm_To_Log_Out") cancelButtonTitle:kLocalized(@"GYHS_General_Cancel") destructiveButtonTitle:kLocalized(@"GYHS_General_Confirm") otherButtonTitles:nil tapBlock:^(UIActionSheet* _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            NSDictionary *dic = @{@"custId":kSaftToNSString(globalData.loginModel.custId),
                                  @"channelType":@"4",
                                  @"token":kSaftToNSString(globalData.loginModel.token)};
            GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlCustomerLogout parameters:dic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON ];
            request.tag = kUrlCustomerLogoutTag;
            [request start];
            [GYGIFHUD showFullScreen];
            
            //不管成不成功
            [GYGIFHUD dismiss];
            [[GYHSLoginManager shareInstance] clearLoginInfo];
            [[GYHSLoginManager shareInstance] goToRootView:0];
            [GYHDMessageCenter sharedInstance].state = GYHDMessageLoginStateAuthenticateFailure;
        }
    }];
}

#pragma mark - 自定义方法
//请求个人信息
- (void)requestData
{
    [[GYHDMessageCenter sharedInstance] searchFriendWithCustId:globalData.loginModel.custId RequetResult:^(NSDictionary* resultDict) {
        NSMutableDictionary *friendDetailDict = [NSMutableDictionary dictionaryWithDictionary:[GYUtils stringToDictionary:resultDict[GYHDDataBaseCenterFriendDetailed]]];
        self.model = [[GYHDUserSetingHeaderModel alloc] initWithDictionary:friendDetailDict error:nil];
        NSIndexPath *index= [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tabView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
//查看是否已设置收货地址及密保问题
- (void)loadcheckInfoStatusUrlString
{
    if ([GYUtils checkStringInvalid:globalData.loginModel.resNo] ||
        [GYUtils checkStringInvalid:globalData.loginModel.custId]) {
        
        DDLogDebug(@"The resNo:%@ or custId:%@ is nil.", globalData.loginModel.resNo, globalData.loginModel.custId);
        return;
    }
    
    NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
        @"perResNo" : kSaftToNSString(globalData.loginModel.resNo),
        @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard };
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kHScardcheckInfoStatusUrlString parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        if(responseObject[@"data"]) {
            if([kSaftToNSString(responseObject[@"data"][@"isSetTradePwd"]) isEqualToString:@"1"]) {
                _isSetTradePass = YES;
            }else {
                _isSetTradePass = NO;
            }
            [self.tabView reloadData];
        }

    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)setUpUI
{
    self.tabView = [[UITableView alloc] init];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    self.tabView.tableFooterView = [[UIView alloc] init];
    self.tabView.separatorColor = UIColorFromRGB(0xebebeb);
    self.tabView.separatorInset = UIEdgeInsetsMake(0, 65, 0, 65);
    [self.view addSubview:self.tabView];

    [self.tabView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.top.right.bottom.mas_equalTo(0);

    }];
    [self.tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHDUserSetingHeaderCell class]) bundle:nil] forCellReuseIdentifier:kGYHDUserSetingHeaderCell];
    [self.tabView registerClass:[UITableViewCell class] forCellReuseIdentifier:kGYTableViewCell];
    [self.tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHDUserSetingFooterCell class]) bundle:nil] forCellReuseIdentifier:kGYHDUserSetingFooterCell];
}

#pragma mark - 懒加载

- (NSArray*)textArr
{
    if (!_textArr) {
        _textArr = [[NSArray alloc] init];
        _textArr = @[ @"网络信息设置", @"交易密码设置", @"密码修改", @"密保设置", @"消息通知设置", @"关于互生", @"版本号" ];
    }
    return _textArr;
}
//- (void)addFriendButtonClick:(UIButton*)button
//{
//    GYHDSearchFriendViewController* searchFriendViewController = [[GYHDSearchFriendViewController alloc] init];
//    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:searchFriendViewController];
//    [nav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//    [self presentViewController:nav animated:YES completion:nil];
//}
//
//- (void)attentionCompanyButtonClick
//{
//    GYHDAttentionCompanyViewController* searchFriendViewController = [[GYHDAttentionCompanyViewController alloc] init];
//    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:searchFriendViewController];
//    [nav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//    [self presentViewController:nav animated:YES completion:nil];
//}

#pragma mark - CustomDelegate
// GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    [GYGIFHUD dismiss];
    if (netRequest.tag == kUrlCustomerLogoutTag) {
        [GYUtils showToast:kLocalized(@"GYHS_General_SuccessExit")];
    }
}

- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    [GYGIFHUD dismiss];
    [GYUtils parseNetWork:error resultBlock:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
