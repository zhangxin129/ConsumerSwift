//
//  GYHSHelpCenterViewController.m
//  HSCompanyPad
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSHelpCenterViewController.h"

@interface GYHSHelpCenterViewController ()

@end

@implementation GYHSHelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createAnswerUI];
    [self createTipUI];
    
}

- (void)createUI{
    
    self.title = kLocalized(@"帮助中心");
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 50)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    headView.backgroundColor = [UIColor whiteColor];
    [imageView setImage:[UIImage imageNamed:@"gyhs_staff_searchBackground"]];
    [headView addSubview:imageView];
    [self.view addSubview:headView];
    
    UITextField *searchTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 200, 30)];
    searchTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    searchTF.layer.borderWidth = 1.0f;
    searchTF.placeholder = kLocalized(@"搜索帮助");
    [headView addSubview:searchTF];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(CGRectGetMaxX(searchTF.frame) + 10, 10, 30, 30);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_point_check"] forState:UIControlStateNormal];
    [headView addSubview:searchBtn];
    UILabel *searchLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchBtn.frame), 10, 40, 30)];
    searchLab.text = kLocalized(@"搜索");
    searchLab.textColor = [UIColor redColor];
    [headView addSubview:searchLab];
}

- (void)createAnswerUI{
    UIView *quickSearchView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, kScreenWidth, 100)];
    [self.view addSubview:quickSearchView];
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 20, 51, 63)];
    [searchImageView setImage:[UIImage imageNamed:@"gyhs_helpCenter"]];
    [quickSearchView addSubview:searchImageView];
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchImageView.frame) + 10, 20, 200, 30)];
    tipLab.text = kLocalized(@"快速找到答案");
    [tipLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    [quickSearchView addSubview:tipLab];
    
    UILabel *searchTipLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchImageView.frame) + 10, CGRectGetMaxY(tipLab.frame), 200, 20)];
    searchTipLab.textColor = [UIColor lightGrayColor];
    searchTipLab.text = kLocalized(@"在以上搜索框中输入少量字词");
    searchTipLab.font = [UIFont systemFontOfSize:15];
    [quickSearchView addSubview:searchTipLab];
    
}

- (void)createTipUI{
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 280, kScreenWidth, 200)];
    [self.view addSubview:tipView];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(200, 10, 200, 30)];
    titleLab.text = kLocalized(@"是否不确定从哪里开始？");
    titleLab.font = [UIFont systemFontOfSize:18];
    [tipView addSubview:titleLab];
    
    UIButton *userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    userBtn.frame = CGRectMake(200, CGRectGetMaxY(titleLab.frame) + 5, 180, 20);
    [userBtn setTitle:kLocalized(@"如何开始使用互生平板？") forState:UIControlStateNormal];
    [userBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    userBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [tipView addSubview:userBtn];
    
    UIButton *functionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    functionBtn.frame = CGRectMake(200, CGRectGetMaxY(userBtn.frame) + 5, 195, 20);
    [functionBtn setTitle:kLocalized(@"平板基本功能：所有主题菜单") forState:UIControlStateNormal];
    [functionBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    functionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [tipView addSubview:functionBtn];
    
    UIButton *helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    helpBtn.frame = CGRectMake(200, CGRectGetMaxY(functionBtn.frame) + 5, 90, 20);
    [helpBtn setTitle:kLocalized(@"浏览帮助回答") forState:UIControlStateNormal];
    [helpBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    helpBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [tipView addSubview:helpBtn];
    
}


@end
