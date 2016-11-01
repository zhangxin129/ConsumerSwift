//
//  GYHSBandingBankCardVC.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/28.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSBindBankCardListVC.h"
#import "GYHSAddBankCardInfoVC.h"
#import "GYHSLoginModel.h"
#import "GYHSLoginManager.h"
#import "GYHSBankCardDetailVC.h"
#import "GYHSNetworkAPI.h"
#import "GYHSBindBankCardListDataController.h"
#import "GYHSConstant.h"
#import "GYCardBandTableViewCell.h"
#import "GYHSCardBandModel.h"

#import "GYHSBasicInfomationController.h"


NSString* const GYHS_Banding_Bank_Card_CellIdentify = @"GYHS_Banding_Bank_Card_CellIdentify";

@interface GYHSBindBankCardListVC () <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate, GYNetRequestDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, strong) GYHSBindBankCardListDataController* queryBankListDC;
@property (nonatomic, assign) NSInteger cellindex;
@property (nonatomic, weak) UIButton* addButton;
@property (nonatomic, weak) UILabel *noBindinglb;
@property (nonatomic,assign) BOOL isCardData;
@property (nonatomic,weak) UIView *background;
@end

@implementation GYHSBindBankCardListVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isPerfect == GYHSBindBankCardListVCTypeNoPerfect) {
        if (!globalData.loginModel.cardHolder) {
            [self noPerfectForNoCardholder];
            self.background.hidden = NO;
        }
    }
    else {
        [self queryBankList];
        self.background.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 115.0f;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 15.0f;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifer = @"cell";
    GYCardBandTableViewCell* cell = (GYCardBandTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = kDefaultVCBackgroundColor;
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:90.0f];
    cell.delegate = self;
    cell.tag = indexPath.section;
    cell.cellScrollView.tag = indexPath.section;
    GYHSCardBandModel* model = nil;
    if (self.dataArray.count > indexPath.section) {
        model = self.dataArray[indexPath.section];
    }
    cell.modol = model;
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHSCardBandModel* model = nil;
    if (self.dataArray.count > indexPath.section) {
        model = self.dataArray[indexPath.section];
    }
    if ([self.type isEqualToString:@"1"]) {
        if ([_bankcardDelegate respondsToSelector:@selector(chooseBank:isAdd:)]) {
            [_bankcardDelegate chooseBank:model isAdd:YES];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        GYHSBankCardDetailVC* vc = [[GYHSBankCardDetailVC alloc] init];
        vc.carBindModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    DDLogDebug(@"responseObject:%@", responseObject);
    [GYGIFHUD dismiss];
    
    if(request.tag == 700) {
        if ([GYUtils checkDictionaryInvalid:responseObject]) {
            [GYUtils showMessage:kLocalized(@"GYHS_Banding_DeleteCardFailedPleaseTryAgain") confirm:nil];
            return;
        }
        
        NSInteger returnCode = [[responseObject objectForKey:@"retCode"] integerValue];
        if (returnCode == 200) {
            
            [GYUtils showToast:kLocalized(@"GYHS_Banding_DeleteSuccess")];
            
            // 解决删除时数据没有更新
            if ([_bankcardDelegate respondsToSelector:@selector(chooseBank: isAdd:)]) {
                GYHSCardBandModel* model = self.dataArray[self.cellindex];
                [_bankcardDelegate chooseBank:model isAdd:NO];
            }
            
            [self.dataArray removeObjectAtIndex:self.cellindex];
            [self.tableView reloadData];
            
            if([globalData.custGlobalDataModel.bankCardBindCount integerValue] <= self.dataArray.count) {
                self.addButton.hidden = YES;
            }else {
                self.addButton.hidden = NO;
            }
            
            if(self.dataArray == nil ||   self.dataArray.count == 0) {
                globalData.loginModel.isBindBank = @"0";
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else {
            [GYUtils showMessage:kLocalized(@"GYHS_Banding_DeleteCardFailedPleaseTryAgain") confirm:nil];
        }
    }else if(request.tag == 701) {
        NSDictionary *dic = responseObject[@"data"];
        if([GYUtils checkStringInvalid:kSaftToNSString(dic[@"name"])]) {
            [self noPerfectForNoCardholder];
            self.noBindinglb.hidden = YES;
        }else {
            GYHSAddBankCardInfoVC* vc = [[GYHSAddBankCardInfoVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    
}

- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
    [GYGIFHUD dismiss];
    if(request.tag == 700) {
        [GYUtils parseNetWork:error resultBlock:nil];
    }
}

- (NSArray*)rightButtons
{
    NSMutableArray* rightUtilityButtons = [NSMutableArray new];

    [rightUtilityButtons sw_addUtilityButtonWithColor:kNavigationBarColor icon:[UIImage imageNamed:@"gyhs_delete_image"]];
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell*)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSArray* cells = [self.tableView visibleCells];
    for (UITableViewCell* cel in cells) {
        if (cel.tag == cell.cellScrollView.tag) {

            self.cellindex = cel.tag;
            GYHSCardBandModel* model = self.dataArray[cel.tag];
            [self gotoQuitBanding:model]; //去除model里面的数据
        }
    }
}

#pragma mark - event response
- (void)addCardBanding
{
    GYHSAddBankCardInfoVC* vc = [[GYHSAddBankCardInfoVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestNetWorkInfo
{
    GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:kHSGetInfo parameters:@{ @"userId" : kSaftToNSString(globalData.loginModel.custId) } requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    request.tag = 701;
    [GYGIFHUD show];
    [request start];
}

- (void)gotoQuitBanding:(GYHSCardBandModel*)model
{
    WS(weakSelf)
    [GYUtils showMessge:kLocalized(@"GYHS_Banding_Sure_Delete_Bank_Card") confirm:^{
        NSString *url = kUrlUnBindBank;
        
        GYHSLoginModel *loginModel = [weakSelf loginModel];
        NSDictionary *paramDic = @{@"accId":model.accId,
                                   @"userType": loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard };
        GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:weakSelf URLString:url parameters:paramDic requestMethod:GYNetRequestMethodDELETE requestSerializer:GYNetRequestSerializerJSON];
        [request setValue:loginModel.token forHTTPHeaderField:@"token"];
        request.tag = 700;
        [request start];
        [GYGIFHUD show];
    } cancleBlock:^{
        
    }];
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_Banding_bankCark");
    self.isCardData  = YES;
    if ([self.type isEqualToString:@"1"]) {
        self.title = kLocalized(@"GYHS_Banding_bankCark");
    }
    else {
        self.title = kLocalized(@"GYHS_Banding_bankCark");
    }
    self.view.backgroundColor = kDefaultVCBackgroundColor;

    UIButton* btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 0, 40, 40);
    btnRight.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [btnRight setTitle:kLocalized(@"GYHS_Banding_Add") forState:UIControlStateNormal];
    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(addCardBanding) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.addButton = btnRight;
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(15, kScreenHeight/2 -64, kScreenWidth-30, 15)];
    lb.text = kLocalized(@"GYHS_Banding_Tip_You_havenot_Binding_Bank_Card_Record");
    lb.textAlignment = NSTextAlignmentCenter;
    lb.font = [UIFont systemFontOfSize:15.0f];
    self.noBindinglb = lb;
    self.noBindinglb.hidden = YES;
    [self.noBindinglb setTextColor:kCellItemTextColor];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.noBindinglb];
}

- (void)queryBankList
{
    BOOL hasCard = [[GYHSLoginManager shareInstance] loginModuleObject].cardHolder;
    NSString* strHasCard = hasCard ? kUserTypeCard : kUserTypeNoCard;
    GYHSLoginModel* model = [[GYHSLoginManager shareInstance] loginModuleObject];

    WS(weakSelf)
    [self.queryBankListDC queryBankList:strHasCard custId:model.custId resultBlock:^(NSArray* resultAry) {
    if ([GYUtils checkArrayInvalid:resultAry] || resultAry.count==0) {
        DDLogDebug(@"Failed to run queryBankListDC.");
        self.noBindinglb.hidden =NO;
        self.isCardData = NO;
        self.addButton.hidden = NO;
        return;
    }
    self.noBindinglb.hidden = YES;
    self.isCardData = YES;
    [weakSelf.dataArray removeAllObjects];
    [weakSelf.dataArray addObjectsFromArray:resultAry];
    [weakSelf.tableView reloadData];
        
        
        if([globalData.custGlobalDataModel.bankCardBindCount integerValue] <= weakSelf.dataArray.count) {
            self.addButton.hidden = YES;
        }else {
            self.addButton.hidden = NO;
        }

        }];
}

- (void)noPerfectForNoCardholder
{
    UIView* background = [[UIView alloc] initWithFrame:self.tableView.frame];
    CGFloat maxW = background.frame.size.width;
    CGFloat imgW = 52;
    CGFloat imgH = 59;
    CGFloat imgX = (maxW - imgW) * 0.5;
    CGFloat imgY = 40;
    UIImageView* imgvNoResult = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_no_result"]];
    imgvNoResult.frame = CGRectMake(imgX, imgY, imgW, imgH);
    [background addSubview:imgvNoResult];
    CGFloat lbTipW = 270;
    CGFloat lbTipH = 40;
    CGFloat lbTipX = (maxW - lbTipW) * 0.5;
    CGFloat lbTipY = CGRectGetMaxY(imgvNoResult.frame) + 20;
    UILabel* lbTips = [[UILabel alloc] init];
    lbTips.textColor = kCellItemTitleColor;
    lbTips.textAlignment = NSTextAlignmentCenter;
    lbTips.font = [UIFont systemFontOfSize:15.0];
    lbTips.backgroundColor = [UIColor clearColor];
    lbTips.frame = CGRectMake(lbTipX, lbTipY, lbTipW, lbTipH);
    lbTips.text = kLocalized(@"GYHS_Banding_Please_Complete_Your_Info");
    [background addSubview:lbTips];
    [self addRegisterBtn:background maxW:maxW libtips:lbTips];
    self.background = background;

    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = background;
}

- (void)addRegisterBtn:(UIView*)background maxW:(CGFloat)maxW libtips:(UILabel*)lbTips
{
    CGFloat btnToNameBandingW = 80;
    CGFloat btnToNameBandingH = 30;
    CGFloat btnToNameBandingX = (maxW - btnToNameBandingW) * 0.5;
    CGFloat btnToNameBandingY = CGRectGetMaxY(lbTips.frame);
    UIButton* btnToNameBanding = [UIButton buttonWithType:UIButtonTypeCustom];

    NSString* title = kLocalized(@"GYHS_Banding_Perfect_Information");
    if (globalData.loginModel.cardHolder) {
        title = kLocalized(@"GYHS_Banding_Real_Name_Register");
    }

    [btnToNameBanding setTitle:title forState:UIControlStateNormal];
    btnToNameBanding.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnToNameBanding setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    btnToNameBanding.frame = CGRectMake(btnToNameBandingX, btnToNameBandingY, btnToNameBandingW, btnToNameBandingH);
    btnToNameBanding.layer.borderWidth = 1;
    btnToNameBanding.layer.cornerRadius = 2;
    btnToNameBanding.layer.borderColor = kDefaultViewBorderColor.CGColor;
    [btnToNameBanding addTarget:self action:@selector(gotoNameReg) forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:btnToNameBanding];

    self.addButton.hidden = YES;
}

- (void)gotoNameReg
{
    GYHSBasicInfomationController* infoVC = [[GYHSBasicInfomationController alloc] init];
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (NSString*)getCustName
{
    GYHSLoginModel* model = [[GYHSLoginManager shareInstance] loginModuleObject];
    return model.custName;
}

#pragma mark - getter and setter

- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYCardBandTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }

    return _dataArray;
}

- (GYHSBindBankCardListDataController*)queryBankListDC
{
    if (_queryBankListDC == nil) {
        _queryBankListDC = [[GYHSBindBankCardListDataController alloc] init];
    }

    return _queryBankListDC;
}

- (GYHSLoginModel*)loginModel
{
    return [[GYHSLoginManager shareInstance] loginModuleObject];
}

@end
