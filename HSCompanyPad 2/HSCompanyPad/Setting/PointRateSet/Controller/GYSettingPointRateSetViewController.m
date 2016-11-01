//
//  GYHSPointRateViewController.m
//
//  Created by apple on 16/8/1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYSettingPointRateSetViewController.h"
#import "GYKeyboardTwoButtonView.h"
#import "GYPadKeyboradView.h"
#import "GYSettingHttpTool.h"
#import "GYSettingPointRateSetFootView.h"
#import "GYSettingPointRateSetTableViewCell.h"
#import "UITextField+GYHSPointTextField.h"
#import <GYKit/UIButton+GYExtension.h>

static NSString* idCell = @"settingPointRateSetTableViewCell";
static NSString* idFootView = @"settingPointRateSetFootView";

@interface GYSettingPointRateSetViewController () <GYPadKeyboradViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, GYKeyboardTwoButtonViewDelegate>

@property (nonatomic, strong) UITableView* rateTableView;
@property (nonatomic, strong) GYKeyboardTwoButtonView* rightKeyBoardView;
@property (nonatomic, strong) NSArray* titleArrary;
@property (nonatomic, strong) NSMutableArray* contentArray;
@property (nonatomic, weak) UITextField* textField;
@property (nonatomic, strong) NSArray* newContentArray;

@property (nonatomic, assign) BOOL isModify;
@property (nonatomic, assign) BOOL neverSetPoint;

@end

@implementation GYSettingPointRateSetViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDLogInfo(@"Show Controller: %@", [self class]);
    [self loadDataFromNet];
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArrary.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYSettingPointRateSetTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:idCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textFiled.delegate = self;
    if (self.contentArray.count > 0) {
        cell.textFiled.text = self.contentArray[indexPath.row];
    }
    cell.titleLabel.text = self.titleArrary[indexPath.row];
    if (indexPath.row == 0) {
        cell.titleLabel.textColor = kRedE50012;
        cell.textFiled.textColor = kRedE50012;
    }
    else {
        cell.titleLabel.textColor = kGray333333;
        cell.textFiled.textColor = kGray333333;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return kDeviceProportion(40.0);
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return kDeviceProportion(40.0);
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return kDeviceProportion(60.0);
}

- (nullable UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = kWhiteFFFFFF;
    return view;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    GYSettingPointRateSetFootView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:idFootView];
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@%@%@", kLocalized(@"GYSetting_Tip_Point_Rate_In_Front"), globalData.config.pointRateMin, kLocalized(@"GYSetting_To"), globalData.config.pointRateMax, kLocalized(@"GYSetting_Between")]];
    [attString setAttributes:@{ NSForegroundColorAttributeName : kRedE50012 } range:NSMakeRange(0, 3)];
    view.footTipLabel.attributedText = attString;
    return view;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    [self deleteLayerBorder:(UIView*)self.textField];
    self.textField = textField;
    [self needLayerBorder:(UIView*)self.textField];
    [textField resignFirstResponder];
}

- (void)needLayerBorder:(UIView*)view
{
    view.layer.borderWidth = 2;
    view.layer.borderColor = kBlue0A59C1.CGColor;
    view.layer.masksToBounds = YES;
}

- (void)deleteLayerBorder:(UIView*)view
{
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor clearColor].CGColor;
    view.layer.masksToBounds = YES;
}

#pragma mark - GYPadKeyboradViewDelegate
- (void)padKeyBoardViewDidClickNumberWithString:(NSString*)string
{
    if (self.textField == nil) {
        [GYUtils showToast:kLocalized(@"GYSetting_Please_Select_Input_View")];
        return;
    }
    DDLogInfo(@"%@", string);
    self.textField.text = [NSString stringWithFormat:@"%@%@", self.textField.text, string];
    self.textField.text = [self.textField subTextToLength:6];
    [self updatNewContentArray];
}

