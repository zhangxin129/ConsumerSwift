//
//  GYHDScanFriendViewController.m
//  HSConsumer
//
//  Created by wangbiao on 16/10/17.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDScanFriendViewController.h"
#import "GYQRCodeReaderViewController.h"
#import "GYHDFriendDetailViewController.h"
#import "GYHDSearchUserDetailViewController.h"
#import "GYHDSearchUserModel.h"

#import "GYHDMessageCenter.h"

@interface GYHDScanFriendViewController ()
/**扫一扫*/
@property(nonatomic, strong)GYQRCodeReaderViewController *scanViewController;
/**好友界面*/
@property(nonatomic, strong)GYHDFriendDetailViewController *friendViewController;
@end

@implementation GYHDScanFriendViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    _scanViewController = [[GYQRCodeReaderViewController alloc] init];
    _scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    _scanViewController.limitTopMagin = 140;
    _scanViewController.hidesBottomBarWhenPushed = YES;
    self.title = @"二维码";
    
    WS(weakSelf);
    [_scanViewController setCompletionWithBlock:^(NSString *resultAsString) {
        NSLog(@"xxxxx");
        if ([resultAsString hasPrefix:@"1101"] && resultAsString.length == 15) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"keyword"] =[resultAsString substringFromIndex:4];
                dict[@"custId"] = globalData.loginModel.custId;
                dict[@"currentPage"] = @"1";
                dict[@"pageSize"] = @"10";
                [[GYHDMessageCenter sharedInstance] getConsumerOrCompanyInfoWithDict:dict RequetResult:^(NSDictionary *resultDict) {
                    NSLog(@"%@",resultDict);
                    if ([resultDict[@"retCode"] integerValue] == 200 && ![resultDict[@"rows"] isKindOfClass:[NSNull class]]) {
                            NSDictionary *dict = [resultDict[@"rows"] lastObject];
 
                            GYHDSearchUserModel *model = [[GYHDSearchUserModel alloc] init];
                            model.iconString = [NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl, dict[@"headPic"]];
                            model.nameString = dict[@"nickname"];
                            model.hushengString = dict[@"resNo"];
                            model.sign = dict[@"sign"];
                            model.address = dict[@"area"];
                            model.hobby = dict[@"hobby"];
                            model.userType = dict[@"searchType"];
                            model.custID = dict[@"friendId"];
                            
                            if ([dict[@"friendStatus"] isKindOfClass:[NSString class]]) {
                                model.friendStatus = dict[@"friendStatus"];
                            }else {
                                model.friendStatus = [dict[@"friendStatus"] stringValue];
                            }
                            if ([model.friendStatus isEqualToString:@"2"]) {
                                GYHDFriendDetailViewController *vc = [[GYHDFriendDetailViewController alloc] init];
                                vc.FriendCustID=model.hushengString;
                                [weakSelf addChildViewController:vc];
                                [weakSelf.view addSubview:vc.view];
                                [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.top.left.bottom.right.mas_equalTo(0);
                                }];
                            }else {
                                GYHDSearchUserDetailViewController *userDetailViewController = [[GYHDSearchUserDetailViewController alloc] init];
                                userDetailViewController.userModel = model;
                                [weakSelf addChildViewController:userDetailViewController];
                                [weakSelf.view addSubview:userDetailViewController.view];
                                [userDetailViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.top.left.bottom.right.mas_equalTo(0);
                                }];
                            }
                    }else {
                        [weakSelf.scanViewController startScanning];
                        [GYUtils showToast:@"只能输入11位数字，不可输入0-9之外的字符。" duration:2.5f position:CSToastPositionCenter];
                    }
                }];

            

        }else {
            [weakSelf.scanViewController startScanning];
            [GYUtils showToast:@"只能输入11位数字，不可输入0-9之外的字符。" duration:2.5f position:CSToastPositionCenter];
        }
    }];
    [self addChildViewController:_scanViewController];
    [self.view addSubview:_scanViewController.view];
    [_scanViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    

}

@end
