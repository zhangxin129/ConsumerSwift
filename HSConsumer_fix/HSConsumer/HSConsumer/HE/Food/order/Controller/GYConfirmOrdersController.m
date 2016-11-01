//
//  GYConfirmOrdersController.m
//  HSConsumer
//
//  Created by appleliss on 15/9/21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
///ViewController
#import "GYConfirmOrdersController.h"
#import "GYAddressData.h"
#import "GYAppDelegate.h"
#import "GYCommentViewController.h"
#import "GYGetGoodViewController.h"
#import "GYRestaurantOrderViewController.h"

//////  view cell
#import "FDChoosedFoodModel.h"
#import "FDFoodFormatModel.h"
#import "FDFoodModel.h"
#import "GYAddresseeCell.h"
#import "GYDeliveryTableViewCell.h"
#import "GYMealTimeCell.h"
#import "GYgreensCell.h"
#import "UIButton+GYTimeOut.h"
#define imagew 15
#define imageh 5
#define labH 18
#define imageddddHH 15
#define baseViewH 35
#define cellH 40
#define clickimage 20
@interface GYConfirmOrdersController () <UIPickerViewDataSource, UIPickerViewDelegate, GYGetAddressDelegate> {

    NSString* addname; ////联系人
    NSString* addres;
    NSString* addiphone;
    //    NSMutableArray *hoursArr;
    //    NSArray *minutesArr;
    //    NSMutableArray *dayArr;/////存放的是天数
    NSString* deliverytime;
    NSString* deliveryOldtime;
    //    NSString *hours;////小时
    //    NSString *minutes;////分钟
    //    NSString *day;// 天
    BOOL type;
    NSMutableArray* tilelabertitletow;
    NSMutableArray* tilelabertielethree;
    NSMutableArray* clickImageNameArr; //// 选择图片 数组
    NSMutableArray* tilelabertitletowData; /////第2区的数据
    //    NSString *rangeDay;////日期范围
    NSString* strComm; ////备注
    BOOL offandno;

    NSString* isBill;
    NSString* ispayment; /////支付方式
    NSString* regCode;
    NSString* pesoneNume; ////人数
    CGFloat JB; ////金币
    NSString* lbpreAmount; ////预消费金额

    UILabel* baselabel; ///底部 金额
    NSMutableArray* timeArr;
    UIButton* btn;
    NSMutableArray* foodArray;
}
@end

@implementation GYConfirmOrdersController

- (void)pushVC:(id)vc animated:(BOOL)ani
{

    [self.navigationController pushViewController:vc animated:ani];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    btn.enabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    timeArr = [NSMutableArray array];
    NSMutableArray* array = [NSMutableArray array];

    [array addObjectsFromArray:self.orderConfirModel.timeresultTakeaway];
    NSString* currentTime = [GYUtils dateToString:[NSDate date] dateFormat:@"yyyy-MM-dd "];
    for (NSString* str in array) {
        if ([str hasPrefix:currentTime]) {
            NSString* str1 = [str substringFromIndex:11];
            [timeArr addObject:str1];
        }
    }
    if (timeArr.count == 0) {
        [timeArr addObject:@"0:00"];
    }

    deliveryOldtime = kLocalized(@"GYHE_Food_PleaseChooseDeliveryTime");
    deliverytime = deliveryOldtime;

    ispayment = @"4";
    [self getNetData];
    [self dataset];
    [self initView];
    lbpreAmount = [NSString string];
    [_orderstable registerNib:[UINib nibWithNibName:@"GYgreensCell" bundle:kDefaultBundle] forCellReuseIdentifier:@"GYgreensCellID"];
    [_orderstable registerNib:[UINib nibWithNibName:@"GYDeliveryTableViewCell" bundle:kDefaultBundle] forCellReuseIdentifier:@"GYDeliveryTableViewCellID"];
    foodArray = [NSMutableArray array];
    for (int i = 0; i < self.orderConfirModel.foodArr.count; i++) {
        FDChoosedFoodModel* fcdmodel = self.orderConfirModel.foodArr[i];
        FDFoodFormatModel* format = fcdmodel.format;
        NSInteger cont = fcdmodel.count;
        FDFoodDetailModel* fdmodel = fcdmodel.food;
        NSString* foodId = fdmodel.foodId;
        NSMutableDictionary* fordic = [NSMutableDictionary dictionary];
        [fordic setObject:@(format.auction.doubleValue) forKey:@"auction"];
        [fordic setObject:kSaftToNSString(format.pId) forKey:@"pId"];
        [fordic setObject:kSaftToNSString(format.pName) forKey:@"pName"];
        [fordic setObject:@(format.price.doubleValue) forKey:@"price"];
        [fordic setObject:format.pVId forKey:@"pVId"];
        [fordic setObject:kSaftToNSString(format.pName) forKey:@"pVName"];

        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setObject:fordic forKey:@"stadand"];
        [dic setObject:@(cont) forKey:@"count"];
        [dic setObject:foodId forKey:@"foodId"];
        [dic setObject:fdmodel.pics forKey:@"pics"];
        [dic setObject:fdmodel.name forKey:@"name"];
        [foodArray addObject:dic];
    }

    DDLogDebug(@"%@", foodArray);
}

