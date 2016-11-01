//
//  GYHDAddMarkViewController.m
//  HSConsumer
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDAddMarkViewController.h"

@interface GYHDAddMarkViewController ()
@property(nonatomic,strong)UIButton *saveBtn;//保存按钮
@property(nonatomic,strong)UITextField*markTextField;
@end

@implementation GYHDAddMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
   [self setupNav];
    
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
}

#pragma mark - 导航栏设置
-(void)setupNav{
    
    self.title= [GYUtils localizedStringWithKey:@"GYHD_MarkNameC"];
    
    UIButton*backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    backBtn.frame=CGRectMake(0, 0, 44, 44);
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backBtn setImage:[UIImage imageNamed:@"gyhd_back_icon"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    self.saveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    self.saveBtn.frame=CGRectMake(0, 0, 60, 40);
    
    [self.saveBtn setTitle:[GYUtils localizedStringWithKey:@"GYHD_save"] forState:UIControlStateNormal];
    self.saveBtn.layer.cornerRadius=6;
    self.saveBtn.layer.masksToBounds=YES;
    self.saveBtn.layer.borderWidth = 1;
    self.saveBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [self.saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.saveBtn.titleLabel.font=[UIFont systemFontOfSize:16.0];
    [self.saveBtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.saveBtn];
    
}


-(void)setupUI{

    UILabel*tipLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 200, 20)];
    
    tipLabel.text=[GYUtils localizedStringWithKey:@"GYHD_MarkName"];
    
    tipLabel.textColor=[UIColor blackColor];
    
    [self.view addSubview:tipLabel];
    
    self.markTextField=[[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(tipLabel.frame)+20, kScreenWidth-20, 40)];
    self.markTextField.textColor=[UIColor colorWithRed:166/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    self.markTextField.borderStyle=UITextBorderStyleBezel;
    self.markTextField.placeholder= [GYUtils localizedStringWithKey:@"GYHD_InputMarkName"];
    [self.view addSubview:self.markTextField];
    if (self.defaultString) {
        self.markTextField.text = self.defaultString;
    }
}


//保存
-(void)saveClick{

    if (self.block) {
        
        self.block(self.markTextField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)backClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
