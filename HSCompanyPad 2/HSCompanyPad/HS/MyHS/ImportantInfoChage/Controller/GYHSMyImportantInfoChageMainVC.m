//
//  GYHSMyImportantInfoChageMainVC.m
//
//  Created by apple on 16/8/29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMyImportantInfoChageMainVC.h"
#import "GYHSMemberProgressView.h"
#import "GYHSMyImportantInfoChageMainCell.h"

#import "GYHSMyImportantChageModel.h"
#import "GYHSMyImportantInfoChangeCommitVC.h"
#import "GYNetwork.h"
#import "GYHSMyImportantShowExplanationVC.h"

static NSString* idCell0 = @"importantInfoChageMainCell0";
static NSString* idCell1 = @"importantInfoChageMainCell1";
static NSString* idCell2 = @"importantInfoChageMainCell2";
static NSString* idCell3 = @"importantInfoChageMainCell3";
static NSString* idCell4 = @"importantInfoChageMainCell4";
static NSString* idCell5 = @"importantInfoChageMainCell5";
static NSString* idCell6 = @"importantInfoChageMainCell6";

@interface GYHSMyImportantInfoChageMainVC () <UITableViewDataSource, UITableViewDelegate, GYHSMyImportantInfoChageMainCellDelegate>

@property (nonatomic, strong) UIButton* nextButton;
@property (nonatomic, strong) UIButton* explanationButton;
@property (nonatomic, strong) UIView* backBottomView;

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) NSArray* titleArray;
@property (nonatomic, strong) NSMutableArray* contentArray;
@property (nonatomic, strong) NSArray* keyArray;
@property (nonatomic, strong) NSMutableArray* heightArray;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) GYHSMyImportantChageStatusModel* model;

@property (nonatomic, strong) UILabel* statusTitleLabel;
@property (nonatomic, strong) UILabel* statusLabel;
@property (nonatomic, strong) UILabel* reasonTitleLabel;
@property (nonatomic, strong) UITextView* reasonTextView;
@property (nonatomic, strong) UILabel* dateTitleLabel;
@property (nonatomic, strong) UILabel* dateLabel;

@end

@implementation GYHSMyImportantInfoChageMainVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    [self loadInitViewType:GYStopTypeLogout :^{
        @strongify(self);
        [self initView];
        [self justImportChangeState];
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDLogInfo(@"Show Controller: %@", [self class]);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self addLine:self.statusLabel];
    [self addLine:self.reasonTextView];
    [self addLine:self.dateLabel];
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    switch (indexPath.row) {
        case 0: {
            
            return [self registeredCell:tableView identifier:idCell0 indexPath:indexPath];
        } break;
        case 1: {
            
            return [self registeredCell:tableView identifier:idCell1 indexPath:indexPath];
        } break;
        case 2: {
            
            return [self registeredCell:tableView identifier:idCell2 indexPath:indexPath];
        } break;
        case 3: {
            
            return [self registeredCell:tableView identifier:idCell3 indexPath:indexPath];
        } break;
        case 4: {
            
            return [self registeredCell:tableView identifier:idCell4 indexPath:indexPath];
        } break;
        case 5: {
            
            return [self registeredCell:tableView identifier:idCell5 indexPath:indexPath];
        } break;
        case 6: {
            
            return [self registeredCell:tableView identifier:idCell6 indexPath:indexPath];
        } break;
        default:
            return nil;
            break;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [self.heightArray[indexPath.row] floatValue];
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - GYHSMyImportantInfoChageMainCellDelegate
- (void)updateCellHeight:(float)height indexPath:(NSIndexPath*)indexPath
{
    [self.heightArray replaceObjectAtIndex:indexPath.row withObject:@(height)];
    [self.tableView reloadData];
}

- (BOOL)updateContent:(UITextField*)contentTextField indexPath:(NSIndexPath*)indexPath
{
    [self.view endEditing:YES];
    if (contentTextField.text.length == 0) {
        [contentTextField tipWithContent:kLocalized(@"GYHS_Myhs_PleaseInputContent") animated:YES];
        return NO;
    }
    
    switch (indexPath.row) {
        case 0: {
            //企业名称
            if (contentTextField.text.length > 60 || contentTextField.text.length < 2) {
                [contentTextField tipWithContent:kLocalized(@"GYHS_Myhs_Company_Name_Length_Error") animated:YES];
                return NO;
            }
            
        } break;
            
        case 1: {
            //企业注册地址
            if (contentTextField.text.length > 128 || contentTextField.text.length < 2) {
                [contentTextField tipWithContent:kLocalized(@"GYHS_Myhs_Company_Address_Length_Error") animated:YES];
                return NO;
            }
        } break;
            
        case 2: {
            //营业执照注册号
            if (contentTextField.text.length > 30 || contentTextField.text.length < 7) {
                [contentTextField tipWithContent:kLocalized(@"GYHS_Myhs_Regist_Number_Length_Error") animated:YES];
                return NO;
            }
        } break;
            
        case 3: {
            //联系人姓名
            if (contentTextField.text.length > 20 || contentTextField.text.length < 2) {
                [contentTextField tipWithContent:kLocalized(@"GYHS_Myhs_Contacter_Name_Length_Error") animated:YES];
                return NO;
            }
        } break;
            
        case 4: {
            //联系人手机号
            if (contentTextField.text.length != 11) {
                 [contentTextField tipWithContent:kLocalized(@"GYHS_Myhs_Contacter_Phone_Length_Error") animated:YES];
                return NO;
            }
            
            if (![contentTextField.text isMobileNumber]) {
                [contentTextField tipWithContent:kLocalized(@"GYHS_Myhs_Contacter_Phone_Invalid") animated:YES];
                return NO;
            }
            
        } break;
        case 5: {
            //法人代表
            if (contentTextField.text.length > 20 || contentTextField.text.length < 2) {
                [contentTextField tipWithContent:kLocalized(@"GYHS_Myhs_Legal_Person_Length_Error") animated:YES];
                return NO;
            }
        } break;
        case 6: {
            //联系人手机号
            if (contentTextField.text.length != 11) {
                [contentTextField tipWithContent:kLocalized(@"GYHS_Myhs_Leagel_Phone_Lenth_Error") animated:YES];
                return NO;
            }
            
            if (![contentTextField.text isMobileNumber]) {
                [contentTextField tipWithContent:kLocalized(@"GYHS_Myhs_Leagel_Phone_Lenth_Invalid") animated:YES];
                return NO;
            }
            
        } break;
        default:
            break;
    }
    
    [self.contentArray replaceObjectAtIndex:indexPath.row withObject:contentTextField.text];
    return YES;
}

#pragma mark - event response
/*!
 *    下一步
 */
- (void)nextButtonAction
{
    NSMutableDictionary* dict = @{}.mutableCopy;
    [self.tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof GYHSMyImportantInfoChageMainCell* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
        if (obj.isModify) {
            [dict addEntriesFromDictionary:obj.paramter];
        }
    }];
    
    if (dict.count == 0) {
        [GYUtils showToast:kLocalized(@"GYHS_Myhs_Input_Chage_Content")];
        return;
    }
    
    NSArray* keyArray = [dict allKeys];
    BOOL onlyChageBussiness = YES;
    
    for (NSString* key in keyArray) {
     
        if ([key containsString:@"custNameOld"] || [key containsString:@"custAddressOld"] || [key containsString:@"legalRepOld"]) {
            onlyChageBussiness = NO;
        }
    }
    
    if (dict[@"bizLicenseNoNew"] && onlyChageBussiness == YES) {
        [GYUtils showToast:kLocalized(@"不单独提供申请营业执照注册号的重要信息的变更业务")];
        return;
    }
    
    //下一步
    GYHSMyImportantInfoChangeCommitVC* vc = [[GYHSMyImportantInfoChangeCommitVC alloc] init];
    vc.requestDict = dict;
    vc.oldModel = self.model.entity;
    [self.navigationController pushViewController:vc animated:NO];
}

/*!
 *    移除驳回界面视图，重新布局
 */
- (void)removeViewToReapply
{
    [self.statusLabel removeFromSuperview];
    [self.reasonTextView removeFromSuperview];
    [self.statusTitleLabel removeFromSuperview];
    [self.reasonTitleLabel removeFromSuperview];
    [self.dateTitleLabel removeFromSuperview];
    [self.dateLabel removeFromSuperview];
    
    [self.backBottomView removeFromSuperview];
    
    self.nextButton = nil;
    self.backBottomView = nil;
    //添加普通视图
    [self nornalStatusView];
}

/*!
 *    显示说明
 *
 *    @param btn 说明按钮
 */
- (void)showExplanationAction:(UIButton*)btn
{
    
    GYHSMyImportantShowExplanationVC* vc = [[GYHSMyImportantShowExplanationVC alloc] init];
    UIPopoverController* povc = [[UIPopoverController alloc] initWithContentViewController:vc];
    povc.popoverContentSize = CGSizeMake(kDeviceProportion(180), kDeviceProportion(227));
    [povc presentPopoverFromRect:btn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

#pragma mark - request
/*!
 *    请求重要信息变更状态
 */
- (void)justImportChangeState
{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:globalData.loginModel.entCustId forKey:@"custId"];
    @weakify(self)
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSQueryEntChangeByCustId)
         parameter:dic
           success:^(id returnValue) {
               @strongify(self);
               if (kHTTPSuccessResponse(returnValue)) {
                   
                   self.model = [[GYHSMyImportantChageStatusModel alloc] initWithDictionary:returnValue[GYNetWorkDataKey] error:nil];
                   self.contentArray = @[
                                         kSaftToNSString(_model.entity.entName),
                                         kSaftToNSString(_model.entity.entRegAddr),
                                         kSaftToNSString(_model.entity.busiLicenseNo),
                                         kSaftToNSString(_model.entity.contactPerson),
                                         kSaftToNSString(_model.entity.contactPhone),
                                         kSaftToNSString(_model.entity.creName),
                                         kSaftToNSString(_model.entity.legalPersonPhone)
                                         ].mutableCopy;
                   
                   if ([kSaftToNSString(self.model.isChange)
                        isEqualToString:@"1"]) {
                       [self isImportantChagingView];
                   } else if ([kSaftToNSString(self.model.isChange) isEqualToString:@"0"] && ([kSaftToNSString(self.model.status) isEqualToString:@"3"] || [kSaftToNSString(self.model.status) isEqualToString:@"4"])) {
                       [self haveChagedView];
                   } else {
                       [self nornalStatusView];
                   }
               }
           }
           failure:^(NSError* error) {
               
           }
       isIndicator:YES
          MaskType:kMaskViewType_Deault];
}

