//
//  GYConfirmationViewController.m
//  HSConsumer
//
//  Created by appleliss on 15/10/20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYConfirmationViewController.h"
#import "GYCommentViewController.h"
#import "GYHSGetGoodViewController.h"
#import "GYNewDataCalendarViewController.h"
#import "GYOrderDetailsViewController.h"
#import "GYRestaurantOrderViewController.h"
///// V
#import "FDChoosedFoodModel.h"
#import "GYConfirmCell.h"
#import "GYConfirmOrdersCell.h"
#import "GYHSLoginManager.h"
#import "GYHSLoginViewController.h"
#import "GYNewAddressCell.h"
#import "GYOrderTableViewCell.h"
#import "GYPayMentModel.h"
#import "GYcellModel.h"
#import "GYnormalCell.h"
#import "UIAlertView+Blocks.h"
#import "UIButton+GYTimeOut.h"

#define imagew 15
#define imageh 5
#define labH 18
#define imageddddHH 15
#define baseViewH 35
#define cellH 40
#define clickimage 20
#define inShop 1
#define outShop 3

@interface GYConfirmationViewController () <UITableViewDataSource, UITableViewDelegate, GYGetAddressDelegate, GYCommentViewControllerDelegate, GYConfirmCellDelegate, UIPickerViewDataSource, UIPickerViewDelegate, GYNewDataCalendarViewControllerDelegate>
///存放图片
@property (nonatomic, strong) NSMutableArray* imageArray;
@property (nonatomic, assign) NSInteger inOrOut;
@property (nonatomic, strong) NSArray* titleArray;
@property (nonatomic, strong) NSArray* titleValueArray;
@property (nonatomic, strong) NSArray* titleValueArray1;
@property (nonatomic, strong) NSString* deliveryOldtime;
@property (nonatomic, copy) NSString* outShopDeliveryOldtime;

@property (nonatomic, strong) NSString* strComm; ////备注
@property (nonatomic, strong) NSMutableArray* tilelabertitletowData; /////第2区的数据
@property (nonatomic, strong) NSMutableArray* ownDeliveryData; ////上门自提
@property (nonatomic, strong) NSMutableArray* sectionTowArry;
@property (nonatomic, strong) GYcellModel* cellmodel;
@property (nonatomic, strong) NSMutableArray* modelArry;
@property (nonatomic, strong) NSMutableArray* modelArry2;
@property (nonatomic, strong) NSString* pesoneNume; ////人数
@property (nonatomic, assign) CGFloat JB; ////金币
@property (nonatomic, strong) NSString* basepreAmount; ///存放定金金额
@property (nonatomic, strong) UIDatePicker* datePicker;
@property (nonatomic, strong) NSDate* date;
@property (nonatomic, strong) NSMutableArray* timeresultSince2;
@property (nonatomic, strong) NSMutableArray* timeresultShop2;
@property (nonatomic, strong) NSString* addres;
@property (nonatomic, assign) int nowdatemark;
@property (nonatomic, assign) int nowtimemark;
@property (strong, nonatomic) IBOutlet UIView* pickTimeView;
@property (weak, nonatomic) IBOutlet UIPickerView* pickerView;
@property (weak, nonatomic) IBOutlet UIButton* pickCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton* pickConfirmBtn;
@property (strong, nonatomic) NSMutableDictionary* timeresultShopDict;
@property (strong, nonatomic) NSMutableDictionary* timeresultSinceDict;
@property (strong, nonatomic) NSMutableArray* timeDataSource;
@property (strong, nonatomic) NSMutableArray* dateDataSource;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* pickTimeViewVerticalConstraint;
@property (weak, nonatomic) IBOutlet UIView* pickBView;
@property (copy, nonatomic) NSString* selectedTime;
//国际化

@property (weak, nonatomic) IBOutlet UILabel* selectTimeLabel; //选择时间
@property (nonatomic, copy) NSString* selecPeoper;
@property (nonatomic, copy) NSString* mobile;
@property (nonatomic, copy) NSString* outShopMobile;
@property (nonatomic, copy) NSString* peopleNum;
@property (nonatomic, copy) NSString* realMoney;

@end

@implementation GYConfirmationViewController

/**
 *
 *跳转页面
 */
- (void)pushVC:(id)vc animated:(BOOL)ani
{

    [self.navigationController pushViewController:vc animated:ani];
}

/////页面初始化
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.requestButton.enabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.pickCancelBtn setTitle:kLocalized(@"GYHE_Food_Cancel") forState:UIControlStateNormal];
    [self.pickConfirmBtn setTitle:kLocalized(@"GYHE_Food_Confirm") forState:UIControlStateNormal];
    self.selectTimeLabel.text = kLocalized(@"GYHE_Food_PleaseSelectTime");

    //免预付定金不需要显示
    if ([self.orderConfirModel.moneyEarnest doubleValue] > 0) {
        self.realMoney = self.orderConfirModel.moneyEarnest;
        self.baseViewMoney.text = [GYUtils formatCurrencyStyle:[self.orderConfirModel.moneyEarnest doubleValue]];
        self.baseViewMoney.hidden = NO;
        self.baseViewLabel.text = kLocalized(@"GYHE_Food_PrepaidDepositBusiness");
        self.baseViewJBImage.hidden = NO;
    } else {
        self.baseViewMoney.text = @"0.00";
        self.baseViewMoney.hidden = YES;
        self.baseViewLabel.text = kLocalized(@"GYHE_Food_BusinessFreeDeposit");
        self.baseViewLabel.hidden = YES;
        self.baseViewJBImage.hidden = YES;
    }

    _timeresultSince2 = [NSMutableArray array];
    _timeresultShop2 = [NSMutableArray array];
    self.title = kLocalized(@"GYHE_Food_OrderFood");
    [self.requestButton setTitle:kLocalized(@"GYHE_Food_ConfirmOrderFood") forState:UIControlStateNormal];
    _tilelabertitletowData = [NSMutableArray array];
    _modelArry = [NSMutableArray array];
    _modelArry2 = [NSMutableArray array];
    _ownDeliveryData = [NSMutableArray array];
    _nowtimemark = 0;
    _nowdatemark = 0;
    [self initData];
    [self getNetData];
}