- (void)padKeyBoardViewDidClickDelete
{
    if (self.textField == nil) {
        [GYUtils showToast:kLocalized(@"GYSetting_Please_Select_Input_View")];
        return;
    }
    DDLogInfo(@"点击删除了");
    if (self.textField.text.length > 0) {
        self.textField.text = [self.textField.text substringToIndex:self.textField.text.length - 1];
    }
    else {
        return;
    }
    [self updatNewContentArray];
}

#pragma mark - GYKeyboardTwoButtonViewDelegate
- (void)keyboardTwoButtonViewFirstClick
{
    //点击取消
    [self.rateTableView reloadData];
}

-(void)keyboardTwoButtonViewSecondClick:(UIButton*)button
{
    //点击ok
    if (![self.contentArray isEqualToArray:self.newContentArray]) {
        [button controlTimeOut];
        if (self.neverSetPoint) {
            
            [self postDataToNet:self.newContentArray pointRateType:PointRateTypeSet
                       complete:nil];
        }
        else {
            [self postDataToNet:self.newContentArray pointRateType:PointRateTypeEdit
                       complete:^{
                           [self loadDataFromNet];
                           self.isModify = YES;
                       }];
        }
    }
    else {
//        [GYUtils showToast:kLocalized(@"GYSetting_Please_Modify_Point_Rate")];
    }
}

#pragma mark - request
/*!
 *    获取积分比例
 */
- (void)loadDataFromNet
{
    [self.contentArray removeAllObjects];
    [GYSettingHttpTool getEntPointRateList:^(id responsObject) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:responsObject];
        if (array.count == 0) {
            self.neverSetPoint = YES;
            array = @[ @"0.0100",
                       @"0.0200",
                       @"0.0300",
                       @"0.0400",
                       @"0.0500" ].mutableCopy;
            self.newContentArray = array;
        }
        for (NSString *str in array) {
            NSString *realStr = [NSString stringWithFormat:@"%.4f",[str doubleValue]];
            [self.contentArray addObject:realStr];
        }
        [self.rateTableView reloadData];
    }
                                   failure:^{
                                       
                                   }];
}

- (void)postDataToNet:(NSArray*)array pointRateType:(PointRateType)type complete:(void (^)(void))comlete
{
    if (array.count < 5) {
        //        [GYUtils showToast:kLocalized(@"GYSetting_Please_Modify_Point_Rate")];
        return;
    }
    NSString* str = [NSString string];
    for (NSString* s in array) {
        if (![self comparePointRate:s]) {
            [GYUtils showToast:[NSString stringWithFormat:@"%@%@%@%@%@。", kLocalized(@"GYSetting_Point_Rate_In_Front"), globalData.config.pointRateMin, kLocalized(@"GYSetting_To"), globalData.config.pointRateMax, kLocalized(@"GYSetting_Between")]];
            return;
        }
        else {
            str = [str stringByAppendingString:s];
            str = [str stringByAppendingString:@","];
        }
    }
    
    [GYSettingHttpTool editEntPointRateWithPointRate:str pointRateType:type success:^(id responsObject) {
        [GYUtils showToast:responsObject[@"msg"]];
        [kDefaultNotificationCenter postNotificationName:GYSetPointSuccesssNotification object:nil];
        if (comlete) {
            comlete();
        }
    } failure:^{
        
    }];
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYSetting_Point_Rate_Set");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    DDLogInfo(@"Load Controller: %@", [self class]);
    
    [self.view addSubview:self.rightKeyBoardView];
    [_rightKeyBoardView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavigationHeight);
        make.width.equalTo(@(kDeviceProportion(130)));
    }];
    
    GYPadKeyboradView* keyboradView = [[GYPadKeyboradView alloc] init];
    keyboradView.delegate = self;
    [self.view addSubview:keyboradView];
    [keyboradView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(_rightKeyBoardView.mas_left).offset(kDeviceProportion(5));
        make.top.equalTo(self.view).offset(kNavigationHeight);
        make.left.equalTo(self.view.mas_left).offset(kDeviceProportion(469));
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.view addSubview:self.rateTableView];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTouchs)];
    [self.rateTableView addGestureRecognizer:tap];
    [self.rateTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavigationHeight);
        make.right.equalTo(keyboradView.mas_left);
    }];
}

