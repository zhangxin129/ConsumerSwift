//
//  GYHSConResManViewController.m
//  HSCompanyPad
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSConResManViewController.h"
#import "GYHSConResManTableViewCell.h"
#import "UILabel+Category.h"
#import "GYHSCusResManHttpTool.h"
#import <MJExtension/MJExtension.h>
#import "GYHSCusResManModel.h"
#import "GYShowPullDownViewVC.h"
#import "GYHSPublicMethod.h"
#import "GYHSResourceListModel.h"
#import <GYKit/GYRefreshFooter.h>
#import <GYKit/GYRefreshHeader.h>

#define kRemoveNoMessage 1233
static NSString *conResStaTableViewCellID = @"GYHSConResManTableViewCell";

@interface GYHSConResManViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate,GYNetworkReloadDelete>

@property (nonatomic, strong) UITableView *conTableView;

@property (nonatomic, strong) UITextField *conStateTextField;
@property (nonatomic, strong) UITextField *cardStateTextField;
@property (nonatomic, strong) UIView *listView;
@property (nonatomic, strong) GYHSCusResManModel *model;
@property (nonatomic, strong) GYShowPullDownViewVC* toolVC;
@property (nonatomic, assign) NSInteger selectConStateIndex;
@property (nonatomic, assign) NSInteger selectCardStateIndex;
@property (nonatomic, strong) UITextField *numStrTF;
@property (nonatomic, strong) UITextField *numEndTF;
@property (nonatomic, strong) NSMutableArray* listArray;
@property (nonatomic, strong) NSMutableArray *cusStatusArray;
@property (nonatomic, strong) GYHSResourceListModel *listModel;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, strong)UILabel *restotalLable;
@property (nonatomic, strong)UILabel *activeCardLable;
@property (nonatomic, strong)UILabel *actionCardLable;
@property (nonatomic, strong)UILabel *resUseTotalLable;
@property (nonatomic, strong)UILabel *realRegLable;
@property (nonatomic, strong)UILabel *realCerLable;
@property (nonatomic, strong)UIView *headListView;

@end

@implementation GYHSConResManViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self requestCusResMan];
//    [self requestResourceList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createTableView];
    self.conTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (NSMutableArray *)cusStatusArray{
    if (!_cusStatusArray) {
        _cusStatusArray = [[NSMutableArray alloc] init];
    }
    return _cusStatusArray;
}
- (void)setModel:(GYHSCusResManModel *)model{
    _model = model;
    self.resUseTotalLable.text = kSaftToNSString([self formatCurrencyStyle:model.systemResourceUsageNumber.doubleValue]);
    NSString* count = globalData.companyType == kCompanyType_Servicecom ? @"989901" : @"9999";
    self.restotalLable.text = [self formatCurrencyStyle:count.doubleValue];
    self.activeCardLable.text = kSaftToNSString([self formatCurrencyStyle:model.activationNumber.doubleValue]);
    self.actionCardLable.text = kSaftToNSString([self formatCurrencyStyle:model.activeNumber.doubleValue]);
    self.realRegLable.text = kSaftToNSString([self formatCurrencyStyle:model.registrationAuthNumber.doubleValue]);
    self.realCerLable.text = kSaftToNSString([self formatCurrencyStyle:model.realnameAuthNumber.doubleValue]);
}