////判断 时间 是否为空 为空不能下单
- (void)upDateBtuttonBackView:(NSInteger)inorout
{
    if (inorout == inShop) {
        if (!self.orderConfirModel.timeresultShop2.count > 0) {
            [self.requestButton setBackgroundColor:[UIColor grayColor]];
            self.requestButton.userInteractionEnabled = NO;
        } else {
            [self.requestButton setBackgroundColor:kNavigationBarColor];
            self.requestButton.userInteractionEnabled = YES;
        }
    } else {
        if (!self.orderConfirModel.timeresultSince2.count > 0) {
            [self.requestButton setBackgroundColor:[UIColor grayColor]];
            self.requestButton.userInteractionEnabled = NO;
        } else {
            [self.requestButton setBackgroundColor:kNavigationBarColor];
            self.requestButton.userInteractionEnabled = YES;
        }
    }
}

- (void)initData
{
    _inOrOut = inShop;
    if (self.orderConfirModel.supportAppointment == NO) {
        _inOrOut = outShop;
    }
    [self upDateBtuttonBackView:_inOrOut];
    _deliveryOldtime = kLocalized(@"GYHE_Food_SelectEatTime");
    _outShopDeliveryOldtime = kLocalized(@"GYHE_Food_SelectTakeTime");
    _imageArray = [NSMutableArray arrayWithObjects:@"gyhe_food_choosed", @"gyhe_food_notchoose", nil];
    _sectionTowArry = [NSMutableArray arrayWithObjects:kLocalized(@"GYHE_Food_EatInStore"), kLocalized(@"GYHE_Food_TakeFromStore"), nil];
    _tilelabertitletowData = [NSMutableArray arrayWithObjects:kLocalized(@"GYHE_Food_NumberOfEatingPeople"), kLocalized(@"GYHE_Food_AppointTime"), kLocalized(@"GYHE_Food_PhoneNumber"), kLocalized(@"GYHE_Food_Remark"), nil];
    _ownDeliveryData = [NSMutableArray arrayWithObjects:kLocalized(@"GYHE_Food_TakeTimeOneSelf"), kLocalized(@"GYHE_Food_PhoneNumber"), kLocalized(@"GYHE_Food_Remark"), nil];
    _titleValueArray = [NSMutableArray arrayWithObjects:kLocalized(@"GYHE_Food_SelectTakeTime"), kLocalized(@"GYHE_Food_PleaseInputPhoneNumber"), kLocalized(@"GYHE_Food_AddRemark"), nil];
    _titleValueArray1 = [NSMutableArray arrayWithObjects:kLocalized(@"GYHE_Food_InputPeopleNumber"), kLocalized(@"GYHE_Food_SelectEatTime"), kLocalized(@"GYHE_Food_PleaseInputPhoneNumber"), kLocalized(@"GYHE_Food_AddRemark"), nil];
    for (int i = 0; i < _tilelabertitletowData.count; i++) {
        GYcellModel* model = [[GYcellModel alloc] init];
        model.titleString = _tilelabertitletowData[i];
        model.valueString = _titleValueArray1[i];
        [_modelArry addObject:model];
    }

    for (int j = 0; j < 3; j++) {
        GYcellModel* model = [[GYcellModel alloc] init];
        model.titleString = _ownDeliveryData[j];
        model.valueString = _titleValueArray[j];
        [_modelArry2 addObject:model];
    }
}

- (void)getTime
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    for (NSString* s in self.orderConfirModel.timeresultShop2) {
        NSDate* d = [dateFormatter dateFromString:s];
        [_timeresultShop2 addObject:d];
    }

    for (NSString* s in self.orderConfirModel.timeresultSince2) {
        NSDate* d = [dateFormatter dateFromString:s];
        [_timeresultSince2 addObject:d];
    }
}

