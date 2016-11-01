//
//  GYHSBankCardListViewController.m
//
//  Created by lizp on 16/9/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define KGYHSBankCardListCellTag 900

#import "GYHSBankCardListViewController.h"
#import "GYHSBankCardNoDataView.h"
#import "YYKit.h"
#import "GYHSCardBandModel.h"
#import "GYHSBankCardListCell.h"
#import "GYHSBankCardAddViewController.h"
#import "GYHSTools.h"
#import "GYHSBankCardNoRealNameView.h"
#import "GYHDRealNameMainViewController.h"
@interface GYHSBankCardListViewController ()<UITableViewDataSource,UITableViewDelegate,GYHSBankCardAddViewControllerDelegate,GYHSBankCardNoRealNameViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;//数据源
@property (nonatomic,strong) UIControl *addBankCardControl;//添加银行卡
@property (nonatomic,strong) GYHSBankCardNoDataView *noDataView;

@end

@implementation GYHSBankCardListViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Show Controller: %@", [self class]);

}

- (void)dealloc {
    NSLog(@"Dealloc Controller: %@", [self class]);
}

#pragma mark - SystemDelegate 

#pragma mark - GYHSBankCardAddViewControllerDelegate
//添加银行卡成功
-(void)addBankCardSuccess {

    
    [self.dataSource removeAllObjects];
    self.tableView = nil;
    self.dataSource = nil;
    [self loadNetWork];
    
    [self bankCardModify];
    
}
#pragma mark TableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GYHSBankCardListCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHSBankCardListCellIdentifier];
    if(!cell) {
        cell = [[GYHSBankCardListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHSBankCardListCellIdentifier];
    }
    
    cell.model = self.dataSource[indexPath.section];
    [cell.deleteBtn addTarget:self action:@selector(deleteBankAccNo:) forControlEvents:UIControlEventTouchUpInside];
    cell.tag = KGYHSBankCardListCellTag + indexPath.section;
    [cell.defaultSwitch addTarget:self action:@selector(defaultSwitchValueChange:) forControlEvents:UIControlEventValueChanged];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectBankCard:)]) {
        GYHSCardBandModel *model = self.dataSource[indexPath.section];
        [self.delegate selectBankCard:model];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 86;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}



// #pragma mark - CustomDelegate
#pragma mark - event response

//删除银行卡
-(void)deleteBankAccNo:(UIButton *)sender {
    
    UIView *view = sender.superview;
    GYHSCardBandModel *model = self.dataSource[view.tag - KGYHSBankCardListCellTag];
    
    [GYUtils showMessge:kLocalized(@"GYHS_Banding_Sure_Delete_Bank_Card") confirm:^{
        
        NSString *url = kUrlUnBindBank;
        
        GYHSLoginModel *loginModel = globalData.loginModel;         NSDictionary *paramDic = @{@"accId":model.accId,
                                                                                               @"userType": loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard };
        
        GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:url parameters:paramDic requestMethod:GYNetRequestMethodDELETE requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
            [GYGIFHUD dismiss];
            if ([GYUtils checkDictionaryInvalid:responseObject]) {
                [GYUtils showMessage:kLocalized(@"GYHS_Banding_DeleteCardFailedPleaseTryAgain") confirm:nil];
                return;
            }
            NSInteger returnCode = [[responseObject objectForKey:@"retCode"] integerValue];
            if (returnCode == 200) {
                [GYUtils showToast:kLocalized(@"GYHS_Banding_DeleteSuccess")];
                [self.dataSource removeObjectAtIndex:view.tag -KGYHSBankCardListCellTag];
                if (self.dataSource.count < kSaftToNSInteger(globalData.custGlobalDataModel.bankCardBindCount) ) {
                    self.tableView.tableFooterView = [self addBankCardView];
                }else {
                    self.tableView.tableFooterView = [[UIView alloc] init];
                }
                if(self.dataSource == nil ||   self.dataSource.count == 0) {
                    [self.tableView removeFromSuperview];
                    [self reloadNoDataView];
                }else {
                    [self.tableView reloadData];
                }
                [self bankCardModify];
            }
            else {
                [GYUtils showMessage:kLocalized(@"GYHS_Banding_DeleteCardFailedPleaseTryAgain") confirm:nil];
            }
        }];
        [request setValue:loginModel.token forHTTPHeaderField:@"token"];
        [request start];
        [GYGIFHUD show];
    } cancleBlock:^{
    } withColor:kBtnBlue];
}

//设置默认银行卡
-(void)defaultSwitchValueChange:(UISwitch *)sender {

    UIView *view = sender.superview;
    GYHSCardBandModel *model = self.dataSource[view.tag -KGYHSBankCardListCellTag];
    
    NSDictionary* paramDic = @{ @"custId" : globalData.loginModel.custId,
                                @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard,
                                @"accId" : model.accId
                                };
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kUrlSetDefaultBindBank parameters:paramDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if(error) {
            [GYUtils parseNetWork:error resultBlock:nil];
        }else {
            [GYUtils showToast:kLocalized(@"GYHS_Address_SettingSuccess")];
            [self loadNetWork];
            
            [self bankCardModify];
        }
    }];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];

    
}

