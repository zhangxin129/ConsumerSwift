//
//  GYHSMyCompanyInfoVC.m
//
//  Created by apple on 16/8/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMyCompanyInfoVC.h"
#import "GYHSMyComanyFooterViewCell.h"
#import "GYHSMyCompanyInfoCell.h"
#import "GYHSMyCompanyInfoHeadLineView.h"
#import "GYHSMyCompanyInfoModel.h"
#import "GYHSMyImportantInfoChageMainVC.h"
#import "GYNetwork.h"
#import "GYDatePickView.h"

static NSString* idCell = @"myCompanyInfoCell";
static NSString* idSecondCell = @"myComanyFooterViewCell";
static NSString* idHeader = @"myCompanyInfoHeadLineView";

typedef NS_ENUM(NSInteger, ModifyType) {
    ModifyTypeBuildDate,
    ModifyTypeEndDate,
    ModifyTypeBusinessScope
};

static float cellHeight = 290;

@interface GYHSMyCompanyInfoVC () <UITableViewDataSource, UITableViewDelegate, GYHSMyComanyFooterViewCellDeleage>

@property (nonatomic, strong) UIImageView* headImageView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* resNoLabel;

@property (nonatomic, strong) UIButton* importantInfoChageButton;
@property (nonatomic, strong) UITableView* baseTableView;

@property (nonatomic, strong) NSArray* titleArray;
@property (nonatomic, strong) NSArray* contentArray;

@property (nonatomic, assign) float secondCellHeight;

@property (nonatomic, strong) GYHSMyCompanyInfoModel* model;

@property (nonatomic, copy) NSString* tempDateString;

@end

@implementation GYHSMyCompanyInfoVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    [self loadInitViewType:GYStopTypeLogout :^{
        @strongify(self);
        [self initView];
        [self loadCompanyAllInfo];
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
    
    self.importantInfoChageButton.imageEdgeInsets = UIEdgeInsetsMake(0, self.importantInfoChageButton.bounds.size.width - 14, 0, 0);
    self.importantInfoChageButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? self.titleArray.count : 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        GYHSMyCompanyInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:idCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title = self.titleArray[indexPath.row];
        if (self.contentArray.count == 4) {
            cell.content = self.contentArray[indexPath.row];
        }
        cell.indexPath = indexPath;
        return cell;
    }
    else {
        GYHSMyComanyFooterViewCell* footViewCell = [tableView dequeueReusableCellWithIdentifier:idSecondCell forIndexPath:indexPath];
        footViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        footViewCell.model = self.model;
        footViewCell.delegate = self;
        return footViewCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CGFloat height = 40.f;
    if (indexPath.section == 0) {
        if (self.contentArray.count == 4) {
            //584为UI上内容的宽度
            CGFloat textHeight = [self.contentArray[indexPath.row] boundingRectWithSize:CGSizeMake(kDeviceProportion(584), MAXFLOAT)
                                                                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                             attributes:@{ NSFontAttributeName : kFont32 }
                                                                                context:nil].size.height;
            if (40 < ceil(textHeight) + 18) {
                //多加18的文字间距
                height = ceil(textHeight) + 18;
            }
            else {
                height = 40.f;
            }
        }
    }
    return indexPath.section == 0 ? height : self.secondCellHeight;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    else {
        return 2;
    }
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

#pragma mark - GYHSMyComanyFooterViewCellDeleage
- (void)updateStandDateComplete:(dispatch_block_t)complete;
{
    [self showDatePickerView:^{
        @weakify(self);
        [self modifyCompanyInfoModifyType:ModifyTypeBuildDate
                                   parama:self.tempDateString
                                 complete:^{
                                     @strongify(self);
                                     self.model.buildDate = self.tempDateString;
                                     [self.baseTableView reloadData];
                                     if (complete) {
                                         complete();
                                     }
                                 }];
    }];
}

- (void)updateBusinessTime:(NSString*)modifyTime complete:(dispatch_block_t)complete
{
    [self.view endEditing:YES];
    if (modifyTime.length == 0) {
        [GYUtils showToast:kLocalized(@"GYHS_Myhs_PleaseInputContent")];
        return;
    }
    @weakify(self);
    [self modifyCompanyInfoModifyType:ModifyTypeEndDate
                               parama:modifyTime
                             complete:^{
                                 @strongify(self);
                                 self.model.endDate = modifyTime;
                                 [self.baseTableView reloadData];
                                 if (complete) {
                                     complete();
                                 }
                             }];
}

- (void)updateRunArea:(NSString*)modifyRunArea complete:(dispatch_block_t)complete
{
    [self.view endEditing:YES];
    if (modifyRunArea.length == 0) {
        [GYUtils showToast:kLocalized(@"GYHS_Myhs_PleaseInputContent")];
        return;
    }
    @weakify(self);
    [self modifyCompanyInfoModifyType:ModifyTypeBusinessScope
                               parama:modifyRunArea
                             complete:^{
                                 @strongify(self);
                                 self.model.businessScope = modifyRunArea;
                                 [self.baseTableView reloadData];
                                 if (complete) {
                                     complete();
                                 }
                             }];
}

- (void)updateCellHeight:(float)height
{
    self.secondCellHeight = height;
    [self.baseTableView reloadData];
}

#pragma mark - event response
- (void)importantInfoChageButtonAction
{
    //重要信息变更
    GYHSMyImportantInfoChageMainVC* vc = [[GYHSMyImportantInfoChageMainVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - request
- (void)loadCompanyAllInfo
{
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSCompanyAllInfo)
         parameter:@{ @"entCustId" : globalData.loginModel.entCustId }
           success:^(id returnValue) {
               
               if ([returnValue[GYNetWorkCodeKey] isEqualToNumber:@200]) {
                   self.model = [[GYHSMyCompanyInfoModel alloc] initWithDictionary:returnValue[GYNetWorkDataKey] error:nil];
                   self.contentArray = @[ kSaftToNSString(_model.entName),
                                          kSaftToNSString(_model.entRegAddr),
                                          kSaftToNSString(_model.nature),
                                          kSaftToNSString(_model.busiLicenseNo ) ];
                   [self.baseTableView reloadData];
               } else {
                   [GYUtils showToast:returnValue[@"msg"]];
               }
               
           }
           failure:^(NSError* error) {
               
           }
       isIndicator:YES];
}

- (void)modifyCompanyInfoModifyType:(ModifyType)type parama:(NSString*)parama complete:(dispatch_block_t)complete
{
    
    NSMutableDictionary* dicParams = @{
                                       @"entCustId" : globalData.loginModel.entCustId,
                                       @"operatorCustId" : globalData.loginModel.entCustId
                                       }.mutableCopy;
    switch (type) {
        case ModifyTypeBuildDate:
            [dicParams addEntriesFromDictionary:@{ @"buildDate" : parama }];
            break;
            
        case ModifyTypeEndDate:
            [dicParams addEntriesFromDictionary:@{ @"endDate" : parama }];
            break;
            
        case ModifyTypeBusinessScope:
            [dicParams addEntriesFromDictionary:@{ @"businessScope" : parama }];
            break;
            
        default:
            break;
    }
    
    [GYNetwork PUT:GY_HSDOMAINAPPENDING(GYHSUpdateBaseInfo)
         parameter:dicParams
           success:^(id returnValue) {
               
               if ([returnValue[GYNetWorkCodeKey] isEqualToNumber:@200]) {
                   [GYUtils showToast:returnValue[@"msg"]];
                   if (complete) {
                       complete();
                   }
               } else {
                   [GYUtils showToast:returnValue[@"msg"]];
               }
               
           }
           failure:^(NSError* error) {
               
           }
       isIndicator:YES];
}

#pragma mark - private methods
- (int)compareOneDay:(NSString*)oneDay withAnotherDay:(NSString*)anotherDay
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* dateA = [dateFormatter dateFromString:oneDay];
    NSDate* dateB = [dateFormatter dateFromString:anotherDay];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        //oneDay 比 anotherDay 晚
        return 1;
    }
    else if (result == NSOrderedAscending) {
        //oneDay 比 anotherDay 早
        return -1;
    }
    //两个日期相同
    return 0;
}

- (void)showDatePickerView:(dispatch_block_t)complete
{
    
    @weakify(self);
    GYDatePickView* view = [[GYDatePickView alloc] initWithDatePickViewType:DatePickViewTypeDate];
    view.dateBlcok = ^(NSString* dateString) {
        @strongify(self);
        NSDate* date = [NSDate date];
        NSString* dateToday = [[NSString stringWithFormat:@"%@", date] substringToIndex:10];
        if ([self compareOneDay:dateToday withAnotherDay:dateString] == -1) {
            [GYUtils showToast:kLocalized(@"GYHS_Myhs_StandDate_Must_Little_CurrentDate")];
            return;
        }
        self.tempDateString = dateString;
        complete();
    };
    [view show];
}

- (void)initView
{
    self.title = kLocalized(@"GYHS_Myhs_Company_Information");
    self.view.backgroundColor = kWhiteFFFFFF;
    DDLogInfo(@"Load Controller: %@", [self class]);
    self.secondCellHeight = cellHeight;
    [self addLeftView];
    [self addRight];
    
    [self.headImageView setImageWithURL:[NSURL URLWithString:GYHE_PICTUREAPPENDING(globalData.loginModel.vshopLogo)] placeholder:[UIImage imageNamed:@"gyhs_bigDefaultImage"]];
}

- (void)addLeftView
{
    [self.view addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.view).offset(44 + kDeviceProportion(48));
        make.left.equalTo(self.view).offset(kDeviceProportion(16));
        make.width.equalTo(@(kDeviceProportion(180)));
        make.height.equalTo(@(kDeviceProportion(150)));
    }];
    
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_headImageView.mas_bottom).offset(kDeviceProportion(15));
        make.left.equalTo(self.view).offset(kDeviceProportion(16));
        make.width.equalTo(@(kDeviceProportion(180)));
        make.height.equalTo(@(kDeviceProportion(25)));
    }];
    
    [self.view addSubview:self.resNoLabel];
    [self.resNoLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(kDeviceProportion(15));
        make.left.equalTo(self.view).offset(kDeviceProportion(16));
        make.width.equalTo(@(kDeviceProportion(180)));
        make.height.equalTo(@(kDeviceProportion(25)));
    }];
}