- (void)mypicker
{
    _pickerBgView = ({
        UIView* bgv = [[UIView alloc] initWithFrame:({
            CGRect frame = CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight);
            frame;
        })];
        bgv.alpha = 0;
        bgv.hidden = YES;
        bgv;
    });

    UIView* tilteView = [[UIView alloc] initWithFrame:({
        CGRect frmae = CGRectMake(0, kScreenHeight - 162 - 64 - cellH, kScreenWidth, cellH);
        frmae;
    })];
    tilteView.backgroundColor = kCorlorFromRGBA(220, 221, 221, 1);
    [_pickerBgView addSubview:tilteView];

    UIButton* cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, 0, cellH + 10, cellH);
    [cancel setTitle:kLocalized(@"GYHE_Food_Cancel") forState:UIControlStateNormal];
    [cancel setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(clickpicke:) forControlEvents:UIControlEventTouchUpInside];
    cancel.tag = 2;
    cancel.backgroundColor = kClearColor;

    UILabel* titlelabel = [[UILabel alloc] initWithFrame:({
        CGRect frame = CGRectMake((kScreenWidth - cellH * 3) / 2, 0, cellH * 3, cellH);
        frame;
    })];
    titlelabel.text = kLocalized(@"GYHE_Food_PleaseSelectTime");
    titlelabel.textColor = kCorlorFromRGBA(160, 160, 160, 1);
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.backgroundColor = [UIColor clearColor];
    UIButton* okbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okbtn.frame = CGRectMake(kScreenWidth - cellH - 10, 0, cellH + 10, cellH);
    [okbtn setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [okbtn setTitle:kLocalized(@"GYHE_Food_MakeSure") forState:UIControlStateNormal];
    [okbtn addTarget:self action:@selector(clickpicke:) forControlEvents:UIControlEventTouchUpInside];
    okbtn.backgroundColor = kClearColor;
    okbtn.tag = 3;
    [tilteView addSubview:cancel];
    [tilteView addSubview:titlelabel];
    [tilteView addSubview:okbtn];

    /////**********************这里是pickerview ****************/////

    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kScreenHeight - 162 - 64, kScreenWidth, kScreenHeight - (tilteView.frame.origin.y + tilteView.bounds.size.height + cellH))];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    NSDate* minDate = nil;
    NSDate* maxDate = nil;

    NSString* comparTimeStr = self.orderConfirModel.timeresultSince2.firstObject;
    comparTimeStr = [comparTimeStr substringFromIndex:13];

    if (_inOrOut == outShop) {
        NSString* minDateStr = self.orderConfirModel.timeresultSince2.lastObject;
        NSString* maxDateStr = self.orderConfirModel.timeresultSince2.firstObject;
        minDate = [dateFormatter dateFromString:minDateStr];
        maxDate = [dateFormatter dateFromString:maxDateStr];
    } else if (_inOrOut == inShop) {
        NSString* minDateStr = self.orderConfirModel.timeresultShop2.lastObject;
        NSString* maxDateStr = self.orderConfirModel.timeresultShop2.firstObject;
        minDate = [dateFormatter dateFromString:minDateStr];
        maxDate = [dateFormatter dateFromString:maxDateStr];
    }
    if (minDate == nil || maxDate == nil) {
        _datePicker.minimumDate = [NSDate date];
        _datePicker.maximumDate = [NSDate date];
        minDate = [NSDate date];
    } else {
        _datePicker.minimumDate = minDate;
        _datePicker.maximumDate = maxDate;
    }
    _datePicker.minuteInterval = 20;
    _datePicker.backgroundColor = [UIColor whiteColor];
    [_datePicker setDate:minDate animated:YES];
    _date = minDate;
    [_datePicker addTarget:self action:@selector(timeChange) forControlEvents:UIControlEventValueChanged];

    [_pickerBgView addSubview:_datePicker];
    [self.view addSubview:_pickerBgView];
}

- (void)timeChange
{
    if ([_datePicker.date laterDate:_datePicker.minimumDate] && [_datePicker.date earlierDate:_datePicker.minimumDate]) {
        _date = _datePicker.date;
    } else {
        _datePicker.date = _date;
        return;
    }
}

- (void)clickpicke:(UIButton*)sender
{
    switch (sender.tag) {
    case 2: ////取消
    {
        ////判端 old 时间是否有值 是否跟 原来的 一样
        [UIView animateWithDuration:0.3
                         animations:^{
                             _pickerBgView.alpha = 0.4;
                             _pickerBgView.alpha = 1;
                             _pickerBgView.hidden = YES;
                             _pickerBgView.backgroundColor = kCorlorFromRGBA(50, 50, 50, 0.4);
                             _pickerBgView.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight - 64);
                         }
                         completion:nil];
    } break;
    case 3: ////确定
    {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        _inOrOut == inShop ? (_deliveryOldtime = _selectedTime) : (_outShopDeliveryOldtime = _selectedTime);
        GYcellModel* model = [[GYcellModel alloc] init];
        if (_inOrOut == inShop) {
            model.titleString = [self.orderConfirModel.moneyEarnest floatValue] > 0 ? _tilelabertitletowData[2] : _tilelabertitletowData[1];
            model.valueString = _deliveryOldtime;
            [_modelArry replaceObjectAtIndex:[self.orderConfirModel.moneyEarnest floatValue] > 0 ? 2 : 1 withObject:model];
        } else {
            model.titleString = _ownDeliveryData[0];
            model.valueString = _outShopDeliveryOldtime;
            [_modelArry2 replaceObjectAtIndex:0 withObject:model];
        }
        [UIView animateWithDuration:0.3
                         animations:^{
                             _pickerBgView.alpha = 0.4;
                             _pickerBgView.alpha = 1;
                             _pickerBgView.hidden = YES;
                             _pickerBgView.backgroundColor = kCorlorFromRGBA(50, 50, 50, 0.4);
                             _pickerBgView.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight - 64);
                         }
                         completion:nil];
        [self.myTableView reloadData];
    } break;
    default:
        break;
    }
}

- (void)getAddressModle:(GYAddressModel*)model
{
    _addmodel = [[AddrModel alloc] init];
    _addmodel.consignee = model.receiver;
    _addmodel.addrID = model.area;
    _addmodel.mobile = model.mobile;
    _addmodel.PostCode = model.postCode;
    self.selecPeoper = model.mobile;
    [_myTableView reloadData];
}

