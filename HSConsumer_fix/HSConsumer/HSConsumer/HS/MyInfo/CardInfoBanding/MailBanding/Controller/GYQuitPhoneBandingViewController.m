//
//  GYQuitPhoneBandingViewController.m
//  HSConsumer
//
//  Created by apple on 14-11-3.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYQuitPhoneBandingViewController.h"
#import "GYQuitPhoneBandingModel.h"
#import "GYQuitPhoneBandingTableViewCell.h"
#import "GYQuitEmailBanding.h"
#import "GYModifyEmailBandingViewController.h"
#import "NSMutableArray+SWUtilityButtons.h"
#import "GYAlertView.h"

@interface GYQuitPhoneBandingViewController ()<GYNetRequestDelegate>

@end

@implementation GYQuitPhoneBandingViewController {

    __weak IBOutlet UITableView* tvQuitPhoneBanding;
}

#pragma mark - life cycle
- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = kLocalized(@"GYHS_Banding_Cell_Phone_Number_Binding");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    _marrDataSoure = [NSMutableArray array];
    
    [tvQuitPhoneBanding registerNib:[UINib nibWithNibName:@"GYQuitPhoneBandingTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    tvQuitPhoneBanding.separatorStyle = UITableViewCellSeparatorStyleNone;
    tvQuitPhoneBanding.backgroundView = nil;
    tvQuitPhoneBanding.backgroundColor = kDefaultVCBackgroundColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_marrDataSoure.count > 0) {
        [_marrDataSoure removeAllObjects];
    }
    [self loadDataFromNetwork];
}

#pragma mark - SystemDelegate

#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return _marrDataSoure.count;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1.0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    return 60.0f;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    static NSString* identifier = @"cell";
    GYQuitPhoneBandingTableViewCell* cell = (GYQuitPhoneBandingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    //从手机绑定  push过来时，设置fromwhere 为yes 传入GYQuitPhoneBandingModel数据，否则传入邮箱绑定的GYQuitEmailBanding
    if (self.fromPhonePage) {
        GYQuitPhoneBandingModel* model = nil;
        if (_marrDataSoure.count > indexPath.row) {
            model = _marrDataSoure[indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.btnQuitBanding.tag = indexPath.row;
        [cell.btnQuitBanding addTarget:self action:@selector(gotoQuitBanding:) forControlEvents:UIControlEventTouchUpInside];
        [cell refreshUIWith:model];
    }
    else {
        [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:70.0f];
        cell.delegate = self;
        GYQuitEmailBanding* model = nil;
        if (_marrDataSoure.count > indexPath.row) {
            model = _marrDataSoure[indexPath.row];
        }
        
        [cell refreshUIWithEmail:model];
    }
    
    return cell;
}

- (void)swipeableTableViewCell:(SWTableViewCell*)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    GYModifyEmailBandingViewController* vcModifyEmail = [[GYModifyEmailBandingViewController alloc] initWithNibName:@"GYModifyEmailBandingViewController" bundle:nil];
    switch (index) {
        case 0: {
            if (![globalData.loginModel.isAuthEmail isEqualToString:kAuthHad]) {
                NSMutableDictionary* allParas = [NSMutableDictionary dictionary];
                
                [allParas setValue:kSaftToNSString(globalData.loginModel.email) forKey:@"email"];
                [allParas setValue:kSaftToNSString(globalData.loginModel.userName) forKey:@"userName"];
                [allParas setValue:globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard forKey:@"userType"];
                if (globalData.loginModel.cardHolder) {
                    [allParas setValue:kCustTypeCard forKey:@"custType"];
                }
                else {
                    [allParas setValue:kCustTypeNoCard forKey:@"custType"];
                }
                
                GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:kSendEmailLinkUrlString parameters:allParas requestMethod:GYNetRequestMethodPUT requestSerializer:GYNetRequestSerializerJSON];
                [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
                [request start];
                [GYGIFHUD show];
            }
            else {
                
                [self.navigationController pushViewController:vcModifyEmail animated:YES];
            }
            
        } break;
        case 1: {
            if (![globalData.loginModel.isAuthEmail isEqualToString:kAuthHad]) {
                
                [self.navigationController pushViewController:vcModifyEmail animated:YES];
            }
            else {
            }
            
        } break;
            
        default:
            break;
    }
}

#pragma mark - CustomDelegate

//GYNetRequestDelegate
-(void)netRequest:(GYNetRequest *)request didSuccessWithData:(NSDictionary *)responseObject {
    [GYGIFHUD dismiss];
    [GYAlertView showMessage:kLocalized(@"GYHS_Banding_Email_Address_Confirmation_Email_Sent_Please_Login_Email") confirmBlock:^{
        [tvQuitPhoneBanding reloadData];
        [self.navigationController popToViewController:self animated:NO];
    }];
    
}

-(void)netRequest:(GYNetRequest *)request didFailureWithError:(NSError *)error {
    [GYGIFHUD dismiss];
    [GYAlertView showMessage:kLocalized(@"GYHS_Banding_Send_Email_Link_Failure") confirmBlock:^{
        [tvQuitPhoneBanding reloadData];
        [ self.navigationController popToViewController:self animated:NO];
    }];
}

#pragma mark - event response
- (NSArray*)rightButtons
{
    NSMutableArray* rightUtilityButtons = [NSMutableArray new];
    if (![globalData.loginModel.isAuthEmail isEqualToString:kAuthHad]) {
        
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor orangeColor]
                                                    title:kLocalized(@"GYHS_Banding_Resend_Mail")];
    }
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:kNavigationBarColor
                                                title:kLocalized(@"GYHS_Banding_Modify_Email_Newline")];
    
    return rightUtilityButtons;
}

- (void)gotoQuitBanding:(UIButton*)sender
{
    if (self.fromPhonePage) {
        
    }
    else {
        
        GYModifyEmailBandingViewController* vcModifyEmail = [[GYModifyEmailBandingViewController alloc] initWithNibName:@"GYModifyEmailBandingViewController" bundle:nil];
        [self.navigationController pushViewController:vcModifyEmail animated:YES];
        
    }
}

#pragma mark - private methods
- (void)loadDataFromNetwork
{
    if (self.fromPhonePage) {
        GYQuitPhoneBandingModel* model = [[GYQuitPhoneBandingModel alloc] init];
        model.strBtnTitle = kLocalized(@"GYHS_Banding_ModifyThePhone");
        model.strBandingSuccess = kLocalized(@"GYHS_Banding_Authenticated");
        model.strPhoneNo = globalData.loginModel.mobile;
        model.strIconUrl = @"hs_cell_img_phone_binding.png";
        [_marrDataSoure addObject:model];
    }
    else {
        
        GYQuitEmailBanding* model = [[GYQuitEmailBanding alloc] init];
        model.strEmail = globalData.loginModel.email;
        
        model.strBtnTitle = kLocalized(@"GYHS_Banding_Authenticated");
        if (![globalData.loginModel.isAuthEmail isEqualToString:kAuthHad]) {
            
            model.strBtnTitle = kLocalized(@"GYHS_Banding_No_Validation");
        }
        
        model.strIconUrl = @"hs_newemail"; 
        [_marrDataSoure addObject:model];
    }
    [tvQuitPhoneBanding reloadData];
}

#pragma mark - getters and setters


@end
