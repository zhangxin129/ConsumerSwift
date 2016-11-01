//
//  GYSystemSettingsViewController.m
//  GYCompany
//
//  Created by apple on 15/9/29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSystemSettingsViewController.h"
#import "GYSystemSettingViewModel.h"
#import "GYSystemSettingModel.h"
#import "GYSelectedButton.h"
#import "GYSystemSettingModel.h"
#import "GYGIFHUD.h"
#import "GYDeliveryStaffManagementViewController.h"


#define kMenuHeight 40

@interface GYSystemSettingsViewController ()<GYSelectedButtonDelegate,UIAlertViewDelegate>
{
    GYSelectedButton *btnSelectBusinessPoint;
    GYSelectedButton *btnDisplayStyle;
    UITextField *tfMaxFood;
    GYSelectedButton *btnLockScreenTime;
    GYSelectedButton *btnDataUpdate;
    GYSelectedButton *btnImgUpdate;
    
    UILabel *lbShowCompanyResource;
    UILabel *lbShowCompanyName;
    
    UIScrollView * svBack;
    
    UIAlertView *_blert;
    NSString*_cachPath;//沙盒路径
    CGFloat _fileSize;//沙盒文件大小
}
@property (nonatomic, strong) NSMutableArray *dataArrOperatingPoint;
@property (nonatomic, strong) GYSystemSettingModel *model;

@property (nonatomic, copy) NSString *updateDataTime;

@property (nonatomic, strong) NSTimer *timerB;

@end

@implementation GYSystemSettingsViewController
#pragma mark - 系统方法
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    self.navigationItem.leftBarButtonItem = [Utils createBackButtonWithTitle:kLocalized(@"SystemSettings") withTarget:self withAction:@selector(popBack)];
    
    [self initUI];
   
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    
    //  获得文件的大小
    _fileSize= [self folderSizeAtPath:_cachPath];
    
    //    [btnDisplayStyle dataSourceArr:[NSMutableArray arrayWithObjects:kLocalized(@"Classic"),kLocalized(@"Flat"),kLocalized(@"Elegant"), nil]];
    
    //    [btnLockScreenTime dataSourceArr:[NSMutableArray arrayWithObjects:
    //                                      kLocalizedAddParams(@"3", kLocalized(@"Minutes")),
    //                                      kLocalizedAddParams(@"6", kLocalized(@"Minutes")),
    //                                      kLocalizedAddParams(@"9", kLocalized(@"Minutes")),
    //                                      nil]];
    [btnDataUpdate dataSourceArr:[NSMutableArray arrayWithObjects:
                                  kLocalizedAddParams(kLocalized(@"once"), kLocalized(@"Hours")),
                                  kLocalizedAddParams(kLocalized(@"once"), kLocalized(@"day")),
                                  nil]];
    [btnImgUpdate dataSourceArr:[NSMutableArray arrayWithObjects:
                                 kLocalizedAddParams(@"10", kLocalized(@"Hours")),
                                 kLocalizedAddParams(@"20", kLocalized(@"Hours")),
                                 kLocalizedAddParams(@"30", kLocalized(@"Hours")),
                                 nil]];
    
}


#pragma mark - 更新数据 定时器更新菜品以及菜品列表
- (void)changeTimeAtTimedisplay
{
    [self httpGetFoodCategoryList];
    [self httpGetSyncShopFoods];
    
}

//一个app 退出前 执行的最后的一个方法

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

