//
//  GYSinglePointViewController.m
//  GYRestaurant
//
//  Created by apple on 15/10/20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

/**
 *  点菜的业务逻辑
    在平板点菜后，下单确认之前，输入互生号或手机号。通过检验号码是否合法，确定是否可下单。其中，互生号是互生平台的会员号
 码，手机号码指在平台上选择非持卡人登陆并且已经登陆过平台的手机号码，并非互生号用于信息认证的互生号对应的手机号。密码为对
 应号码在平台用户登录的密码。
    通过互生号与或者手机号码检验，以识别消费者用户，消费时获取消费积分。后台通过访问用户中心的接口，通过互生号或者手机号
 获取客户的ID，下单时将记录当前验证的用户。操作方法如下：
     输入互生号或者手机号，点击【下单】后，录入互生验证码，输入验证码并通过系统验证，下单成功。密码输入操作，在输入完成互
 生号或手机号码后，输入互生号或手机号码登陆密码进行验证。验证通过，则下单成功，转入待用餐状态。
 */

#import "GYSinglePointViewController.h"
#import "GYSinglePointCell.h"
#import "GYSinglePointCellPro.h"
#import "GYSinglepointViewModel.h"
#import "GYSyncShopFoodsModel.h"
#import "GYFoodSpecModel.h"
#import "GYPicUrlModel.h"
#import "NSObject+HXAddtions.h"
#import "GYTakeOrderTool.h"
#import "GYAlertWithAddFoodFieldView.h"
#import "GYAlertWithFieldView.h"

@interface GYSinglePointViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UITableView *tbvSinglePoint;
@property (nonatomic, weak) GYSinglePointCell *cell;
@property (nonatomic, weak) UITextField *tfResNoAndPhone;
@property (nonatomic, weak) UILabel *lbShowPrice;
@property (nonatomic, weak) UILabel *lbShowNumber;
@property (nonatomic, weak) UILabel *lbShowTotalPrice;
@property (nonatomic, weak) UILabel *lbShowPV;
@property (nonatomic, strong) NSMutableArray *arrBtn;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) BOOL succsess;//记录订单是否成功
@property (nonatomic, copy) NSString *textStr;
@property (nonatomic, strong) GYAlertWithAddFoodFieldView *alert;
@property (nonatomic, assign) double foodPrice;
@property (nonatomic,copy) NSString *userTypeStr;
@property (nonatomic,copy) NSString *isCardTypeStr;

@end

@implementation GYSinglePointViewController
#pragma mark - 继承系统
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(takeCount) name:GYSinglePointCellDeleteNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //订单成功需要刷新角标 否则不需要刷新角标
    if (!self.succsess) {
        globalData.pop = YES;
    }else {
        globalData.pop = NO;
    }
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 数据源
- (void)getData
{

    NSMutableArray *arr = [NSMutableArray array];
    for (GYSyncShopFoodsModel *model in globalData.takeOrderA) {
        if (model.foodSpec.count > 0) {
            
            for (GYFoodSpecModel *m in model.foodSpec) {
                if ([model.selected[m.identify] intValue] > 0) {
                    m.pName = model.foodName;
                    m.picUrl = model.picUrl;
                    [arr addObject:m];
                }
            }
            
        }else{
            if ([model.selected[model.foodId] intValue] > 0) {
                [arr addObject:model];
            }
        }
    }
    
    self.dataSource = arr;
    [self.tbvSinglePoint reloadData];
    [self takeCount];

}

