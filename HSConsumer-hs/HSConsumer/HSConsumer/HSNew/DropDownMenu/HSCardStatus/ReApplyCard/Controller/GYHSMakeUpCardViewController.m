//
//  GYAgainViewController.m
//  HSConsumer
//
//  Created by 00 on 14-10-16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAddressData.h"
#import "GYAddressModel.h"
#import "GYAlertView.h"
#import "GYHSGetGoodViewController.h"
#import "GYHSLoginManager.h"
#import "GYHSMakeUpCardViewController.h"
#import "GYHSCardPaymentViewController.h"

@interface GYHSMakeUpCardViewController () <UITextViewDelegate, GYGetAddressDelegate> {

    __weak IBOutlet UIScrollView* scvAgain; //scrollView
    __weak IBOutlet UIView* vHSC; //互生卡行
    __weak IBOutlet UILabel* lbHSCTitle; //互生卡title
    __weak IBOutlet UILabel* lbHSCNum; //互生号

    __weak IBOutlet UIButton* btnAddress; //获取地址按钮
    __weak IBOutlet UIButton* btnCommit; //确认按钮

    __weak IBOutlet UIView* vReason; //补办原因底图
    __weak IBOutlet UITextView* tvReason; //补办原因输入框
    __weak IBOutlet UILabel* lbReason; //原因标题
    __weak IBOutlet UILabel* lbAddress; //收货地址标题
    __weak IBOutlet UILabel* lbAddressLong; //收货地址内容
    __weak IBOutlet UILabel* lbPlaceholder; //补办原因占位符
    __weak IBOutlet UILabel* lbPhone; //电话号码展示

    __weak IBOutlet UILabel *addAddressLabel;//添加收货地址提醒
    GlobalData* data;
    GYAddressModel* addrModel;
}
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation GYHSMakeUpCardViewController

//下一步按钮 点击事件
- (IBAction)btnNextClick:(UIButton*)sender
{
    if (lbAddress.text.length < 1 || lbAddressLong.text.length < 1) {
        [GYAlertView showMessage:kLocalized(@"GYHS_BP_SelectAdder")];
        return;
    }
    if (tvReason.text.length > 300) {
        [GYAlertView showMessage:kLocalized(@"GYHS_BP_Input_Rehandle_Reason_Not_More_Than_300_Words")];
        return;
    }
    if ([globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusNoRes]) {
        [GYAlertView showMessage:kLocalized(@"GYHS_BP_Please_Realname_Registration")];
        return;
    }

    [self commit_new];
}
//进入选择收货地址页面
- (IBAction)btnAddressClick:(id)sender
{

    GYHSGetGoodViewController* vcAdd = [[GYHSGetGoodViewController alloc] init];
    vcAdd.deletage = self;
    [self.navigationController pushViewController:vcAdd animated:YES];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //textView
    [vReason addAllBorder];
    [vHSC addTopBorderAndBottomBorder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    data = globalData;

    //国际化
    self.title = kLocalized(@"GYHS_BP_Points_Card_Rehandle");
    lbReason.text = kLocalized(@"补办原因");
    lbHSCTitle.text = kLocalized(@"互生卡号");
    [lbHSCTitle setTextColor:kCellItemTitleColor];
    addAddressLabel.text = kLocalized(@"请添加收货地址");

    lbHSCNum.text = [GYUtils formatCardNo:data.loginModel.resNo];

    //确认提交按钮设置
    btnCommit.layer.cornerRadius = 20.0f;

    [btnCommit setTitle:kLocalized(@"GYHS_BP_Next_Step") forState:UIControlStateNormal];

    //textview
    lbPlaceholder.text = kLocalized(@"请填写补办原因");
    lbPlaceholder.enabled = NO;
    tvReason.delegate = self;

    scvAgain.contentSize = CGSizeMake(0, CGRectGetMaxY(btnCommit.frame) + 80);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:kReceiveGoodsLocationChanged object:nil];

    [self getAddrFromNetwork];
}
#pragma mark - 自定义方法
- (void)refreshData
{
    [self getAddrFromNetwork];
}

#pragma mark - UITextViewDelegate
//占位符逻辑
- (void)textViewDidChange:(UITextView*)textView
{
    if (textView.text.length > 300) {
        textView.text = [textView.text substringToIndex:300];
        lbPlaceholder.text = @"";
        return;
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(300 - textView.text.length)];
    
    if (textView.text.length == 0) {
        lbPlaceholder.text = kLocalized(@"GYHS_BP_Input_Rehandle_Reason");
    } else {
        lbPlaceholder.text = @"";
    }
    
}

//地址回调函数
- (void)getAddressModle:(GYAddressModel*)model
{
    if (model) {
        addAddressLabel.hidden = YES;
    }
    addrModel = model;
    lbAddress.text = model.receiver;

    lbAddressLong.text = [self getAddressWithPrivinceNo:model.provinceNo cityNo:model.cityNo areaName:model.area detailAddress:model.address postCodeName:model.postCode];

    addrModel.fullAddress = lbAddressLong.text;
    lbPhone.text = model.mobile;
    //[btnAddress setTitle:kLocalized(@"GYHS_BP_Change_Shipping_Address") forState:UIControlStateNormal];
}