#pragma mark - 创建视图
- (void)initUI
{
    svBack = [[UIScrollView alloc ] initWithFrame:self.view.bounds];
    svBack.showsVerticalScrollIndicator = NO;
    svBack.contentSize = CGSizeMake(kScreenWidth,kScreenHeight);
    svBack.userInteractionEnabled = YES;
    [self.view addSubview:svBack];
    
    UIImageView *imgViewLine = [[UIImageView alloc]init];
    imgViewLine.image = [UIImage imageNamed:@"redline.png"];
    [svBack addSubview:imgViewLine];
    [imgViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@(2));
        
    }];
    
    
    UIView *v1 = [self createdViewWithX:0 y:0 width:kScreenWidth height:200];
    UILabel *lbCompanyResource = [self createdLableWithText:kLocalizedAddParams(kLocalized(@"HSEnterpriseNumber"), @":") textColor:[UIColor darkGrayColor]];
    lbCompanyResource.textAlignment = NSTextAlignmentRight;
    [v1 addSubview:lbCompanyResource];
    [lbCompanyResource mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(20);
        make.left.equalTo(v1.mas_left).offset(10);
        make.width.equalTo(@(kScreenWidth / 3 - 30));
        make.height.equalTo(@40);
    }];
    
    NSString *reNo = kLocalized(@"ForFailure");
    if (globalData.loginModel.entResNo.length > 0) {
        reNo = [NSString stringWithFormat:@"  %@",globalData.loginModel.entResNo];
    }
    lbShowCompanyResource = [self createdLableWithText:reNo textColor:[UIColor darkGrayColor]];
    lbShowCompanyResource.layer.borderColor = [UIColor colorWithRed:100.0/255.0 green:135.0/255.0 blue:185.0/255.0 alpha:1].CGColor;//边框颜色,要为CGColor
    lbShowCompanyResource.layer.borderWidth = 1;//边框宽度
    [v1 addSubview:lbShowCompanyResource];
    [lbShowCompanyResource mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(20);
        make.left.equalTo(lbCompanyResource.mas_right).offset(10);
        make.width.equalTo(@(kScreenWidth / 3 - 30));
        make.height.equalTo(@40);
    }];
    NSString *companyN = kLocalized(@"ForFailure");
    if (globalData.loginModel.entCustName.length > 0) {
        companyN = [NSString stringWithFormat:@"  %@",globalData.loginModel.entCustName];
    }
    lbShowCompanyName = [self createdLableWithText:companyN textColor:[UIColor colorWithRed:0.0/225.0 green:91.0/255.0 blue:168.0/255.0 alpha:0.8]];
    lbShowCompanyName.textAlignment = NSTextAlignmentLeft;
    [v1 addSubview:lbShowCompanyName];
    [lbShowCompanyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(20);
        make.left.equalTo(lbShowCompanyResource.mas_right).offset(40);
        make.right.equalTo(v1.mas_right).offset(-10);
        make.height.equalTo(@40);
    }];
    UILabel *lbSelectBusinessPoint = [self createdLableWithText:kLocalizedAddParams(kLocalized(@"SelectAnEstablishment"), @":") textColor:[UIColor darkGrayColor]];
    lbSelectBusinessPoint.textAlignment = NSTextAlignmentRight;
    [v1 addSubview:lbSelectBusinessPoint];
   
    [lbSelectBusinessPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(80);
        make.left.equalTo(v1.mas_left).offset(10);
        make.width.equalTo(@(kScreenWidth / 3 - 30));
        make.height.equalTo(@40);
    }];
    
    
    btnSelectBusinessPoint = [[GYSelectedButton alloc]init];
    btnSelectBusinessPoint.delegate = self;
    btnSelectBusinessPoint.tag = 100;
    
    [v1 addSubview:btnSelectBusinessPoint];
    [btnSelectBusinessPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(80);
        make.left.equalTo(lbSelectBusinessPoint.mas_right).offset(10);
        make.width.equalTo(@(kScreenWidth / 3 - 30));
        make.height.equalTo(@40);
    }];
    
    if (kGetNSUser(@"shopName")) {
        
        [btnSelectBusinessPoint setTitle:kGetNSUser(@"shopName") forState:UIControlStateNormal];
    }else{
        [btnSelectBusinessPoint setTitle:kLocalized(@"PleaseSelect") forState:UIControlStateNormal];
    }
   

    UIButton *btnImmediatelyUpdateBusinessPoint = [self createdButtonTitle:kLocalized(@"UpdateImmediately") titleColor:[UIColor darkGrayColor] backgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:0.8] fontSize:20.0];
    btnImmediatelyUpdateBusinessPoint.tag = 106;
    [v1 addSubview:btnImmediatelyUpdateBusinessPoint];
    [btnImmediatelyUpdateBusinessPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(80);
        make.left.equalTo(btnSelectBusinessPoint.mas_right).offset(50);
        make.width.equalTo(@(150));
        make.height.equalTo(@40);
    }];
  
    
    UILabel *maxFood = [self createdLableWithText:kLocalizedAddParams(kLocalized(@"IndividualDishesCanBeAMaximumNumberOfPoints"), @":") textColor:[UIColor darkGrayColor]];
    maxFood.textAlignment = NSTextAlignmentRight;
    [v1 addSubview:maxFood];
    
    [maxFood mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(140);
        make.left.equalTo(v1.mas_left).offset(10);
        make.width.equalTo(@(kScreenWidth / 3 - 30));
        make.height.equalTo(@40);
    }];
    
    
    
    tfMaxFood = [[UITextField alloc]init];
    tfMaxFood.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, tfMaxFood.height)];
    tfMaxFood.leftViewMode = UITextFieldViewModeAlways;
    tfMaxFood.background = [UIImage imageNamed:@"blueBox.png"];
    tfMaxFood.keyboardType = UIKeyboardTypeNumberPad;
    tfMaxFood.delegate = self;
    
    if (kGetNSUser(@"maxFood")) {
        tfMaxFood.text = kGetNSUser(@"maxFood");
    }
  
    [v1 addSubview:tfMaxFood];
    [tfMaxFood mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(140);
        make.left.equalTo(lbSelectBusinessPoint.mas_right).offset(10);
        make.width.equalTo(@(kScreenWidth / 3 - 30));
        make.height.equalTo(@40);
    }];
      tfMaxFood.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    
    UIImageView *img1 = [[UIImageView alloc]init];
    img1.image = [UIImage imageNamed:@"dottedline.png"];
    [v1 addSubview:img1];
    [img1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(198);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@2);
    }];
    
    UIView *v2 = [self createdViewWithX:0 y:200 width:kScreenWidth height:200];
    UILabel *lbScreenResolution = [self createdLableWithText:kLocalized(@"ScreenResolution") textColor:[UIColor darkGrayColor]];
    lbScreenResolution.textAlignment = NSTextAlignmentRight;
    [v2 addSubview:lbScreenResolution];
    [lbScreenResolution mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v2.mas_top).offset(20);
        make.left.equalTo(v2.mas_left).offset(10);
        make.width.equalTo(@(kScreenWidth / 3 - 30));
        make.height.equalTo(@40);
    }];
 
