//
//  GYMyInfoNoCardViewController.m
//  HSConsumer
//
//  Created by zhangqy on 16/4/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSBasicInfomationController.h"
#import "GYHSModifyReserveDataViewController.h"
#import "GYMyInfoNoCardViewController.h"
#import "GYMyInfoViewController.h"
#import "GYMyInfoTableViewCell.h"
#import "GYChangeLoginPwdViewController.h"
#import "GYHSGetGoodViewController.h"
#import "GYSetupPasswdQuestionViewController.h"
#import "GYQuitPhoneBandingViewController.h"

//卡信息绑定
#import "GYHSBindCardInfoVC.h"
#import "GYHSLoginViewController.h"
#import "GYHSLoginManager.h"
#import "GYHSTradingPasswordViewController.h"

#define sectionNumber 4
@interface GYMyInfoNoCardViewController ()

@property (nonatomic, retain) NSArray* arrSourceArrForSectionTitle;
@property (nonatomic, retain) NSArray* imgArr;
@property (nonatomic, retain) NSArray* titleArr;
@property (nonatomic, copy) NSArray* towSectionTitleArr;
@property (nonatomic, copy) NSArray* towSectionImageArr;

@property (nonatomic, copy) NSString* address; //是否设置地址
@property (nonatomic, copy) NSString* secret; //是否设置密保
@property (nonatomic, assign) NSInteger isSetTradePwd; //设置还是修改交易密码
@end

@implementation GYMyInfoNoCardViewController {

    GlobalData* data; //获取单例对象调用通用方法
    BOOL already;
}

- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -160) style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}
- (void)loadPersonDataRequest
{
    if (!globalData.isLogined) {
        return;
    }

    [self.tableView reloadData];
    return;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    //设置标题
    self.title = kLocalized(@"GYHS_NoHSCard_my_profile");

    data = globalData;

    NSNotificationCenter* notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(loadPersonDataRequest) name:@"refreshPersonInfo" object:nil];
    
#pragma mark- 暂时屏蔽修改预留信息
//    _titleArr = @[ @"基本资料", @"收货地址", @"修改登录密码", @"修改交易密码", @"修改预留信息" ];
    _titleArr = @[ @"基本资料", @"收货地址", @"修改登录密码", @"修改交易密码"];
    //cell 图片数组
//    _imgArr = @[ @"hs_basic_info",
//                 @"cell_img_shipping_address_manage",
//                 @"gyhs_changeLoginPwd",
//                 @"cell_trade_password",
//                 @"hs_reserve_data" ];
    
    _imgArr = @[ @"hs_basic_info",
                 @"hs_cell_img_shipping_address_manage",
                 @"gyhs_changeLoginPwd",
                 @"hs_cell_question_answer"
                 ];
   

    //根据不同屏幕适配，对应的cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYMyInfoTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    UIView* bview = [[UIView alloc] init];
    bview.backgroundColor = kDefaultVCBackgroundColor;
    [self.tableView setBackgroundView:bview];
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];

    self.tableView.userInteractionEnabled = YES;
    [self.tableView reloadData];
    if (globalData.isLogined && !globalData.loginModel.cardHolder && globalData.loginModel.resNo) {
        [self loadcheckInfoStatusUrlString];
    }
}

#pragma mark TableViewDateSourceDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 75.0f;
    //    return kCellHeight;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
};