#pragma mark - 接口重构  by zxm 20151230
- (void)commit_new
{

    NSMutableDictionary* allParas = [NSMutableDictionary dictionary];
    [allParas setValue:kSaftToNSString(data.loginModel.custId) forKey:@"custId"];
    [allParas setValue:kSaftToNSString(data.loginModel.resNo) forKey:@"hsResNo"];

    NSString* custName = data.loginModel.custName;
    [allParas setValue:kSaftToNSString(custName) forKey:@"custName"];
    [allParas setValue:kSaftToNSString(lbAddressLong.text) forKey:@"fullAddr"];
    [allParas setValue:kSaftToNSString(lbAddress.text) forKey:@"linkman"];
    [allParas setValue:kSaftToNSString(lbPhone.text) forKey:@"mobile"];
    [allParas setValue:kSaftToNSString(tvReason.text) forKey:@"orderRemark"];

    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kHSCardMendCardOrderUrlString
                                                     parameters:allParas
                                                  requestMethod:GYNetRequestMethodPOST
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary* responseObject, NSError* error) {
                                                       [GYGIFHUD dismiss];
                                                       if (error) {
                                                           DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
                                                           [GYUtils parseNetWork:error resultBlock:nil];
                                                           return;
                                                       }
                                                       NSDictionary* dic = responseObject[@"data"];
                                                       NSMutableDictionary* orderDic = [NSMutableDictionary dictionary];
                                                       [orderDic setValue:kSaftToNSString(dic[@"orderNo"]) forKey:@"orderNo"];
                                                       [orderDic setValue:kSaftToNSString(dic[@"hsbAmount"]) forKey:@"orderAmount"];
                                                       GYHSCardPaymentViewController *vc = [[GYHSCardPaymentViewController alloc] init];
                                                       vc.orderNo = orderDic[@"orderNo"];
                                                       vc.realMoney = orderDic[@"orderAmount"];
                                                       [self.navigationController pushViewController:vc animated:YES];
                                                   }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

#pragma mark - 获取默认收货一个地址
- (void)getAddrFromNetwork
{
    [self getAddrFromNetwork_new];
}
#pragma mark - 获取默认收货地址，接口重构 by zxm 20160107
- (void)getAddrFromNetwork_new
{
    NSMutableDictionary* allParas = [NSMutableDictionary dictionary];

    [allParas setValue:kSaftToNSString(data.loginModel.custId) forKey:@"custId"];

    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kGetDefaultReceiveGoodsAddressUrlString
                                                     parameters:allParas
                                                  requestMethod:GYNetRequestMethodGET
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary* responseObject, NSError* error) {
                                                       [GYGIFHUD dismiss];
                                                       if (error) {
                                                           DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
                                                           [GYUtils parseNetWork:error resultBlock:nil];
                                                           addAddressLabel.hidden = NO;
                                                           return;
                                                       }
                                                       NSDictionary* dicData = responseObject[@"data"];
                                                       if ([dicData isKindOfClass:[NSNull class]] || dicData == nil || dicData.count == 0) {
                                                           addAddressLabel.hidden = NO;
                                                           lbAddressLong.text = @"";
                                                           lbPhone.text = @"";
                                                           addrModel.fullAddress = @"";
                                                           lbAddress.text = @"";
                                                           return;
                                                       }
                                                       addAddressLabel.hidden = YES;
                                                       lbAddress.text = kSaftToNSString(dicData[@"receiver"]);
                                                       if ([GYUtils isBlankString:lbAddress.text]) {
                                                           return; //无收货人
                                                       } else {
                                                           lbAddressLong.text = [self getAddressWithPrivinceNo:dicData[@"provinceNo"] cityNo:dicData[@"cityNo"] areaName:dicData[@"area"] detailAddress:dicData[@"address"] postCodeName:dicData[@"postCode"]];
                                                           addrModel.fullAddress = lbAddressLong.text;
                                                           lbPhone.text = kSaftToNSString(dicData[@"mobile"]);
                                                           //[btnAddress setTitle:kLocalized(@"GYHS_BP_Change_Shipping_Address") forState:UIControlStateNormal];
                                                       }
                                                   }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (NSString*)getAddressWithPrivinceNo:(NSString*)privinceNo cityNo:(NSString*)cityNo areaName:(NSString*)areaName detailAddress:(NSString*)detailAddress postCodeName:(NSString*)postCodeName
{

    GYProvinceModel* provinceModel = [[GYAddressData shareInstance] queryProvinceNo:privinceNo];
    GYCityAddressModel* cityModel = [[GYAddressData shareInstance] queryCityNo:cityNo];

    NSString* province = @"";
    NSString* city = @"";

    province = provinceModel.provinceName; //广东省.....
    city = cityModel.cityName; //深圳市.....

    if (kSaftToNSString(postCodeName).length > 0) {
        return [NSString stringWithFormat:@"%@%@%@%@%@(%@)", kLocalized(@"GYHS_BP_Contact_Address"),
                         kSaftToNSString(province),
                         kSaftToNSString(city),
                         kSaftToNSString(areaName),
                         kSaftToNSString(detailAddress),
                         kSaftToNSString(postCodeName)];
    } else {
        return [NSString stringWithFormat:@"%@%@%@%@%@", kLocalized(@"GYHS_BP_Contact_Address"),
                kSaftToNSString(province),
                kSaftToNSString(city),
                kSaftToNSString(areaName),
                kSaftToNSString(detailAddress)];
    }
    
}


@end
