//
//  GYHSModifyReserveDataViewController.m
//  HSConsumer
//
//  Created by zhangqy on 16/4/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSModifyReserveDataViewController.h"
#import "GYNetRequest.h"
#import "GYAlertView.h"
@interface GYHSModifyReserveDataViewController () <GYNetRequestDelegate>
@property (weak, nonatomic) IBOutlet UITextField* textField;
@property (weak, nonatomic) IBOutlet UIButton* confirmBtn;

@end

@implementation GYHSModifyReserveDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改预留信息";
    self.view.backgroundColor = kBackgroundGrayColor;

    // Do any additional setup after loading the view from its nib.
}

- (IBAction)confirmBtnClicked:(id)sender
{
    [self.view endEditing:YES];
    NSString* str = _textField.text;
    if ([str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [self.view makeToast:@"预留信息不能为空！" duration:0.5 position:CSToastPositionCenter];
        return;
    }
    else if (str.length > 15) {
        [self.view makeToast:@"预留信息长度不超过15位" duration:0.5 position:CSToastPositionCenter];
        return;
    }

    [GYAlertView showMessage:@"确认设置吗?" cancleBlock:nil confirmBlock:^{
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:str forKey:@"reserveInfo"];
        [params setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"custId"];
        [params setValue:@"1" forKey:@"userType"];
        
        [GYGIFHUD show];
        GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self baseURL:nil URLString:kSetReserveInfoUrlString parameters:params requestMethod:GYNetRequestMethodPUT requestSerializer:GYNetRequestSerializerJSON];
        [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        [request start];
    }];
}

- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    DDLogDebug(@"responseObject:%@", responseObject);
    [GYGIFHUD dismiss];

    if ([GYUtils checkDictionaryInvalid:responseObject]) {
        DDLogDebug(@"responseObject:%@ is invalid.", responseObject);
        [GYUtils showMessage:kLocalized(@"GYHS_NoHSCard_netError")];
        return;
    }

    NSInteger returnCode = [[responseObject objectForKey:@"retCode"] integerValue];
    if (returnCode != 200) {
        DDLogDebug(@"ThereturnCode：%ld, is not 200.", (long)returnCode);
        [GYUtils showMessage:kLocalized(@"GYHS_NoHSCard_netError")];
        return;
    }

    [GYAlertView showMessage:@"修改预留信息成功" confirmBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }];
}

- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{
    [GYGIFHUD dismiss];
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}

@end
