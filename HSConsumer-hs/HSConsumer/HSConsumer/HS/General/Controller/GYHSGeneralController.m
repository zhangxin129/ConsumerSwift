//
//  GYHSGeneralController.m
//  GYHSConsumer_MyHS
//
//  Created by liss on 16/4/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSGeneralController.h"
#import "GYAboutHSViewController.h"
#import "GYHSGeneralCell.h"
#import "GYHSGeneralButtonCell.h"
#import "UIActionSheet+Blocks.h"
#import "GYHSLoginManager.h"
#import "GYHSQRCodeController.h"
#import "GYHelpViewController.h"
#import "Masonry.h"
#import "GYHDMessageCenter.h"

#define kUrlCustomerLogoutTag 100

@interface GYHSGeneralController () <GYNetRequestDelegate>

@property (nonatomic, copy) NSArray* oneTitlArray;
@property (nonatomic, copy) NSString* lang;
@property (nonatomic, copy) NSDictionary* dic;
@property (nonatomic, copy) NSString* versionNumber;
@property (nonatomic, copy) NSString* tel;
@property (nonatomic, copy) NSString* iconString;
@property (nonatomic, copy) NSString* languageString;
@property (nonatomic, strong) UIActivityIndicatorView* activityIndicatorView;
@property (nonatomic, copy) NSString* cachPath; //沙盒路径
@property (nonatomic, assign) CGFloat fileSize; //沙盒文件大小

@end

@implementation GYHSGeneralController


#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    DDLogDebug(@"Load Controller: %@", [self class]);
    
    self.title = kLocalized(@"GYHS_General_Settings");
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSGeneralCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSGeneralCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSGeneralButtonCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSGeneralButtonCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    
    self.tel = @"0755-83344111";
    self.versionNumber = kAppVersion;
    
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSString* newString = [def valueForKey:@"userLanguage"];
    
    if ([newString isEqualToString:@"zh-Hans"]) {
        _iconString = @"hs_cell_img_language_sim";
        _languageString = kLocalized(@"GYHS_Chinese_simplified");
    }
    else if ([newString isEqualToString:@"zh-Hant"]) {
        
        _iconString = @"hs_cell_img_language_tra";
        _languageString = kLocalized(@"GYHS_Chinese_Traditional");
    }
    else if ([newString isEqualToString:@"en"]) {
        
        _iconString = @"hs_cell_img_language_en";
        _languageString = kLocalized(@"GYHS_English");
    }
    
    _cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    self.fileSize = [self folderSizeAtPath:_cachPath];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)dealloc
{
    DDLogDebug(@"dealloc Controller: %@", [self class]);
}


#pragma mark - SystemDelegate