- (void)takeCount
{
    int totalNum = 0;
    double totalFoodPv = 0;
    double totalFoodPrice = 0;
    NSMutableArray *arr = [NSMutableArray array];
    for (GYSyncShopFoodsModel *model in globalData.takeOrderA) {
        if (model.selected.count > 0) {
            [arr addObject:model];
        }
    }
    for (GYSyncShopFoodsModel *model in arr) {
        totalNum = [GYTakeOrderTool getTakeListNum];
        
        if (model.foodSpec.count > 0) {
            for (GYFoodSpecModel *m in model.foodSpec ) {
                if ([model.selected[m.identify] intValue] > 0) {
                    totalFoodPrice += [model.selected[m.identify] intValue] * m.price.doubleValue;
                    totalFoodPv += [model.selected[m.identify] intValue] * m.auction.doubleValue;
                }
            }
        }else{
            if ([model.selected[model.foodId] intValue] > 0) {
                totalFoodPrice += [model.selected[model.foodId] intValue] * model.foodPrice.doubleValue;
                totalFoodPv += [model.selected[model.foodId] intValue] * model.foodPv.doubleValue;;
            }
        }
    }
    //下单前不需四色五入
    float noFoodPrice = 0 ;
    noFoodPrice = totalFoodPrice;
    _foodPrice = 0;
    
    totalFoodPrice = roundf(totalFoodPrice *10);
     _foodPrice = totalFoodPrice*.1;
   // foodPrice = totalFoodPrice;
    self.lbShowTotalPrice.text = [NSString stringWithFormat:@"%.2f",noFoodPrice];
    self.lbShowPV.text = [NSString stringWithFormat:@"%.2f",totalFoodPv];
    self.lbShowNumber.text = [NSString stringWithFormat:@"%d",totalNum];
}

#pragma mark - 创建视图

- (void)initUI
{ 
    self.navigationItem.leftBarButtonItem = [Utils createBackButtonWithTitle:kLocalized(@"Ithascarte") withTarget:self withAction:@selector(popBack)];
    
    UIImageView *imgViewLine = [[UIImageView alloc]init];
    imgViewLine.image = [UIImage imageNamed:@"redline.png"];
    [self.view addSubview:imgViewLine];
    [imgViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@(2));
    }];
    
    [self initTableView];
    [self bottomView];
}

#pragma mark - 初始化TableView

- (void)initTableView
{
    UITableView *tbvSinglePoint = [[UITableView alloc]initWithFrame:CGRectMake(0, 2,kScreenWidth, kScreenHeight - 80 - 66) style:UITableViewStylePlain];
    tbvSinglePoint.delegate = self;
    tbvSinglePoint.dataSource = self;
    tbvSinglePoint.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tbvSinglePoint];
    self.tbvSinglePoint = tbvSinglePoint;
}

#pragma mark - 初始化bottomView