- (void)createUI{
    self.title = kLocalized(@"GYHS_ConResManager_ConsumerResourcesManagement");
    self.view.backgroundColor = kWhiteFFFFFF;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 , kDeviceProportion(kScreenWidth), kDeviceProportion(50))];
    headView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(kScreenWidth - 20), kDeviceProportion(50))];
    [imageView setImage:[UIImage imageNamed:@"gyhs_staff_searchBackground"]];
    [headView addSubview:imageView];
    [self.view addSubview:headView];
    
    NSArray *headNameArr = @[kLocalized(@"GYHS_ConResManager_TheTotalNumberOfSystemResources"),kLocalized(@"GYHS_ConResManager_TotalUseOfSystemResources"), kLocalized(@"GYHS_ConResManager_ActivationOfHSCardNumber"),kLocalized(@"GYHS_ConResManager_ActiveHSardNumber"),kLocalized(@"GYHS_ConResManager_Real-nameRegistrationNumber"),kLocalized(@"GYHS_ConResManager_Real-nameAuthenticateNumber")];
    float labWidth = (kScreenWidth - 20) / 6;
    for (int i = 0; i < headNameArr.count ; i++) {
        UILabel *headNameLab = [[UILabel alloc] initWithFrame:CGRectMake(i * labWidth, 13, kDeviceProportion(labWidth), kDeviceProportion(24))];
        headNameLab.text = headNameArr[i];
        headNameLab.font = kFont24;
        headNameLab.textAlignment = NSTextAlignmentCenter;
        headNameLab.textColor = kGray777777;
        [headView addSubview:headNameLab];
    }
    
    UIView *resourceView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(headView.frame), kDeviceProportion(kScreenWidth - 60), kDeviceProportion(50))];
    resourceView.layer.borderColor = kGrayE3E3EA.CGColor;
    resourceView.layer.borderWidth = 1.0f;
    [self.view addSubview:resourceView];
    
    float resLableW = (kScreenWidth - 60) / 7;
    
    UILabel *restotalLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, kDeviceProportion(resLableW), kDeviceProportion(24))];
    restotalLable.textColor = kRedE50012;
    restotalLable.font = kFont24;
    restotalLable.textAlignment = NSTextAlignmentCenter;
    [resourceView addSubview:restotalLable];
    self.restotalLable = restotalLable;
    
    UILabel *resUseTotalLable = [[UILabel alloc] initWithFrame:CGRectMake(labWidth, 13, kDeviceProportion(resLableW), kDeviceProportion(24))];
    resUseTotalLable.textColor = kRedE50012;
    resUseTotalLable.font = kFont24;
    resUseTotalLable.textAlignment = NSTextAlignmentCenter;
    [resourceView addSubview:resUseTotalLable];
    self.resUseTotalLable = resUseTotalLable;
    
    UILabel *activeCardLable = [[UILabel alloc] initWithFrame:CGRectMake(labWidth * 2, 13, kDeviceProportion(resLableW), kDeviceProportion(24))];
    activeCardLable.textColor = kGray333333;
    activeCardLable.font = kFont24;
    activeCardLable.textAlignment = NSTextAlignmentCenter;
    [resourceView addSubview:activeCardLable];
    self.activeCardLable = activeCardLable;
    
    UILabel *actionCardLable = [[UILabel alloc] initWithFrame:CGRectMake(labWidth * 3, 13, kDeviceProportion(resLableW), kDeviceProportion(24))];
    actionCardLable.textColor = kGray333333;
    actionCardLable.font = kFont24;
    actionCardLable.textAlignment = NSTextAlignmentCenter;
    [resourceView addSubview:actionCardLable];
    self.actionCardLable = actionCardLable;
    
    UILabel *realRegLable = [[UILabel alloc] initWithFrame:CGRectMake(labWidth * 4, 13, kDeviceProportion(resLableW), kDeviceProportion(24))];
    realRegLable.textColor = kGray333333;
    realRegLable.font = kFont24;
    realRegLable.textAlignment = NSTextAlignmentCenter;
    [resourceView addSubview:realRegLable];
    self.realRegLable = realRegLable;
    
    UILabel *realCerLable = [[UILabel alloc] initWithFrame:CGRectMake(labWidth * 5, 13, kDeviceProportion(resLableW), kDeviceProportion(24))];
    realCerLable.textColor = kGray333333;
    realCerLable.font = kFont24;
    realCerLable.textAlignment = NSTextAlignmentCenter;
    [resourceView addSubview:realCerLable];
    self.realCerLable = realCerLable;
   
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(resourceView.frame) + 16, kDeviceProportion(kScreenWidth - 60), kDeviceProportion(50))];
    [self.view addSubview:searchView];
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(kScreenWidth - 40), kDeviceProportion(50))];

    [searchView addSubview:searchImageView];
    searchView.layer.borderColor = kGrayE3E3EA.CGColor;
    searchView.layer.borderWidth = 1.0f;
    searchView.backgroundColor = kGreenF9F9FB;
    searchImageView.userInteractionEnabled = YES;
    
    UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, kDeviceProportion(80), kDeviceProportion(24))];
    numLab.text = kLocalized(@"GYHS_ConResManager_CardNumberRange");
    numLab.textColor = kGray777777;
    numLab.font = kFont24;
    [searchView addSubview:numLab];
    
    UITextField *numStrTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(numLab.frame) + 10, 10, kDeviceProportion(110), kDeviceProportion(30))];
    numStrTF.layer.borderColor = kGrayE3E3EA.CGColor;
    numStrTF.layer.borderWidth = 1.0f;
    numStrTF.textColor = kGray333333;
    numStrTF.font = kFont24;
    numStrTF.delegate = self;
    numStrTF.keyboardType = UIKeyboardTypeNumberPad;
    [searchView addSubview:numStrTF];
    self.numStrTF = numStrTF;
    
    UILabel *toLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(numStrTF.frame) + 4, 20, 20, 10)];
    toLab.textAlignment = NSTextAlignmentCenter;
    toLab.text = @"-";
    toLab.font = [UIFont systemFontOfSize:20];
    toLab.textColor = [UIColor lightGrayColor];
    [searchView addSubview:toLab];
    
    UITextField *numEndTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(toLab.frame) + 4, 10, 110, 30)];
    numEndTF.layer.borderColor = kGrayE3E3EA.CGColor;
    numEndTF.layer.borderWidth = 1.0f;
    numEndTF.textColor = kGray333333;
    numEndTF.font = kFont24;
    numEndTF.delegate = self;
    numEndTF.keyboardType = UIKeyboardTypeNumberPad;
    [searchView addSubview:numEndTF];
    self.numEndTF = numEndTF;
    
    self.conStateTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(numEndTF.frame) + 10, 10, 200, 30)];
    self.conStateTextField.font = kFont24;
    self.conStateTextField.textColor = kGray333333;
    self.conStateTextField.placeholder = kLocalized(@"GYHS_ConResManager_ConsumersState");
    self.conStateTextField.layer.borderColor = kGrayE3E3EA.CGColor;
    self.conStateTextField.layer.borderWidth = 1.0f;
    self.conStateTextField.delegate = self;
    self.conStateTextField.leftViewMode = UITextFieldViewModeAlways;
    self.conStateTextField.rightViewMode = UITextFieldViewModeAlways;
    UIImageView* cusStaLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(5), kDeviceProportion(30))];
    self.conStateTextField.leftView = cusStaLeftView;
    UIImageView* cusStaRightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(30), kDeviceProportion(30))];
    cusStaRightView.image = [UIImage imageNamed:@"gycom_gray_pullDown"];
    cusStaRightView.userInteractionEnabled = YES;
    cusStaRightView.multipleTouchEnabled = YES;
    cusStaRightView.contentMode = UIViewContentModeCenter;
    self.conStateTextField.rightView = cusStaRightView;

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] init];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    self.conStateTextField.userInteractionEnabled = YES;
    [self.conStateTextField addGestureRecognizer:tap];
    
    [searchImageView addSubview:self.conStateTextField];
    
    self.cardStateTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.conStateTextField.frame) + 10, 10, 200, 30)];
    self.cardStateTextField.font = kFont24;
    self.cardStateTextField.textColor = kGray333333;
    self.cardStateTextField.placeholder = kLocalized(@"GYHS_ConResManager_CardState");
    self.cardStateTextField.layer.borderColor = kGrayE3E3EA.CGColor;
    self.cardStateTextField.layer.borderWidth = 1.0f;
    self.cardStateTextField.leftViewMode = UITextFieldViewModeAlways;
    self.cardStateTextField.rightViewMode = UITextFieldViewModeAlways;
    UIImageView* cardStaLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(5), kDeviceProportion(30))];
    self.conStateTextField.leftView = cardStaLeftView;
    UIImageView* cardStaRightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(30), kDeviceProportion(30))];
    cardStaRightView.image = [UIImage imageNamed:@"gycom_gray_pullDown"];
    cardStaRightView.userInteractionEnabled = YES;
    cardStaRightView.multipleTouchEnabled = YES;
    cardStaRightView.contentMode = UIViewContentModeCenter;
    self.cardStateTextField.rightView = cardStaRightView;
    UITapGestureRecognizer* cardStatap = [[UITapGestureRecognizer alloc] init];
    cardStatap.delegate = self;
    [self.cardStateTextField addGestureRecognizer:cardStatap];
    self.cardStateTextField.delegate = self;
    self.cardStateTextField.userInteractionEnabled = YES;
    [searchImageView addSubview:self.cardStateTextField];
    
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(CGRectGetMaxX(self.cardStateTextField.frame) + 10, 18, 15, 15);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_point_check"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(gyNetworkDidTapReloadBtn) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchBtn];
    UILabel *searchLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchBtn.frame), 10, 40, 30)];
    searchLab.text = kLocalized(@"GYHS_ConResManager_Search");
    searchLab.textColor = [UIColor redColor];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gyNetworkDidTapReloadBtn)];
    [searchLab addGestureRecognizer:tapGes];
    searchLab.userInteractionEnabled = YES;
    [searchView addSubview:searchLab];
    
    UIView *listView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(searchView.frame), kDeviceProportion(kScreenWidth), kDeviceProportion(50))];
    UIImageView *listImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(kScreenWidth - 20), kDeviceProportion(50))];
    [listImageView setImage:[UIImage imageNamed:@"gycom_search_back"]];
    [listView addSubview:listImageView];
    [self.view addSubview:listView];
    self.listView = listView;
    
    float titleLableW = (kScreenWidth - 20) / 4;
    NSArray *titleArray = @[kLocalized(@"GYHS_ConResManager_HSCardNumber"),kLocalized(@"GYHS_ConResManager_ConsumersState"),kLocalized(@"GYHS_ConResManager_ConsumersStateFinishTime"),kLocalized(@"GYHS_ConResManager_HSCardState")];
    for (int i=0 ; i<titleArray.count;i++) {
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(i * titleLableW, 13, kDeviceProportion(titleLableW), kDeviceProportion(24))];
        titleLable.text = titleArray[i];
        titleLable.textColor = kGray777777;
        titleLable.font = kFont24;
        titleLable.textAlignment = NSTextAlignmentCenter;
        [self.listView addSubview:titleLable];
    }
}
- (void)createTableView{
    
    UIView *headListView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.listView.frame), kDeviceProportion(kScreenWidth - 60), kDeviceProportion(kScreenHeight - 44 - 20 - 200 - 16))];
    headListView.layer.borderColor = kGrayE3E3EA.CGColor;
    headListView.layer.borderWidth = 1.0f;
    [self.view addSubview:headListView];
    self.headListView = headListView;
    self.conTableView = [[UITableView alloc] init];
    self.conTableView.frame = CGRectMake(20, 0 , kDeviceProportion(kScreenWidth - 40 - 20 - 20), kDeviceProportion(kScreenHeight - 44 - 20 - 200 - 16));
    self.conTableView.showsVerticalScrollIndicator = NO;
    self.conTableView.delegate = self;
    self.conTableView.dataSource = self;
    [headListView addSubview:self.conTableView];
    [self.conTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSConResManTableViewCell class]) bundle:nil] forCellReuseIdentifier:conResStaTableViewCellID];
}

