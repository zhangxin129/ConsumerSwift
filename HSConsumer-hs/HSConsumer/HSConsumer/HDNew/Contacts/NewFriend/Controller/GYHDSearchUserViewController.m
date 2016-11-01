//
//  GYHDSearchUserViewController.m
//  HSConsumer
//
//  Created by wangbiao on 16/9/19.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSearchUserViewController.h"
#import "GYHDMessageCenter.h"
#import "GYHDSearchUserCell.h"
#import "GYHDSearchUserModel.h"
#import "GYUtils+HSConsumer.h"
#import "GYHDSearchUserDetailViewController.h"
#import "GYHDFriendDetailViewController.h"
#import "GYHDChatViewController.h"
@interface GYHDSearchUserViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic, strong)UITextField *searchTextField;
@property(nonatomic, strong)UITableView *searchTableView;
@property(nonatomic, strong)NSArray     *dataArray;

@property(nonatomic, strong)NSDictionary *companyDict;
@end

@implementation GYHDSearchUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_cancel"] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];


    self.searchTextField = [[UITextField alloc] init];
    self.searchTextField.layer.masksToBounds = YES;
    self.searchTextField.layer.cornerRadius = 12;
    self.searchTextField.placeholder = @"互生卡/手机号";
    self.searchTextField.font = [UIFont systemFontOfSize:12.0f];
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0, 0, 30, 24);
    
    UIImageView *leftimageView = [[UIImageView alloc] init];
    leftimageView.image = [UIImage imageNamed:@"gyhd_search_icon"];
    leftimageView.contentMode = UIViewContentModeCenter;
    [leftView addSubview:leftimageView];
    [leftimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-2);
        make.center.equalTo(leftView);
    }];
    self.searchTextField.leftView = leftView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIView *rightView = [[UIView alloc] init];
    rightView.frame = CGRectMake(0, 0, 30, 24);
    
    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton setImage:[UIImage imageNamed:@"gyhd_search_bar_right_icon"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(2);
        make.center.equalTo(rightView);
    }];
    self.searchTextField.rightView = rightView;
    self.searchTextField.rightViewMode = UITextFieldViewModeAlways;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.delegate = self;
    [self.view  addSubview:self.searchTextField];
    self.searchTextField.backgroundColor = [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1];
    
    
    self.searchTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.searchTableView.dataSource = self;
    self.searchTableView.delegate = self;
    [self.searchTableView registerClass:[GYHDSearchUserCell class] forCellReuseIdentifier:NSStringFromClass([GYHDSearchUserCell class])];
    
//    UIView *headerView = [[UIView alloc] init];
//    headerView.frame = CGRectMake(10, 0, kScreenWidth, 20);
//    headerView.backgroundColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1];
    

//    [tableHeaderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(10);
//        make.top.bottom.right.mas_equalTo(0);
//    }];
//    self.searchTableView.tableHeaderView = headerView;
    [self.view addSubview:self.searchTableView];
    self.searchTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    WS(weakSelf);
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(20);
        make.width.mas_equalTo(50);
    }];

    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cancelButton.mas_left).offset(-10);
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(24);
    }];
    
    [self.searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.searchTextField.mas_bottom).offset(10);
//        make.top.mas_equalTo(0);
        make.left.bottom.right.mas_equalTo(0);
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)rightBtnClick {
    self.searchTextField.text = nil;
}

