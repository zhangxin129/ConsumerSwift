//
//  GYHSStaffManagerViewController.m
//  HSCompanyPad
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//
/**
 *     操作绑定互生卡完成确认时，提示用户已完成互生卡绑定，请持卡人登录个人平台完成确认绑定操作；持卡人未确认同意绑定操作时，互生卡登录绑定显示绑定互生卡号，显示“待确认”提示，提供“取消绑定”按钮操作，如果超过24小时持卡人没有同意绑定操作，则不显示互生卡号，只显示“绑定互生卡”按钮；
 系统预设的操作员（企业系统管理员、超级用户）不能进行修改、停用（启用）、删除、角色设置操作，新增加的操作员可以进行修改、停用（启用）、删除、角色设置操作；
 当对新增操作员进行修改、停用（启用）、删除、角色设置设置时，权限立即生效，即时操作员已登录企业系统平台，也不能够进行提交操作，提示该操作员已被禁止或者受到限制提示框.
 */
#import "GYHSStaffManagerViewController.h"
#import "GYHSStaffManagerTableViewCell.h"
#import "GYHEFoodTitleViewController.h"
#import "GYHSAddStaffViewController.h"
#import "UILabel+Category.h"
#import "GYHSChangeStaffViewController.h"
#import "GYHSStaffHttpTool.h"
#import "GYHSStaffManModel.h"


static NSString *staffManagerTableViewCellID = @"GYHSStaffManagerTableViewCell";

@interface GYHSStaffManagerViewController ()<UITableViewDelegate, UITableViewDataSource,GYHSOperatorInfoCellDelegate,GYHEFoodTitleViewControllerDelegate,GYAlertTextViewDelegate>

@property(nonatomic, strong) UITableView *staffTableView;
@property (nonatomic, strong) NSMutableArray *dutyArr;
@property (nonatomic, copy) NSString *roleString;
@property (nonatomic, strong) NSMutableArray *shopNameDataArray;
@property (nonatomic , strong) NSMutableArray *dataSourceArr;
@property (nonatomic, strong) GYHSStaffManModel *staffModel;
@property (nonatomic, strong) NSMutableArray *recRoleArray;
@property (nonatomic, copy) NSString *oprcusIdStr;
@property (nonatomic, strong) NSMutableArray *recShopNameArray;
@property (nonatomic, copy) NSString *userNameStr;
@property (nonatomic, copy) NSString *shopOprcusIdStr;
@property (nonatomic, strong) NSArray *roleArray;
@property (nonatomic, copy) NSString *blindOprcusIdStr;
@property (nonatomic, copy) NSString *cardNumStr;
@property (nonatomic, copy) NSString *passwordStr;
@property (nonatomic, copy) NSString *unPasswordStr;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, copy) NSString *adminCustId;

@property (nonatomic, assign) BOOL isTip;//为了解决互动重复弹出提示框的问题，现在加一个字段判断当前是否弹出提示框

@end

@implementation GYHSStaffManagerViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self requestOpretatorList];
    [self requestGetRoleList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createTableView];
    
}
/**
 *  懒加载数据源
 *
 */
#pragma mark - 懒加载
-(NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc] init];
    }
    return _dataSourceArr;
}

- (NSMutableArray *)dutyArr{
    if (!_dutyArr) {
        _dutyArr = [[NSMutableArray alloc] init];
    }
    return _dutyArr;
}

- (NSMutableArray *)shopNameDataArray{
    if (!_shopNameDataArray) {
        _shopNameDataArray = [[NSMutableArray alloc] init];
    }
    return _shopNameDataArray;
}
/**
 *  创建头部视图
 */