#pragma mark -refresh
/**
 *  添加上下拉刷新方法
 */
- (void)addRefreshView
{
    self.page = 1;
    self.pageSize = 20;
    
    @weakify(self);
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.isDown = YES;
        self.page = 1;
        [self requestResourceList];
    }];
    
    self.conTableView.mj_header = header;
    [self.conTableView.mj_header beginRefreshing];
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.isDown = NO;
        self.page++;
        [self.conTableView.mj_footer resetNoMoreData];
        [self requestResourceList];
        
    }];
    
    self.conTableView.mj_footer = footer;
}
- (void)endRefresh
{
    [self.conTableView.mj_header endRefreshing];
    [self.conTableView.mj_footer endRefreshing];
}


- (NSString *)formatCurrencyStyle:(double)val
{
    if (val<0.0001) {
        return @"0";
    }
    
    //自定义方式
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"#,##0"];//@"$#,###0.00"    format:12345678.987 =912,345,678.10
    
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:val]];
    
    return formattedNumberString;
}
#pragma mark -- request
- (void)requestCusResMan{
    
    [GYHSCusResManHttpTool getResourceStatistics:^(id responsObject) {
        if ([responsObject[GYNetWorkDataKey] isKindOfClass:[NSNull class]]){

        }else {
            GYHSCusResManModel *model = [GYHSCusResManModel mj_objectWithKeyValues:responsObject[GYNetWorkDataKey]];
            self.model = model;
        }
    } failure:^{
        
    }];
}