-(void)loadNetWork {
    
    BOOL hasCard = [[GYHSLoginManager shareInstance] loginModuleObject].cardHolder;
    NSString* strHasCard = hasCard ? kUserTypeCard : kUserTypeNoCard;
    GYHSLoginModel* model = [[GYHSLoginManager shareInstance] loginModuleObject];
    NSDictionary* paramDic = @{ @"userType" : strHasCard,
                                @"custId" : model.custId };
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kUrlListBindBank parameters:paramDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if(error) {
            [GYUtils parseNetWork:error resultBlock:nil];
        }else {
            [self.dataSource removeAllObjects];
            self.dataSource = nil;
            NSArray* serverAry = responseObject[@"data"];
            if ([GYUtils checkArrayInvalid:serverAry]) {
                DDLogDebug(@"The resultAry:%@ is invalid.", serverAry);
                return;
            }
            for (NSDictionary* tempDic in serverAry) {
                GYHSCardBandModel* model = [[GYHSCardBandModel alloc] initWithDictionary:tempDic error:nil];
                [self.dataSource addObject:model];
            }
        }
        
        if(self.dataSource.count){
           
            if (self.dataSource.count < kSaftToNSInteger(globalData.custGlobalDataModel.bankCardBindCount) ) {
                self.tableView.tableFooterView = [self addBankCardView];
            }else {
                self.tableView.tableFooterView = [[UIView alloc] init];
            }
             [self.tableView reloadData];

        }else {
            [self reloadNoDataView];
            
        }
    }];
    [GYGIFHUD show];
    [request setValue:model.token forHTTPHeaderField:@"token"];
    [request start];
}

//添加银行卡事件
-(void)addBankCardInfo {
    
    GYHSBankCardAddViewController *addVC = [[GYHSBankCardAddViewController alloc] init];
    addVC.delegate = self;
    addVC.view.frame = self.view.frame;
    [self addChildViewController:addVC];
    [self.view addSubview:addVC.view];
}

//货币转银行获取默认银行卡接口重新获取
-(void)bankCardModify {

    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(bankCardChange)]) {
            [self.delegate bankCardChange];
        }
    });
}

#pragma mark - private methods 
- (void)initView
{
    self.title = kLocalized(@"");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    NSLog(@"Load Controller: %@", [self class]);
    //判断实名认证 如果没有 上盖实名认证页面
//    NSLog(@"globalData.loginModel.isRealnameAuth = %@",globalData.loginModel.isRealnameAuth);
    if ([globalData.loginModel.isRealnameAuth isEqualToString:@"1"]) {
        //添加上盖视图
//        NSLog(@"globalData.loginModel.isRealnameAuth 2222= %@",globalData.loginModel.isRealnameAuth);
        GYHSBankCardNoRealNameView* view1 = [[GYHSBankCardNoRealNameView alloc] initWithFrame:self.view.frame];
        
        [self.view addSubview:view1];
        
        view1.delegate = self;
        return;
    }
    [self loadNetWork];
}

-(void)pushToRegistNameVC{
    GYHDRealNameMainViewController* vc = [[GYHDRealNameMainViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//无银行卡展示
-(void)reloadNoDataView {
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 275)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundView];
    
    self.noDataView = [[GYHSBankCardNoDataView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 161)];
    [backgroundView addSubview:self.noDataView];
    
    UIView *addView = [self addBankCardView];
    addView.frame = CGRectMake(0, self.noDataView.bottom, addView.width, addView.height);
    [backgroundView addSubview:addView];

}

//添加银行卡视图
-(UIView *)addBankCardView {
    
    UIView *addCardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 73)];
    addCardView.backgroundColor = [UIColor whiteColor];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, self.view.bounds.size.width, 30)];
    backView.backgroundColor = kBackgroundGrayColor;
    [addCardView addSubview: backView];
    
    self.addBankCardControl = [[UIControl alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 -50, 9, 100, 25)];
    [self.addBankCardControl addTarget:self action:@selector(addBankCardInfo) forControlEvents:UIControlEventTouchUpInside];
    [addCardView addSubview:self.addBankCardControl];
    
    // +
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"gyhs_bank_add"] forState:UIControlStateNormal];
    addButton.frame = CGRectMake(0, 0, self.addBankCardControl.height, self.addBankCardControl.height);
    [addButton addTarget:self action:@selector(addBankCardInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.addBankCardControl addSubview:addButton];
    
    //添加银行卡
    UILabel *addCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(addButton.right, 0, self.addBankCardControl.width - addButton.right - 8, self.addBankCardControl.height)];
    addCardLabel.text = kLocalized(@"GYHS_Address_AddBankCard");
    addCardLabel.font = [UIFont systemFontOfSize:12] ;//字体不做宏定义
    addCardLabel.textColor = UIColorFromRGB(0x1d7dd6);
    [self.addBankCardControl addSubview:addCardLabel];
    
    return addCardView;
}

#pragma mark - getters and setters  
-(UITableView *)tableView {

    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        [_tableView registerClass:[GYHSBankCardListCell class] forCellReuseIdentifier:kGYHSBankCardListCellIdentifier];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableArray *)dataSource {

    if(!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
