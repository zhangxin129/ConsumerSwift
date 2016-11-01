//
//  GYGetGoodViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kGYHSGetGoodsCellTag 600

#import "GYHSGetGoodViewController.h"
//#import "GYAddressModel.h"
#import "GYHSGetGoodsCell.h"
#import "ViewTipBkgView.h"
//#import "GYAddressHeightModel.h"
#import "ViewTipBkgView.h"
#import "NSString+YYAdd.h"
#import "GYHSAddAddressViewController.h"
#import "GYHSTools.h"
#import "GYHSCreateAddressViewController.h"
#import "GYAddressListModel.h"
#import "GYAddressListHeightModel.h"

@interface GYHSGetGoodViewController ()<GYNetRequestDelegate,GYHSAddAddressViewControllerDelegate>
{
    NSIndexPath* oldIndex;
    UIButton* btnTemp;
//    GYAddressModel* globalAddressMod;
//    GYAddressModel* pushAddressMod;
    GYAddressListModel *globalAddressMod;
    ViewTipBkgView* viewTipBkg;
}

@property (nonatomic, weak) UITableView* tableView;


@end

@implementation GYHSGetGoodViewController

#pragma mark - 系统方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = kLocalized(@"地址管理");

    _marrDataSoure = [NSMutableArray array];
    UIButton* btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 0, 80, 40);
    btnRight.backgroundColor = [UIColor clearColor];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:15];//不做字体宏定义
    [btnRight addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];


    [btnRight setTitle:kLocalized(@"新增地址") forState:UIControlStateNormal];
    btnRight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = rightItem;

    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    self.tableView.backgroundColor = kDefaultVCBackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GYGetGoodCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self loadDataFromNetwork];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:kReceiveGoodsLocationChanged object:nil];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [self.tableView setEditing:NO];
}

#pragma mark - 自定义方法
- (void)refreshData {

    if (_marrDataSoure.count > 0) {
        [_marrDataSoure removeAllObjects];
        [self.tableView reloadData];
    }
    [self loadDataFromNetwork];
}

#pragma mark - 编辑
-(void)editorBtnClick:(UIButton *)sender {
    
//    GYAddressModel* model = self.marrDataSoure[sender.superview.superview.tag - kGYHSGetGoodsCellTag];
    
    
//    GYAddressListModel* model = self.marrDataSoure[sender.superview.superview.tag - kGYHSGetGoodsCellTag];
//    globalAddressMod = model;
//    GYHSAddAddressViewController* vcAddAddressModify = [[GYHSAddAddressViewController alloc] init];
//    vcAddAddressModify.delegate = self;
//    vcAddAddressModify.isFood = self.isFood;
//    vcAddAddressModify.boolstr = YES;
//    vcAddAddressModify.addrId = model.addrId;
//    vcAddAddressModify.model = model;
//    [self.navigationController pushViewController:vcAddAddressModify animated:YES];
}

#pragma mark - 删除点击
-(void)deleteBtnClick:(UIButton *)sender {

    WS(weakSelf)
    [GYUtils showMessge:kLocalized(@"GYHS_Address_Confirm_Delete_Shipping_Address") confirm:^{
        [weakSelf deleteAddress:sender];
    } cancleBlock:^{
    }];
}

#pragma mark - 删除
-(void)deleteAddress:(UIButton *)sender {

    GYAddressModel* model = self.marrDataSoure[sender.superview.superview.tag - kGYHSGetGoodsCellTag];
    if (self.isFood) {
        NSDictionary* dict = @{ @"id" : kSaftToNSString(model.idString),
                                @"key" : kSaftToNSString(globalData.loginModel.token) };
        GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:EasyBuyDeleteDeliveryAddressUrl parameters:dict requestMethod:GYNetRequestMethodDELETE requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
            [GYGIFHUD dismiss];
            if(error) {
                [GYUtils parseNetWork:error resultBlock:nil];
            }else {
                WS(weakSelf)
                [GYUtils showMessage:kLocalized(@"GYHS_Address_TheAddressWasRemovedSuccessfully")  confirm:^{
                    [weakSelf refreshData];
                }];
            }
        }];
        [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        [GYGIFHUD show];
        [request start];
    }else {
        NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
                                @"addrId" : kSaftToNSString(model.addrId) };
        
        GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kUrlDeleteAddress parameters:dict requestMethod:GYNetRequestMethodDELETE requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
            [GYGIFHUD dismiss];
            if(error) {
                [GYUtils parseNetWork:error resultBlock:nil];
            }else {
                WS(weakSelf)
                [GYUtils showMessage:kLocalized(@"GYHS_Address_TheAddressWasRemovedSuccessfully")  confirm:^{
                    [weakSelf refreshData];
                }];
            }
        }];
        [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        [GYGIFHUD show];
        [request start];
    }
}

