//
//  GYChageEnvironmentViewController.m
//  GYRestaurant
//
//  Created by kuser on 15/10/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYChageEnvironmentViewController.h"
#import "GYLoginEn.h"

@interface GYChageEnvironmentViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSDictionary *dicResutl;
    NSMutableArray *arr;
    
    GYLoginEn *ln;
    EMLoginEn lineTurns;
    NSString *version;
}
@property(nonatomic, weak)UITableView *tvEnvi;

@end

@implementation GYChageEnvironmentViewController

- (void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [Utils createBackButtonWithTitle:kLocalized(@"Back") withTarget:self withAction:@selector(popBack)];
    
    version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    ln = [GYLoginEn sharedInstance];
    //设置顺序
    lineTurns = [GYLoginEn getInitLoginLine];
    

    arr = [@[
            @[kLocalized(@"DevelopmentEnvironmentWithoutUserNameAndPassword"), @(kLoginEn_dev)],
            @[kLocalized(@"TestEnvironmentWithoutUserNameAndPassword"), @(kLoginEn_test)],
            @[kLocalized(@"DemoEnvironmentWithoutUserNameAndPassword"), @(kLoginEn_demo)],
            @[kLocalized(@"PerProductEnvironmentWithoutUserNameAndPassword"), @(kLoginEn_pre_release)],
            @[kLocalized(@"ProductionEnvironmentWithoutUserNameAndPassword"), @(kLoginEn_is_release)],
                     
                     ] mutableCopy];
            
    NSString *strCheckUpdate = [NSString stringWithFormat:kLocalized(@"CheckTheNewVersion")];
    [arr addObject:@[strCheckUpdate, @(-1)]];
    [arr addObject:@[kLocalized(@"Notice:ThisSettingsPanelForInternalUseOnly."), @(-2)]];
    
    UIImageView *iconImage = [[UIImageView alloc]init];
    iconImage.image = [UIImage imageNamed:@"background"];
    iconImage.userInteractionEnabled = YES;
    [self.view addSubview:iconImage];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
        
    }];
    
    
    
    UITableView *tv = [[UITableView alloc] init];
    [iconImage addSubview:tv];
    [tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tvEnvi = tv ;
    self.tvEnvi.tableFooterView = [[UIView alloc]init];
    self.tvEnvi.backgroundColor = [UIColor clearColor];
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor clearColor];
    self.tvEnvi.backgroundView = backView;
    tv.delegate = self;
    tv.dataSource = self;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    
    static NSString *cid = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cid];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    }
    NSString *text = arr[row][0];
    EMLoginEn l = [arr[row][1] integerValue];
    
    cell.textLabel.text = text;
    if ((NSInteger)l >= 0)
    {
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
        if (ln.loginLine == l)
        {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }else
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        
    }else
    {
        if ((NSInteger)l == -1)//更新
        {
            [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
            [cell.textLabel setTextColor:kBlueFontColor];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"ver：%@", version]];
            [cell.detailTextLabel setFont:[UIFont italicSystemFontOfSize:cell.detailTextLabel.font.pointSize]];
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
        }else
        {
            [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
            [cell.textLabel setTextColor:[UIColor orangeColor]];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        }
    }
   
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *resNoStr = kGetNSUser(@"resNO");
    if (resNoStr.length > 0) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"resNO"];
    }
    NSString *userNameStr = kGetNSUser(@"userName");
    if (userNameStr.length > 0) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    }
    
    NSString *pwdStr = kGetNSUser(@"pwd");
    if (pwdStr.length > 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pwd"];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    EMLoginEn l = [arr[row][1] integerValue];
    if ((NSInteger)l < -1)
    {
        return;
    }else if ((NSInteger)l == -1)//更新
    {
        //        [self updateVer];
        return;
    }
    
    ln.loginLine = l;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 企业证书的更新
/*
- (void)updateVer//更新
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.view addSubview:hud];
    //    hud.labelText = @"初始化数据...";
    [hud show:YES];

    [Network HttpGetForRequetURL:@"http://192.168.1.102:9003/update1" parameters:nil httpRequestType:kHttpRequestType_HTTP_ParasNoEncrypt requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
                {
                    dic = dic[@"data"];
                    NSString *sVer = kSaftToNSString(dic[@"ver"]);
                    if (![version isEqualToString:sVer])//有更新
                    {
                        [UIAlertView showWithTitle:@"提示" message:@"检测到新版本,请及时更新！" cancelButtonTitle:@"取消" otherButtonTitles:@[@"更新"]tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            if (buttonIndex != 0)//更新
                            {
                                NSURL *url = [NSURL URLWithString:kSaftToNSString(dic[@"url"])];
                                [[UIApplication sharedApplication] openURL:url];
                            }
                        }];
                    }else
                    {
                        [Utils showMessgeWithTitle:@"提示" message:@"当前版本已经是最新版." isPopVC:nil];
                    }
                }else//返回失败数据
                {
                    [Utils showMessgeWithTitle:nil message:@"查询服务器版本信息失败，请稍后再试." isPopVC:nil];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"查询服务器版本信息失败，请稍后再试." isPopVC:nil];
            }
        }else
        {
            [Utils showMessgeWithTitle:@"提示" message:@"连接问题，请稍后再试." isPopVC:nil];
        }
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];
}
*/

@end