#pragma mark - private methods
- (void)addLine:(UIView*)view
{
    view.customBorderType = UIViewCustomBorderTypeAll;
    view.customBorderColor = kGrayE3E3EA;
    view.customBorderLineWidth = @1;
}

- (void)initView
{
    self.title = kLocalized(@"GYHS_Myhs_Important_Info_Chage");
    self.view.backgroundColor = kWhiteFFFFFF;
    DDLogInfo(@"Load Controller: %@", [self class]);
    self.cellHeight = kDeviceProportion(60);
    self.automaticallyAdjustsScrollViewInsets = NO;
}

/*!
 *    驳回视图
 */
- (void)haveChagedView
{
    
    [self.view addSubview:self.statusLabel];
    [self.view addSubview:self.reasonTextView];
    [self.view addSubview:self.dateLabel];
    [self.view addSubview:self.statusTitleLabel];
    [self.view addSubview:self.reasonTitleLabel];
    [self.view addSubview:self.dateTitleLabel];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view).offset(kDeviceProportion(329));
        make.width.greaterThanOrEqualTo(@(kDeviceProportion(150)));
        make.top.equalTo(self.view).offset(kNavigationHeight + kDeviceProportion(75));
        make.height.mas_equalTo(kDeviceProportion(40));
    }];
    
    [self.statusTitleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(self.statusLabel.mas_left).offset(-20);
        make.top.equalTo(self.statusLabel.mas_top);
        make.width.mas_equalTo(kDeviceProportion(150));
        make.height.equalTo(self.statusLabel);
    }];
    
    [self.reasonTextView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view).offset(kDeviceProportion(329));
        make.width.equalTo(@(kDeviceProportion(450)));
        make.top.equalTo(self.statusLabel.mas_bottom).offset(kDeviceProportion(25));
        make.height.mas_equalTo(kDeviceProportion(120));
    }];
    
    [self.reasonTitleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(self.statusLabel.mas_left).offset(-20);
        make.top.equalTo(self.reasonTextView.mas_top);
        make.width.equalTo(@(kDeviceProportion(150)));
        make.height.equalTo(self.statusLabel);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view).offset(kDeviceProportion(329));
        make.width.equalTo(@(kDeviceProportion(150)));
        make.top.equalTo(self.reasonTextView.mas_bottom).offset(kDeviceProportion(25));
        make.height.equalTo(self.statusLabel);
    }];
    
    [self.dateTitleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(self.dateLabel.mas_left).offset(-20);
        make.top.equalTo(self.dateLabel.mas_top);
        make.width.mas_equalTo(kDeviceProportion(150));
        make.height.equalTo(self.statusLabel);
    }];
    
    NSString* str;
    if ([self.model.status isEqualToString:@"3"]) {
        str = kLocalized(@"GYHS_Myhs_Apply_Reject");
    }
    else {
        str = kLocalized(@"GYHS_Myhs_Review_Reject");
    }
    NSMutableParagraphStyle* style = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
    style.headIndent = 10;
    style.firstLineHeadIndent = 10;
    _statusLabel.attributedText = [[NSAttributedString alloc] initWithString:str attributes:@{ NSFontAttributeName : kFont32, NSForegroundColorAttributeName : kGrayCCCCCC, NSParagraphStyleAttributeName : style }];
    
    _reasonTextView.attributedText = [[NSAttributedString alloc] initWithString:self.model.apprRemark ? self.model.apprRemark : @"" attributes:@{ NSFontAttributeName : kFont32, NSForegroundColorAttributeName : kGrayCCCCCC, NSParagraphStyleAttributeName : style }];
    
    _dateLabel.attributedText = [[NSAttributedString alloc] initWithString:self.model.apprDate attributes:@{ NSFontAttributeName : kFont32, NSForegroundColorAttributeName : kGrayCCCCCC, NSParagraphStyleAttributeName : style }];
    
    [self addBottomView];
    [self.nextButton setTitle:kLocalized(@"GYHS_Myhs_Again_Apply") forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(removeViewToReapply) forControlEvents:UIControlEventTouchUpInside];
}

