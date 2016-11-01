//
//  GYOutOrderPayViewController.m
//  GYRestaurant
//
//  Created by apple on 15/10/28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOutOrderPayViewController.h"
#import "GYOrderManagerViewModel.h"
#import "GYOrdDetailModel.h"
#import "GYOutOrderPayView.h"
#import "GYOrderTakeOutModel.h"
#import "GYAlertView.h"
#import "GYOrderTakeOutViewController.h"

@interface GYOutOrderPayViewController ()

@property(nonatomic,strong)GYOutOrderPayView *outPayView;
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation GYOutOrderPayViewController

#pragma mark - 继承系统
-(void)loadView{
    [super loadView];
    [self createView];
    [self RequestOderDetailData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark-创建视图
-(void)createView{
    self.navigationItem.leftBarButtonItem = [Utils createBackButtonWithTitle:kLocalized(@"TakeoutCashReceipts") withTarget:self withAction:@selector(popBack)];
    
    
    _outPayView = [[[NSBundle mainBundle]loadNibNamed:@"GYOutOrderPayView" owner:self options:nil] objectAtIndex:0];
   
    [self.view addSubview:_outPayView];
    @weakify(self);
    _outPayView.sendBlock = ^(id sender){
    @strongify(self);
        [self clickAction:sender];
    
    };
}

#pragma mark - 按钮点击触发操作

- (void)clickAction:(UIView *)sender{

    
    GYAlertView *alert=[[GYAlertView alloc] initWithTitle:kLocalizedAddParams(kLocalized(@"AreYouSureToSettleAccounts"), @"?") contentText:nil leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Determine")];
    alert.rightBlock = ^(){
       
        GYOrderManagerViewModel *viewModel=[[GYOrderManagerViewModel alloc] init];        
        [self modelRequestNetwork:viewModel :^(id resultDic) {
        //    DDLogCInfo(@"现金结算成功");
            if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
               [self notifyWithText:kLocalized(@"ReceivablesSuccess")];
             
                [self performSelector:@selector(pop) withObject:nil afterDelay:1.5];
                
//                UIAlertView *aleView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"现金结账成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                [aleView show];
//                [self popBack];
            
            }else if ([resultDic[@"retCode"] isEqualToNumber:@590]){
                [self notifyWithText:kLocalized(@"EnterprisePrepaidAccountBalanceIsRunningLow!")];
            
            }else{
                [self notifyWithText:kLocalized(@"ReceivablesFailure")];
            }

            
        } isIndicator:YES];
    
    [viewModel outOrderPayWithkey:globalData.loginModel.token userId:_userIdStr orderId:_orderIdStr orderType:@"2"];
    
    };
    
    [alert show];
}

- (void)popBack{
    UIViewController *v = nil;
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"GYOrderViewController")]) {
            v = vc;
        }else if([vc isKindOfClass:NSClassFromString(@"GYOutPaidViewController")]){
            
            v = vc;
        }else if ([vc isKindOfClass:NSClassFromString(@"GYQueryViewController")]){
            v = vc;
            
        }
    }
    
    if (v) {
        [self.navigationController popToViewController:v animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)pop{
    
    UIViewController *v = nil;
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"GYOrderViewController")]) {
            v = vc;
        }else if ([vc isKindOfClass:NSClassFromString(@"GYQueryViewController")]){
            v = vc;
            
        }
    }
    if (v) {
        [self.navigationController popToViewController:v animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    
}

#pragma mark-请求订单详情数据
-(void)RequestOderDetailData{
    GYOrderManagerViewModel *orderListDetail = [[GYOrderManagerViewModel alloc]init];
    @weakify(self);
    [self modelRequestNetwork:orderListDetail :^(id resultDic) {
      @strongify(self);
        _dataArr = resultDic;
        GYOrdDetailModel *mdoel = _dataArr[0];
        
        [self.outPayView refreshUI:mdoel];
       
    } isIndicator:YES];
    [orderListDetail GetOrderDetailWithUserIdId:_userIdStr orderId:_orderIdStr];
}

@end