#pragma mark - 设置默认地址
-(void)defaultBtnClick:(UIButton *)sender {

    GYAddressModel* model = self.marrDataSoure[sender.superview.superview.tag - kGYHSGetGoodsCellTag];
    if (self.isFood) {
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        [dict setValue:kSaftToNSString(globalData.loginModel.token) forKey:@"key"];
        [dict setValue:kSaftToNSString(model.province) forKey:@"province"];
        [dict setValue:@"" forKey:@"provinceNo"];
        [dict setValue:kSaftToNSString(model.city) forKey:@"city"];
        [dict setValue:@"" forKey:@"cityNo"];
        [dict setValue:kSaftToNSString( model.area ) forKey:@"area"];
        [dict setValue:kSaftToNSString(model.detail) forKey:@"detail"];
        [dict setValue:@"" forKey:@"receiverName"];
        [dict setValue:kSaftToNSString(model.mobile) forKey:@"phone"];
        [dict setValue:sender.selected == YES ? @"0" : @"1" forKey:@"isDefault"];//此处相反
        [dict setValue:@"" forKey:@"postcode"];
        [dict setValue:@"" forKey:@"fixedTelephone"];
        [dict setValue:kSaftToNSString(model.idString) forKey:@"id"];
        
        GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:EasyBuyUpdateDeliveryAddressUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
            [GYGIFHUD dismiss];
            if(error) {
                [GYUtils parseNetWork:error resultBlock:nil];
            }else {
                [GYUtils showToast:kLocalized(@"GYHS_Address_Save_Success")];
                [self refreshData];
            }
        }];
        [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        [GYGIFHUD show];
        [request start];
    }else {
        NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
                                @"addrId" : kSaftToNSString(model.addrId),
                                @"receiver" : kSaftToNSString(model.receiver),
                                @"isDefault" : sender.selected == YES ? @"0" : @"1",//此处相反
                                @"mobile" : kSaftToNSString(model.mobile),
                                @"phone" : kSaftToNSString(model.telphone),
                                @"postCode" : kSaftToNSString(model.postCode),
                                @"address" : kSaftToNSString(model.address),
                                @"area" : kSaftToNSString(@""),
                                @"cityNo" : model.cityNo ,
                                @"provinceNo" : model.provinceNo,
                                @"countryNo" : kSaftToNSString(globalData.localInfoModel.countryNo) };
        
        GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kUrlUpdateAddress parameters:dict requestMethod:GYNetRequestMethodPUT requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
            [GYGIFHUD dismiss];
            if(error) {
                [GYUtils parseNetWork:error resultBlock:nil];
            }else {
                [GYUtils showToast:kLocalized(@"GYHS_Address_Setting_Default_Address_Success")];
                [self refreshData];
                
            }
        }];
        [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        [GYGIFHUD show];
        [request start];
    }
}

