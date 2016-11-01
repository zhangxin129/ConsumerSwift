//
//  GYComplaintViewController.m
//  HSConsumer
//
//  Created by kuser on 16/4/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYComplaintViewController.h"

@interface GYComplaintViewController () <UITextViewDelegate, GYNetRequestDelegate>

@property (weak, nonatomic) IBOutlet UILabel* probLabel;
@property (weak, nonatomic) IBOutlet UITextView* tvInputContent;

@end

@implementation GYComplaintViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTextView];
    [self setCommitBtn];
}

- (void)setTextView
{
    _tvInputContent.contentInset = UIEdgeInsetsMake(8, 8, -5, -8);
    _tvInputContent.delegate = self;
    _tvInputContent.font = [UIFont systemFontOfSize:16];
    _tvInputContent.layer.borderColor = kCorlorFromHexcode(0xDCDCDC).CGColor;
    _tvInputContent.layer.borderWidth = 1;
    _tvInputContent.layer.cornerRadius = 3;
    _tvInputContent.layer.masksToBounds = YES;
}

- (void)setCommitBtn
{
    self.probLabel.text = kLocalized(@"GYHE_MyHE_PleaseInputComplaintReason");
    self.probLabel.textColor = kCorlorFromHexcode(0xC8C8C8);
    [self.commitBtn setTitle:kLocalized(@"GYHE_MyHE_Submit") forState:UIControlStateNormal];
    _commitBtn.layer.cornerRadius = 3;
    _commitBtn.layer.masksToBounds = YES;
    _commitBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.commitBtn setBackgroundColor:kCorlorFromHexcode(0xf08228)];
    [self.commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)commitBtnClick
{
    if ([GYUtils isBlankString:self.tvInputContent.text]) {
        [GYUtils showToast:kLocalized(@"GYHE_MyHE_ComplaintReasonNoNull")];
        return;
    }
    else if (self.tvInputContent.text.length > 180) {
        [GYUtils showMessage:@"GYHE_MyHE_ComplaintReasonNoMoreWord"];
        return;
    }
    NSDictionary* dic = @{ @"key" : globalData.loginModel.token,
        @"complainContext" : self.tvInputContent.text,
        @"orderId" : self.orderId,
        @"refundId" : self.refId,
    };
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:appealUrl parameters:dic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON];
    [request start];
}

#pragma mark -GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    if ([responseObject[@"retCode"] isEqualToNumber:@(200)]) {
        [GYUtils showToast:kLocalized(@"GYHE_MyHE_BuyerComplaintSuccess")];
        [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
        return;
    }
    else {
        [GYUtils showToast:kLocalized(@"GYHE_MyHE_BuyerComplaintFail")];
        return;
    }
}

#pragma mark - failDelegate
-(void)netRequest:(GYNetRequest *)request didFailureWithError:(NSError *)error {
    
    [GYGIFHUD dismiss];
    [GYUtils parseNetWork:error resultBlock:nil];
}

#pragma mark - textViewDelegate
- (void)textViewDidBeginEditing:(UITextView*)textView
{
    _tvInputContent.layer.borderColor = UIColor.greenColor.CGColor;
    _tvInputContent.layer.borderWidth = 1;
    _tvInputContent.layer.cornerRadius = 3;
    _tvInputContent.layer.masksToBounds = YES;
}

- (void)textViewDidEndEditing:(UITextView*)textView
{
    _tvInputContent.layer.borderColor = kCorlorFromHexcode(0xDCDCDC).CGColor;
    _tvInputContent.layer.borderWidth = 1;
    _tvInputContent.layer.cornerRadius = 3;
    _tvInputContent.layer.masksToBounds = YES;
}

- (void)textViewDidChange:(UITextView*)textView
{
    if (textView.text.length == 0) {
        _probLabel.hidden = NO;
    } else {
        _probLabel.hidden = YES;
    }
}

@end
