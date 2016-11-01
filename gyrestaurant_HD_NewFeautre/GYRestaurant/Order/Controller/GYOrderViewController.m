//
//  GYOrderViewController.m
//  GYCompany
//
//  Created by apple on 15/9/30.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOrderViewController.h"
#import "GYOrderInViewController.h"
#import "GYOrderTakeOutViewController.h"
#import "GYOrderManagerViewModel.h"

@interface GYOrderViewController ()<UISearchBarDelegate, UITextFieldDelegate>

//子视图控制器
@property (nonatomic,strong)GYOrderInViewController *orderInVC;
@property (nonatomic,strong)GYOrderTakeOutViewController *orderTakeOutVC;
@property (nonatomic ,weak) UIViewController *currentVC;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UITableView *orderTabView;

@property (nonatomic, copy) NSString *searchStr;

@property (nonatomic, strong) NSMutableArray *searchArr;
@property (nonatomic, weak) UIButton *takeOutBtn;

@end

@implementation GYOrderViewController
#pragma mark - 继承系统
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self creatNavigation];
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    //子视图控制器实例化
    self.orderInVC = [[GYOrderInViewController alloc]init];
    [self.orderInVC.view setFrame:CGRectMake(0, 0, kScreenWidth ,self.view.height - 50)];
    [self addChildViewController:_orderInVC];

    self.orderTakeOutVC = [[GYOrderTakeOutViewController alloc]init];
    [self.orderTakeOutVC.view setFrame:CGRectMake(0, 0, kScreenWidth , kScreenHeight - 50 - 64)];
    [self addChildViewController:_orderTakeOutVC];
    [self.view addSubview:self.orderInVC.view];
    self.currentVC = _orderInVC;
    [self.view addSubview:self.currentVC.view];
    if (globalData.currentRole == roleTypeTrusteeshipCompanyDeliveryStaff || globalData.currentRole == roleTypeMemberCompanyDeliveryStaff) {
        self.currentVC = self.orderTakeOutVC;
        [self takeOutBtn:self.takeOutBtn];
        [self.view addSubview:self.currentVC.view];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    globalData.pop = NO;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UINavigationItemButtonView")]) {
            view.hidden = YES;
        }
    }
}

#pragma mark - 创建视图
- (void)creatNavigation{
  
    self.navigationItem.leftBarButtonItem = [Utils createBackButtonWithTitle:kLocalized(@"OrderManagement") withTarget:self withAction:@selector(popBack)];
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.size = CGSizeMake(300, 30);
    _searchBar.delegate = self;
    _searchBar.placeholder = kLocalized(@"PleaseEnterTheOrderNumber/AlternateNumber/MobilePhoneNumber");
      
    _searchBar.returnKeyType = UIReturnKeySearch;
    _searchBar.layer.masksToBounds = YES;
    _searchBar.layer.borderWidth = 1;
    _searchBar.layer.borderColor = kBlueFontColor.CGColor;
   // [_searchBar setBackgroundImage:[UIImage imageNamed:@"Query-2"]];
    _searchBar.keyboardType = UIKeyboardTypeNumberPad;
    UIBarButtonItem *bbiRight = [[UIBarButtonItem alloc] initWithCustomView:_searchBar];

    self.navigationItem.rightBarButtonItem = bbiRight;
}

-(void)creatUI{
    @weakify(self);
    
    //店内按钮
    UIButton *eatInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    eatInBtn.tag = 1000;
    
    [self.view addSubview:eatInBtn];
    
    [eatInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@49);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(@(kScreenWidth * 0.5));
        
    }];
    [eatInBtn addTarget:self action:@selector(eatInBtn:) forControlEvents:UIControlEventTouchUpInside];
    [eatInBtn setTitle:kLocalized(@"Store") forState:UIControlStateNormal];
    [eatInBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [eatInBtn setBackgroundImage:[UIImage imageNamed:@"btn.normal"] forState:UIControlStateNormal];
    [eatInBtn setBackgroundImage:[UIImage imageNamed:@"btn.selected"] forState:UIControlStateSelected];
    [eatInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    eatInBtn.selected =YES;
    
    //外卖按钮
    UIButton *takeOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:takeOutBtn];
    
    [takeOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@49);
        make.left.equalTo(eatInBtn.mas_right);
        make.right.equalTo(self.view.mas_right);
        
    }];
    self.takeOutBtn = takeOutBtn;
    [takeOutBtn addTarget:self action:@selector(takeOutBtn:) forControlEvents:UIControlEventTouchUpInside];
    [takeOutBtn setTitle:kLocalized(@"Takeout") forState:UIControlStateNormal];
    [takeOutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [takeOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [takeOutBtn setBackgroundImage:[UIImage imageNamed:@"btn.normal"] forState:UIControlStateNormal];
    [takeOutBtn setBackgroundImage:[UIImage imageNamed:@"btn.selected"] forState:UIControlStateSelected];
    takeOutBtn.tag = 1001;
    
    if (globalData.currentRole == roleTypeTrusteeshipCompanyDeliveryStaff || globalData.currentRole == roleTypeMemberCompanyDeliveryStaff) {
        eatInBtn.userInteractionEnabled = NO;
    }
}

#pragma mark - 懒加载
-(NSMutableArray *)searchArr{
    if (!_searchArr) {
        _searchArr = [[NSMutableArray alloc] init];
    }
    return _searchArr;
}

#pragma mark - btnAction
- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)eatInBtn:(UIButton*)button
{
    [self.navigationItem setHidesBackButton:YES animated:NO];
    if (button.selected) {
        return;
    }
    button.selected = !button.selected;
    ((UIButton *)[self.view viewWithTag:1001]).selected = NO;
    if (self.currentVC == self.orderInVC) {
    
        
        return;
    }
    else{

        [self replaceController:self.currentVC newController:self.orderInVC];
    }
}

-(void)takeOutBtn:(UIButton*)btn{
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")]) {
            view.hidden = YES;
        }
    }
    if (btn.selected) {
        
        return;
    }
    btn.selected = !btn.selected;
    ((UIButton *)[self.view viewWithTag:1000]).selected = NO;
    if (self.currentVC == self.orderTakeOutVC) {
       
            return;
    }
    else{
       
        [self replaceController:self.currentVC newController:self.orderTakeOutVC];
    }
    
}
/**
 *
 *  transitionFromViewController:toViewController:duration:options:animations:completion:
 *  fromViewController	  当前显示在父视图控制器中的子视图控制器
 *  toViewController		将要显示的姿势图控制器
 *  duration				动画时间(这个属性,old friend 了 O(∩_∩)O)
 *  options				 动画效果(渐变,从下往上等等,具体查看API)
 *  animations			  转换过程中的动画
 *  completion			  转换完成
 */

- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
            
        }else{
            
            self.currentVC = oldController;
            
        }
    }];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
//    if (searchBar.text.length != 11 && searchBar.text.length != 17) {
//        [self notifyWithText:@"输入的互生号或手机号或订单号不正确"];
//        return;
//    }

    [self requestSearch:[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
 
}


- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    if (_searchBar.text.length == 0) {
        [self requestSearch:nil];
    }
    return YES;
}


#pragma mark - 给子控制器拿到的资源号
-(void)requestSearch:(NSString *)strText{
    
    if (self.currentVC == self.orderInVC) {
        self.orderInVC.strResNO = strText;
    }else {
        self.orderTakeOutVC.strResNO = strText;
    }
}
@end