#pragma mark 获取收货地址
- (void)loadDataFromNetwork {
    if (self.isFood) {

        GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuyGetDeliveryAddressUrl parameters:@{ @"key" : kSaftToNSString(globalData.loginModel.token) } requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
        request.tag = 800;
        [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        [GYGIFHUD show];
        [request start];
        
    }
    else {
//        GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlAddressList parameters:@{ @"custId" : kSaftToNSString(globalData.loginModel.custId) } requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
//        request.tag = 700;
//        [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
//        [GYGIFHUD show];
//        [request start];
        
        NSDictionary *parameter = @{@"token":globalData.loginModel.token,
                                    @"custId":globalData.loginModel.custId,
                                    @"resNo":globalData.loginModel.resNo,
                                    @"channelType":@"2"
                                    };
        [GYGIFHUD show];//@"http://192.168.229.17:8085/addressManagementController/findAhippingAddress"
        GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kFindAhippingAddressUrl parameters:parameter requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
            [GYGIFHUD dismiss];
            if (error) {
                [GYUtils parseNetWork:error resultBlock:nil];
                return ;
            }
            
            if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *temDic in responseObject[@"data"]) {
                    GYAddressListModel *model = [[GYAddressListModel alloc] dataWithDic:temDic isFood:self.isFood];
                    [_marrDataSoure addObject:model];
                }
                
                self.tableView.tableFooterView.hidden = YES;
                self.tableView.backgroundView.hidden = YES;
                [self.tableView reloadData];
                
            } else {
                self.tableView.backgroundView.hidden = YES;
                self.tableView.tableFooterView.hidden = NO;
                self.tableView.backgroundView.hidden = NO;
                if (_marrDataSoure.count == 0) {
                    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                    self.tableView.backgroundView = background;
                    
                    ViewTipBkgView *tipView = [[ViewTipBkgView alloc] init];
                    CGRect frame = tipView.frame;
                    frame = background.frame;
                    tipView.frame = frame;
                    [tipView.lbTip setText:kLocalized(@"GYHS_Address_YouNotYetShippingAddressInformationToImproveAtOnce")];
                    [background addSubview:tipView];
                }
            }
        }];
        [request start];
    }
}


- (void)addAddress {
    
//    GYHSAddAddressViewController *addVC = [[GYHSAddAddressViewController alloc] init];
//    addVC.delegate = self;
//    addVC.boolstr = NO; //修改收货地址传 “1”
//    addVC.isFood = self.isFood;
//    [self.navigationController pushViewController:addVC animated:YES];
    
    GYHSCreateAddressViewController *VC = [[GYHSCreateAddressViewController alloc] init];
    VC.isFood = self.isFood;
    VC.boolstr = NO;
    [self.navigationController pushViewController:VC animated:YES];
    
}


#pragma mark - GYHSAddAddressViewControllerDelegate
-(void)refreshGoodList {

    [self refreshData];
}

#pragma mark － DataSourceDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableVie {

    return self.marrDataSoure.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    
