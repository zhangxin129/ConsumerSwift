//
//  GYFoodActeGoryListView.m
//  GYRestaurant
//
//  Created by apple on 15/10/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYFoodActeGoryListView.h"
#import "GYTakeOrderListModel.h"
#import "GYSyncShopFoodsCell.h"
#import "GYSyncShopFoodsCollectionView.h"
#import "GYTakeOrderTool.h"


@interface GYFoodActeGoryListView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UIButton *btnFooter;
@property (nonatomic, strong) UITableView *tbvList;
@property (nonatomic, assign) int sum;
@end

@implementation GYFoodActeGoryListView


#pragma mark - 系统方法
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notification) name:GYSyncShopFoodsCellNotification object:nil];
        [kDefaultNotificationCenter addObserver:self selector:@selector(notification) name:GYSinglePointCellDeleteNotification object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notification) name:GYTakeOrderSuccessNotification object:nil];
        
    }
    
    return self;
}



#pragma mark - 自定义方法

- (void)setup
{
    UIButton *btnHeader = [self createdBtn];
    btnHeader.tag = 100;
    btnHeader.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height / 9);
    btnHeader.hidden = NO;
    [btnHeader setTitle:kLocalized(@"SinglePointClear") forState:UIControlStateNormal];
    
    [self addSubview:btnHeader];
    self.btnHeader = btnHeader;
    
    UIButton *btnFooter = [self createdBtn];
    btnFooter.tag = 101;
    btnFooter.frame = CGRectMake(0, 8 * self.frame.size.height / 9, self.frame.size.width, self.frame.size.height / 9);
    [btnFooter setTitle:kLocalized(@"Ithascarte") forState:UIControlStateNormal];
    [self addSubview:btnFooter];
    self.btnFooter = btnFooter;
    
    
    
    self.tbvList = [[UITableView alloc]initWithFrame:self.frame style:UITableViewStylePlain];
    self.tbvList.backgroundColor = [UIColor lightGrayColor];
    self.tbvList.frame = self.tbvList.frame = CGRectMake(0, 0, self.frame.size.width, 8 * self.frame.size.height / 9);
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    self.tbvList.tableFooterView = view;
    self.tbvList.tableHeaderView = view;
    self.tbvList.delegate = self;
    self.tbvList.dataSource = self;
    [self addSubview:self.tbvList];
    
}

#pragma mark--------UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mdataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
    UIView *vback = [[UIView alloc]initWithFrame:cell.frame];
    vback.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:215.0/255.0 blue:163.0/255.0 alpha:1.0];
    cell.selectedBackgroundView = vback;
    GYTakeOrderListModel * model = self.mdataSource[indexPath.row];
    cell.textLabel.text = model.itemCustomCategoryName;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:24.0];
    cell.textLabel.textColor = [UIColor colorWithRed:95.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0];
   
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
      return (kScreenHeight - 64)/9;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell *cell = [self.tbvList cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = kRedFontColor;
    
    
    if ([self.delegate respondsToSelector:@selector(GYFoodActeGoryListViewRowAtIndexPath:)]) {
                [self.delegate GYFoodActeGoryListViewRowAtIndexPath:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.tbvList cellForRowAtIndexPath:indexPath];
    
    cell.textLabel.textColor = [UIColor colorWithRed:95.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0];
}

#pragma mark-------创建btn
- (UIButton *)createdBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 5);
    btn.titleLabel.font = [UIFont systemFontOfSize:25.0];
    
    btn.backgroundColor = [UIColor colorWithRed:95.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0];
    [btn setTitleColor:[UIColor colorWithRed:253.0/255.0 green:209.0/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(headerAndFooterClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark-------btn的点击事件

- (void)headerAndFooterClick:(UIButton *)btn
{
    if (btn.tag == 100 ) {
        
        [self.btnFooter setTitle:kLocalized(@"Ithascarte") forState:UIControlStateNormal];
        self.btnHeader.hidden = YES;
        kNotice(kLocalized(@"CarteNenuHasBeenCleared"));
        self.tbvList.frame = CGRectMake(0, 0, self.frame.size.width, 8 * self.frame.size.height / 9);
        [GYTakeOrderTool reloadTabkeOrderList];
        [[NSNotificationCenter defaultCenter]postNotificationName:GYFoodActeGoryListHeaderClickNotification object:nil];
        self.sum = 0;
        
     
    }
    
    if (btn.tag == 101) {
        if ([self.delegate respondsToSelector:@selector(GYFoodActeGoryListViewPushVC:sumCount:)]) {
                [self.delegate GYFoodActeGoryListViewPushVC:btn sumCount:self.sum];
            }
    }
    
}


- (void)setMdataSource:(NSArray *)mdataSource
{
    _mdataSource = mdataSource;
    
    [self.tbvList reloadData];
    
}


/**
 *  处理通知消息
 *
 *
 */
- (void)notification

{
    int i = [GYTakeOrderTool getTakeListNum];
    self.sum = i;
    if (i > 0){
        self.btnHeader.hidden = NO;
       // [self.btnHeader setTitle:@"清除点单" forState:UIControlStateNormal];
        self.tbvList.frame = CGRectMake(0, self.frame.size.height / 9, self.frame.size.width, 7 * self.frame.size.height / 9);
    }
    
    
    if (i == 0){
        self.btnHeader.hidden = YES;
        
       self.tbvList.frame = self.tbvList.frame = CGRectMake(0, 0, self.frame.size.width, 8 * self.frame.size.height / 9);
        [self.btnFooter setTitle:kLocalized(@"Ithascarte") forState:UIControlStateNormal];
    }else{
    [self.btnFooter setTitle:[NSString stringWithFormat:@"%@ (%d)",kLocalized(@"Ithascarte"),i] forState:UIControlStateNormal];
    }
}



@end
