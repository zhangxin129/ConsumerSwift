//
//  GYHSUncouplingViewController.m
//  HSConsumer
//
//  Created by admin on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSUncouplingViewController.h"
#import "GYHSUncouplingTableViewCell.h"
#import "GYPasswordKeyboardView.h"
#import "IQKeyboardManager.h"

#define kUncouplingCell @"UncouplingTableViewCell"
#define kKeyBoardHeight kScreenWidth / 2

@interface GYHSUncouplingViewController () <UITableViewDataSource,UITableViewDelegate,GYPasswordKeyboardViewDelegate>

@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong) GYPasswordKeyboardView *keyboardView;
@property (nonatomic, assign) BOOL isCanCommit;
@property (nonatomic, copy) NSString *cardState;
@property (nonatomic, copy) NSString* passWordStr;
@property (nonatomic, strong) UIView *footerView;

@end

@implementation GYHSUncouplingViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    [self getAppendResult];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GYHSUncouplingTableViewCell *uncouplingCell = [tableView dequeueReusableCellWithIdentifier:kUncouplingCell forIndexPath:indexPath];
    uncouplingCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            uncouplingCell.titleLabel.text = kLocalized(@"互生卡号");
            uncouplingCell.contentTextField.text = kSaftToNSString(globalData.loginModel.resNo);
            uncouplingCell.contentTextField.userInteractionEnabled = NO;
            
        } else {
            uncouplingCell.titleLabel.text = kLocalized(@"互生卡状态");
            uncouplingCell.contentTextField.text = self.cardState;
            uncouplingCell.contentTextField.textColor = [UIColor redColor];
            uncouplingCell.contentTextField.userInteractionEnabled = NO;
        }
    } else {
        uncouplingCell.titleLabel.text = kLocalized(@"登录密码");
        uncouplingCell.contentTextField.placeholder = kLocalized(@"请输入6位登录密码");
        uncouplingCell.contentTextField.userInteractionEnabled = YES;
        uncouplingCell.contentTextField.secureTextEntry = YES;
        
        [self.keyboardView settingInputView:uncouplingCell.contentTextField];
        uncouplingCell.contentTextField.inputView = [[UIView alloc] initWithFrame:CGRectZero];//阻止系统键盘弹出
        [self.keyboardView pop:self.footerView];
        
    }
    return uncouplingCell;
}

#pragma mark -GYPasswordKeyboardViewDelegate
-(void)returnPasswordKeyboard:(GYPasswordKeyboardView *)passwordKeyboard style:(GYPasswordKeyboardStyle)style type:(GYPasswordKeyboardReturnType)type password:(NSString *)password {
    if (!self.isCanCommit) {
        [GYUtils showMessage:kLocalized(@"GYHS_BP_Points_Card_Number_State_Normal_Can't_Operation") confirm:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        return;
    }
    
    if (password.length != 6) {
        [GYUtils showToast:kLocalized(@"GYHS_BP_Placeholder_Verified_Pwd")];
        return;
    }
    [self uncouplingAction:password];
    
}

-(void)textFiledEdingChanged:(UITextField *)textField {
    if (textField.text.length > 6) {
        textField.text = [textField.text substringToIndex:6];
    }
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"互生卡解挂");
    self.automaticallyAdjustsScrollViewInsets = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    self.cardState = @"--";
    
    [self.view addSubview:self.tabView];
    [self.tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSUncouplingTableViewCell class]) bundle:nil] forCellReuseIdentifier:kUncouplingCell];
    
}

- (void)getAppendResult
{
    NSDictionary* allParas = @{ @"resNo" : kSaftToNSString(globalData.loginModel.resNo)};
    
    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:ksearchHsCardInfoByResNoUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            self.isCanCommit = NO;
            return ;
        }
        if (![responseObject[@"data"] isKindOfClass:[NSNull class]]) {
            if ([responseObject[@"data"] isEqualToNumber:@1]) {
                self.cardState = kLocalized(@"GYHS_BP_Normal");
                self.isCanCommit = NO;
            } else if ([responseObject[@"data"] isEqualToNumber:@2]) {
                self.cardState = kLocalized(@"GYHS_BP_Already_ReportLoss");
                self.isCanCommit = YES;
            } else {
                self.cardState = kLocalized(@"GYHS_BP_Stop_Use");
                self.isCanCommit = NO;
            }
        } else {
            self.cardState = kLocalized(@"GYHS_BP_Normal");
            self.isCanCommit = NO;
        }
        
        [self.tabView reloadData];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)uncouplingAction:(NSString *)passWord
{ //提交
    
    NSDictionary* allFixParas = @{
                                  @"custId" : globalData.loginModel.custId,
                                  @"loginPwd" : [kSaftToNSString(passWord) md5String16:globalData.loginModel.custId],
                                  @"cardStatus" : kHSCardStatusUnlock
                                  };
    NSMutableDictionary* allParas = [NSMutableDictionary dictionaryWithDictionary:allFixParas];
    
    [allParas setValue:globalData.loginModel.custId forKey:@"custId"];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kHSCardLossUnlockUrlString parameters:allParas requestMethod:GYNetRequestMethodPUT requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        [GYGIFHUD dismiss];
        if (error) {
            NSInteger  errorRetCode = [error code];
            if ( errorRetCode == 206)
            {
                [GYUtils showToast:kLocalized(@"GYHS_BP_Alternate_Card_Has_Hung")];
                return ;
            }
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        [GYUtils showMessage:kLocalized(@"GYHS_BP_Unlock_Success") confirm:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}


#pragma mark - lazyLoad
- (UITableView *)tabView {
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49) style:UITableViewStyleGrouped];
        _tabView.backgroundColor = kDefaultVCBackgroundColor;
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.sectionHeaderHeight = 0.1f;
        _tabView.sectionFooterHeight = 15.0f;
        
        _tabView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];

        _tabView.tableFooterView = [self addFooterView];
        _tabView.delaysContentTouches = NO;
    }
    return _tabView;
}

-(UIView *)addFooterView {

    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50 + kKeyBoardHeight)];
    UIView *topView  =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.footerView addSubview:topView];
    [self.footerView addSubview:self.keyboardView];

    return self.footerView;
}

- (GYPasswordKeyboardView *)keyboardView {
    if (!_keyboardView) {
        _keyboardView = [[GYPasswordKeyboardView alloc] init];
        _keyboardView.frame = CGRectMake(0, 50, kScreenWidth, kKeyBoardHeight);
        _keyboardView.style = GYPasswordKeyboardStyleLogin;
        _keyboardView.type = GYPasswordKeyboardReturnTypeConfirm;
        _keyboardView.colorType = GYPasswordKeyboardCommitColorTypeRed;
        _keyboardView.delegate = self;
    }
    return _keyboardView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