#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if (globalData.isLogined) {
        if (globalData.loginModel.cardHolder) {
            return 5;
        }
        else {
            return 4;
        }
    }
    else
        return 3;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (globalData.isLogined) {
        if (globalData.loginModel.cardHolder) {
            if (section == 0) {
                return 2;
            }
            else if (section == 4 || section == 2) {
                return 1;
            }
            else {
                return 2;
            }
        }
        else {
            if (section == 3) {
                return 1;
            }
            else {
                return 2;
            }
        }
    }
    else {
        return 2;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 4 || (globalData.loginModel.cardHolder == NO && indexPath.section == 3)) {
        GYHSGeneralButtonCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSGeneralButtonCell" forIndexPath:indexPath];
        cell.backgroundColor = kDefaultVCBackgroundColor;
        cell.loginoutBtn.backgroundColor = UIColorFromRGB(0xF0823C);
        [cell.loginoutBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        [cell.loginoutBtn setTitle:kLocalized(@"GYHS_General_Log_Out") forState:UIControlStateNormal];
        [cell.loginoutBtn addTarget:self action:@selector(getOut:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else {
        GYHSGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSGeneralCell" forIndexPath:indexPath];
        cell.languangeImg.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ((indexPath.row == 1 && indexPath.section == 3) || (indexPath.row == 1 && indexPath.section == 2)) {
            cell.rightImg.hidden = YES;
        }
        else {
            cell.rightImg.hidden = NO;
        }
        
        //判断 是否登录
        if (globalData.isLogined) {
            
            if ((indexPath.row == 1 && indexPath.section == 3  && globalData.loginModel.cardHolder == YES) || (indexPath.row == 1 && indexPath.section == 2  && globalData.loginModel.cardHolder == NO)) {
                if(self.fileSize > 0) {
                    cell.title.text = [NSString stringWithFormat:@"%@(%.2fM)", self.oneTitlArray[indexPath.section][indexPath.row], self.fileSize];
                }else {
                    cell.title.text = [NSString stringWithFormat:@"%@(0.0Byte)", self.oneTitlArray[indexPath.section][indexPath.row]];
                }
                [self addIndicatorView:cell];
            }
            else {
                cell.title.text = self.oneTitlArray[indexPath.section][indexPath.row];
            }
        }
        else {
            if (indexPath.row == 1 && indexPath.section == 2  ) {
                if(self.fileSize > 0) {
                    cell.title.text = [NSString stringWithFormat:@"%@(%.2fM)", self.oneTitlArray[indexPath.section][indexPath.row], self.fileSize];
                }else {
                    cell.title.text = [NSString stringWithFormat:@"%@(0.0Byte)", self.oneTitlArray[indexPath.section][indexPath.row]];
                }
                
                [self addIndicatorView:cell];
            }
            else {
                cell.title.text = self.oneTitlArray[indexPath.section][indexPath.row];
            }
        }
        if (indexPath.section == 0 && indexPath.row == 2) {
            cell.languangeImg.image = [UIImage imageNamed:self.dic[@"img"]];
            cell.languangeImg.hidden = YES;
            cell.detileLab.text = self.dic[@"det"];
        }
        
        if (indexPath.section == 1 && indexPath.row == 0) {
            cell.detileLab.text = self.tel;
        }
        else if (indexPath.section == 1 && indexPath.row == 1) {
            cell.detileLab.text = [NSString stringWithFormat:@"%@", kSaftToNSString(self.versionNumber)];
            cell.rightImg.hidden = YES;
        }
        
        
        if(indexPath.section == 2 && indexPath.row == 0 && globalData.loginModel.cardHolder) {
            cell.languangeImg.hidden = NO;
            cell.languangeImg.image = [UIImage imageNamed:@"hs_cell_img_my_Qr_code"];
            
            
            [cell.contentView removeConstraint:cell.right];
            [cell.languangeImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.with.equalTo(cell.rightImg.mas_left).offset(-10);
            }];
            
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        //帮助中心
        GYHelpViewController* vcHelp = [[GYHelpViewController alloc] init];
        vcHelp.navigationItem.title = kLocalized(@"GYHS_General_Help");
        [self.navigationController pushViewController:vcHelp animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        GYAboutHSViewController* aboutVC = [[GYAboutHSViewController alloc] init];
        aboutVC.title = kLocalized(@"GYHS_General_About_HS");
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        [self callTel];
    }
    else if (indexPath.section == 2 && indexPath.row == 0 && [[GYHSLoginManager shareInstance] checkLogin] && globalData.loginModel.cardHolder) {
        GYHSQRCodeController* vc = [[GYHSQRCodeController alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
    }
    else if ((indexPath.section == 3 && indexPath.row == 0) || (indexPath.section == 2 && indexPath.row == 0 && ![[GYHSLoginManager shareInstance] checkLogin]) || (globalData.loginModel.cardHolder == NO && indexPath.section == 2 && indexPath.row == 0)) {
        [GYUtils showMessge:kLocalized(@"GYHS_General_WhetherToDownLoad") confirm:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/hu-sheng-qi-ye/id882674478?mt=8&uo=4"]];
        } cancleBlock:^{
            
        }];
    }
    else if ((indexPath.section == 3 && indexPath.row == 1) || (indexPath.section == 2 && indexPath.row == 1 && ![[GYHSLoginManager shareInstance] checkLogin]) || (globalData.loginModel.cardHolder == NO && indexPath.section == 2 && indexPath.row == 1)) {
        [self myClearCacheAction];
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 4 || (globalData.loginModel.cardHolder == NO && section == 3)) {
        return 0.0f;
    }
    return 15.0f;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    if (indexPath.section == 4 || (globalData.loginModel.cardHolder == NO && indexPath.section == 3)) {
        return 81.0f;
    }
    else {
        return 50.0f;
    }
}

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

//GYLanguageControllerDelegate
- (void)tableViewdidSelected:(NSInteger)index withTitle:(NSString*)title withIcon:(NSString*)icon
{
    _iconString = icon;
    _languageString = kLocalized(title);
    self.dic = @{ @"img" : _iconString,
                  @"det" : _languageString };
    [self.tableView reloadData];
}

#pragma mark - event response
- (void)getOut:(UIButton *)sender
{
    [UIActionSheet showInView:self.view withTitle:kLocalized(@"GYHS_General_Confirm_To_Log_Out") cancelButtonTitle:kLocalized(@"GYHS_General_Cancel") destructiveButtonTitle:kLocalized(@"GYHS_General_Confirm") otherButtonTitles:nil tapBlock:^(UIActionSheet* _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            NSDictionary *dic = @{@"custId":globalData.loginModel.custId,
                                  @"channelType":@"4",
                                  @"token":globalData.loginModel.token};
            
            GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlCustomerLogout parameters:dic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON ];
            request.tag = kUrlCustomerLogoutTag;
            [request start];
            [GYGIFHUD showFullScreen];
            
            sender.enabled = NO;
            //不管成不成功
            [GYGIFHUD dismiss];
            [[GYHSLoginManager shareInstance] clearLoginInfo];
            [[GYHSLoginManager shareInstance] goToRootView:1];
            [GYHDMessageCenter sharedInstance].state = GYHDMessageLoginStateAuthenticateFailure;
        }
    }];
}

//AppStoreScore
- (void)commitScoreToAppStore
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=725215709&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
}

//清理缓存
- (void)myClearCacheAction
{
    [self.activityIndicatorView startAnimating];
    
    [GYGIFHUD showFullScreen];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:_cachPath];
        DDLogDebug(@"files :%lu",(unsigned long)[files count]);
        
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [_cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self clearCacheSuccess];
            [GYGIFHUD dismiss];
        });
    });
}