//    GYAddressModel* model = nil;
    
    GYAddressListModel* model = nil;
    if (_marrDataSoure.count > indexPath.row) {
        model = _marrDataSoure[indexPath.section];
    }
    return model.heightModel.cellHeight;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    GYHSGetGoodsCell* cell = [[GYHSGetGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHSGetGoodsCellIdentifier];
    cell.isFood = self.isFood;
    if (_marrDataSoure.count > indexPath.row) {
        cell.model = self.marrDataSoure[indexPath.section];
    }
    cell.tag = kGYHSGetGoodsCellTag + indexPath.section;
    [cell.editorBtn addTarget:self action:@selector(editorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.defaultBtn addTarget:self action:@selector(defaultBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}



- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {

    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.1;
}

#pragma mark tableview didSelect 代理方法
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    GYAddressModel* model = nil;
    
//    GYAddressListModel* model = nil;
//    if (_marrDataSoure.count > indexPath.row) {
//        model = _marrDataSoure[indexPath.section];
//    }
//    globalAddressMod = model;
//
//    if (_deletage && [_deletage respondsToSelector:@selector(getAddressModle:)]) {
//        [_deletage getAddressModle:model];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    else {
//
//        GYHSAddAddressViewController *addVC = [[GYHSAddAddressViewController alloc] init];
//        addVC.delegate = self;
//        addVC.boolstr = YES; //修改收货地址传 “1”
//        addVC.addrId = model.addrId;
//        addVC.isFood = self.isFood;
//        addVC.model = model;
//        [self.navigationController pushViewController:addVC animated:YES];
//    }
}

//代理方法，用于接受 从cell传过来的button
- (void)senderBtn:(id)sender WithCellModel:(id)mod {
    
//    globalAddressMod = mod;
//    btnTemp = sender;
//    globalAddressMod = (GYAddressModel*)mod;
//
//    for (int i = 0; i < self.marrDataSoure.count; i++) {
//        GYAddressModel* model = _marrDataSoure[i];
//        model.isDefault = @"0";
//        if (model == globalAddressMod) {
//            model.isDefault = @"1";
//        }
//    }
//
//    if (_deletage && [_deletage respondsToSelector:@selector(getAddressModle:)]) {
//        [_deletage getAddressModle:mod];
//    }
//
//    [self.tableView reloadData];
}


#pragma mark- GYNetRequestDelegate 
-(void)netRequest:(GYNetRequest *)request didSuccessWithData:(NSDictionary *)responseObject {

    [GYGIFHUD dismiss];
    if(request.tag == 800) {
        if ([responseObject[@"retCode"] isEqualToNumber:@200] && [responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *temDic in responseObject[@"data"]) {
                GYAddressModel *model = [[GYAddressModel alloc] dataWithDic:temDic isFood:self.isFood];
                [_marrDataSoure addObject:model];
            }
            
            if (_marrDataSoure.count == 0 || _marrDataSoure == nil) {
                UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                self.tableView.backgroundView = background;
                ViewTipBkgView *tipView = [[ViewTipBkgView alloc] init];
                [tipView.lbTip setText:kLocalized(@"GYHS_Address_You_Not_Yet_Shipping_Address_Information_Improve_Once")];
                tipView.frame = background.frame;
                [background addSubview:tipView];
                self.tableView.tableFooterView.hidden = YES;
                self.tableView.backgroundView.hidden = NO;
                
            } else {
                
                self.tableView.tableFooterView.hidden = YES;
                self.tableView.backgroundView.hidden = YES;
                
            }
            [self.tableView reloadData];
            
        } else {
            self.tableView.backgroundView.hidden = YES;
            self.tableView.tableFooterView.hidden = NO;
            self.tableView.backgroundView.hidden = NO;
            if (_marrDataSoure.count == 0) {
                UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                self.tableView.backgroundView = background;
                ViewTipBkgView *tipView = [[ViewTipBkgView alloc] init];
                CGRect frame = tipView.frame;
                frame = background.frame;
                tipView.frame = frame;
                [tipView.lbTip setText:kLocalized(@"GYHS_Address_YouNotYetShippingAddressInformationToImproveAtOnce")];
                [background addSubview:tipView];
            }
        }
    }else if(request.tag == 700) {
        if ([responseObject[@"retCode"] isEqualToNumber:@200] && [responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *temDic in responseObject[@"data"]) {
                GYAddressModel *model = [[GYAddressModel alloc] dataWithDic:temDic isFood:self.isFood];
                [_marrDataSoure addObject:model];
            }
            
            self.tableView.tableFooterView.hidden = YES;
            self.tableView.backgroundView.hidden = YES;
            [self.tableView reloadData];
            
        } else {
            self.tableView.backgroundView.hidden = YES;
            self.tableView.tableFooterView.hidden = NO;
            self.tableView.backgroundView.hidden = NO;
            if (_marrDataSoure.count == 0) {
                UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                self.tableView.backgroundView = background;
                
                ViewTipBkgView *tipView = [[ViewTipBkgView alloc] init];
                CGRect frame = tipView.frame;
                frame = background.frame;
                tipView.frame = frame;
                [tipView.lbTip setText:kLocalized(@"GYHS_Address_YouNotYetShippingAddressInformationToImproveAtOnce")];
                [background addSubview:tipView];
            }
        }

    }
}

-(void)netRequest:(GYNetRequest *)request didFailureWithError:(NSError *)error {

    [GYGIFHUD dismiss];
    [GYUtils parseNetWork:error resultBlock:nil];
}
@end