- (void)cancelBtnClick {
    [self.navigationController popViewControllerAnimated:YES];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    GYHDSearchUserModel *model = self.dataArray[indexPath.row];
    
    if ([model.userType isEqualToString:@"e"]) {
        GYHDChatViewController* chatViewController = [[GYHDChatViewController alloc] init];
        chatViewController.companyInformationDict = self.companyDict;
        [self.navigationController pushViewController:chatViewController animated:YES];
    }else  {
        if ([model.friendStatus isEqualToString:@"2"]) {
            GYHDFriendDetailViewController *vc = [[GYHDFriendDetailViewController alloc] init];
            vc.FriendCustID=model.hushengString;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            GYHDSearchUserDetailViewController *userDetailViewController = [[GYHDSearchUserDetailViewController alloc] init];
            userDetailViewController.userModel = model;
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController pushViewController:userDetailViewController animated:YES];
        }
    }
    


}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataArray.count) {
        return 20;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.dataArray.count) {
        UILabel *tableHeaderLabel = [[UILabel alloc] init];
        if (self.companyDict) {
            tableHeaderLabel.text = @"  企业信息";
        }else {
            tableHeaderLabel.text = @"  互生卡号联系人";
        }

        tableHeaderLabel.font = [UIFont systemFontOfSize:12];
        tableHeaderLabel.backgroundColor = [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1];
        tableHeaderLabel.frame = CGRectMake(0, 0, kScreenWidth, 20);
        return tableHeaderLabel;
    }
    return nil;
}
//- (UIView *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//
//    if (self.dataArray.count) {
//        UILabel *tableHeaderLabel = [[UILabel alloc] init];
//        tableHeaderLabel.text = @"互生卡号联系人";
//        tableHeaderLabel.font = [UIFont systemFontOfSize:12];
//        tableHeaderLabel.backgroundColor = [UIColor clearColor];
//        tableHeaderLabel.frame = CGRectMake(0, 0, kScreenWidth, 20);
//        return tableHeaderLabel;
//    }
//    return nil;
//
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYHDSearchUserCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GYHDSearchUserCell class])];
//    cell.backgroundColor = [UIColor randomColor];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"%@",textField.text);
    WS(weakSelf);
    if (textField.text.length>=11) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"keyword"] = textField.text;
        dict[@"custId"] = globalData.loginModel.custId;
        dict[@"currentPage"] = @"1";
        dict[@"pageSize"] = @"10";
        [[GYHDMessageCenter sharedInstance] getConsumerOrCompanyInfoWithDict:dict RequetResult:^(NSDictionary *resultDict) {
            NSLog(@"%@",resultDict);
            if ([resultDict[@"retCode"] integerValue] == 200 && ![resultDict[@"rows"] isKindOfClass:[NSNull class]]) {
                NSDictionary *dict = [resultDict[@"rows"] lastObject];
                if ([dict[@"searchType"] isEqualToString:@"e"]) {
                    [[GYHDMessageCenter sharedInstance] GetVShopShortlyInfoUrlWithResourcesNo:dict[@"entResNo"] RequetResult:^(NSDictionary *resultDict) {
                        NSLog(@"%@",resultDict);
                        weakSelf.companyDict = resultDict;
                        
//                        if ([resultDict[@"data"] isKindOfClass:[NSDictionary class]]) {
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                GYHDChatViewController* chatViewController = [[GYHDChatViewController alloc] init];
//                                
//                                chatViewController.companyInformationDict = responseObject;
//                                [self.navigationController pushViewController:chatViewController animated:YES];
//                            });
//                        }
                        
                        if ([resultDict[@"retCode"] integerValue] == 200) {
                            NSDictionary *comDict = resultDict[@"data"];
                            if (![comDict isKindOfClass:[NSNull class]]) {
                                NSMutableArray *array = [NSMutableArray array];
                                GYHDSearchUserModel *model = [[GYHDSearchUserModel alloc] init];
                                model.iconString =  comDict[@"logo"];
                                model.nameString =  comDict[@"vShopName"];
                                model.hushengString = dict[@"entResNo"];
                                model.userType =  dict[@"searchType"];
                                model.vshopID = comDict[@"vShopId"];
                                model.address = comDict[@"addr"];
                                model.custID = comDict[@"messageCard"];
                                [array addObject:model];
                                weakSelf.dataArray = array;
                                [weakSelf.searchTableView reloadData];
                            }else {
                                [GYUtils showToast:@"返回数据有误" duration:2.5f position:CSToastPositionCenter];
                            }
                        }
                    }];
                }else  if ([dict[@"searchType"] isEqualToString:@"c"]) {
                    
                    NSMutableArray *array = [NSMutableArray array];
                    for (NSDictionary *dict in resultDict[@"rows"]) {
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
         
             
                        [array addObject:model];
                    }
                    weakSelf.dataArray = array;
                    [weakSelf.searchTableView reloadData];
                }
            }else {
                [GYUtils showToast:@"只能输入11位数字，不可输入0-9之外的字符。" duration:2.5f position:CSToastPositionCenter];
            }
        }];
    }else {
        [GYUtils showToast:@"只能输入11位数字，不可输入0-9之外的字符。" duration:2.5f position:CSToastPositionCenter];
    }

    return YES;
}
@end