/**
 *  json格式化字典
 *
 *  @param dict 字典
 *
 *  @return json
 */
- (NSString*)jsonWithDic:(NSMutableDictionary*)dict
{

    NSError* parseError = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString* str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@"\'"];
    return str;
}

- (void)setValut:(NSString*)value
{
    strComm = value;
    [tilelabertitletowData replaceObjectAtIndex:3 withObject:[GYUtils isBlankString:value] == YES ? kLocalized(@"GYHE_Food_AddRemark") : value];
    [_orderstable reloadData];
}

- (void)dataset
{
    type = NO;
    offandno = NO;
    strComm = kLocalized(@"GYHE_Food_AddRemark");
    isBill = @"0";
    clickImageNameArr = [NSMutableArray arrayWithObjects:@"gyhe_food_choosed", @"gyhe_food_notchoose", @"gyhe_food_notchoose", nil];
    self.title = kLocalized(@"GYHE_Food_OutOrder");
    tilelabertitletow = [NSMutableArray arrayWithObjects:kLocalized(@"GYHE_Food_DistributionTime"), kLocalized(@"GYHE_Food_Remark"), kLocalized(@"GYHE_Food_WriteInvoice"), nil];
}

- (void)initView
{
    _orderstable = ({
        UITableView* tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 100) style:UITableViewStyleGrouped];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.backgroundColor = kCorlorFromRGBA(239, 239, 239, 1);
        [tableview registerNib:[UINib nibWithNibName:@"GYAddresseeCell" bundle:nil] forCellReuseIdentifier:@"CELLTITLT"];
        tableview;
    });
    _orderstable.dataSource = self;
    _orderstable.delegate = self;
    [self.view addSubview:_orderstable];
    [self baseView];
    [self mypicker];
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

    _picker = ({
        UIPickerView* picker = [[UIPickerView alloc] initWithFrame:({
            CGRect fr = CGRectMake(0, kScreenHeight - 162 - 64, kScreenWidth, kScreenHeight - (tilteView.frame.origin.y + tilteView.bounds.size.height + cellH));
            fr;
        })];
        picker.backgroundColor = [UIColor whiteColor];
        picker.showsSelectionIndicator = YES;
        picker.dataSource = self;
        picker.delegate = self;
        [picker selectRow:0 inComponent:0 animated:YES];
        picker;
    });
    [_pickerBgView addSubview:_picker];
    [self.view addSubview:_pickerBgView];
}

- (void)dateChanged:(id)sender
{
    NSDate* select = [sender date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* dateAndTime = [dateFormatter stringFromDate:select];

    [GYUtils showMessage:dateAndTime confirm:nil];
}

/////获取当前时间

- (NSString*)nowDate:(NSString*)dateformater
{
    ////获取当前时间
    NSDate* nowtime = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateformater];
    NSString* nowhours = [dateFormatter stringFromDate:nowtime];
    return nowhours;
}