//获取屏幕分辨率
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGSize size_screen = rect_screen.size;
    
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
    CGFloat width = size_screen.width*scale_screen;
    CGFloat height = size_screen.height*scale_screen;
    
    NSString *Wh = [NSString stringWithFormat:@" %.0f*%.0f",width,height];
    
    
    UILabel *lbShowScreenResolution = [self createdLableWithText:Wh textColor:[UIColor darkGrayColor]];
    lbShowScreenResolution.textAlignment = NSTextAlignmentLeft;
    [v2 addSubview:lbShowScreenResolution];
    [lbShowScreenResolution mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v2.mas_top).offset(20);
        make.left.equalTo(lbScreenResolution.mas_right).offset(10);
        make.right.equalTo(v2.mas_right).offset(-10);
        make.height.equalTo(@40);
    }];
    UILabel *lbDisplayStyle = [self createdLableWithText:kLocalized(@"Displaystyle") textColor:[UIColor darkGrayColor]];
    lbDisplayStyle.textAlignment = NSTextAlignmentRight;
    [v2 addSubview:lbDisplayStyle];
    [lbDisplayStyle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v2.mas_top).offset(80);
        make.left.equalTo(v2.mas_left).offset(10);
        make.width.equalTo(@(kScreenWidth / 3 - 30));
        make.height.equalTo(@40);
    }];
    btnDisplayStyle = [[GYSelectedButton alloc]init];
    [btnDisplayStyle setTitle:kLocalized(@"Classic") forState:UIControlStateNormal];
    btnDisplayStyle.delegate = self;
    btnDisplayStyle.tag = 101;
    [v2 addSubview:btnDisplayStyle];
    [btnDisplayStyle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v2.mas_top).offset(80);
        make.left.equalTo(lbDisplayStyle.mas_right).offset(10);
        make.width.equalTo(@(kScreenWidth / 3 - 30));
        make.height.equalTo(@40);
    }];
    [btnDisplayStyle addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lbLockScreenTime = [self createdLableWithText:kLocalized(@"Lockscreentime") textColor:[UIColor darkGrayColor]];
    lbLockScreenTime.textAlignment = NSTextAlignmentRight;
    [v2 addSubview:lbLockScreenTime];
    [lbLockScreenTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v2.mas_top).offset(140);
        make.left.equalTo(v2.mas_left).offset(10);
        make.width.equalTo(@(kScreenWidth / 3 - 30));
        make.height.equalTo(@40);
    }];
    
    
    btnLockScreenTime = [[GYSelectedButton alloc]init];
    [btnLockScreenTime setTitle:kLocalizedAddParams(@"3", kLocalized(@"Minutes")) forState:UIControlStateNormal];
    btnLockScreenTime.delegate = self;
    [btnLockScreenTime addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    btnLockScreenTime.tag = 102;
    [v2 addSubview:btnLockScreenTime];
    [btnLockScreenTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v2.mas_top).offset(140);
        make.left.equalTo(lbLockScreenTime.mas_right).offset(10);
        make.width.equalTo(@(kScreenWidth / 3 - 30));
        make.height.equalTo(@40);
    }];
    
    UIButton *btnModifyTheLockScreenPassword = [self createdButtonTitle:kLocalized(@"Modifypasswordlockscreen") titleColor:[UIColor darkGrayColor] backgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:0.8] fontSize:20.0];
    btnModifyTheLockScreenPassword.tag = 110;
    [v2 addSubview:btnModifyTheLockScreenPassword];
    [btnModifyTheLockScreenPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v2.mas_top).offset(140);
        make.left.equalTo(btnLockScreenTime.mas_right).offset(50);
        make.width.equalTo(@(150));
        make.height.equalTo(@40);
    }];

    [btnModifyTheLockScreenPassword addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *img2 = [[UIImageView alloc]init];
    img2.image = [UIImage imageNamed:@"dottedline.png"];
    [v2 addSubview:img2];
    [img2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v2.mas_top).offset(198);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@2);
    }];
    UIView *v3 = [self createdViewWithX:0 y:400 width:kScreenWidth height:260];
    
    UILabel *lbDataUpdate = [self createdLableWithText:kLocalized(@"Setthedataupdatefrequency") textColor:[UIColor darkGrayColor]];
    lbDataUpdate.textAlignment = NSTextAlignmentRight;
    [v3 addSubview:lbDataUpdate];
    [lbDataUpdate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v3.mas_top).offset(20);
        make.left.equalTo(v3.mas_left).offset(10);
        make.width.equalTo(@(kScreenWidth / 3 - 30));
        make.height.equalTo(@40);
    }];
    btnDataUpdate = [[GYSelectedButton alloc]init];
    [btnDataUpdate setTitle: kLocalizedAddParams(kLocalized(@"once"), kLocalized(@"Hours")) forState:UIControlStateNormal];
    btnDataUpdate.tag = 103;
    btnDataUpdate.delegate = self;
    [v3 addSubview:btnDataUpdate];
    [btnDataUpdate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v3.mas_top).offset(20);
        make.left.equalTo(lbDataUpdate.mas_right).offset(10);
        make.width.equalTo(@(kScreenWidth / 3 - 30));
        make.height.equalTo(@40);
    }];
    
    UIButton *btnImmediatelyDataUpdate = [self createdButtonTitle:kLocalized(@"UpdateImmediately") titleColor:[UIColor darkGrayColor] backgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:0.8] fontSize:20.0];
    btnImmediatelyDataUpdate.tag = 104;
    [v3 addSubview:btnImmediatelyDataUpdate];
    [btnImmediatelyDataUpdate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v3.mas_top).offset(20);
        make.left.equalTo(btnDataUpdate.mas_right).offset(50);
        make.width.equalTo(@(150));
        make.height.equalTo(@40);
    }];
    
    UIButton *btnCache = [self createdButtonTitle:kLocalized(@"ClearCache") titleColor:[UIColor darkGrayColor] backgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:0.8] fontSize:20.0];
    btnCache.tag = 114;
    [btnCache addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    [v3 addSubview:btnCache];
    [btnCache mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v3.mas_top).offset(80);
        make.left.equalTo(btnDataUpdate.mas_right).offset(50);
        make.width.equalTo(@(150));
        make.height.equalTo(@40);
    }];

    UIImageView *img5 = [[UIImageView alloc]init];
    img5.image = [UIImage imageNamed:@"dottedline.png"];
    [v3 addSubview:img5];
    [img5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v3.mas_top).offset(138);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@2);
    }];

    UILabel *lbVersion = [self createdLableWithText:kLocalized(@"Version") textColor:[UIColor darkGrayColor]];
    lbVersion.textAlignment = NSTextAlignmentRight;
    [v3 addSubview:lbVersion];
    [lbVersion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v3.mas_top).offset(150);
        make.left.equalTo(v3.mas_left).offset(10);
        make.width.equalTo(@(kScreenWidth / 3 - 30));
        make.height.equalTo(@40);
    }];

    UILabel *lbShowVersion = [self createdLableWithText:[NSString stringWithFormat:@" V%@",kAppVersion] textColor:[UIColor darkGrayColor]];
    lbShowVersion.textAlignment = NSTextAlignmentLeft;
    [v3 addSubview:lbShowVersion];
    [lbShowVersion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v3).offset(150);
        make.left.equalTo(lbVersion.mas_right).offset(10);
        make.right.equalTo(v3.mas_right).offset(-10);
        make.height.equalTo(@40);
    }];

    UIImageView *img3 = [[UIImageView alloc]init];
    img3.image = [UIImage imageNamed:@"dottedline.png"];
    [v3 addSubview:img3];
    [img3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v3.mas_top).offset(198);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@2);
    }];
    
    
    UIView *v4 = [self createdViewWithX:0 y:620 width:kScreenWidth height:100];
    
    UIButton *btnRoomManagement = [self createdButtonTitle:kLocalized(@"DeliveryStaffManagement") titleColor:[UIColor colorWithRed:0.0/225.0 green:91.0/255.0 blue:168.0/255.0 alpha:0.8] backgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:0.8] fontSize:25.0];
    btnRoomManagement.tag = 112;
    [btnRoomManagement addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    [v4 addSubview:btnRoomManagement];
    [btnRoomManagement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v4.mas_top).offset(20);
        make.left.equalTo(v4.mas_left).offset(kScreenWidth / 3 - 150);
        make.width.equalTo(@(150));
        make.height.equalTo(@40);
    }];
    
    UIButton *btnNetworkTest = [self createdButtonTitle:kLocalized(@"NetworkTesting") titleColor:[UIColor colorWithRed:0.0/225.0 green:91.0/255.0 blue:168.0/255.0 alpha:0.8] backgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:0.8] fontSize:25.0];
    btnNetworkTest.tag = 107;
    [v4 addSubview:btnNetworkTest];
    [btnNetworkTest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v4.mas_top).offset(20);
        make.left.equalTo(v4.mas_left).offset(kScreenWidth / 2 - 75);
        make.width.equalTo(@(150));
        make.height.equalTo(@40);
    }];
    
    UIButton *btnInstructions = [self createdButtonTitle:kLocalized(@"Instructionmanual") titleColor:[UIColor colorWithRed:0.0/225.0 green:91.0/255.0 blue:168.0/255.0 alpha:0.8] backgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:0.8] fontSize:25.0];
    btnInstructions.tag = 108;
    [btnInstructions addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    [v4 addSubview:btnInstructions];
    [btnInstructions mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v4.mas_top).offset(20);
        make.left.equalTo(v4.mas_left).offset(2 * kScreenWidth / 3);
        make.width.equalTo(@(150));
        make.height.equalTo(@40);
    }];
    
    //权限控制
    if (globalData.currentRole == roleTypeMemberCompanySystemAdministrator  || globalData.currentRole == roleTypeMemberCompanyStoreManger || globalData.currentRole == roleTypeTrusteeshipCompanySystemAdministrator || globalData.currentRole == roleTypeTrusteeshipCompanyStoreManger) {
        btnRoomManagement.hidden = NO;
       
    }else {
       
        btnRoomManagement.hidden = YES;
       
    }
    
    if(globalData.currentRole == roleTypeMemberCompanySystemAdministrator|| globalData.currentRole == roleTypeTrusteeshipCompanySystemAdministrator ){
        btnImmediatelyUpdateBusinessPoint.hidden = NO;
        btnSelectBusinessPoint.enabled = YES;
    }else {
        btnImmediatelyUpdateBusinessPoint.hidden = YES;
        btnSelectBusinessPoint.enabled = NO;
    
    }
    
}