//组头高度
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 16.0f;
    }
    else {
        return 0.1f;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
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

//绘制每一个单元格内容
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    //从缓存队列中 弹出可用的cell
    GYMyInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //第一组中每个cell的内容，分别是图片和titile所对应的数组，根据行号来获取
        switch (indexPath.row) {
        case 0: {
            [cell refreshWithImg:[_imgArr objectAtIndex:indexPath.row] WithTitle:[_titleArr objectAtIndex:indexPath.row]];
            if ([GYUtils checkStringInvalid:_infoModel.name]) {
                cell.vAccessoryView.text = kLocalized(@"GYHS_NoHSCard_unfinished");
            }
            else {
                cell.vAccessoryView.text = kLocalized(@"GYHS_NoHSCard_finished");
            }
        } break;
        case 1: {
            [cell refreshWithImg:[_imgArr objectAtIndex:indexPath.row] WithTitle:[_titleArr objectAtIndex:indexPath.row]];
            cell.vAccessoryView.text = self.address;
        } break;
        case 2: {
            [cell refreshWithImg:[_imgArr objectAtIndex:indexPath.row] WithTitle:[_titleArr objectAtIndex:indexPath.row]];
            cell.vAccessoryView.hidden = YES;
        } break;
        case 3: {

                if (self.isSetTradePwd  == GYHSTradingPasswordTypeModify) {
                    [cell refreshWithImg:[_imgArr objectAtIndex:indexPath.row ] WithTitle:[_titleArr objectAtIndex:indexPath.row]];
                }else if(self.isSetTradePwd  == GYHSTradingPasswordTypeSet){
                    [cell refreshWithImg:[_imgArr objectAtIndex:indexPath.row ] WithTitle:@"设置交易密码"];
                    
                }
          
            cell.vAccessoryView.hidden = YES;

        } break;
#pragma mark - 屏蔽修改预留信息
//        case 4: {
//
//                [cell refreshWithImg:[_imgArr objectAtIndex:indexPath.row] WithTitle:[_titleArr objectAtIndex:indexPath.row]];
//                
//                cell.vAccessoryView.hidden = YES;
//                
//        } break;
        default:
            break;
        }
    return cell;
}
#pragma mark tableviewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    kCheckLogined
        id __block sender = nil;

    if (indexPath.section == 0) {
        switch (indexPath.row) {
        case 0: {

            GYHSBasicInfomationController* vc = [[GYHSBasicInfomationController alloc] init];
            vc.delegate = self;
            sender = vc;
        } break;
        case 1:

        {
            GYHSGetGoodViewController* vcContactInfo = [[GYHSGetGoodViewController alloc] init];
            sender = vcContactInfo;
        } break;
        case 2: {
            //修改登录密码
            GYChangeLoginPwdViewController* vcChangePasswd = [[GYChangeLoginPwdViewController alloc] initWithNibName:NSStringFromClass([GYChangeLoginPwdViewController class]) bundle:nil];
            sender = vcChangePasswd;

        } break;
        case 3:
          //交易密码
        {
            //交易密码。
            GYHSTradingPasswordViewController* vcCardBanding = [[GYHSTradingPasswordViewController alloc] init];
            vcCardBanding.tradingPasswordType = self.isSetTradePwd;
            sender = vcCardBanding;
        
        } break;
#pragma mark -暂时屏蔽 重置交易密码 以及屏蔽修改预留信息
//        case 4:
//                
//        {

//            if(self.isSetTradePwd == GYHSTradingPasswordTypeSet) {
//                GYHSModifyReserveDataViewController* vc = [[GYHSModifyReserveDataViewController alloc] init];
//                sender = vc;
//            }else {
//                
//            }
            
            
//        } break;
//        case 5:
//                
//        {
//            GYHSModifyReserveDataViewController* vc = [[GYHSModifyReserveDataViewController alloc] init];
//            sender = vc;
//        } break;

        default:
            break;
        }
    }

    //通过代理 将 controller 传到 navigation push
    if (sender && [_delegate respondsToSelector:@selector(pushVC:animated:)]) {
        UIViewController *vc = (UIViewController *)sender;
        vc.hidesBottomBarWhenPushed = YES;
        [_delegate pushVC:vc animated:YES];
        tableView.userInteractionEnabled = NO;
    }
}

//查看是否已设置收货地址及密保问题
- (void)loadcheckInfoStatusUrlString
{

    NSDictionary* dict = @{ @"custId" : globalData.loginModel.custId,
                            @"perResNo" : globalData.loginModel.resNo,
                            @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard};
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kHScardcheckInfoStatusUrlString parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary *dic = responseObject[@"data"];
        if ([dic[@"address"] isEqualToNumber:@1]) {
            self.address = kLocalized(@"GYHS_NoHSCard_finished");
        }
        else {
            self.address = kLocalized(@"GYHS_NoHSCard_unfinished");
        }
        if ([dic[@"secret"] isEqualToNumber:@1]) {
            self.secret = kLocalized(@"GYHS_NoHSCard_already_setting");
        }
        else {
            self.secret = kLocalized(@"GYHS_NoHSCard_non_setting");
        }
        if ([dic[@"isSetTradePwd"] isEqualToNumber:@1]) {
            
            self.isSetTradePwd = GYHSTradingPasswordTypeModify;
#pragma mark -暂时屏蔽 重置交易密码
            //                    _titleArr = @[ @"基本资料", @"收货地址", @"修改登录密码", @"修改交易密码",@"重置交易密码", @"修改预留信息" ];
            //                    //cell 图片数组
            //                    _imgArr = @[ @"hs_basic_info",
            //                                 @"cell_img_shipping_address_manage",
            //                                 @"gyhs_changeLoginPwd",
            //                                 @"cell_trade_password",
            //                                 @"reset_trade_password",
            //                                 @"hs_reserve_data" ];
        }else {
            self.isSetTradePwd = GYHSTradingPasswordTypeSet;
        }
        [self.tableView reloadData];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}
@end
