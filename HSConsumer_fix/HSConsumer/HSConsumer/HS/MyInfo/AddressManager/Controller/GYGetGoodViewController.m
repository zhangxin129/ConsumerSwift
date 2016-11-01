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

#import "GYGetGoodViewController.h"
#import "GYAddressModel.h"
#import "GYAddAddressSroViewController.h"
#import "GYGetGoodCell.h"
#import "ViewTipBkgView.h"
#import "GYAddressHeightModel.h"
#import "ViewTipBkgView.h"
#import "NSString+YYAdd.h"


@interface GYGetGoodViewController ()<GYNetRequestDelegate>
{
    NSIndexPath* oldIndex;
    UIButton* btnTemp;
    GYAddressModel* globalAddressMod;
    GYAddressModel* pushAddressMod;
    ViewTipBkgView* viewTipBkg;
}

@property (nonatomic, weak) UITableView* tableView;

@end

@implementation GYGetGoodViewController

#pragma mark - 系统方法
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = kLocalized(@"GYHS_Address_Select_Getgood_Address");

    _marrDataSoure = [NSMutableArray array];
    UIButton* btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(20, 0, 44, 44);
    btnRight.backgroundColor = [UIColor clearColor];
    btnRight.titleLabel.font = [UIFont boldSystemFontOfSize:25.0];
    [btnRight addTarget:self action:@selector(ToAddAddress) forControlEvents:UIControlEventTouchUpInside];

    [btnRight setImage:[UIImage imageNamed:@"gyhs_address_add"] forState:UIControlStateNormal];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.tableView setEditing:NO];
}

#pragma mark - 自定义方法
- (void)refreshData
{

    if (_marrDataSoure.count > 0) {
        [_marrDataSoure removeAllObjects];
        [self.tableView reloadData];
    }
    [self loadDataFromNetwork];
}

#pragma mark 获取收货地址
- (void)loadDataFromNetwork
{
    if (self.isFood) {

        GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuyGetDeliveryAddressUrl parameters:@{ @"key" : kSaftToNSString(globalData.loginModel.token) } requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
        request.tag = 800;
        [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        [GYGIFHUD show];
        [request start];
        
    }
    else {

        
        GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlAddressList parameters:@{ @"custId" : kSaftToNSString(globalData.loginModel.custId) } requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
        request.tag = 700;
        [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        [GYGIFHUD show];
        [request start];
        
    }
}


- (void)ToAddAddress
{
    GYAddAddressSroViewController* vcAddAddress = [[GYAddAddressSroViewController alloc] initWithNibName:@"GYAddAddressSroViewController" bundle:nil];
    vcAddAddress.isFood = self.isFood;
    vcAddAddress.boolstr = NO; //添加收货地址传 “0”
    [self.navigationController pushViewController:vcAddAddress animated:YES];
}

#pragma mark － DataSourceDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableVie
{

    return _marrDataSoure.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYAddressModel* model = nil;
    if (_marrDataSoure.count > indexPath.row) {
        model = _marrDataSoure[indexPath.section];
    }
    return model.heightModel.cellHeight;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYGetGoodCell* cell = [[GYGetGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.isFood = self.isFood;
    if (_marrDataSoure.count > indexPath.row) {
        cell.model = _marrDataSoure[indexPath.section];
    }
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    cell.editingView.tag = 100 + indexPath.section;
    cell.editingView.userInteractionEnabled = YES;
    [cell.editingView addGestureRecognizer:tap];

    return cell;
}

- (void)tapClick:(UITapGestureRecognizer*)tap
{

    UIView* imageView = (UIView*)tap.view;

    GYAddressModel* model = _marrDataSoure[imageView.tag - 100];
    globalAddressMod = model;
    GYAddAddressSroViewController* vcAddAddressModify = [[GYAddAddressSroViewController alloc] initWithNibName:@"GYAddAddressSroViewController" bundle:nil];
    vcAddAddressModify.isFood = self.isFood;
    vcAddAddressModify.boolstr = YES;
    vcAddAddressModify.addrId = model.addrId;
    vcAddAddressModify.model = model;
    [self.navigationController pushViewController:vcAddAddressModify animated:YES];
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{

    return 15.0f;
}

#pragma mark tableview didSelect 代理方法
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GYAddressModel* model = nil;
    if (_marrDataSoure.count > indexPath.row) {
        model = _marrDataSoure[indexPath.section];
    }
    globalAddressMod = model;

    if (_deletage && [_deletage respondsToSelector:@selector(getAddressModle:)]) {
        [_deletage getAddressModle:model];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {

        GYAddAddressSroViewController* vcAddAddressModify = [[GYAddAddressSroViewController alloc] initWithNibName:@"GYAddAddressSroViewController" bundle:nil];
        vcAddAddressModify.boolstr = YES; //修改收货地址传 “1”
        vcAddAddressModify.addrId = model.addrId;
        vcAddAddressModify.isFood = self.isFood;
        vcAddAddressModify.model = model;
        [self.navigationController pushViewController:vcAddAddressModify animated:YES];
    }
}

//代理方法，用于接受 从cell传过来的button
- (void)senderBtn:(id)sender WithCellModel:(id)mod
{
    globalAddressMod = mod;

    btnTemp = sender;
    globalAddressMod = (GYAddressModel*)mod;

    for (int i = 0; i < self.marrDataSoure.count; i++) {
        GYAddressModel* model = _marrDataSoure[i];
        model.isDefault = @"0";
        if (model == globalAddressMod) {
            model.isDefault = @"1";
        }
    }

    if (_deletage && [_deletage respondsToSelector:@selector(getAddressModle:)]) {
        [_deletage getAddressModle:mod];
    }

    [self.tableView reloadData];
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