- (void)requestResourceList{
    
    if (![self isDataAllRight]) {
        return;
    }
    
    NSString *conStateStr;
    if ([self.conStateTextField.text isEqualToString:kLocalized(@"GYHS_ConResManager_UnReal-nameRegistration")]) {
        conStateStr = @"1";
    }else if ([self.conStateTextField.text isEqualToString:kLocalized(@"GYHS_ConResManager_Real-nameRegistration")]){
        conStateStr = @"2";
    }else if ([self.conStateTextField.text isEqualToString:kLocalized(@"GYHS_ConResManager_HasBeenReal-nameCertification")]){
        conStateStr = @"3";
    }
    NSString *cardStateStr;
    if ([self.cardStateTextField.text isEqualToString:kLocalized(@"GYHS_ConResManager_Inactive")]) {
        cardStateStr = @"1";
    }else if ([self.cardStateTextField.text isEqualToString:kLocalized(@"GYHS_ConResManager_Active")]){
        cardStateStr = @"2";
    }else if ([self.cardStateTextField.text isEqualToString:kLocalized(@"GYHS_ConResManager_Sleep")]){
        cardStateStr = @"3";
    }else if ([self.cardStateTextField.text isEqualToString:kLocalized(@"GYHS_ConResManager_Precipitation")]){
        cardStateStr = @"4";
    }
    
    
    [GYHSCusResManHttpTool getResourceListWithBeginCard:kBlankNSString(self.numStrTF.text)?@"":self.numStrTF.text EndCard:kBlankNSString(self.numEndTF.text)?@"":self.numEndTF.text CardStatus:kBlankNSString(cardStateStr)?@"":cardStateStr AuthStatus:kBlankNSString(conStateStr)?@"":conStateStr CurPage:[@(self.page) stringValue] PageSize:[@(self.pageSize) stringValue] success:^(id responsObject) {
        if ([self.conTableView.mj_footer isRefreshing]) {
            [self.conTableView.mj_footer endRefreshing];
        }
        if ([self.conTableView.mj_header isRefreshing]) {
            [self.conTableView.mj_header endRefreshing];
        }
        if (self.isDown) {
            [_cusStatusArray removeAllObjects];
            _cusStatusArray = (NSMutableArray *)responsObject;
            
        }else{
            [_cusStatusArray addObjectsFromArray:responsObject];
            
        }
        
        [_conTableView reloadData];
    } failure:^{
    }];
}

