//
//  GYMyQRViewController.m
//  HSConsumer
//
//  Created by kuser on 16/9/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYMyQRViewController.h"

@interface GYMyQRViewController ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backImageHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backImageDistanceTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *qrImageHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *qrImageDistanceTopConstraint;
@property (strong, nonatomic) IBOutlet UIImageView *qrImage;     //二维码图标
@property (strong, nonatomic) IBOutlet UIImageView *headerImage; //头像图标
@property (strong, nonatomic) IBOutlet UILabel *resNo;


@end

@implementation GYMyQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUI];
    [self setQRIconImage];
    [self headerIconImage];
//    [self setBackButton];
}

-(void)setBackButton
{
    UIImageView* leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    leftImage.contentMode = UIViewContentModeScaleAspectFit;
    leftImage.image = [UIImage imageNamed:@"gy_he_back_arrow"];
    leftImage.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapSetting = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushBack)];
    [leftImage addGestureRecognizer:tapSetting];
    UIBarButtonItem* leftBackBtn = [[UIBarButtonItem alloc] initWithCustomView:leftImage];
    self.navigationItem.leftBarButtonItem = leftBackBtn;
}

-(void)pushBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setUI
{
    //背景约束
    self.backImageHeightConstraint.constant = (kScreenWidth - 30 * 2 - 32 * 2);
    self.backImageDistanceTopConstraint.constant = ((kScreenHeight  - 110 - 80) - (kScreenWidth - 30 * 2 - 32 * 2)) * 0.5;
    //二维码约束
    self.qrImageHeightConstraint.constant = (kScreenWidth - 60 * 2 - 32 * 2);
    self.qrImageDistanceTopConstraint.constant = ((kScreenHeight - 110 - 80) - (kScreenWidth - 60 * 2 - 32 * 2)) * 0.5;
    //头像圆角
    self.headerImage.layer.cornerRadius = 28;
    self.headerImage.layer.borderWidth = 2;
    self.headerImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headerImage.clipsToBounds = YES;
    self.resNo.text = globalData.loginModel.nickName;
}

//生成二维码
-(void)setQRIconImage
{
    NSString *typeString = nil;
    NSString *accountString = nil;
    if (globalData.loginModel.cardHolder) {
        typeString = @"01";
        accountString = globalData.loginModel.resNo;
    } else {
        typeString = @"51";
        accountString = globalData.loginModel.mobile;
    }
    NSString *finalString = [NSString stringWithFormat:@"%@%@%@",@"11",typeString,accountString];
    UIImage *qrImage = [GYUtils createQRImageWithString:finalString size:CGSizeMake(kScreenWidth - 32 *2 - 65 * 2, kScreenWidth - 32 *2 - 65 * 2)];
   self.qrImage.image = qrImage;
}

//加载头像
-(void)headerIconImage
{
    [self.headerImage setImageWithURL:[NSURL URLWithString:_picUrl] placeholder:kLoadPng(@"hs_cell_img_noneuserimg") options:kNilOptions completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