- (BOOL)verifyView
{
    BOOL alBool = YES;
    NSString* string;
    if ([GYUtils isBlankString:_pesoneNume] && _inOrOut == inShop) {
        string = kLocalized(@"GYHE_Food_InputPeopleNumber");
        alBool = NO;
    } else if (![GYUtils isBlankString:_pesoneNume] && _inOrOut == inShop && _pesoneNume.integerValue < 1) {
        string = kLocalized(@"GYHE_Food_EatingNumberLimited");
        alBool = NO;
    } else if (_inOrOut == inShop ? ([GYUtils isIncludeChineseInString:_deliveryOldtime]) : ([GYUtils isIncludeChineseInString:_outShopDeliveryOldtime])) {
        string = kLocalized(@"GYHE_Food_PleaseSelectTime");
        alBool = NO;
    } else if (_inOrOut == 1 ? [GYUtils isBlankString:self.mobile] : [GYUtils isBlankString:self.outShopMobile]) {
        string = kLocalized(@"GYHE_Food_PleaseInputPhoneNumber");
        alBool = NO;
    } else if (_inOrOut == 1 ? (self.mobile.length < 7 || self.mobile.length > 20) : (self.outShopMobile.length < 7 || self.outShopMobile.length > 20)) {
        string = kLocalized(@"GYHE_Food_PhoneNumberFormatError");
        alBool = NO;
    }

    BOOL isout = [GYUtils isIncludeChineseInString:_outShopDeliveryOldtime];
    DDLogDebug(@"%d", isout);

    if (_inOrOut == inShop ? _deliveryOldtime : _outShopDeliveryOldtime) {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate* date2 = [dateFormatter dateFromString:_inOrOut == inShop ? _deliveryOldtime : _outShopDeliveryOldtime];
        NSDate* nowdate = [NSDate date];
        ////更当前时间进行一个比较
        if ([nowdate compare:date2] == NSOrderedDescending) {
            string = kLocalized(@"GYHE_Food_SingleTimeCannotLessCurrentTime");
            alBool = NO;
        }
    }
    if (alBool == NO) {
        [GYUtils showMessage:string];
    }
    return alBool;
}

- (IBAction)confirmButton:(UIButton*)sender
{
    if ([self verifyView] == YES) {

        [sender controlTimeOut];
        [self requestOrder];
    }
}