- (void)createUI{

    self.title = kLocalized(@"GYHS_StaffManager_StaffManager");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    
    UIView *listHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kDeviceProportion(kScreenWidth), kDeviceProportion(70))];
    UIImageView *listHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(kScreenWidth), kDeviceProportion(70))];
    [listHeadImageView setImage:[UIImage imageNamed:@"gycom_search_back"]];
    [listHeadView addSubview:listHeadImageView];
    [self.view addSubview:listHeadView];
    
    float nameLableW = 97;
    float stateLableW = 96;
    float userNameLableW = 119;
    float actorLableW = 118;
    float roleLableW = 147;
    float shopNameLableW = 146;
    float HSCardBlindingLableW = 146;
    float cusSerSwitchW = 104;
    float operateW = 345.0/2;
    float lableH = 30;
    
    UILabel *nameLable = [[UILabel alloc] init];
    [nameLable initWithText:kLocalized(@"GYHS_StaffManager_EmployeeName") TextColor:kGray777777 Font:[UIFont systemFontOfSize:15] TextAlignment:1];
    [listHeadView addSubview:nameLable];
    [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listHeadView.mas_top).offset(25);
        make.left.equalTo(listHeadView.mas_left).offset(10);
        make.width.equalTo(@(kDeviceProportion(nameLableW)));
        make.height.equalTo(@(kDeviceProportion(lableH)));
    }];
    
    
    UILabel *stateLable = [[UILabel alloc] init];
    [stateLable initWithText:kLocalized(@"GYHS_StaffManager_State") TextColor:kGray777777 Font:[UIFont systemFontOfSize:15] TextAlignment:1];
    [listHeadView addSubview:stateLable];
    [stateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listHeadView.mas_top).offset(25);
        make.left.equalTo(listHeadView.mas_left).offset(10 + nameLableW);
        make.width.equalTo(@(kDeviceProportion(stateLableW)));
        make.height.equalTo(@(kDeviceProportion(lableH)));
    }];
    
    UILabel *userNameLable = [[UILabel alloc] init];
    [userNameLable initWithText:kLocalized(@"GYHS_StaffManager_LoginUsername") TextColor:kGray777777 Font:[UIFont systemFontOfSize:15] TextAlignment:0];
    [listHeadView addSubview:userNameLable];
    [userNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listHeadView.mas_top).offset(25);
        make.left.equalTo(stateLable.mas_left).offset(stateLableW);
        make.width.equalTo(@(kDeviceProportion(userNameLableW)));
        make.height.equalTo(@(kDeviceProportion(lableH)));
    }];
    
    UILabel *actorLable = [[UILabel alloc] init];
    [actorLable initWithText:kLocalized(@"GYHS_StaffManager_Post") TextColor:kGray777777 Font:[UIFont systemFontOfSize:15] TextAlignment:1];
    [listHeadView addSubview:actorLable];
    [actorLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listHeadView.mas_top).offset(25);
        make.left.equalTo(userNameLable.mas_left).offset(userNameLableW);
        make.width.equalTo(@(kDeviceProportion(actorLableW)));
        make.height.equalTo(@(kDeviceProportion(lableH)));
    }];

    
    UILabel *roleLable = [[UILabel alloc] init];
    [roleLable initWithText:kLocalized(@"GYHS_StaffManager_Role") TextColor:kGray777777 Font:[UIFont systemFontOfSize:15] TextAlignment:1];
    [listHeadView addSubview:roleLable];
    [roleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listHeadView.mas_top).offset(25);
        make.left.equalTo(actorLable.mas_left).offset(actorLableW);
        make.width.equalTo(@(kDeviceProportion(roleLableW)));
        make.height.equalTo(@(kDeviceProportion(lableH)));
    }];
    
    
    UILabel *HSCardBlindingLable = [[UILabel alloc] init];
    [HSCardBlindingLable initWithText:kLocalized(@"GYHS_StaffManager_HScardLoginBind") TextColor:kGray777777 Font:[UIFont systemFontOfSize:15] TextAlignment:1];
    [listHeadView addSubview:HSCardBlindingLable];
    [HSCardBlindingLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listHeadView.mas_top).offset(25);
        make.left.equalTo(roleLable.mas_left).offset(shopNameLableW);
        make.width.equalTo(@(kDeviceProportion(HSCardBlindingLableW)));
        make.height.equalTo(@(kDeviceProportion(lableH)));
    }];
    
    
    UILabel *cusSerSwitchLable = [[UILabel alloc] init];
    [cusSerSwitchLable initWithText:kLocalized(@"GYHS_StaffManager_CustomerServiceFunction") TextColor:kGray777777 Font:[UIFont systemFontOfSize:15] TextAlignment:1];
    [listHeadView addSubview:cusSerSwitchLable];
    [cusSerSwitchLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listHeadView.mas_top).offset(25);
        make.left.equalTo(HSCardBlindingLable.mas_left).offset(HSCardBlindingLableW);
        make.width.equalTo(@(kDeviceProportion(cusSerSwitchW)));
        make.height.equalTo(@(kDeviceProportion(lableH)));
    }];
    
    UILabel *oprateLable = [[UILabel alloc] init];
    [oprateLable initWithText:kLocalized(@"GYHS_StaffManager_Operation") TextColor:kGray777777 Font:[UIFont systemFontOfSize:15] TextAlignment:1];
    [listHeadView addSubview:oprateLable];
    [oprateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listHeadView.mas_top).offset(25);
        make.left.equalTo(cusSerSwitchLable.mas_left).offset(cusSerSwitchW);
        make.width.equalTo(@(kDeviceProportion(operateW)));
        make.height.equalTo(@(kDeviceProportion(lableH)));
    }];

}