- (BOOL)isDataAllRight{
    if (self.numStrTF.text.length > 0) {
        if (![self.numStrTF.text isValidNumber]) {
            [self.numStrTF tipWithContent:kLocalized(@"GYHS_ConResManager_TheHSNumberCanOnlyBePureNumber") animated:YES];
            return NO;
        }
        if (self.numStrTF.text.length != 11) {
            [self.numStrTF tipWithContent:kLocalized(@"GYHS_ConResManager_TheHSNumberMustBe 11 Digits") animated:YES];
            return NO;
        }

    }else{
        return YES;
    }
    
    if (self.numEndTF.text.length > 0) {
        if (![self.numEndTF.text isValidNumber]) {
            [self.numEndTF tipWithContent:kLocalized(@"GYHS_ConResManager_TheHSNumberCanOnlyBePureNumber") animated:YES];
            return NO;
        }
        
        if (self.numEndTF.text.length != 11) {
            [self.numEndTF tipWithContent:kLocalized(@"GYHS_ConResManager_TheHSNumberMustBe 11 Digits") animated:YES];
            return NO;
        }

    }else{
        return YES;
    }
    
    if ([self.numStrTF.text doubleValue] > [self.numEndTF.text doubleValue]) {
        [self.numEndTF tipWithContent:kLocalized(@"请输入正确的卡号范围") animated:YES];
        return NO;

    }
    
    return YES;
}