#pragma mark 确认订单提交  接口
- (void)requestOrder
{

    [self.view endEditing:YES];
    kCheckLogined;
    self.requestButton.enabled = NO;

    NSMutableDictionary* json = [NSMutableDictionary dictionary];
    [json setValue:globalData.loginModel.token forKey:@"userKey"];
    if (self.orderConfirModel.supportAppointment == NO) {
        [json setValue:@(outShop) forKey:@"type"];
    } else {
        [json setValue:@(self.inOrOut) forKey:@"type"];
    }
    [json setValue:self.orderConfirModel.vShopId forKey:@"vShopId"];
    CGFloat totalAmount = roundf([self.orderConfirModel.totalAmount floatValue] * 10);
    totalAmount = totalAmount * 0.1;
    [json setValue:[NSString stringWithFormat:@"%0.2f", totalAmount] forKey:@"totalAmount"];
    [json setValue:self.orderConfirModel.totalPv forKey:@"totalPv"];
    GYcellModel* ml = [[GYcellModel alloc] init];
    if (self.inOrOut == inShop) {
        [json setValue:(_inOrOut == inShop ? self.deliveryOldtime : self.outShopDeliveryOldtime) forKey:@"useDate"];
        ml = self.modelArry[3];
        if ([ml.valueString isEqualToString:kLocalized(@"GYHE_Food_AddRemark")]) {
            ml.valueString = @"";
        }

        [json setValue:ml.valueString forKey:@"remark"];
        CGFloat totalAmount = roundf([self.realMoney doubleValue] * 10);
        totalAmount = totalAmount * 0.1;
        [json setValue:[NSString stringWithFormat:@"%0.2f", totalAmount] forKey:@"preAmount"];
    } else {
        [json setValue:(_inOrOut == inShop ? self.deliveryOldtime : self.outShopDeliveryOldtime) forKey:@"useDate"];
        ml = self.modelArry2[2];
        if ([ml.valueString isEqualToString:kLocalized(@"GYHE_Food_AddRemark")]) {
            ml.valueString = @"";
        }
        [json setValue:ml.valueString forKey:@"remark"];
        [json setValue:@"" forKey:@"preAmount"];
    }
    [json setValue:self.orderConfirModel.shopId forKey:@"shopId"];
    [json setValue:(_inOrOut == inShop ? self.mobile : self.outShopMobile) forKey:@"tel"];

    for (NSInteger i = 0; i < self.modelArry.count; i++) {
        ml = self.modelArry[i];
        DDLogDebug(@"%@", ml.valueString);
    }

    for (NSInteger i = 0; i < self.modelArry2.count; i++) {
        ml = self.modelArry2[i];
        DDLogDebug(@"%@", ml.valueString);
    }

    [json setValue:@"3" forKey:@"payment"];
    [json setValue:self.orderConfirModel.foodArr forKey:@"foodList"];
    [json setValue:@"0" forKey:@"isBill"];

    [json setValue:@"000" forKey:@"currency"];
    json[@"IsCardCustomer"] = globalData.loginModel.cardHolder ? @"1" : @"0";
    [json setValue:@"" forKey:@"amountLogistic"];
    NSMutableArray* fa = [NSMutableArray array];

    for (int i = 0; i < self.orderConfirModel.foodArr.count; i++) {
        FDChoosedFoodModel* fcdmodel = self.orderConfirModel.foodArr[i];
        FDFoodFormatModel* format = fcdmodel.format;
        NSInteger cont = fcdmodel.count;
        FDFoodDetailModel* fdmodel = fcdmodel.food;
        NSString* foodId = fdmodel.foodId;
        NSMutableDictionary* fordic = [NSMutableDictionary dictionary];
        [fordic setObject:@(format.auction.floatValue) forKey:@"auction"];
        [fordic setObject:kSaftToNSString(format.pId) forKey:@"pId"];
        [fordic setObject:kSaftToNSString(format.pName) forKey:@"pName"];
        [fordic setObject:@(format.price.doubleValue) forKey:@"price"];

        [fordic setObject:format.pVId forKey:@"pVId"];
        [fordic setObject:kSaftToNSString(format.pVName) forKey:@"pVName"];

        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setObject:fordic forKey:@"stadand"];
        [dic setObject:@(cont) forKey:@"count"];
        [dic setObject:foodId forKey:@"foodId"];
        [dic setObject:fdmodel.pics forKey:@"pics"];
        [fa addObject:dic];
    }
    [json setValue:fa forKey:@"foodList"];
    [json setValue:self.pesoneNume forKey:@"personNum"];
    NSString* url = [NSString stringWithFormat:@"%@%@", globalData.foodConsmerDomain, @"/ph/food/confirmOrderFood"];

    @try {

        GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:url
                                                         parameters:json
                                                      requestMethod:GYNetRequestMethodPOST
                                                  requestSerializer:GYNetRequestSerializerJSON
                                                       respondBlock:^(NSDictionary* responseObject, NSError* error) {

                                                           if (error) {
                                                               if (!responseObject || responseObject[@"retCode"] == nil) {
                                                                   [GYUtils showMessage:kLocalized(@"GYHE_Food_Systemisbusypleaselater") confirm:nil];
                                                                   self.requestButton.enabled = YES;
                                                               } else {
                                                                   [GYUtils showMessage:kLocalized(@"GYHE_Food_NetWorkError")];
                                                               }
                                                               return;
                                                           }
                                                           if (self.inOrOut == inShop && [self.orderConfirModel.moneyEarnest floatValue] > 0) {
                                                               GYOrderDetailsViewController* vc = [[GYOrderDetailsViewController alloc] initWithNibName:NSStringFromClass([GYOrderDetailsViewController class]) bundle:nil];
                                                               vc.isComeOrder = YES;
                                                               vc.moderType = [NSString stringWithFormat:@"%ld", self.inOrOut];
                                                               vc.orderId = kSaftToNSString(responseObject[@"data"][@"orderId"]);
                                                               GYPayMentModel* mo = [[GYPayMentModel alloc] init];
                                                               mo.amount = kSaftToNSString(self.orderConfirModel.totalAmount);
                                                               mo.userKey = kSaftToNSString(globalData.loginModel.token);
                                                               mo.preAmount = kSaftToNSString(self.realMoney);
                                                               mo.orderId = kSaftToNSString(responseObject[@"data"][@"orderId"]);
                                                               mo.userId = globalData.loginModel.custId;
                                                               mo.custId = kSaftToNSString(globalData.loginModel.custId);
                                                               mo.currency = kSaftToNSString(globalData.custGlobalDataModel.currencyCode);
                                                               mo.retCode = kSaftToNSString(responseObject[@"data"]);
                                                               vc.pyModel = mo;
                                                               vc.mobile = _inOrOut == inShop ? self.mobile : self.outShopMobile;
                                                               [self pushVC:vc animated:YES];
                                                           } else {
                                                               GYRestaurantOrderViewController* restVc = [[GYRestaurantOrderViewController alloc] init];
                                                               restVc.strTyp = @"1";
                                                               [self pushVC:restVc animated:YES];
                                                           }
                                                       }];
        [request commonParams:[GYUtils netWorkCommonParams]];
        [request start];
    }
    @catch (NSException* exception) {
        [GYUtils showMessage:kLocalized(@"GYHE_Food_NetWorkError")];
    }
    @finally {
        self.requestButton.enabled = YES;
    }
}

/**
 *  给数字做四舍五入
 *
 *  @param number   需要处理的数字
 *  @param position 保留小数点第几位
 *
 *  @return 返回四舍五入后的字符串
 */
- (NSString*)roundUp:(NSString*)number afterPoint:(int)position
{

    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];

    NSDecimalNumber* ouncesDecimal = [NSDecimalNumber decimalNumberWithString:number];

    NSDecimalNumber* roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];

    return [NSString stringWithFormat:@"%@", roundedOunces];
}

#pragma mark - 从网络请求得到默认地址 getAddrData
- (void)getNetData
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:globalData.loginModel.token forKey:@"key"];
    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:GetDefaultDeliveryAddressUrl
                                                     parameters:dict
                                                  requestMethod:GYNetRequestMethodGET
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary* responseObject, NSError* error) {
                                                       [GYGIFHUD dismiss];
                                                       if (error) {
                                                           //网络请求错误
                                                           [GYUtils showToast:kLocalized(@"GYHE_Food_NetRequestError")];
                                                           self.addmodel = nil;
                                                           return;
                                                       }
                                                       if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                                                           self.addmodel = [[AddrModel alloc] init];
                                                           self.addmodel.mobile = responseObject[@"data"][@"mobile"];
                                                       }
                                                   }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

#pragma mark 时间picker View
- (void)clickttime
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         _pickerBgView.alpha = 0.4;
                         _pickerBgView.alpha = 1;
                         _pickerBgView.hidden = NO;
                         _pickerBgView.backgroundColor = kCorlorFromRGBA(50, 50, 50, 0.4);
                         _pickerBgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
                     }
                     completion:nil];
}