- (void)tableViewTouchs
{
    [self deleteLayerBorder:self.textField];
    self.textField = nil;
}

//比较积分比率大小
- (BOOL)comparePointRate:(NSString*)pointString
{
    NSDecimalNumber* pointRate = [NSDecimalNumber decimalNumberWithString:pointString];
    NSDecimalNumber* maxPointRate = [NSDecimalNumber decimalNumberWithString:globalData.config.pointRateMax];
    NSDecimalNumber* minPointRate = [NSDecimalNumber decimalNumberWithString:globalData.config.pointRateMin];
    
    NSComparisonResult resultMax = [pointRate compare:maxPointRate];
    NSComparisonResult resultMin = [pointRate compare:minPointRate];
    if (resultMax != NSOrderedDescending && resultMin != NSOrderedAscending) {
        return YES;
    }
    else {
        return NO;
    }
}

- (GYSettingPointRateSetTableViewCell*)getCellWithRow:(NSInteger)row
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    GYSettingPointRateSetTableViewCell* cell = [self.rateTableView cellForRowAtIndexPath:indexPath];
    return cell;
}

- (void)updatNewContentArray
{
    GYSettingPointRateSetTableViewCell* cell0 = [self getCellWithRow:0];
    GYSettingPointRateSetTableViewCell* cell1 = [self getCellWithRow:1];
    GYSettingPointRateSetTableViewCell* cell2 = [self getCellWithRow:2];
    GYSettingPointRateSetTableViewCell* cell3 = [self getCellWithRow:3];
    GYSettingPointRateSetTableViewCell* cell4 = [self getCellWithRow:4];
    self.newContentArray = @[
                             cell0.textFiled.text,
                             cell1.textFiled.text,
                             cell2.textFiled.text,
                             cell3.textFiled.text,
                             cell4.textFiled.text
                             ];
}

#pragma mark - lazy load
- (UITableView*)rateTableView
{
    if (!_rateTableView) {
        _rateTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rateTableView.scrollEnabled = NO;
        _rateTableView.backgroundColor = [UIColor whiteColor];
        [_rateTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYSettingPointRateSetTableViewCell class]) bundle:nil] forCellReuseIdentifier:idCell];
        [_rateTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYSettingPointRateSetFootView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:idFootView];
        _rateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rateTableView.delegate = self;
        _rateTableView.dataSource = self;
    }
    return _rateTableView;
}

- (GYKeyboardTwoButtonView*)rightKeyBoardView
{
    if (!_rightKeyBoardView) {
        _rightKeyBoardView = [[GYKeyboardTwoButtonView alloc] initWithTitle:kLocalized(@"GYSetting_Cancel")];
        _rightKeyBoardView.delegate = self;
    }
    return _rightKeyBoardView;
}

- (NSArray*)titleArrary
{
    if (!_titleArrary) {
        _titleArrary = @[ kLocalized(@"GYSetting_Default_Point_Rate"), kLocalized(@"GYSetting_Second_Point_Rate"), kLocalized(@"GYSetting_Third_Point_Rate"), kLocalized(@"GYSetting_Fourth_Point_Rate"), kLocalized(@"GYSetting_Fifth_Point_Rate") ];
    }
    return _titleArrary;
}

- (NSMutableArray*)contentArray
{
    if (!_contentArray) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}

- (NSArray*)newContentArray
{
    if (!_newContentArray) {
        _newContentArray = [NSArray array];
    }
    return _newContentArray;
}

@end