/**
 *  创建员工列表的视图
 */
-(void)createTableView{
    self.staffTableView = [[UITableView alloc] init];
    self.staffTableView.frame = CGRectMake(20, 114, kDeviceProportion(kScreenWidth - 40), kDeviceProportion(kScreenHeight - 44 - 70 - 62 - 44 - 50));
    self.staffTableView.layer.borderColor = kGrayDDDDDD.CGColor;
    self.staffTableView.layer.borderWidth = 1.0f;
    self.staffTableView.delegate = self;
    self.staffTableView.dataSource = self;
    [self.view addSubview:self.staffTableView];

    _footerView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.staffTableView.frame), kDeviceProportion(kScreenWidth - 40), kDeviceProportion(50))];
    _footerView.backgroundColor = kWhiteFFFFFF;
    _footerView.layer.borderWidth = 1.0f;
    _footerView.layer.borderColor = kGrayDDDDDD.CGColor;
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake((kScreenWidth - 40 - 100) / 2, 18, kDeviceProportion(15), kDeviceProportion(15));
    [addButton setBackgroundImage:[UIImage imageNamed:@"gyhs_add_address"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addStaff) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:addButton];
    
    UIButton *addStaffButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addStaffButton.frame = CGRectMake(CGRectGetMaxX(addButton.frame) + 5, 10, kDeviceProportion(100), kDeviceProportion(30));
    [addStaffButton setTitle:kLocalized(@"GYHS_StaffManager_AddNewOperator") forState:UIControlStateNormal];
    [addStaffButton setTitleColor:kBlue0A59C2 forState:UIControlStateNormal];
    [addStaffButton addTarget:self action:@selector(addStaff) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:addStaffButton];
    [self.view addSubview:_footerView];

}

/**
 *  底部新增员工按钮的事件
 */
- (void)addStaff{
    
    GYHSAddStaffViewController *addStaffViewController = [[GYHSAddStaffViewController alloc] init];
    addStaffViewController.title = kLocalized(@"GYHS_StaffManager_AddNewOperator");
    [self.navigationController pushViewController:addStaffViewController animated:YES];
    
}

#pragma mark - request
/**
 *  查询员工列表的网络请求
 */