- (void)gyNetworkDidTapReloadBtn
{
    [self addRefreshView];
//    [self requestResourceList];
}

#pragma mark - UITableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    UIView* view = [self.view viewWithTag:kRemoveNoMessage];
    if (view) {
        [view removeFromSuperview];
    }
    if (self.cusStatusArray.count == 0) {
        UIView *viewC = [GYHSPublicMethod addNoDataTipViewWithSuperView:self.headListView];
        viewC.frame = CGRectMake(0, 0 , kDeviceProportion(kScreenWidth - 60), kDeviceProportion(kScreenHeight - 62 - 44 - 20 - 200 - 16));;
        viewC.tag = kRemoveNoMessage;
    }
    
    self.conTableView.mj_footer.hidden = _cusStatusArray.count < 2;
     return _cusStatusArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GYHSConResManTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:conResStaTableViewCellID forIndexPath:indexPath];
    cell.model = _cusStatusArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.conStateTextField || textField == self.cardStateTextField) {
        return NO;
    }
    return YES;
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.numStrTF) {
        if (toBeString.length > 11) {
            [self.numStrTF tipWithContent:kLocalized(@"GYHS_ConResManager_TheHSNumberCannotExceed 11 Digits") animated:YES];
            [textField resignFirstResponder];
        }else{
            return YES;
        }
    }else if (textField == self.numEndTF){
        if (toBeString.length > 11) {
            [self.numEndTF tipWithContent:kLocalized(@"GYHS_ConResManager_TheHSNumberCannotExceed 11 Digits") animated:YES];
            [textField resignFirstResponder];
        }else{
        
            return YES;
        }
        
    }
    
    return YES;
}

#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{

    if ([touch.view isKindOfClass:[UITextField class]] || [touch.view isKindOfClass:[UIView class]]) {
        
        id view = (UITextField*)touch.view;
        
        if (view == self.conStateTextField || view == self.conStateTextField.rightView) {
            [self tapAlertView:self.conStateTextField];
            return YES;
        }else if (view == self.cardStateTextField || view == self.cardStateTextField.rightView){
            
            [self tapAlertView:self.cardStateTextField];
            return YES;
        }
    }
    
    return NO;
}
#pragma mark - event
- (void)tapAlertView:(UITextField *)textField
{
    if (textField == self.conStateTextField) {
        NSArray* array = @[@"",kLocalized(@"GYHS_ConResManager_UnReal-nameRegistration"),kLocalized(@"GYHS_ConResManager_Real-nameRegistration"),kLocalized(@"GYHS_ConResManager_HasBeenReal-nameCertification")];
        _toolVC = [[GYShowPullDownViewVC alloc] initWithView:self.conStateTextField PullDownArray:array direction:UIPopoverArrowDirectionUp];
        @weakify(self);
        _toolVC.selectBlock = ^(NSInteger index) {
            @strongify(self);
            self.selectConStateIndex = index;
            self.conStateTextField.text = array[index];
        };
    }else if (textField == self.cardStateTextField){
        NSArray* array = @[@"",kLocalized(@"GYHS_ConResManager_Inactive"),kLocalized(@"GYHS_ConResManager_Active"),kLocalized(@"GYHS_ConResManager_Sleep"),kLocalized(@"GYHS_ConResManager_Precipitation")];
        _toolVC = [[GYShowPullDownViewVC alloc] initWithView:self.cardStateTextField PullDownArray:array direction:UIPopoverArrowDirectionUp];
        @weakify(self);
        _toolVC.selectBlock = ^(NSInteger index) {
            @strongify(self);
            self.selectCardStateIndex = index;
            self.cardStateTextField.text = array[index];
        };
    }
}

@end
