//
//  GYHSIntegralCodeViewController.m
//  HSConsumer
//
//  Created by admin on 16/9/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSIntegralCodeViewController.h"
#import "GYBigPic.h"

@interface GYHSIntegralCodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *barCodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImageView;
@property (nonatomic,strong) GYBigPic *bigPic;

@end

@implementation GYHSIntegralCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *typeString = nil;
    NSString *accountString = nil;
    if (globalData.loginModel.cardHolder) {
        typeString = @"01";
        accountString = globalData.loginModel.resNo;
        self.cardNumLabel.text = kSaftToNSString([GYUtils formatCardNo:globalData.loginModel.resNo]);
    } else {
        typeString = @"51";
        accountString = globalData.loginModel.mobile;
        self.cardNumLabel.text = kSaftToNSString([GYUtils formatCardNo:globalData.loginModel.mobile]);
    }
    NSString *finalString = [NSString stringWithFormat:@"%@%@%@",@"11",typeString,accountString];
    
    //条形码的生成
    self.barCodeImageView.image = [GYUtils creatBarCodeWithString:finalString size:self.barCodeImageView.frame.size];

    //二维码的生成
    self.QRCodeImageView.image = [GYUtils creatQRCodeWithURLString:finalString imageViewSize:self.QRCodeImageView.frame.size logoImage:[UIImage imageNamed:@"gyhs_account_pvAccount"] logoImageSize:CGSizeMake(self.QRCodeImageView.frame.size.width / 5, self.QRCodeImageView.frame.size.height / 5) logoImageWithCornerRadius:0];
    
    //放大二维码
    self.bigPic = [[GYBigPic alloc] init];
    UITapGestureRecognizer *qrCodeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enlargeqrCodeTap)];
    self.QRCodeImageView.userInteractionEnabled = YES;
    [self.QRCodeImageView addGestureRecognizer:qrCodeTap];
}

#pragma mark -- 放大二维码
-(void)enlargeqrCodeTap
{
    [self.bigPic showView:self.QRCodeImageView.image];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