- (void)requestOpretatorList{
    @weakify(self);
    [GYHSStaffHttpTool getOperatorListWithEntCustId:globalData.loginModel.entCustId success:^(id responsObject) {
       @strongify(self);
        self.dataSourceArr = (NSMutableArray *)responsObject;
        [self.dataSourceArr enumerateObjectsUsingBlock:^(GYHSStaffManModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.userName isEqualToString:@"0000"]) {
                self.adminCustId = obj.operCustId;
            }
        }];
        [self.staffTableView reloadData];
    } failure:^{
        
    }];

}
/**
 *  查询角色列表的网络请求
 */
- (void)requestGetRoleList{
    @weakify(self);
    [GYHSStaffHttpTool getRoleList:^(id responsObject) {
        @strongify(self);
        self.dutyArr = (NSMutableArray *)responsObject;
        
//        for (GYRoleListModel *selectModel in self.staffModel.roleList) {
//            for (GYRoleListModel *model in self.dutyArr) {
//                    if ([selectModel.roleId isEqualToString:model.roleId]) {
//                        NSMutableArray *arr = [NSMutableArray alloc].mutableCopy;
//                        [arr addObject:selectModel.roleId];
//                    }
//                }
//            }
    } failure:^{
        
    }];

}
/**
 *  删除员工操作的网络请求
 */
- (void)requestDeletOpretor:(GYHSStaffManModel *)model{

    [GYHSStaffHttpTool deleteOperatorOperCustId:model.operCustId entResNo:model.entResNo userName:model.userName success:^(id responsObject) {
        [GYUtils showToast:kLocalized(@"GYHS_StaffManager_DeletedSuccessfully")];
        [self requestOpretatorList];
    } failure:^{
        
    }];

}
/**
 *  绑定角色操作的网络接口
 */
- (void)requestGrantRole{
    
    NSMutableArray* roleListArr = @[].mutableCopy;
    
    for (GYRoleListModel* model in self.recRoleArray) {
        [roleListArr addObject:model.roleId];
    }
    [GYHSStaffHttpTool grantRoleWithRoleList:[roleListArr componentsJoinedByString:@","] operCustId:self.oprcusIdStr success:^(id responsObject) {
         [GYUtils showToast:kLocalized(@"GYHS_StaffManager_BandingSuccess")];
        [self requestOpretatorList];
    } failure:^{
        
    }];

}

/**
 *  绑定互生卡操作的网络请求
 */
- (void)requestBlindingHSCard:(GYAlertWithTwoTextView *)textview{
    
    if (self.cardNumStr.length == 0) {
        [GYUtils showToast:kLocalized(@"GYHS_StaffManager_PleaseEnterTheHSCardNumber")];
        return;
    }
    if (![self.cardNumStr isValidNumber]) {
        [GYUtils showToast:kLocalized(@"GYHS_StaffManager_TheHSCardNumberMustBePureNumber")];
        return;
    }
    
    if (self.passwordStr.length == 0) {
        [GYUtils showToast:kLocalized(@"GYHS_StaffManager_PleaseEnterTheAdministratorLoginPassword")];
        return;
    }
    
    [GYHSStaffHttpTool bindCardLoginOperCustId:self.blindOprcusIdStr operResNo:self.cardNumStr adminLoginPwd:self.passwordStr success:^(id responsObject) {
        if (kHTTPSuccessResponse(responsObject)) {
            [GYUtils showToast:kLocalized(@"GYHS_StaffManager_OpeManager_HScardLoginBindSetSuccessfully!PleaseUseThis alternate HSCardNumberLoginConsumptionIntegralManagementPlatformCompleteBindingAcknowledgment!")];
            [textview removeFromSuperview];
            [self requestOpretatorList];
        }
        
    } failure:^{
        
    }];
}
/**
 *  解除绑定互生卡操作的网络请求
 */
- (void)requestUnBlindingHSCard{
    [GYHSStaffHttpTool unBindCardLoginOperCustId:self.blindOprcusIdStr loginPwd:self.unPasswordStr success:^(id responsObject) {
        [GYUtils showToast:kLocalized(@"GYHS_StaffManager_HSCardCancelBindSuccess!")];
        [self requestOpretatorList];
    } failure:^{
        
    }];

}
/**
 *  修改客服功能
 */
