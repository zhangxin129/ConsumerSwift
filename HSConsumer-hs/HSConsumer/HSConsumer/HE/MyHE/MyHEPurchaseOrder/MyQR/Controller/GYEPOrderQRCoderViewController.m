//
//  GYEPOrderQRCoderViewController.m
//  HSConsumer
//
//  Created by apple on 15/5/29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEPOrderQRCoderViewController.h"

#import "GYGIFHUD.h"
@interface GYEPOrderQRCoderViewController () {
    IBOutlet UIImageView* ivOrderQRCoder;
    IBOutlet UILabel* lbTip;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* imageViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* bgViewHeightConstraint;

@end

@implementation GYEPOrderQRCoderViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _orderID = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [lbTip setTextColor:kCellItemTextColor];
    lbTip.text = @"";
    lbTip.textColor = kCorlorFromHexcode(0x464646);
    lbTip.font = [UIFont systemFontOfSize:18];
    _imageViewHeightConstraint.constant = kScreenWidth - 2 * 10;
    _bgViewHeightConstraint.constant = (kScreenWidth - 2 * 10) + 50;
    //后台二维码350*350
    [self getOrderQRCoder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - 获取订单二维码
- (void)getOrderQRCoder
{
    if (!_orderID)
        return;
    GlobalData* data = globalData;
    NSDictionary* allParas = @{ @"key" : data.loginModel.token,
        @"orderId" : self.orderID };
    [GYGIFHUD show];
    
    GYNetRequest *request = [[GYNetRequest alloc]initWithBlock:EasyBuyBuildTakeQRCodeUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        
        if ([responseObject[@"retCode"] integerValue] == 200) {
            NSDictionary *dic = responseObject;
            if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode) {//返回成功数据
                NSString *message = [NSString stringWithFormat:@"%@", dic[@"data"]];
                NSData *imgData = [[NSData alloc] initWithBase64EncodedString:message options:0];
                UIImage *image = [[UIImage alloc] initWithData:imgData];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ivOrderQRCoder setImage:image];
                        lbTip.text = kLocalized(@"GYHE_MyHE_PleaseUseTwo-dimensionalCode");
                    });
                }
            } else {//返回失败数据
                WS(weakSelf)
                [GYUtils showMessage:kLocalized(@"GYHE_MyHE_InTwo-dimensionalCodeFailure") confirm:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }
        } else {
            WS(weakSelf)
            [GYUtils showMessage:kLocalized(@"GYHE_MyHE_InTwo-dimensionalCodeFailure") confirm:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
    [request start];
}

@end