- (void)bottomView
{
    UIView *vBottom = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.tbvSinglePoint.frame), kScreenWidth, 80)];
    [self.view addSubview:vBottom];
    
    
    UILabel *lbNumber = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 5, 20, 60, 40)];
    lbNumber.textAlignment = NSTextAlignmentCenter;
    lbNumber.font = [UIFont systemFontOfSize:20.0];
    lbNumber.textColor = [UIColor colorWithRed:95.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0];
    lbNumber.text = kLocalizedAddParams(kLocalized(@"Quantity"), @":");
    [vBottom addSubview:lbNumber];
    
    UILabel *lbShowNumber = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbNumber.frame), 20, 40, 40)];
    lbShowNumber.textAlignment = NSTextAlignmentLeft;
    lbShowNumber.font = [UIFont systemFontOfSize:20.0];
    lbShowNumber.textColor = kRedFontColor;
    
    [vBottom addSubview:lbShowNumber];
    self.lbShowNumber = lbShowNumber;
    
    UILabel *lbTotal = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbShowNumber.frame), 20, 60, 40)];
    lbTotal.textAlignment = NSTextAlignmentCenter;
    lbTotal.font = [UIFont systemFontOfSize:20.0];
    lbTotal.textColor = [UIColor colorWithRed:95.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0];
    lbTotal.text = kLocalized(@"lumpsum");
    [vBottom addSubview:lbTotal];
    
    
    UIImageView *imgPrice = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbTotal.frame), 30, 20, 20)];
    imgPrice.image = [UIImage imageNamed:@"currency.png"];
    [vBottom addSubview:imgPrice];
    
    UILabel *lbShowTotalPrice = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgPrice.frame), 20, 120, 40)];
    lbShowTotalPrice.textAlignment = NSTextAlignmentLeft;
    lbShowTotalPrice.font = [UIFont systemFontOfSize:20.0];
    lbShowTotalPrice.textColor = kRedFontColor;
    [vBottom addSubview:lbShowTotalPrice];
    self.lbShowTotalPrice = lbShowTotalPrice;
    
    UILabel *lbPV = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbShowTotalPrice.frame), 20, 60, 40)];
    lbPV.textAlignment = NSTextAlignmentCenter;
    lbPV.font = [UIFont systemFontOfSize:20.0];
    lbPV.textColor = [UIColor colorWithRed:95.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0];
    lbPV.text = kLocalizedAddParams(kLocalized(@"Integration"), @":");
    [vBottom addSubview:lbPV];
    
    UIImageView *imgPV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbPV.frame), 30, 30, 20)];
    imgPV.image = [UIImage imageNamed:@"PV.png"];
    [vBottom addSubview:imgPV];
    
    UILabel *lbShowPV = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgPV.frame), 20, 120, 40)];
    lbShowPV.textAlignment = NSTextAlignmentLeft;
    lbShowPV.font = [UIFont systemFontOfSize:20.0];
    lbShowPV.textColor = kBlueFontColor;
    [vBottom addSubview:lbShowPV];
    self.lbShowPV = lbShowPV;
    
    UIButton *btnPlaceOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPlaceOrder.frame = CGRectMake(CGRectGetMaxX(lbShowPV.frame) + 50, 20, 120, 40);
    [btnPlaceOrder setTitle:kLocalized(@"Single") forState:UIControlStateNormal];
    btnPlaceOrder.titleLabel.font = [UIFont systemFontOfSize:25.0];
    [btnPlaceOrder setBackgroundImage:[UIImage imageNamed:@"placeOrder.png"] forState:UIControlStateNormal];
    [btnPlaceOrder addTarget:self action:@selector(PlaceAnOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    [vBottom addSubview:btnPlaceOrder];

    
}

#pragma mark ------- UITextViewDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.tfResNoAndPhone == textField) {

        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > 11) {
            [self notifyWithText:kLocalized(@"Pleaseenterthecorrectalternatenumber/mobilephonenumber")];
     
            return NO;
        }
    }
    return YES;
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    GYSinglePointCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        
        DDLogCInfo(@"%f",kScreenWidth);
        
        if (kScreenWidth == 1366) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYSinglePointCellPro class])
                                                  owner:self
                                                options:nil] objectAtIndex:0];
        }else{
            
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYSinglePointCell class])
                                                  owner:self
                                                options:nil] objectAtIndex:0];
        }
        [cell setValue:CellIdentifier forKey:@"reuseIdentifier"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.sfModel = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *vHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    vHeader.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    
    NSArray *arrLab = @[kLocalized(@"Ithascartemenu"),kLocalized(@"Specification"),kLocalized(@"unitprice"),kLocalized(@"Integration"),kLocalized(@"Quantity"),kLocalized(@"Operating")];
    
    for (int i = 0; i < 6 ; i ++) {
        UILabel *lb = [[UILabel alloc]init];
        
        lb.tag = i;
        
        lb.frame = CGRectMake(i * (kScreenWidth / 6 - 10) + 80, 0, kScreenWidth / 6 - 10, 50);
        if (i == 0) {
            lb.frame = CGRectMake(30, 0, kScreenWidth / 6 - 10, 50);
        }
        lb.text = [NSString stringWithFormat:@"%@",arrLab[i]];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.font = [UIFont systemFontOfSize:23.0];
        lb.textColor = [UIColor colorWithRed:95.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0];
        [vHeader addSubview:lb];
    }
    
    return vHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

//确认下单按钮
- (void) PlaceAnOrder:(UIButton *)button
{
//    if (self.tfResNoAndPhone.text.length <11) {
//        [self notifyWithText:kLocalized(@"Pleaseenteralternatenumber/mobilephonenumber")];
//        return;
//    }
  
    if ([self.lbShowNumber.text intValue]== 0) {
        [self notifyWithText:kLocalized(@"OrderingNumberCanNotBeEmpty!")];
        return;
    }
//
//    
//    kWEAKSELF
//    [self.view endEditing:YES];
//    
////    NSString * subString = [self.tfResNoAndPhone.text substringToIndex:1];
////    if (![subString isEqualToString:@"0"]) {
////        [self notifyWithText:@"暂不支持非持卡人下单!"];
////        return;
////    }
//    
    @weakify(self);
    _alert = [[GYAlertWithAddFoodFieldView alloc] initWithTitle:kLocalized(@"Please_enter_information") numberTextFieldName:kLocalizedAddParams(kLocalized(@"LoginPassword"), @"：") leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Determine")];
    
    _alert.leftBlock = ^{
        @strongify(self);
        [self.view endEditing:YES];
    };
    _alert.ramadhinTextField.text = self.tfResNoAndPhone.text;
    
    _alert.rightBlock = ^(NSString *tableNo, NSString *tableNumber){
        @strongify(self);
        [self.view endEditing:YES];
        if (tableNumber.length != 6) {
            [self notifyWithText:kLocalized(@"Digitpasswordyouenteredisincorrect,pleasere-enter")];
        }
        if (tableNo.length != 11) {
             [self notifyWithText:kLocalized(@"AccountNumberOrPasswordAuthenticationFailure")];
        }
        
        [self httpGetCheckAccountIdWithPassWord:tableNumber andResNo:tableNo button:button];
    };
    [_alert show];
}

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 网络请求数据
/**
 *  验证互生号
 *
 *  @param pwd    密码
 *  @param resNo  企业号
 */
- (void) httpGetCheckAccountIdWithPassWord:(NSString *)pwd andResNo:(NSString *)resNo button:(UIButton *)button
{
  
    GYSinglepointViewModel *spViewModel = [[GYSinglepointViewModel alloc]init];
    [button controlTimeOut];
    [self modelRequestNetwork:spViewModel :^(id resultDic) {
        
    NSArray *resutlt = (NSArray *)resultDic;
        
       if ([[resutlt firstObject] integerValue] == 200) {
            [self notifyWithText:kLocalized(@"Verifyalternatenumber/cellphonenumbersuccessfully,beingsinglein")];
            [self httpSubmitOrder:[resultDic objectAtIndex:1]];
       }else if([[resutlt firstObject] integerValue] == 160411){
           kNotice([resultDic lastObject]);
       }else{
            [self notifyWithText:kLocalized(@"AccountNumberOrPasswordAuthenticationFailure")];
       }
    } isIndicator:YES];

    resNo = _alert.ramadhinTextField.text;
    self.userTypeStr = _alert.returnStatusStr;
    self.isCardTypeStr = _alert.isCardStr;
    [spViewModel POSTCheckAccountIdWithAccountId:resNo password:pwd UserType:self.userTypeStr isCardCustomer:self.isCardTypeStr];
}
/**
 *  下单
 *
 *  @param userId 用户ID
 */
- (void)httpSubmitOrder:(NSString *)userId
{
    GYSinglepointViewModel *spViewModel = [[GYSinglepointViewModel alloc]init];
    
    [self modelRequestNetwork:spViewModel :^(id resultDic) {
        

        if ([resultDic[@"retCode"] isEqualToNumber:@201]) {
            [self customAlertView:kLocalized(@"Underthesingleexception")];
        }
        if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
            NSDictionary *dic = resultDic[@"data"];
            [GYTakeOrderTool reloadTabkeOrderList];
            NSString *orderS = dic[@"orderId"];
            self.succsess = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:GYTakeOrderSuccessNotification object:nil];
            [self notifyWithText:[NSString stringWithFormat:@"%@%@",kLocalized(@"Singlesuccess,theordernumber:"),orderS]];
            [self performSelector:@selector(popBack) withObject:nil afterDelay:1.5];
        }else if ([resultDic[@"retCode"] isEqualToNumber:@507]) {
            [self notifyWithText:kLocalized(@"PointYourDishesOffTheShelf,PleaseUpdateTheMenu")];
            //  [self httpSubmitOrder:[resultDic lastObject]];
        }else {
        
         [self customAlertView:kLocalized(@"Underthesingleexception")];
        }
    } isIndicator:YES];
    NSString *foodPriceStr = [NSString stringWithFormat:@"%.2f",self.foodPrice];
    self.isCardTypeStr = _alert.isCardStr;
    //默认人数为1
    [spViewModel PostOrderSubmitOrderWithAmountTotal:foodPriceStr personCount:@"1" pointsTotal:self.lbShowPV.text remark:@"" resNo:_alert.ramadhinTextField.text userId:userId isCardCustomer:self.isCardTypeStr];
}

@end