- (void)addRight
{
    [self.view addSubview:self.importantInfoChageButton];
    [self.importantInfoChageButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(self.view).offset(kDeviceProportion(-16));
        make.top.equalTo(self.view).offset(kDeviceProportion(11) + 44);
        make.height.equalTo(@(kDeviceProportion(27)));
        make.width.equalTo(@(kDeviceProportion(200)));
    }];
    
    [self.view addSubview:self.baseTableView];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.view).offset(44 + kDeviceProportion(63));
        make.left.equalTo(_headImageView.mas_right).offset(kDeviceProportion(16));
        make.right.equalTo(self.view).offset(kDeviceProportion(-16));
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - lazy load
- (UIImageView*)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.userInteractionEnabled = YES;
    }
    return _headImageView;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = kLocalized(@"GYHS_Myhs_Company_HS_Number");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = kFont36;
        _titleLabel.textColor = kGray666666;
    }
    return _titleLabel;
}

- (UILabel*)resNoLabel
{
    if (!_resNoLabel) {
        _resNoLabel = [[UILabel alloc] init];
        _resNoLabel.text = globalData.loginModel.entResNo;
        _resNoLabel.textAlignment = NSTextAlignmentCenter;
        _resNoLabel.font = kFont36;
        _resNoLabel.textColor = kGray333333;
    }
    return _resNoLabel;
}

- (UIButton*)importantInfoChageButton
{
    if (!_importantInfoChageButton) {
        _importantInfoChageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_importantInfoChageButton setImage:[UIImage imageNamed:@"gyhs_goArrow"] forState:UIControlStateNormal];
        [_importantInfoChageButton setImage:[UIImage imageNamed:@"gyhs_goArrow"] forState:UIControlStateHighlighted];
        _importantInfoChageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _importantInfoChageButton.titleLabel.font = kFont36;
        [_importantInfoChageButton setTitleColor:kBlue0A59C1 forState:UIControlStateNormal];
        [_importantInfoChageButton setTitle:kLocalized(@"GYHS_Myhs_Important_Application_Info_Changes") forState:UIControlStateNormal];
        [_importantInfoChageButton addTarget:self action:@selector(importantInfoChageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _importantInfoChageButton;
}
- (UITableView*)baseTableView
{
    if (!_baseTableView) {
        _baseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _baseTableView.showsHorizontalScrollIndicator = NO;
        _baseTableView.showsVerticalScrollIndicator = NO;
        [_baseTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSMyCompanyInfoCell class]) bundle:nil] forCellReuseIdentifier:idCell];
        [_baseTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSMyComanyFooterViewCell class]) bundle:nil] forCellReuseIdentifier:idSecondCell];
        _baseTableView.dataSource = self;
        _baseTableView.delegate = self;
        _baseTableView.backgroundColor = [UIColor whiteColor];
    }
    return _baseTableView;
}

- (NSArray*)titleArray
{
    if (!_titleArray) {
        _titleArray = @[ kLocalized(@"GYHS_Myhs_Company_Name_Colon"), kLocalized(@"GYHS_Myhs_Company_Address_Colon"), kLocalized(@"GYHS_Myhs_Company_Type_Colon"), kLocalized(@"GYHS_Myhs_Business_License_Nymber_Colon") ];
    }
    return _titleArray;
}

- (NSArray*)contentArray
{
    if (!_contentArray) {
        _contentArray = [NSArray array];
    }
    return _contentArray;
}

@end