#pragma mark 各种代理方法
///备注
- (void)setValut:(NSString*)value
{
    _strComm = value;
    GYcellModel* model = [[GYcellModel alloc] init];
    if (_inOrOut == inShop) {
        model.titleString = _tilelabertitletowData[3];
        model.valueString = value;
        [_modelArry replaceObjectAtIndex:3 withObject:model];
    } else {
        model.titleString = _ownDeliveryData[2];
        model.valueString = value;
        [_modelArry2 replaceObjectAtIndex:2 withObject:model];
    }
    _pickerBgView.hidden = YES;
    [_myTableView reloadData];
}

////时间控件返回的数据
- (void)updateDate:(NSString*)value andDatemark:(int)datemark andTimemark:(int)timemark
{
    _inOrOut == inShop ? (_deliveryOldtime = value) : (_outShopDeliveryOldtime = value);
    _nowdatemark = datemark;
    _nowtimemark = timemark;
    GYcellModel* model = [[GYcellModel alloc] init];
    if (_inOrOut == inShop) {
        model.titleString = _tilelabertitletowData[1];
        model.valueString = value;
        [_modelArry replaceObjectAtIndex:1 withObject:model];
    } else {
        model.titleString = _ownDeliveryData[0];
        model.valueString = value;
        [_modelArry2 replaceObjectAtIndex:0 withObject:model];
    }
    _pickerBgView.hidden = YES;
    [_myTableView reloadData];
}