/*!
 *    正重要信息变更中的视图
 */
- (void)isImportantChagingView
{
    UILabel* tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kDeviceProportion(106) + 44, kScreenWidth, 40)];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = kFont32;
    tipLabel.textColor = kGray333333;
    tipLabel.text = kLocalized(@"GYHS_Myhs_Now_You_Chaging_No_This_Bussniss");
    [self.view addSubview:tipLabel];
}

/*!
 *    未申请重要信息变更视图
 */
- (void)nornalStatusView
{
    [self addLeftView];
    [self addBottomView];
    [self.nextButton setTitle:kLocalized(@"GYHS_Myhs_Next") forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addTableView];
}

/*!
 *    左边的下一步视图
 */
- (void)addLeftView
{
    GYHSMemberProgressView* progressView = [[GYHSMemberProgressView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kDeviceProportion(225), kDeviceProportion(400)) array:@[ kLocalized(@"GYHS_Myhs_Click_Modify_Info"), kLocalized(@"GYHS_Myhs_Upload_Related_Image"), kLocalized(@"GYHS_Myhs_Finish_Chage") ]];
    progressView.index = 1;
    [self.view addSubview:progressView];
}

/*!
 *    底部下一步按钮视图
 */
- (void)addBottomView
{
    
    [self.view addSubview:self.backBottomView];
    [self.backBottomView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kDeviceProportion(70)));
    }];
    
    [_backBottomView addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@(kDeviceProportion(33)));
        make.width.equalTo(@(kDeviceProportion(120)));
        make.centerX.centerY.equalTo(_backBottomView);
    }];
}

/*!
 *    添加基本视图tableview
 */
- (void)addTableView
{
    [self.view addSubview:self.explanationButton];
    [self.explanationButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.width.mas_equalTo(kDeviceProportion(40));
        make.right.equalTo(self.view).offset(kDeviceProportion(-16));
        make.top.equalTo(self.view).offset(kNavigationHeight+ kDeviceProportion(10));
        make.height.mas_equalTo(kDeviceProportion(30));
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.width.mas_equalTo(kDeviceProportion(791));
        make.right.equalTo(self.view).offset(kDeviceProportion(-16));
        make.top.equalTo(self.view).offset(kDeviceProportion(40) + kNavigationHeight);
        make.bottom.equalTo(self.backBottomView.mas_top).offset(kDeviceProportion(-16));
    }];
}

/*!
 *    获取cell
 *
 *    @param tableView  代理中传来的tableView
 *    @param identifier 代理中传来的identifier
 *    @param indexPath  代理中传来的indexPath
 *
 *    @return cell
 */
- (GYHSMyImportantInfoChageMainCell*)registeredCell:(UITableView*)tableView identifier:(NSString*)identifier indexPath:(NSIndexPath*)indexPath
{
    GYHSMyImportantInfoChageMainCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title = self.titleArray[indexPath.row];
    cell.cellHeight = [self.heightArray[indexPath.row] floatValue];
    cell.indexPath = indexPath;
    cell.delegate = self;
    if (self.contentArray.count == 7) {
        cell.content = self.contentArray[indexPath.row];
        cell.key = self.keyArray[indexPath.row];
    }
    return cell;
}

/*!
 *    注册cell
 *
 *    @param identifier identifier标识
 */
- (void)registeredCellIdentifier:(NSString*)identifier
{
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSMyImportantInfoChageMainCell class]) bundle:nil] forCellReuseIdentifier:identifier];
}