-(void) requestChangeCustomerServiceFunction:(NSString *)operTypeStr model:(GYHSStaffManModel *)model{
    [GYHSStaffHttpTool editOperatorCustomerServiceFunctionRealName:model.realName operDuty:model.operDuty operCustId:model.operCustId remark:model.remark mobile:model.mobile accountStatus:model.accountStatus operType:operTypeStr success:^(id responsObject) {
        [GYUtils showToast:kLocalized(@"GYHS_StaffManager_UpdateSuccess")];
        [self requestOpretatorList];
    } failure:^{
        
    }];

}
#pragma mark - UITableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSourceArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GYHSStaffManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:staffManagerTableViewCellID];
    if(cell == nil) {
        cell  = [[GYHSStaffManagerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:staffManagerTableViewCellID];
    }
    GYHSStaffManModel *model = self.dataSourceArr[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GYHSStaffManModel *model = self.dataSourceArr[indexPath.row];
    return model.fCellHeight;
}

#pragma mark - GYHSOperatorInfoCellDelegate
/**
 *  绑定角色的操作，只能对首位为0的用户操作（0000的超级管理员不能进行此操作）
 */
- (void)postAction:(GYHSStaffManModel *)model roleArr:(NSMutableArray *)roleArr{
    if (model.userName.integerValue > 999) {
        [GYUtils showToast:kLocalized(@"GYHS_StaffManager_OperatorUsernameOfTheFirstDigitShallBe0!")];
        return;
    }
    
    GYHEFoodTitleViewController * foodCtl = [[GYHEFoodTitleViewController alloc]initWithFrame:CGRectMake((kScreenWidth - 250)/2,
                                                                                                         (kScreenHeight - 300)/2,kDeviceProportion(300), kDeviceProportion(400)) titleArray:self.dutyArr heardTitle:@"" select:YES];
    foodCtl.delegate = self;
    foodCtl.roleIdArray = roleArr;
    self.oprcusIdStr = model.operCustId;
    [self addChildViewController:foodCtl];
    [self.view addSubview:foodCtl.view];
    UIWindow * win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:foodCtl.view];
    
}
/**
 *  修改员工的操作，只能对首位为0的用户操作（0000的超级管理员不能进行此操作）
 *
 */
-(void)changeAction:(GYHSStaffManModel *)model{
    if (model.userName.integerValue > 999) {
        [GYUtils showToast:kLocalized(@"GYHS_StaffManager_OperatorUsernameOfTheFirstDigitShallBe0!")];
        return;
    }
    GYHSChangeStaffViewController *changeStaffViewController = [[GYHSChangeStaffViewController alloc] init];
    changeStaffViewController.model = model;
    changeStaffViewController.adminCustId = self.adminCustId;
    [self.navigationController pushViewController:changeStaffViewController animated:YES];
}
/**
 *  删除员工的操作，只能对首位为0的用户操作（0000的超级管理员不能进行此操作）
 */
-(void)deleteAction:(GYHSStaffManModel *)model{
    NSString *messageStr = [NSString stringWithFormat:@"%@%@？",kLocalized(@"GYHS_StaffManager_ConfirmToDeleteUsername"),model.userName];
    [GYAlertView alertWithTitle:kLocalized(@"GYHS_StaffManager_Tip") Message:messageStr topColor:0 comfirmBlock:^{
        [self requestDeletOpretor:model];
    }];

}
/**
 *  绑定和解除绑定互生卡的操作，只能对首位为0的用户操作
 */
