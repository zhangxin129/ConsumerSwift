//
//  GYHEServiceOrderListVC.m
//  HSConsumer
//
//  Created by 吴文超 on 16/10/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEServiceOrderListVC.h"
#import "GYHEServiceOrderHeaderView.h"
#import "Masonry.h"
#import "GYHEMiddleViewFirstCell.h"
#import "GYHEFooterViewSecondView.h"
#import "GYHEFooterViewThirdView.h"
#import "GYHEFooterViewFirstView.h"
#import "GYHEFooterViewFourthView.h"
#import "GYHEFooterViewFifthView.h"
#import "GYHEFoodOrderHeaderView.h"
#define kGYHEMiddleViewFirstCell @"GYHEMiddleViewFirstCell"
@interface GYHEServiceOrderListVC ()<UITableViewDataSource,UITableViewDelegate,GYHEServiceOrderHeaderViewDelegate>


@property (nonatomic, strong) UITableView* tableView;//总体表视图

@property (nonatomic, strong) GYHEServiceOrderHeaderView* serviceHeadView; //第一种表头视图
@property (nonatomic, strong) GYHEFoodOrderHeaderView* foodHeadView; //第二种表头视图

@property (nonatomic, strong) GYHEFooterViewFirstView* footerViewFirst; //第一种表尾视图 合计 运费 共多少件商品
@property (nonatomic, strong) GYHEFooterViewFourthView* footerViewSecond; //第二种表尾视图 // 合计 后面三个标示 没有描述
@property (nonatomic, strong) GYHEFooterViewFifthView* footerViewThird; //第三种表尾视图




@property (nonatomic, strong) GYHEFooterViewSecondView* viewBottomFirst;  //最底部的视图一 //实付款

@property (nonatomic, strong) GYHEFooterViewThirdView* viewBottomSecond;  //最底部的视图二 //免费预约





@end

@implementation GYHEServiceOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x1d7dd6);
    self.navigationItem.title = kLocalized(@"提交订单");
     self.view.backgroundColor = kBackgroundGrayColor;
    //这里需要分情况进行布局展示
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-----设置ui
-(void)setUI{
    //前面预设条件
    self.hasAbilityTakeHSCard = YES;
    self.hasValidAddress = NO;
    self.serviceOrFoodType = kFoodOrderType;
    self.freeOrPayImmediatelyType = kPayImmediatelyType;
    
    //餐品服务 是否仅仅在线支付
    self.isOnlyPayOnline = NO;
    
    //按情况判断做显示
    if (self.serviceOrFoodType == kServiceOrderType) {//在服务订单下两种状态
        //如果是免费预约
        if (self.freeOrPayImmediatelyType == kFreeOrderType) {
            [self showFreeOrderPage];
        }
        else
        {//实付款
            [self showPayImmediatelyPage];
        }
    }
    else
    {
        [self showFoodServicePage];
    }
    

    
    
}

//免费预订视图
-(void)showFreeOrderPage{
    
    self.tableView.tableHeaderView = self.serviceHeadView;
    self.tableView.tableFooterView = self.footerViewThird;
    self.viewBottomSecond.descriptionLabel.text = @"免费预约/预订";
}

//实际付款视图
-(void)showPayImmediatelyPage{
    self.tableView.tableHeaderView = self.serviceHeadView;
    self.tableView.tableFooterView = self.footerViewSecond;
    self.viewBottomFirst.realPayCharacterLabel.text = @"实付款";
}

//餐品服务
-(void)showFoodServicePage{
self.tableView.tableHeaderView = self.foodHeadView;
    self.tableView.tableFooterView = self.footerViewFirst;
    self.viewBottomFirst.realPayCharacterLabel.text = @"实付款";
}


#pragma mark-----表视图的代理方法
//表视图代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arc4random() % 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GYHEMiddleViewFirstCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHEMiddleViewFirstCell];
cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;//49.5
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;//7.5
}

#pragma mark-----前面开关按钮的代理方法
//开关控件的代理方法
-(void)reloadData:(GYHEServiceOrderHeaderView *)headView{
    self.tableView.tableHeaderView.frame = headView.frame;
    [self.tableView setTableHeaderView:headView];
    

}

#pragma mark-----懒加载

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 42 - 49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEMiddleViewFirstCell class]) bundle:nil] forCellReuseIdentifier:kGYHEMiddleViewFirstCell];
        [self.view addSubview:self.tableView];
    }
    return _tableView;
}

#pragma mark- 表头尾分解

//头部一
-(GYHEServiceOrderHeaderView *)serviceHeadView{
    //表视图 头部视图
    if (!_serviceHeadView) {
        _serviceHeadView = [[GYHEServiceOrderHeaderView alloc] init];
        _serviceHeadView.hasAbilityTakeHSCard = _hasAbilityTakeHSCard;
        _serviceHeadView.hasValidAddress = _hasValidAddress;
        [_serviceHeadView initView];
        _serviceHeadView.delegate = self;
        
    }
    return _serviceHeadView;
}

//头部二
-(GYHEFoodOrderHeaderView *)foodHeadView{
    if (!_foodHeadView) {
        _foodHeadView = [[GYHEFoodOrderHeaderView alloc] init];
        _foodHeadView.hasAbilityTakeHSCard = _hasAbilityTakeHSCard;
        _foodHeadView.isOnlyPayOnline = _isOnlyPayOnline;
        _foodHeadView.hasValidAddress = _hasValidAddress;
        [_foodHeadView initView];
    }
    return _foodHeadView;
}


//尾部一
-(GYHEFooterViewFirstView *)footerViewFirst{
    if (!_footerViewFirst) {
        _footerViewFirst = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHEFooterViewFirstView class]) owner:self options:nil].lastObject;
    }
    return _footerViewFirst;
}


//尾部二
-(GYHEFooterViewFourthView *)footerViewSecond{
    if (!_footerViewSecond) {
        _footerViewSecond = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHEFooterViewFourthView class]) owner:self options:nil].lastObject;
    }
    return _footerViewSecond;
}

//尾部三
-(GYHEFooterViewFifthView *)footerViewThird{
    if (!_footerViewThird) {
        _footerViewThird = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHEFooterViewFifthView class]) owner:self options:nil].lastObject;
    }
    return _footerViewThird;
}



//底部的提交订单一
-(GYHEFooterViewSecondView *)viewBottomFirst{
    if (!_viewBottomFirst) {
        _viewBottomFirst = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHEFooterViewSecondView class]) owner:self options:nil].lastObject;
        [self.view addSubview:_viewBottomFirst];
        WS(weakSelf);
        [_viewBottomFirst mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-49);
            make.height.mas_equalTo(42);
        }];
    }
    return _viewBottomFirst;
}

//底部的提交订单二
-(GYHEFooterViewThirdView *)viewBottomSecond{
    if (!_viewBottomSecond) {
            _viewBottomSecond = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHEFooterViewThirdView class]) owner:self options:nil].lastObject;
        [self.view addSubview:_viewBottomSecond];
        WS(weakSelf);
        [_viewBottomSecond mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-49);
            make.height.mas_equalTo(42);
        }];
    }
    return _viewBottomSecond;
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