- (void)callTel
{
    UIWebView* callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.tel]]]];
    [self.view addSubview:callWebview];
}

#pragma mark - private methods
//清除 缓存文件成功 调用
- (void)clearCacheSuccess
{
    [self.activityIndicatorView stopAnimating];
    self.tableView.userInteractionEnabled = YES;
    _fileSize = 0;
    [self.tableView reloadData];
}

- (void)addIndicatorView:(UITableViewCell*)cell
{
    if (self.activityIndicatorView == nil) {
        //指定进度轮的大小
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        
        //指定进度轮中心点
        [self.activityIndicatorView setCenter:CGPointMake(kScreenWidth * 0.9, cell.frame.size.height * 0.5)];
        [cell addSubview:self.activityIndicatorView];
        self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
}

//单个文件的大小
- (long long)fileSizeAtPath:(NSString*)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
- (float)folderSizeAtPath:(NSString*)folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
        return 0;
    NSEnumerator* childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize / (1024.0 * 1024.0);
}

#pragma mark - getters and setters
- (NSArray*)oneTitlArray
{
    if (!_oneTitlArray) {
        if (globalData.isLogined) {
            if (globalData.loginModel.cardHolder) {
                _oneTitlArray = @[ @[ kLocalized(@"GYHS_General_Help"), kLocalized(@"GYHS_General_About_HS") ],
                    @[ kLocalized(@"GYHS_General_Customer_Service_Telephone"), kLocalized(@"GYHS_General_Version_Check") ],
                    @[ kLocalized(@"GYHS_General_MyQrCode") ],
                    @[ kLocalized(@"GYHS_General_Company_Download"), kLocalized(@"GYHS_General_Clear_Cache") ] ];
            }
            else {
                _oneTitlArray = @[ @[ kLocalized(@"GYHS_General_Help"), kLocalized(@"GYHS_General_About_HS") ],
                    @[ kLocalized(@"GYHS_General_Customer_Service_Telephone"), kLocalized(@"GYHS_General_Version_Check") ],
                    @[ kLocalized(@"GYHS_General_Company_Download"), kLocalized(@"GYHS_General_Clear_Cache") ] ];
            }
        }
        else {
            _oneTitlArray = @[ @[ kLocalized(@"GYHS_General_Help"), kLocalized(@"GYHS_General_About_HS") ],
                @[ kLocalized(@"GYHS_General_Customer_Service_Telephone"), kLocalized(@"GYHS_General_Version_Check") ],
                @[ kLocalized(@"GYHS_General_Company_Download"), kLocalized(@"GYHS_General_Clear_Cache") ] ];
        }
    }
    return _oneTitlArray;
}

@end