///底部
- (void)baseView
{
    _baseview = [[UIView alloc] initWithFrame:CGRectMake(0, _orderstable.bounds.size.height, kScreenWidth, baseViewH)];
    _baseview.backgroundColor = [UIColor whiteColor];

    UILabel* title = [[UILabel alloc] initWithFrame:({
        CGRect frame = CGRectMake(imagew, 0, 90, baseViewH);
        frame;
    })];
    title.text = kLocalized(@"GYHE_Food_OrderAmount");
    title.backgroundColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:14];
    title.textAlignment = NSTextAlignmentLeft;
    [title setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

    UIImage* image = [UIImage imageNamed:@"gyhe_food_coin"];
    UIImageView* imageview = [[UIImageView alloc] initWithFrame:({
        CGRect fr = CGRectMake(title.frame.size.width, 2, labH, labH);
        fr;
    })];
    imageview.image = image;
    [imageview setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

    baselabel = [[UILabel alloc] initWithFrame:({
        CGRect fr = CGRectMake(imageview.frame.origin.x + imageview.frame.size.width + 6, 0, 100, labH);
        fr;
    })];

    baselabel.text = [NSString stringWithFormat:@"%0.2f", [self.orderConfirModel.totalAmount doubleValue] + [self.orderConfirModel.sendPrice doubleValue]];
    baselabel.font = [UIFont systemFontOfSize:15];
    baselabel.textColor = kNavigationBarColor;
    [baselabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

    [_baseview addSubview:title];
    [_baseview addSubview:imageview];

    UIImage* pvimage = [UIImage imageNamed:@"gyhe_about_pv_image"];
    UIImageView* pvimageview = [[UIImageView alloc] initWithFrame:({
        CGRect fr = CGRectMake(imageview.frame.origin.x, imageview.frame.origin.y + imageview.bounds.size.height + 2, labH - 3, imagew);
        fr;
    })];
    pvimageview.image = pvimage;
    pvimageview.hidden = type;
    [pvimageview setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

    UILabel* pvnumlabel = [[UILabel alloc] initWithFrame:({
        CGRect fr = CGRectMake(baselabel.frame.origin.x + 4, pvimageview.frame.origin.y - 2, 100, labH - 3);
        fr;
    })];

    pvnumlabel.text = [NSString stringWithFormat:@"%0.2f", [self.orderConfirModel.totalPv doubleValue]];
    pvnumlabel.font = [UIFont systemFontOfSize:14];

    pvnumlabel.textColor = [UIColor colorWithRed:21 / 255.0 green:124 / 255.0 blue:209 / 255.0 alpha:1.0];
    pvnumlabel.numberOfLines = 0;
    [pvnumlabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    pvnumlabel.hidden = type;

    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kScreenWidth - 80, 0, 80, _baseview.frame.size.height + 2);
    [btn addTarget:self action:@selector(clickt:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:kLocalized(@"GYHE_Food_ConfirmOrderFood") forState:UIControlStateNormal];
    btn.tag = 3; /////跳转页面
    btn.backgroundColor = kNavigationBarColor;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [_baseview addSubview:pvnumlabel];
    [_baseview addSubview:pvimageview];
    [_baseview addSubview:baselabel];
    [_baseview addSubview:btn];
    [_baseview setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
    [self.view addSubview:_baseview];
    [_baseview setFrame:CGRectMake(0, _orderstable.bounds.size.height, kScreenWidth, baseViewH)];
}

#pragma mark 确定订单 按钮  cell 里面选择按钮
- (void)clickt:(UIButton*)sender
{
    [self.view endEditing:YES];

    switch (sender.tag) {
    case 0: {
        clickImageNameArr = [NSMutableArray arrayWithObjects:@"gyhe_food_choosed", @"gyhe_food_notchoose", @"gyhe_food_notchoose", nil];
        ispayment = @"4";
        break;
    }
    case 1: {
        clickImageNameArr = [NSMutableArray arrayWithObjects:@"gyhe_food_notchoose", @"gyhe_food_choosed", @"gyhe_food_notchoose", nil];
        if ([self.orderConfirModel.type isEqualToString:@"1"]) {
            ispayment = @"4";
        } else {
            ispayment = @"3";
        }
        break;
    }
    case 2: {
        clickImageNameArr = [NSMutableArray arrayWithObjects:@"gyhe_food_notchoose", @"gyhe_food_notchoose", @"gyhe_food_choosed", nil];
        ispayment = @"0";
        break;
    }
    case 3: /////确认订单
    {
        [self.view endEditing:YES];
        if ([self verifyView] == YES) {

            [sender controlTimeOut];
            [self requestOrder];
        } else {
        }

    } break;
    default:
        break;
    }
    [_orderstable reloadData];
}

- (BOOL)verifyView
{
    BOOL alBool = YES;
    NSString* string;
    if ([GYUtils isBlankString:deliveryOldtime] || [deliveryOldtime isEqualToString:kLocalized(@"GYHE_Food_PleaseChooseDeliveryTime")]) {
        string = kLocalized(@"GYHE_Food_PleaseSelectTime");
        alBool = NO;
    } else if ([GYUtils isBlankString:self.addmodel.mobile]) {
        string = kLocalized(@"GYHE_Food_PleaseSelectAddress");
        alBool = NO;
    }
    if (deliveryOldtime) {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate* date2 = [dateFormatter dateFromString:deliveryOldtime];
        NSDate* nowdate = [NSDate date];
        ////更当前时间进行一个比较
        if ([nowdate compare:date2] == NSOrderedDescending) {
            string = kLocalized(@"GYHE_Food_SingleTimeCannotLessCurrentTime");
            alBool = NO;
        }
    }
    if (alBool == NO) {
        [GYUtils showMessage:string confirm:nil];
    }
    return alBool;
}

#pragma mark 确认订单提交  接口
- (void)requestOrder
{

    btn.enabled = NO;
    NSMutableDictionary* json = [NSMutableDictionary dictionary];
    [json setValue:globalData.loginModel.token forKey:@"userKey"];
    [json setValue:addres forKey:@"addr"];
    [json setValue:@([self.orderConfirModel.type integerValue]) forKey:@"type"];
    [json setValue:self.orderConfirModel.vShopId forKey:@"vShopId"];
    [json setValue:[NSString stringWithFormat:@"%0.2f", [self.orderConfirModel.totalAmount doubleValue]] forKey:@"totalAmount"];
    [json setValue:self.orderConfirModel.totalPv forKey:@"totalPv"];
    [json setValue:self.orderConfirModel.shopId forKey:@"shopId"];

    [json setValue:0 forKey:@"isPayOnDelivery"];
    if ([deliveryOldtime isEqualToString:kLocalized(@"GYHE_Food_ImmediateDelivery")]) {
        NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString* courrentDate = [dateformatter stringFromDate:[NSDate date]];
        [json setValue:courrentDate forKey:@"useDate"];
    } else {
        [json setValue:deliveryOldtime forKey:@"useDate"];
    }
    [json setValue:self.orderConfirModel.shopId forKey:@"shopId"];

    if ([strComm isEqualToString:kLocalized(@"GYHE_Food_AddRemark")]) {
        strComm = @"";
    }

    [json setValue:strComm forKey:@"remark"];
    [json setValue:isBill forKey:@"isBill"];
    [json setValue:self.addmodel.mobile forKey:@"tel"];
    [json setValue:self.addmodel.consignee forKey:@"contactor"];
    [json setValue:@"1" forKey:@"isPayOnDelivery"];
    [json setValue:@"0" forKey:@"payment"];

    [json setValue:self.orderConfirModel.foodArr forKey:@"foodList"];
    [json setValue:self.orderConfirModel.sendPrice forKey:@"amountLogistic"];
    [json setValue:@"000" forKey:@"currency"];
    json[@"IsCardCustomer"] = globalData.loginModel.cardHolder ? @"1" : @"0";
    NSMutableArray* fa = [NSMutableArray array];
    for (int i = 0; i < self.orderConfirModel.foodArr.count; i++) {
        FDChoosedFoodModel* fcdmodel = self.orderConfirModel.foodArr[i];
        FDFoodFormatModel* format = fcdmodel.format;
        NSInteger cont = fcdmodel.count;
        FDFoodDetailModel* fdmodel = fcdmodel.food;
        NSString* foodId = fdmodel.foodId;

        NSMutableDictionary* fordic = [NSMutableDictionary dictionary];
        [fordic setObject:@(format.auction.doubleValue) forKey:@"auction"];
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
    [json setValue:pesoneNume forKey:@"personNum"];

    DDLogDebug(@"%@", json);
    DDLogDebug(@"%@", FoodConfirmOrderFoodUrl);
    @try {
        GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:FoodConfirmOrderFoodUrl
                                                         parameters:json
                                                      requestMethod:GYNetRequestMethodPOST
                                                  requestSerializer:GYNetRequestSerializerJSON
                                                       respondBlock:^(NSDictionary* responseObject, NSError* error) {
                                                           if (error) {
                                                               WS(weakSelf)
                                                                   [GYUtils showMessage:kLocalized(@"GYHE_Food_OrderFailed")
                                                                                confirm:^{
                                                                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                                }];
                                                               return;
                                                           }

                                                           btn.enabled = NO;

                                                           GYRestaurantOrderViewController* vc = [[GYRestaurantOrderViewController alloc] init];
                                                           vc.strTyp = self.orderConfirModel.type;
                                                           [self pushVC:vc animated:YES];
                                                       }];
        [request commonParams:[GYUtils netWorkCommonParams]];
        [request start];
    }
    @catch (NSException* exception) {

        WS(weakSelf)
            [GYUtils showMessage:kLocalized(@"GYHE_Food_NetWorkError")
                         confirm:^{
                             [weakSelf.navigationController popViewControllerAnimated:YES];
                         }];
    }
    @finally {
    }
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

- (void)clickpicke:(UIButton*)sender
{
    switch (sender.tag) {
    case 2: ////取消
    {
        deliveryOldtime = deliverytime;
        if (![deliveryOldtime isEqualToString:kLocalized(@"GYHE_Food_PleaseChooseDeliveryTime")]) {
            [self settingTime];
        }
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
        if ([deliveryOldtime isEqualToString:kLocalized(@"GYHE_Food_PleaseChooseDeliveryTime")] && timeArr.count > 0) {
            deliveryOldtime = timeArr[0];
        }

        [self settingTime];
        deliverytime = deliveryOldtime;

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
        [_orderstable reloadData];

    } break;
    default:
        break;
    }
}

- (void)settingTime
{
    NSString* deliveryDatetime = [GYUtils dateToString:[NSDate date] dateFormat:@"yyyy-MM-dd "];
    NSRange range = [deliveryOldtime rangeOfString:deliveryDatetime];
    if (!(range.location == NSNotFound)) {
        deliveryOldtime = [deliveryOldtime substringFromIndex:11];
    }
    deliveryOldtime = [deliveryDatetime stringByAppendingString:deliveryOldtime];
    [tilelabertitletowData replaceObjectAtIndex:2 withObject:deliveryOldtime];
}

////switch
- (void)swithc:(UISwitch*)sender
{
    if (sender.isOn) {
        isBill = @"1";
    } else {
        isBill = @"0";
    }
}

#pragma mark 回调函数
- (void)getAddressModle:(GYAddressModel*)model
{
    _addmodel = [[AddrModel alloc] init];
    _addmodel.area = model.area;
    _addmodel.consignee = model.receiver;
    _addmodel.addrID = model.area;
    _addmodel.mobile = model.mobile;
    _addmodel.detail = model.address;

    GYProvinceModel* provinceModel = [[GYAddressData shareInstance] queryProvinceNo:model.provinceNo];
    GYCityAddressModel* cityModel = [[GYAddressData shareInstance] queryCityNo:model.cityNo];

    _addmodel.province = provinceModel.provinceName;
    _addmodel.city = cityModel.cityName;

    addres = [NSString stringWithFormat:@"%@%@%@%@", model.province, model.city, model.area, model.detail];
    [_orderstable reloadData];
}

#pragma mark - 从网络请求得到默认地址 getAddrData
- (void)getNetData
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:globalData.loginModel.token forKey:@"key"];

    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:GetDefaultDeliveryAddressUrl
                                                     parameters:dict
                                                  requestMethod:GYNetRequestMethodGET
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary* responseObject, NSError* error) {
                                                       if (error) {
                                                           if (responseObject == nil || responseObject[@"retCode"] == nil) {
                                                               [GYUtils showMessage:kLocalized(@"GYHE_Food_Systemisbusypleaselater") confirm:nil];
                                                           } else {
                                                               [GYUtils parseNetWork:error resultBlock:nil];
                                                               self.addmodel = nil;
                                                               [_orderstable reloadData];
                                                           }
                                                           return;
                                                       }
                                                       if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                                                           self.addmodel = [[AddrModel alloc] init];
                                                           self.addmodel.province = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"province"]];
                                                           self.addmodel.city = kSaftToNSString(responseObject[@"data"][@"city"]);
                                                           self.addmodel.area = kSaftToNSString(responseObject[@"data"][@"area"]);
                                                           self.addmodel.detail = kSaftToNSString(responseObject[@"data"][@"detail"]);
                                                           self.addmodel.beDefault = kSaftToNSString(responseObject[@"data"][@"beDefault"]);
                                                           self.addmodel.consignee = kSaftToNSString(responseObject[@"data"][@"consignee"]);
                                                           self.addmodel.mobile = kSaftToNSString(responseObject[@"data"][@"mobile"]);
                                                           self.addmodel.addrID = kSaftToNSString(responseObject[@"data"][@"id"]);
                                                           addres = [NSString stringWithFormat:@"%@%@%@%@", kSaftToNSString(self.addmodel.province), kSaftToNSString(self.addmodel.city),
                                                                              kSaftToNSString(self.addmodel.area),
                                                                              kSaftToNSString(self.addmodel.detail)];
                                                       } else {
                                                           self.addmodel = nil;
                                                       }

                                                       [_orderstable reloadData];
                                                   }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

#pragma mark tableview deleget
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
        return 1;
    else if (section == 2) {
        return tilelabertitletow.count;
    } else {
        return foodArray.count + 1;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellreuseId"];
        /////如果没有默认地址  显示的VIew
        if (self.addmodel == nil) {
            UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 100) / 2, (cell.bounds.size.height - 30) - 2, 100, 30)];
            lab.font = [UIFont systemFontOfSize:15];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.backgroundColor = [UIColor clearColor];
            lab.text = kLocalized(@"GYHE_Food_PleaseSelectAddress");
            [cell.contentView addSubview:lab];

            UIImageView* imageview = [[UIImageView alloc] initWithFrame:({
                CGRect fr;
                fr = CGRectMake((kScreenWidth - 20), (cell.bounds.size.height - 15) / 2, 10, 15);
                fr;
            })];
            imageview.image = [UIImage imageNamed:@"gycommon_cell_btn_right"];
            [cell.contentView addSubview:imageview];
            return cell;
        } else {
            [cell.contentView addSubview:[self sectionone:self.addmodel.consignee andiphone:self.addmodel.mobile andaddress:addres]]; ////订餐
            return cell;
        }
    } else if (indexPath.section == 1) {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIden"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = kLocalized(@"GYHE_Food_PaymentMethods");
        cell.detailTextLabel.text = kLocalized(@"GYHE_Food_ArriveAndPay");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 2) {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if (indexPath.row == 2) {
            _isSwitch = ({
                UISwitch* sw = [[UISwitch alloc] initWithFrame:({
                    CGRect fr = CGRectMake(kScreenWidth - 65, 6, 50, imageddddHH);
                    fr;
                })];
                sw.backgroundColor = [UIColor clearColor];
                if ([isBill isEqualToString:@"0"]) {
                    sw.on = NO;
                } else {
                    sw.on = YES;
                }
                sw.onTintColor = kNavigationBarColor;
                [sw addTarget:self action:@selector(swithc:) forControlEvents:UIControlEventValueChanged];
                sw;
            });
            [cell.contentView addSubview:_isSwitch];
        }
        [cell.contentView addSubview:[self sectiontwo:indexPath]];
        return cell;
    } else if (indexPath.section == 3) {
        static NSString* orderID = @"GYgreensCellID";
        GYgreensCell* cell = [tableView dequeueReusableCellWithIdentifier:orderID];

        if (cell == nil) {
            cell = [[GYgreensCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderID];
        }
        NSUInteger rowCount = [self.orderstable numberOfRowsInSection:3];
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        if (indexPath.row == rowCount - 1) { ////配送费
            GYDeliveryTableViewCell* deliveryCell = [tableView dequeueReusableCellWithIdentifier:@"GYDeliveryTableViewCellID" forIndexPath:indexPath];
            deliveryCell.labDeliveryTitle.text = kLocalized(@"GYHE_Food_SendPrice");
            deliveryCell.labDeliveryMoney.text = [NSString stringWithFormat:@"%0.2f", [_orderConfirModel.sendPrice doubleValue]];
//            deliveryCell.labEvent.text = [self.orderConfirModel.offPrice isEqualToString:@""] ? @"" : [NSString stringWithFormat:@"(满%@减%@元配送费)", self.orderConfirModel.fullPrice, self.orderConfirModel.offPrice];
            deliveryCell.labEvent.text = self.orderConfirModel.fullOffDesc;
            deliveryCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return deliveryCell;
        } else {
            if (foodArray.count > indexPath.row) {
                dic = foodArray[indexPath.row];
            }
            NSMutableDictionary* formatdic = dic[@"stadand"];
            NSString* name = nil;
            if (![GYUtils isBlankString:formatdic[@"pVName"]]) {
                name = [NSString stringWithFormat:@"%@(%@)", dic[@"name"], formatdic[@"pVName"]];
            } else {
                name = dic[@"name"];
            }
            cell.lbGreensName.text = name;
            cell.lbGreensPirce.text = [NSString stringWithFormat:@"%0.2f", [formatdic[@"price"] doubleValue]];
            cell.lbGreensPVPrice.text = [NSString stringWithFormat:@"%0.2f", [formatdic[@"auction"] doubleValue]];
            cell.greensNum.text = [dic[@"count"] stringValue];
            cell.X.hidden = NO;
            cell.lbGreensName.hidden = NO;
            cell.greensNum.hidden = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        GYGetGoodViewController* vc = [[GYGetGoodViewController alloc] init];
        vc.deletage = self;
        vc.isFood = YES;
        [self pushVC:vc animated:YES];
    }

    if (indexPath.section == 2 && indexPath.row == 0 && timeArr.count > 0) {
        [self clickttime];
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        GYCommentViewController* comm = [[GYCommentViewController alloc] init];
        comm.str = [strComm isEqualToString:kLocalized(@"GYHE_Food_AddRemark")] == YES ? @"" : strComm;
        comm.strtype = NO;
        comm.gydelegate = self;
        [self pushVC:comm animated:YES];
    }
    if (indexPath.section == 2 && indexPath.row == 2) {
        if (offandno == YES) {
            offandno = NO;
        } else
            offandno = YES;
        [_orderstable reloadData];
    }
}

#pragma mark 设置分区的高度
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 18; //section头部高度
}