#pragma mark - lazy load
- (UIButton*)explanationButton
{
    if (!_explanationButton) {
        _explanationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_explanationButton setTitleColor:kBlue0A59C2 forState:UIControlStateNormal];
        _explanationButton.titleLabel.font = kFont32;
        _explanationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_explanationButton setTitle:kLocalized(@"说明") forState:UIControlStateNormal];
        [_explanationButton addTarget:self action:@selector(showExplanationAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _explanationButton;
}

- (NSMutableArray*)contentArray
{
    if (!_contentArray) {
        _contentArray = @[].mutableCopy;
    }
    return _contentArray;
}

- (NSMutableArray*)heightArray
{
    if (!_heightArray) {
        _heightArray = [[NSMutableArray alloc] initWithArray:@[ @(self.cellHeight),
                                                                @(self.cellHeight),
                                                                @(self.cellHeight),
                                                                @(self.cellHeight),
                                                                @(self.cellHeight),
                                                                @(self.cellHeight),
                                                                @(self.cellHeight) ]];
    }
    return _heightArray;
}

- (NSArray*)titleArray
{
    if (!_titleArray) {
        _titleArray = @[ kLocalized(@"GYHS_Myhs_Company_Name_Colon"),
                         kLocalized(@"GYHS_Myhs_Company_Regist_Address_Colon"),
                         kLocalized(@"GYHS_Myhs_Business_License_Nymber_Colon"),
                         kLocalized(@"GYHS_Myhs_Contacts_Name_Colon"),
                         kLocalized(@"GYHS_Myhs_Contacts_Phone_Colon"),
                         kLocalized(@"GYHS_Myhs_Leagel_Name_Colon"),
                         kLocalized(@"GYHS_Myhs_Leagel_Phone_Colon") ];
    }
    return _titleArray;
}

- (NSArray*)keyArray
{
    if (!_keyArray) {
        _keyArray = @[ @"custName", @"custAddress", @"bizLicenseNo", @"linkman", @"linkmanMobile", @"legalRep", @"legalRepMobile" ];
    }
    return _keyArray;
}

- (UILabel*)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
    }
    return _statusLabel;
}

- (UILabel*)statusTitleLabel
{
    if (!_statusTitleLabel) {
        _statusTitleLabel = [[UILabel alloc] init];
        _statusTitleLabel.textColor = kGray333333;
        _statusTitleLabel.textAlignment = NSTextAlignmentRight;
        _statusTitleLabel.font = kFont32;
        _statusTitleLabel.text = kLocalized(@"GYHS_Myhs_Apply_Result_Colon");
    }
    return _statusTitleLabel;
}

- (UITextView*)reasonTextView
{
    if (!_reasonTitleLabel) {
        _reasonTextView = [[UITextView alloc] init];
        _reasonTextView.editable = NO;
        _reasonTextView.selectable = NO;
    }
    return _reasonTextView;
}

- (UILabel*)reasonTitleLabel
{
    if (!_reasonTitleLabel) {
        _reasonTitleLabel = [[UILabel alloc] init];
        _reasonTitleLabel.textColor = kGray333333;
        _reasonTitleLabel.textAlignment = NSTextAlignmentRight;
        _reasonTitleLabel.font = kFont32;
        _reasonTitleLabel.text = kLocalized(@"GYHS_Myhs_Apply_Opinion_Colon");
    }
    return _reasonTitleLabel;
}

- (UILabel*)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
    }
    return _dateLabel;
}

- (UILabel*)dateTitleLabel
{
    if (!_dateTitleLabel) {
        _dateTitleLabel = [[UILabel alloc] init];
        _dateTitleLabel.textColor = kGray333333;
        _dateTitleLabel.textAlignment = NSTextAlignmentRight;
        _dateTitleLabel.font = kFont32;
        _dateTitleLabel.text = kLocalized(@"GYHS_Myhs_Apply_Time_Colon");
    }
    return _dateTitleLabel;
}

- (UIView*)backBottomView
{
    if (!_backBottomView) {
        _backBottomView = [[UIView alloc] init];
        _backBottomView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.16];
    }
    return _backBottomView;
}

- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kWhiteFFFFFF;
        [self registeredCellIdentifier:idCell0];
        [self registeredCellIdentifier:idCell1];
        [self registeredCellIdentifier:idCell2];
        [self registeredCellIdentifier:idCell3];
        [self registeredCellIdentifier:idCell4];
        [self registeredCellIdentifier:idCell5];
        [self registeredCellIdentifier:idCell6];
    }
    return _tableView;
}

- (UIButton*)nextButton
{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitleColor:kWhiteFFFFFF forState:UIControlStateNormal];
        _nextButton.backgroundColor = kRedE50012;
        _nextButton.layer.cornerRadius = 6;
    }
    return _nextButton;
}
@end