- (void)gYConfirmCellDelegateTextField:(NSString*)string andIndexPath:(NSIndexPath*)indexPath
{
    if ([GYUtils isBlankString:string]) {
        return;
    }
    [self.view resignFirstResponder];
    [self.view endEditing:YES];
    GYcellModel* model = [[GYcellModel alloc] init];
    if (indexPath.row == 0) {
        if (_tilelabertitletowData.count > indexPath.row) {
            model.titleString = _tilelabertitletowData[indexPath.row];
        }
        model.valueString = string;
        [_modelArry replaceObjectAtIndex:indexPath.row withObject:model];

        _pesoneNume = string;
    } else {
        if (_inOrOut == inShop) {
            if (_tilelabertitletowData.count > indexPath.row) {
                model.titleString = _tilelabertitletowData[indexPath.row];
            }
            model.valueString = string;
            [_modelArry replaceObjectAtIndex:indexPath.row withObject:model];
        } else {
            if (_ownDeliveryData.count > indexPath.row) {
                model.titleString = _ownDeliveryData[indexPath.row];
            }
            model.valueString = string;
            [_modelArry2 replaceObjectAtIndex:indexPath.row withObject:model];
        }
    }
    [_myTableView reloadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark tableView Deleget
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    [self.view endEditing:YES];

    if (section == 0) {
        return [self firstSectionNum];
    } else if (section == 1) {
        if (_inOrOut == 1) {
            return 4;
        } else {
            return 3;
        }
    } else if (section == 2) {
        return 1;
    }

    return 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellid = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    UILabel* lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    lb.text = kLocalized(@"GYHE_Food_PleaseInputPhoneNumber");
    lb.textAlignment = NSTextAlignmentCenter;
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:lb];

    if (indexPath.section == 0) {

        NSString* title = [self firstSectionName:indexPath];
        GYConfirmOrdersCell* cell = [GYConfirmOrdersCell cellWithTableView:tableView andtitleName:title andImageName:_imageArray[indexPath.row]];

        if (self.orderConfirModel.supportAppointment == NO || self.orderConfirModel.supportTake == NO) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        return cell;
    } else if (indexPath.section == 1) {

        if (([@"1" isEqualToString:[NSString stringWithFormat:@"%ld", (long)_inOrOut]] && (indexPath.row == 0 || indexPath.row == 2)) || (_inOrOut == outShop && indexPath.row == 1)) { ///店内 如果 需要订金就是row 小于2 否则就是小于1
            GYConfirmCell* cell = [GYConfirmCell cellWithTableView:tableView andindes:indexPath andtitleName:nil];

            if (_inOrOut == inShop) {
                if (indexPath.row == 0 && ![GYUtils isBlankString:self.peopleNum]) {
                    cell.cellTextFile.text = self.peopleNum;
                }
                if (indexPath.row == 2 && ![GYUtils isBlankString:self.mobile]) {
                    cell.cellTextFile.text = self.mobile;
                }
                if (_modelArry.count > indexPath.row) {
                    cell.model = _modelArry[indexPath.row];
                }
            } else {
                if (indexPath.row == 1 && ![GYUtils isBlankString:self.outShopMobile]) {
                    cell.cellTextFile.text = self.outShopMobile;
                }
                if (_modelArry2.count > indexPath.row) {
                    cell.model = _modelArry2[indexPath.row];
                }
            }

            cell.textFielDelegat = self;
            [cell.cellTextFile addTarget:self action:@selector(cellTextFile:) forControlEvents:UIControlEventEditingChanged];
            cell.cellTextFile.tag = indexPath.row;
            cell.indexPath = indexPath;

            return cell;
        } else {
            GYnormalCell* cell = [GYnormalCell cellWithTableView:tableView andindes:indexPath andtitleName:nil];

            if (_inOrOut == 1) {
                if (_modelArry.count > indexPath.row) {
                    cell.model = _modelArry[indexPath.row];
                }
            } else {
                if (_modelArry2.count > indexPath.row) {
                    cell.model = _modelArry2[indexPath.row];
                }
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

            return cell;
        }
    } else {
        NSString* priceStr = [self roundUp:self.orderConfirModel.totalAmount afterPoint:1];
        GYOrderTableViewCell* cell = [GYOrderTableViewCell cellWithTableView:tableView andtitleName:kLocalized(@"GYHE_Food_OrderFoodAmount") andValue:[NSString stringWithFormat:@"%0.2f", [priceStr floatValue]]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }

    return nil;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        if (!(self.orderConfirModel.supportTake == YES && self.orderConfirModel.supportAppointment == YES)) {
            return;
        } else {
            if (indexPath.row == 0) {
                _inOrOut = inShop;
                [self upDateBtuttonBackView:_inOrOut];
                _imageArray = [NSMutableArray arrayWithObjects:@"gyhe_food_choosed", @"gyhe_food_notchoose", nil];

                if ([self.orderConfirModel.moneyEarnest doubleValue] > 0) {
                    self.realMoney = self.orderConfirModel.moneyEarnest;
                    self.baseViewMoney.text = [GYUtils formatCurrencyStyle:[self.orderConfirModel.moneyEarnest doubleValue]];
                    self.baseViewMoney.hidden = NO;
                    self.baseViewLabel.text = kLocalized(@"GYHE_Food_PrepaidDepositBusiness");
                    self.baseViewJBImage.hidden = NO;
                } else {
                    self.baseViewMoney.text = @"0.00";
                    self.baseViewMoney.hidden = YES;
                    self.baseViewLabel.text = kLocalized(@"GYHE_Food_BusinessFreeDeposit");
                    self.baseViewLabel.hidden = YES;
                    self.baseViewJBImage.hidden = YES;
                }
            } else {
                _inOrOut = outShop;
                [self upDateBtuttonBackView:_inOrOut];
                _imageArray = [NSMutableArray arrayWithObjects:@"gyhe_food_notchoose", @"gyhe_food_choosed", nil];

                self.baseViewLabel.text = kLocalized(@"GYHE_Food_PaymentAmount");
                self.baseViewJBImage.hidden = NO;
                NSString* priceStr = [self roundUp:self.orderConfirModel.totalAmount afterPoint:1];
                self.baseViewMoney.text = [GYUtils formatCurrencyStyle:[[NSString stringWithFormat:@"%.2f", [priceStr doubleValue]] doubleValue]];
                self.baseViewMoney.hidden = NO;
                self.baseViewLabel.hidden = NO;

                if ([self.orderConfirModel.moneyEarnest doubleValue] > 0) {
                    self.baseViewLabel.hidden = NO;
                    self.baseViewMoney.hidden = NO;
                    self.baseViewJBImage.hidden = NO;
                } else {
                    self.baseViewLabel.hidden = YES;
                    self.baseViewMoney.hidden = YES;
                    self.baseViewJBImage.hidden = YES;
                }
            }
            [_myTableView reloadData];
        }
    } else if (indexPath.section == 1) {
        [self.view endEditing:YES];

        if ((indexPath.row == 1 && _inOrOut == inShop) || (indexPath.row == 0 && _inOrOut == outShop)) {
            if ((_inOrOut == inShop && self.orderConfirModel.timeresultShop2.count > 0) || (_inOrOut == outShop && self.orderConfirModel.timeresultSince2.count > 0)) {
                GYNewDataCalendarViewController* dataVC = [[GYNewDataCalendarViewController alloc] init];
                dataVC.dataTimes = _inOrOut == inShop ? self.orderConfirModel.timeresultShop2 : self.orderConfirModel.timeresultSince2;
                dataVC.dataTimesNoShop = _inOrOut == inShop ? self.orderConfirModel.timeresultShopNoShop : self.orderConfirModel.timeresultSinceNoShop;
                dataVC.gynewDataCalendarDelegate = self;
                dataVC.datemark = _nowdatemark;
                dataVC.timemark = _nowtimemark;
                [self pushVC:dataVC animated:YES];
            } else {
                [GYUtils showMessage:kLocalized(@"GYHE_Food_ConnectServerFailed") confirm:nil];
                return;
            }
        } else if ((indexPath.row == 3 && _inOrOut == inShop) || (indexPath.row == 2 && _inOrOut == outShop)) {
            GYCommentViewController* comm = [[GYCommentViewController alloc] init];
            comm.str = [_strComm isEqualToString:kLocalized(@"GYHE_Food_AddRemark")] == YES ? @"" : _strComm;
            _inOrOut == inShop ? (comm.strtype = YES) : (comm.strtype = NO);
            comm.gydelegate = self;
            [self pushVC:comm animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{

    return 45;
}

- (NSInteger)firstSectionNum
{
    NSInteger number = 2;
    if (self.orderConfirModel.supportTake && !self.orderConfirModel.supportAppointment) {
        number = 1;
    } else if (!self.orderConfirModel.supportTake && self.orderConfirModel.supportAppointment) {
        number = 1;
    } else if (self.orderConfirModel.supportAppointment && self.orderConfirModel.supportTake) {
        number = 2;
    } else {
        number = 1;
    }

    return number;
}

- (NSString*)firstSectionName:(NSIndexPath*)indexPath
{
    // 自提 && 不支持预约 -> 门店自提
    if (self.orderConfirModel.supportTake && !self.orderConfirModel.supportAppointment) {
        return _sectionTowArry[1];
    }
    // 不自提 && 支持预约 -> 店内就餐
    else if (!self.orderConfirModel.supportTake && self.orderConfirModel.supportAppointment) {
        return _sectionTowArry[0];
    }
    // 自提 && 支持预约 -> 门店自提 and 店内就餐
    else if (self.orderConfirModel.supportAppointment && self.orderConfirModel.supportTake) {
        return _sectionTowArry[indexPath.row];
    } else {
        return @"";
    }
}

- (void)showPickTimeView
{
}

- (IBAction)pickCancelBtnClicked:(id)sender
{
}

- (IBAction)pickConfirmBtnClicked:(id)sender
{
    _pickBView.hidden = YES;
    [UIView animateWithDuration:0.25
                     animations:^{
                         _pickTimeViewVerticalConstraint.constant = 49;
                         [self.view layoutIfNeeded];
                     }];

    NSInteger dateIndex = [_pickerView selectedRowInComponent:0];
    NSInteger timeIndex = [_pickerView selectedRowInComponent:1];
    NSString* sDate = _dateDataSource[dateIndex];
    NSString* sTime = _timeDataSource[timeIndex];
    _selectedTime = [NSString stringWithFormat:@"%@ %@", sDate, sTime];
    _inOrOut == inShop ? (_deliveryOldtime = _selectedTime) : (_outShopDeliveryOldtime = _selectedTime);
    GYcellModel* model = [[GYcellModel alloc] init];
    if (_inOrOut == inShop) {
        model.titleString = [self.orderConfirModel.moneyEarnest floatValue] > 0 ? _tilelabertitletowData[2] : _tilelabertitletowData[1];
        model.valueString = _deliveryOldtime;
        [_modelArry replaceObjectAtIndex:[self.orderConfirModel.moneyEarnest floatValue] > 0 ? 2 : 1 withObject:model];
    } else {
        model.titleString = _ownDeliveryData[0];
        model.valueString = _outShopDeliveryOldtime;
        [_modelArry2 replaceObjectAtIndex:0 withObject:model];
    }
    [self.myTableView reloadData];
}

- (void)setupPickTimeView
{
    _timeresultShopDict = [[NSMutableDictionary alloc] init];
    _timeresultSinceDict = [[NSMutableDictionary alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _timeresultShopDict = [self makeDictFromArray:self.orderConfirModel.timeresultShop2[0]];
        _timeresultSinceDict = [self makeDictFromArray:self.orderConfirModel.timeresultSince2[0]];
        [_pickerView reloadAllComponents];
    });
}

- (NSMutableDictionary*)makeDictFromArray:(NSArray*)array
{
    NSMutableArray* marr = [[NSMutableArray alloc] init];
    for (NSString* str in array) {
        NSArray* arr = [str componentsSeparatedByString:@" "];
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setObject:arr[1] forKey:arr[0]];
        [marr addObject:dict];
    }

    NSMutableDictionary* mdic = [[NSMutableDictionary alloc] init];

    mdic = [[NSMutableDictionary alloc] init];
    for (NSMutableDictionary* dict in marr) {
        NSString* key = dict.allKeys.firstObject;
        NSString* value = dict.allValues.firstObject;
        if (![mdic.allKeys containsObject:key]) {
            NSMutableArray* arr = [[NSMutableArray alloc] init];
            [arr addObject:value];
            [mdic setObject:arr forKey:key];
        } else {
            NSMutableArray* arr = mdic[key];
            [arr addObject:value];
        }
    }
    return mdic;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        if (_inOrOut == inShop) {
            _dateDataSource = [[_timeresultShopDict.allKeys sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
        } else {
            _dateDataSource = [[_timeresultSinceDict.allKeys sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
        }
        return _dateDataSource.count;
    } else {
        if (!_timeDataSource) {

            if (_inOrOut == inShop) {
                _timeDataSource = _timeresultShopDict[_dateDataSource.firstObject];
            } else {
                _timeDataSource = _timeresultSinceDict[_dateDataSource.firstObject];
            }
        }
        return _timeDataSource.count;
    }
}

- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return _dateDataSource[row];
    } else {
        return _timeDataSource[row];
    }
}

- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        if (_inOrOut == inShop) {
            NSString* selectDate = [_dateDataSource objectAtIndex:row];
            _timeDataSource = [_timeresultShopDict objectForKey:selectDate];
            [self.pickerView reloadComponent:1];
        } else {
            NSString* selectDate = [_dateDataSource objectAtIndex:row];
            _timeDataSource = [_timeresultSinceDict objectForKey:selectDate];
            [self.pickerView reloadComponent:1];
        }
    }
}

- (CGFloat)pickerView:(UIPickerView*)pickerView rowHeightForComponent:(NSInteger)component
{
    return 45.f;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)cellTextFile:(UITextField*)textField
{
    if ((_inOrOut == inShop && textField.tag == 0)) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:1];
        GYConfirmCell* cell = [self.myTableView cellForRowAtIndexPath:indexPath];
        cell.cellTextFile.text = textField.text;
        self.peopleNum = cell.cellTextFile.text;
    }

    if ((_inOrOut == inShop && textField.tag == 2) || (_inOrOut == outShop && textField.tag == 1)) {
        _inOrOut == inShop ? (self.mobile = textField.text) : (self.outShopMobile = textField.text);
        if (textField.text.length > 20) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:1];
            GYConfirmCell *cell = [self.myTableView cellForRowAtIndexPath:indexPath];
            cell.cellTextFile.text = [textField.text substringToIndex:20];
            _inOrOut == inShop ? (self.mobile = cell.cellTextFile.text) : (self.outShopMobile = cell.cellTextFile.text);
            [textField endEditing:YES];
            return;
        }
    }

}

@end
