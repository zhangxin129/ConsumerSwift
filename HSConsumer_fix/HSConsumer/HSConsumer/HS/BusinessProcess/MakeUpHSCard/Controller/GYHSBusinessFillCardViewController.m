//
//  GYHSBusinessFillCardViewController.m
//
//  Created by lizp on 16/8/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSBusinessFillCardViewController.h"
#import "GYHSBusinessFillCardView.h"
#import "GYHESCDefaultAddressModel.h"

@interface GYHSBusinessFillCardViewController ()<UITextViewDelegate>

@property (nonatomic,strong) GYHSBusinessFillCardView *fillCardView;
@property (nonatomic,strong) GYHESCDefaultAddressModel *model;

@end

@implementation GYHSBusinessFillCardViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self loadNetData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Show Controller: %@", [self class]);

}

- (void)dealloc {
    NSLog(@"Dealloc Controller: %@", [self class]);
}

#pragma mark - SystemDelegate 
-(void)textViewDidBeginEditing:(UITextView *)textView {
    if(textView == self.fillCardView.reasonTextView) {
        if([textView.text isEqualToString:kLocalized(@"GYHS_BP_Input_Rehandle_Reason")]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }else {
            textView.textColor = [UIColor blackColor];
        }
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if(textView == self.fillCardView.reasonTextView) {
        if(textView.text.length == 0) {
            textView.textColor = [UIColor lightGrayColor];
            textView.text = kLocalized(@"GYHS_BP_Input_Rehandle_Reason");
        }else {
            textView.textColor = [UIColor blackColor];
        }
    }


}
// #pragma mark TableView Delegate
// #pragma mark - CustomDelegate  
#pragma mark - event response
//下一步
-(void)nextStepBtnClick {

    [self.view endEditing:YES];
}

#pragma mark - private methods 
- (void)initView
{
    self.title = kLocalized(@"GYHS_BP_Points_Card_Rehandle");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    NSLog(@"Load Controller: %@", [self class]);
    
    self.fillCardView = [[GYHSBusinessFillCardView alloc] init];
    [self.view addSubview:self.fillCardView];
    [self.fillCardView.nextStepBtn addTarget:self action:@selector(nextStepBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.fillCardView.reasonTextView.delegate = self;
    
    
    
}

//请求网络 默认地址
-(void)loadNetData {
    NSMutableDictionary* allParas = [NSMutableDictionary dictionary];
    [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"custId"];
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kGetDefaultReceiveGoodsAddressUrlString parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            self.fillCardView.model = nil;
            return ;
        }
        NSDictionary *dicData = responseObject[@"data"];
        if(!([dicData isKindOfClass:[NSNull class]] || dicData == nil || dicData.count == 0)) {
            self.model = [[GYHESCDefaultAddressModel alloc] initWithDictionary:dicData error:nil];
            self.fillCardView.model = self.model;
        }else {
            self.fillCardView.model = nil;
        }

    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];

}

#pragma mark - getters and setters  


@end