//section底部间距
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        return 45 + [self getStringRect_:addres].height + 2;
    } else
        return 40;
}

#pragma mark 第一个分区的布局
- (UIView*)sectionone:(NSString*)model andiphone:(NSString*)iphone andaddress:(NSString*)address
{

    UIView* cell = [[UIView alloc] init];
    ////整个cellui 布局在这里
    UILabel* contactlabel = [[UILabel alloc] initWithFrame:({
        CGRect fr;
        fr = CGRectMake(imagew, imagew, 200, labH);
        fr;
    })];
    [contactlabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    contactlabel.text = [NSString stringWithFormat:@"%@  %@ ", kLocalized(@"GYHE_Food_Telephone"), iphone];
    contactlabel.font = [UIFont boldSystemFontOfSize:16];
    contactlabel.backgroundColor = [UIColor clearColor];
    contactlabel.textColor = kCorlorFromRGBA(70, 70, 70, 1);
    ///电话
    UILabel* phonenum = [[UILabel alloc] initWithFrame:({
        CGRect fr;
        fr = CGRectMake(kScreenWidth / 2 - 10, imagew, 120, labH);
        fr;
    })];
    phonenum.textAlignment = NSTextAlignmentRight;
    phonenum.font = [UIFont boldSystemFontOfSize:16];
    phonenum.text = iphone;
    phonenum.backgroundColor = [UIColor clearColor];
    phonenum.textColor = kCorlorFromRGBA(70, 70, 70, 1);
    [phonenum setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

    UILabel* lbaddress = [[UILabel alloc] initWithFrame:({
        CGRect fr = CGRectMake(imagew, CGRectGetHeight(contactlabel.frame) + CGRectGetMinY(contactlabel.frame), kScreenWidth - 80, [self getStringRect_:address].height);
        fr;
    })];
    lbaddress.hidden = NO;

    lbaddress.backgroundColor = [UIColor clearColor];
    lbaddress.numberOfLines = 0;

    lbaddress.text = [GYUtils checkStringInvalid:address] ? kLocalized(@"GYHE_Food_AddressPrefixs") : [NSString stringWithFormat:@"%@  %@", kLocalized(@"GYHE_Food_AddressPrefixs"), kSaftToNSString(address)];
    lbaddress.textColor = kCorlorFromRGBA(160, 160, 160, 1);
    lbaddress.font = [UIFont systemFontOfSize:12];
    [lbaddress setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

    UIImageView* imageview = [[UIImageView alloc] initWithFrame:({
        CGRect fr;
        fr = CGRectMake(CGRectGetWidth(phonenum.frame) + CGRectGetMinX(phonenum.frame) + 5, CGRectGetHeight(phonenum.frame) + CGRectGetMinY(phonenum.frame), 10, imageddddHH);
        fr;
    })];
    imageview.image = [UIImage imageNamed:@"gycommon_cell_btn_right"];
    [imageview setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

    UIImageView* lintimage = [[UIImageView alloc] initWithFrame:({
        CGRect frame = lbaddress.frame;
        DDLogDebug(@"%f", CGRectGetHeight(frame));
        CGFloat Y = CGRectGetHeight(frame);
        if (CGRectGetHeight(frame) < 0.001) {
            Y = 15;
        }
        CGRect fr = CGRectMake(0, CGRectGetMinY(frame) + Y + 10, kScreenWidth, 2);
        fr;
    })];
    lintimage.image = [UIImage imageNamed:@"gyhe_food_colorbar"];
    [lintimage setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

    [cell addSubview:contactlabel];
    [cell addSubview:lbaddress];
    [cell addSubview:lintimage];
    return cell;
}

#pragma mark 封装好的第二个区的cell
- (UIView*)cellview:(NSString*)string andlabel:(NSString*)labstr andimageName:(NSString*)imagename
{
    UIView* view = [[UIView alloc] init];
    UILabel* label = [[UILabel alloc] initWithFrame:({
        CGRect fr = CGRectMake(imageddddHH, imageddddHH - 5, 60, 20);
        fr;
    })];
    label.text = string;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = kCorlorFromRGBA(70, 70, 70, 1);
    if (imagename == nil) {
        _timelabel = [[UILabel alloc] initWithFrame:({
            CGRect fr = CGRectMake(imageddddHH + label.bounds.size.width, imageddddHH - 5, kScreenWidth - (imageddddHH * 2 + label.bounds.size.width), 20);
            fr;
        })];
    } else {
        _timelabel = [[UILabel alloc] initWithFrame:({
            CGRect fr = CGRectMake(imageddddHH + label.bounds.size.width + imageddddHH - 10, imageddddHH - 5, kScreenWidth - (imageddddHH * 2 + label.bounds.size.width + 30), 20);
            fr;
        })];
    }

    _timelabel.textColor = kCorlorFromRGBA(160, 160, 160, 1);
    _timelabel.textAlignment = NSTextAlignmentRight;
    _timelabel.text = labstr;
    _timelabel.backgroundColor = [UIColor clearColor];
    UIImageView* imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imagename]];
    if ([imagename isEqualToString:@"fd_off"]) {
        imageview.frame = CGRectMake(_timelabel.frame.origin.x + _timelabel.frame.size.width - 3 - 10, imageddddHH - 3, 30, imageddddHH);
    } else {
        imageview.frame = CGRectMake(_timelabel.frame.origin.x + _timelabel.frame.size.width - 3 + 20, imageddddHH - 3, 8, imageddddHH);
    }
    [view addSubview:_timelabel];
    [view addSubview:label];
    [view addSubview:imageview];
    return view;
}

#pragma mark 封装第三个区的cell
/////封装第三个区的cell
- (UIView*)cellview:(NSString*)string andimagename:(NSArray*)imagename andindex:(NSIndexPath*)indexPath
{
    UIView* view = [[UIView alloc] init];
    UILabel* title = [[UILabel alloc] initWithFrame:({
        CGRect fr = CGRectMake(imageddddHH, imageddddHH - 5, kScreenWidth / 2 - 50, imageddddHH);
        fr;
    })];
    title.text = string;
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = kCorlorFromRGBA(70, 70, 70, 1);
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:({
        CGRect fr = CGRectMake(kScreenWidth - imageddddHH * 2 - imageddddHH, (cellH - clickimage) / 2, clickimage, clickimage);
        fr;
    })];
    imageView.image = [UIImage imageNamed:[imagename objectAtIndex:indexPath.row]];
    [view addSubview:imageView];

    [view addSubview:title];
    return view;
}

#pragma mark 第三个分区
- (UIView*)sectiontwo:(NSIndexPath*)indexPath
{
    NSString* imagename = @"gycommon_cell_btn_right";
    UIView* cellview = [[UIView alloc] init];
    switch (indexPath.row) {
    case 0:
        cellview = [self cellview:[tilelabertitletow objectAtIndex:indexPath.row] andlabel:deliveryOldtime andimageName:imagename];
        break;
    case 1:
        cellview = [self cellview:[tilelabertitletow objectAtIndex:indexPath.row] andlabel:strComm andimageName:imagename];
        break;
    case 2:
        cellview = [self cellview:[tilelabertitletow objectAtIndex:indexPath.row] andlabel:nil andimageName:nil];
        break;
    default:
        break;
    }
    return cellview;
}

////计算字体高度
- (CGSize)getStringRect_:(NSString*)aString
{
    CGSize size;
    UIFont* nameFont = [UIFont systemFontOfSize:12];
    if ([aString isEqualToString:@""]) {
        return size;
    } else {
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary* attributes = @{
            NSFontAttributeName : nameFont,
            NSParagraphStyleAttributeName : paragraphStyle
        };
        size = [aString boundingRectWithSize:CGSizeMake(kScreenWidth - 80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    }
    return size;
}

#pragma mark picker delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return timeArr.count;
}

- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [timeArr objectAtIndex:row];
}

// 返回选中的行
- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    deliveryOldtime = [timeArr objectAtIndex:row] == nil ? deliveryOldtime : [timeArr objectAtIndex:row];
}

///宽度
- (CGFloat)pickerView:(UIPickerView*)pickerView widthForComponent:(NSInteger)component
{
    return kScreenWidth;
}

///高度
- (CGFloat)pickerView:(UIPickerView*)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];

}

@end