-(void)blingingCardAction:(GYHSStaffManModel *)model{
    if (model.userName.integerValue > 999) {
        [GYUtils showToast:kLocalized(@"GYHS_StaffManager_OperatorUsernameOfTheFirstDigitShallBe0!")];
        return;
    }
    self.blindOprcusIdStr = model.operCustId;
    if ([model.bindResNoStatus isEqualToString:@"0"]) {
        GYAlertWithTwoTextView *alertView = [[GYAlertWithTwoTextView alloc] initWithTitle:kLocalized(@"GYHS_StaffManager_HScardLoginBind") userNameTF:kLocalized(@"GYHS_StaffManager_BlindingHSCardNumber:") passWordTF:kLocalized(@"GYHS_StaffManager_AdministratorLoginPassword:") leftButtonTitle:kLocalized(@"GYHS_StaffManager_Confirm") rightButtonTitle:nil];
        alertView.rightbtn.hidden = YES;
        alertView.delegate = self;
        alertView.leftbtn.frame = CGRectMake((325 - 90) / 2, 258 - 35 - 33 , 90, 33);
        [alertView show];
    }else if([model.bindResNoStatus isEqualToString:@"-1"]){
        GYAlertWithTwoTextView *alertView = [[GYAlertWithTwoTextView alloc] initWithTitle:kLocalized(@"GYHS_StaffManager_HScardLoginBind") userNameTF:kLocalized(@"GYHS_StaffManager_BlindingHSCardNumber:") passWordTF:kLocalized(@"GYHS_StaffManager_AdministratorLoginPassword:") leftButtonTitle:kLocalized(@"GYHS_StaffManager_Confirm") rightButtonTitle:kLocalized(@"GYHS_StaffManager_Unblinding")];
        alertView.leftbtn.hidden = YES;
        alertView.userNameTextField.text = [GYUtils formatCardNo:model.operResNo];
        alertView.delegate = self;
        alertView.rightbtn.frame = CGRectMake((325 - 90) / 2, 258 - 35 - 33 , 90, 33);
        [alertView show];

    }else{
        GYAlertWithTwoTextView *alertView = [[GYAlertWithTwoTextView alloc] initWithTitle:kLocalized(@"GYHS_StaffManager_HScardLoginBind") userNameTF:kLocalized(@"GYHS_StaffManager_BlindingHSCardNumber:") passWordTF:kLocalized(@"GYHS_StaffManager_AdministratorLoginPassword:") leftButtonTitle:kLocalized(@"GYHS_StaffManager_Confirm") rightButtonTitle:kLocalized(@"解除绑定")];
        alertView.leftbtn.hidden = YES;
        alertView.userNameTextField.text = [GYUtils formatCardNo:model.operResNo];
        alertView.delegate = self;
        alertView.rightbtn.frame = CGRectMake((325 - 90) / 2, 258 - 35 - 33 , 90, 33);
        [alertView show];
    
    }
}

-(void)switchAction:(GYHSStaffManModel *)model switch:(UISwitch *)cusSwitch{
    
    if (self.isTip) {
        return;
    }
    NSString *operTypeStr;
    BOOL isOn = [cusSwitch isOn];
    if (isOn) {
        operTypeStr = @"1";
    }else{
        operTypeStr = @"0";
    }
    self.isTip =  YES;
    [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"确定修改客服功能？") topColor:1 comfirmBlock:^{
        [self requestChangeCustomerServiceFunction:operTypeStr model:model];
        self.isTip = NO;
    }];
}

#pragma GYHEFoodTitleViewControllerDelegate
- (void)transSelectedRoleArray:(NSMutableArray *)selectArray{
    self.recRoleArray = selectArray;
    [self requestGrantRole];
}

#pragma mark -- GYAlertTextViewDelegate
- (void)transPassword:(NSString *)password{
    self.unPasswordStr = password;
    [self requestUnBlindingHSCard];
}

- (void)transAlertView:(GYAlertWithTwoTextView *)alertView CardNum:(NSString *)cardNum Password:(NSString *)password{
    self.cardNumStr = cardNum;
    self.passwordStr = password;
    [self requestBlindingHSCard:alertView];

}

@end
