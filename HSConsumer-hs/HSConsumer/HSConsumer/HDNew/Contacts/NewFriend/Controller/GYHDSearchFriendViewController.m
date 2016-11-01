//
//  GYHDSearchFriendViewController.m
//  HSConsumer
//
//  Created by shiang on 16/3/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSearchFriendViewController.h"
#import "GYHDMessageCenter.h"
#import "GYHDAddFriendTableViewCell.h"
#import "GYHDSearchUserViewController.h"
#import "GYHDScanFriendViewController.h"
#import "GYHDPhoneFriendViewController.h"
#import "GYMyQRViewController.h"
#import "GYHSPopView.h"
@interface GYHDSearchFriendViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation GYHDSearchFriendViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    UIButton *backtrackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backtrackButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [backtrackButton setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1] forState:UIControlStateNormal];
    backtrackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backtrackButton.frame = CGRectMake(0, 0, 80, 44);
    [backtrackButton setImage:kLoadPng(@"gyhd_back_icon") forState:UIControlStateNormal];
    backtrackButton.contentEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backtrackButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];

//        UIButton *backtrackButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backtrackButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
//        [backtrackButton setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1] forState:UIControlStateNormal];
//        backtrackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        backtrackButton.frame = CGRectMake(0, 0, 80, 44);
//        [backtrackButton setImage:kLoadPng(@"gyhd_back_icon") forState:UIControlStateNormal];
//        backtrackButton.contentEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backtrackButton];
    self.title = [GYUtils localizedStringWithKey:@"GYHD_user_addfriend"];
    
        //互生号搜索按钮
    UIButton*searchHushengBtn=[[UIButton alloc]init];
    [searchHushengBtn setImage:[UIImage imageNamed:@"gyhd_search_icon"] forState:UIControlStateNormal];
    [searchHushengBtn setTitle:[GYUtils localizedStringWithKey:@"GYHD_searchHusheng"] forState:UIControlStateNormal];
    [searchHushengBtn setTitleColor:[UIColor colorWithRed:186/255.0f green:186/255.0f blue:186/255.0f alpha:1] forState:UIControlStateNormal];
    searchHushengBtn.backgroundColor=[UIColor whiteColor];
    searchHushengBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    searchHushengBtn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentLeft;
//    [searchHushengBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 200)];
//    [searchHushengBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 180)];
    [searchHushengBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [searchHushengBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [searchHushengBtn addTarget:self action:@selector(searchHushengBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchHushengBtn];
    [searchHushengBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(40);

    }];
    
    //自身互生号显示
    
    UIButton *hushengShowBtn=[[UIButton alloc]init];
    
    NSString*hushengStr=[self segmentationHuShengCardWithCard:globalData.loginModel.resNo];
    
    [hushengShowBtn setTitle:[NSString stringWithFormat:@"互生卡号:%@",hushengStr] forState:UIControlStateNormal];
    [hushengShowBtn addTarget:self action:@selector(QRHushengClick) forControlEvents:UIControlEventTouchUpInside];
    [hushengShowBtn setImage:[UIImage imageNamed:@"gyhd_addfriend_code"] forState:UIControlStateNormal];
    [hushengShowBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -270)];
    [hushengShowBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -100, 0, 0)];
    [hushengShowBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    hushengShowBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    
    hushengShowBtn.backgroundColor=[UIColor clearColor];
    [self.view addSubview:hushengShowBtn];
    
    [hushengShowBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(searchHushengBtn.mas_bottom).offset(5);
        make.height.mas_equalTo(40);
        
    }];

    //搜索表
    UITableView* selectAddTableView = [[UITableView alloc] init];
    selectAddTableView.scrollEnabled = NO;
    selectAddTableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:selectAddTableView];
    [selectAddTableView registerClass:[GYHDAddFriendTableViewCell class] forCellReuseIdentifier:@"GYHDAddFriendTableViewCell"];
    selectAddTableView.tableFooterView=[[UIView alloc]init];
    [selectAddTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(hushengShowBtn.mas_bottom).offset(40);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    selectAddTableView.dataSource = self;
    selectAddTableView.delegate = self;
    
}
- (void)QRHushengClick {
    GYHSPopView* popView = [[GYHSPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    GYMyQRViewController* vc = [[GYMyQRViewController alloc] init];
    
    vc.title = @"我的二维码";
    NSString* imgUrl;
    if ([globalData.loginModel.headPic hasPrefix:@"http"]) {
        imgUrl = globalData.loginModel.headPic;
    }
    else {
        imgUrl = [NSString stringWithFormat:@"%@%@", globalData.loginModel.picUrl,globalData.loginModel.headPic ];
    }
    vc.picUrl = imgUrl;
    [popView showViews:vc withViewFrame:CGRectMake(32, 90, kScreenWidth - 64, kScreenHeight - 100)];
    
    
}

- (void)backClick:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
  
}


-(void)searchHushengBtnClick{

    DDLogInfo(@"搜索好友或企业互生号");
    GYHDSearchUserViewController *vc = [[GYHDSearchUserViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
//    [self presentViewController:vc animated:YES completion:nil];
    
    
    
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
   
    GYHDAddFriendTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDAddFriendTableViewCell"];
    if (indexPath.row==0) {
        
        cell.titleLabel.text=@"扫一扫";
        
        cell.contentLabel.text=@"扫描二维码名片";
        
        cell.iconImgView.image=[UIImage imageNamed:@"gyhd_addfriend_scan"];
        
    }else if (indexPath.row==1){
    
        cell.titleLabel.text=@"手机联系人";
        
        cell.contentLabel.text=@"添加通讯录中的朋友";
        
        cell.iconImgView.image=[UIImage imageNamed:@"gyhd_addfriend_mobileContacts"];
    
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    switch (indexPath.row) {
        case 0:{   //@"扫一扫"
            GYHDScanFriendViewController *scanViewController = [[GYHDScanFriendViewController alloc] init];
            [self.navigationController pushViewController:scanViewController animated:YES];
            break;
        }
        case 1:{   //@"手机联系人"
            GYHDPhoneFriendViewController *phoneViewController = [[GYHDPhoneFriendViewController alloc] init];
            [self.navigationController pushViewController:phoneViewController animated:YES];
            break;
        }
        default:
            break;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 66;
}

/**根据互生卡 返回分段互生卡*/
- (NSString *)segmentationHuShengCardWithCard:(NSString *)card {
    if (card.length > 10) {
        NSString *sub1 = [card substringWithRange:NSMakeRange(0, 2)];
        NSString *sub2 = [card substringWithRange:NSMakeRange(2, 3)];
        NSString *sub3 = [card substringWithRange:NSMakeRange(5, 2)];
        NSString *sub4 = [card substringWithRange:NSMakeRange(7, 4)];
        card = [NSString stringWithFormat:@"%@ %@ %@ %@",sub1,sub2,sub3,sub4];
    }
    return card;
}

@end