#pragma mark-------创建lab
- (UILabel *)createdLableWithText:(NSString *)text
                        textColor:(UIColor *)textColor
{
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:20.0];
    return label;
}

#pragma mark-------创建btn
/**
 *	@param 	title           标题
 *	@param 	titleColor      标题颜色
 *	@param 	backgroundColor btn背景颜色
 *	@param 	fontSize        标题字体大小
 */
- (UIButton *)createdButtonTitle:(NSString *)title
                      titleColor:(UIColor *)titleColor
                 backgroundColor:(UIColor *)backgroundColor
                        fontSize:(CGFloat)fontSize

{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.backgroundColor = backgroundColor;
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:5.0];
    [button.layer setBorderWidth:1.0];
    [button.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [button addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - －－－－－创建一个View
/**
 *	@param 	x           x点坐标
 *	@param 	y           y点坐标
 *	@param 	width       view宽度
 *	@param 	height      view的高度
 */

- (UIView *)createdViewWithX:(int)x
                           y:(int)y
                       width:(int)width
                      height:(int)height
{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(x, y, width, height);
    [svBack addSubview:view];
    return view;
}

#pragma mark -----点击事件

- (void)select:(UIButton *)btn
{
        if (btn.tag == 104) {
            
            if (!kGetNSUser(@"shopId")) {
                [self notifyWithText:kLocalized(@"PleaseSelectTheBusiness")];
                
            }else{
                [self httpGetSyncShopFoods];
                [self httpGetFoodCategoryList];
               // [self notifyWithText:@"更新菜品资料成功！"];
            }
        
    }else if (btn.tag == 106){
        btnSelectBusinessPoint.enabled = YES;
        //为开通商城的权限控制
        if ([kGetNSUser(@"vshopStatus") isEqualToString:@"0"]) {
            kNotice(kLocalized(@"StoreDidNotOpen,PleaseOpen."));
        }else{
            [self httpGetShopList];
        }

    }
    else if (btn.tag == 107) {
        [self networkTest];
    }
    if (btn.tag == 112) {
        if (kGetNSUser(@"shopName")) {
            GYDeliveryStaffManagementViewController *staffCtl=[[GYDeliveryStaffManagementViewController alloc] init];
            [self.navigationController pushViewController:staffCtl animated:YES];
        }else{
            [self notifyWithText:kLocalized(@"PleaseSelectTheBusiness")];
        
        }
    }
    
    if (btn.tag == 114) {
        _blert = [[UIAlertView alloc] initWithTitle:kLocalized(@"Tips") message:kLocalized(@"SureToClearTheIternalCache?") delegate:self cancelButtonTitle:kLocalized(@"Cancel") otherButtonTitles:kLocalized(@"Determine"), nil];
        
        [_blert show];
    }
    
    if (btn.tag == 110 || btn.tag == 101 || btn.tag == 102 || btn.tag == 108 ) {
        [self customAlertView:kLocalized(@"ThisFeatureIsUnderDevelopment,SoStayTuned!")];
    }
  
}
- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -----网络请求
/**
 *  获取营业点列表
 */
- (void)httpGetShopList
{
    GYSystemSettingViewModel *setting = [[GYSystemSettingViewModel alloc]init];
    
    [self modelRequestNetwork:setting :^(id resultDic) {
      
        [self notifyWithText:kLocalized(@"SynchronizationBusinessPointSuccessful")];
        
        NSMutableArray *array = [NSMutableArray array];
        for (GYSystemSettingModel *model in resultDic) {
            [array addObject:model.shopName];
        }
        [btnSelectBusinessPoint dataSourceArr:array];
        self.dataArrOperatingPoint = resultDic;
    
    }isIndicator:YES];

    [setting getShopList];
    
}
/**
 *  获取菜品分类列表
 */
- (void)httpGetFoodCategoryList
{
    GYSystemSettingViewModel *setting = [[GYSystemSettingViewModel alloc]init];
  
    
    [self modelRequestNetwork:setting :^(id resultDic) {
        
        DDLogCInfo(@"%@",resultDic);
        
     //   [self notifyWithText:@"同步分类列表/菜品列表成功"];
        
    }isIndicator:YES];
    [setting getFoodCategoryList];
    
}
/**
 *  同步营业点菜品
 */
- (void)httpGetSyncShopFoods
{
    GYSystemSettingViewModel *setting = [[GYSystemSettingViewModel alloc]init];

    [self modelRequestNetwork:setting :^(id resultDic) {
        
        DDLogCInfo(@"%@",resultDic);
        [self notifyWithText:kLocalized(@"UpdateDishesProfileSuccess!")];
        
    } isIndicator:YES];
     [setting getSyncShopFoods];
    
}

- (void)setModel:(GYSystemSettingModel *)model
{
    if (_model != model) {
        _model = model;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == _blert) {
        if (buttonIndex != alertView.cancelButtonIndex) {

            [GYGIFHUD show];
            
//            btnSelectBusinessPoint.enabled = NO;
//            [btnSelectBusinessPoint setTitle:@"请更新数据" forState:UIControlStateNormal];
            
            [self myClearCacheAction];
           
        }
    }
        return;
}


#pragma mark - 清理缓存
- (void)myClearCacheAction{
    
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{

                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:_cachPath];
                       DDLogCInfo(@"files :%lu",(unsigned long)[files count]);
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [_cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                           //清空菜品及分类
                           GYSystemSettingViewModel *model = [[GYSystemSettingViewModel alloc]init];
                           [model  writeModel:[NSDictionary dictionary] toPath:@"getFoodCategoryList"];
                           [model  writeModel:[NSDictionary dictionary]  toPath:@"foodsList"];
                           
                       }
                       
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
}
//清除 缓存文件成功 调用
-(void)clearCacheSuccess
{
    
    
    [GYGIFHUD dismiss];
    
    NSString *str = [NSString stringWithFormat:@"已成功腾出%.2fM空间",_fileSize];
    
    UIAlertView*lertView = [[UIAlertView alloc] initWithTitle:kLocalized(@"Tips") message:str delegate:nil cancelButtonTitle:kLocalized(@"Determine") otherButtonTitles:nil];
    
    [lertView show];
    
    _fileSize = 0;
    
}

//遍历文件夹获得文件夹大小，返回多少M

- (float) folderSizeAtPath:(NSString *) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

//单个文件的大小
- (long long) fileSizeAtPath:(NSString *) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark -GYSelectedButtonDelegate
- (void)GYSelectedButtonDidClick:(GYSelectedButton *) btn withContent :(NSString *)content
{
    
    //存shopId
    if (btn == btnSelectBusinessPoint) {
        for (GYSystemSettingModel *model in self.dataArrOperatingPoint) {
            if (model.shopName == content) {
                kSetNSUser(@"shopId", model.strID);
                kSetNSUser(@"shopName", model.shopName);
            }
        }
    }else if(btn == btnDataUpdate){
        
        if ([content isEqualToString:kLocalizedAddParams(kLocalized(@"once"), kLocalized(@"Hours"))] ) {
            
            content = @"60";
            
            [NSTimer scheduledTimerWithTimeInterval:3600.0f target:self selector:@selector(httpGetFoodCategoryList) userInfo:nil repeats:YES];
            [NSTimer scheduledTimerWithTimeInterval:3600.0f target:self selector:@selector(httpGetSyncShopFoods) userInfo:nil repeats:YES];
            
        }else if([content isEqualToString:kLocalizedAddParams(kLocalized(@"once"), kLocalized(@"day"))]){
            int time = 60 * 12;
            content = [NSString stringWithFormat:@"%d",time];
            [NSTimer scheduledTimerWithTimeInterval:3600.0*24 target:self selector:@selector(httpGetFoodCategoryList) userInfo:nil repeats:YES];
            [NSTimer scheduledTimerWithTimeInterval:3600.0*24 target:self selector:@selector(httpGetSyncShopFoods) userInfo:nil repeats:YES];
        }
        
        
    if ([content integerValue] > 0) {
        self.updateDataTime = content;
        int time = [content intValue] * 60;
        if (_timerB) {
            _timerB = nil;
        }
        _timerB = [NSTimer scheduledTimerWithTimeInterval:time target:self
                                                                    selector:@selector(changeTimeAtTimedisplay) userInfo:nil repeats:YES];
        [[NSRunLoop  currentRunLoop] addTimer:_timerB forMode:NSDefaultRunLoopMode];
        
    }}
}
#pragma mark - 网络测试
- (void)networkTest
{
    if ([AFNetworkReachabilityManager sharedManager].isReachable) {
        [self customAlertView:kLocalized(@"Connectednetwork")];
    }else {
    
        [self customAlertView:kLocalized(@"NetworkConnectionFails,CheckTheNetwork!")];
    }
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length >0) {
        kSetNSUser(@"maxFood", textField.text);
    }
}
@end
