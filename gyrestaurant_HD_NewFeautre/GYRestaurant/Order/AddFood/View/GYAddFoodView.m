//
//  GYAddFoodView.m
//  GYRestaurant
//
//  Created by apple on 15/10/28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAddFoodView.h"
#import "GYTakeOrderListModel.h"
#import "GYSyncShopFoodsModel.h"
#import "GYTakeOrderTool.h"
@interface GYAddFoodView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UITableView *tbvAddFoodView;
@property (nonatomic, assign) int sum;

@end
@implementation GYAddFoodView

#pragma mark - 系统方法
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GYAddFoodCollecionViewChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GYAddFoodChangeNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addFoodnotification) name:GYAddFoodChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addFoodnotification) name:GYAddFoodCollecionViewChangeNotification object:nil];
    }
    return self;
}

- (void)setup
{
    UIButton *btnHeader = [self createdBtn];
    btnHeader.tag = 100;
    btnHeader.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height / 9);
    [self addSubview:btnHeader];
    self.btnHeader = btnHeader;
    
    UIButton *btnFooter = [self createdBtn];
    btnFooter.tag = 101;
    btnFooter.frame = CGRectMake(0, 8 * self.frame.size.height / 9, self.frame.size.width, self.frame.size.height / 9);
    [btnFooter setTitle:kLocalized(@"AddMenu") forState:UIControlStateNormal];
    [self addSubview:btnFooter];
    self.btnFooter = btnFooter;
    
    UITableView *tbvAddFoodView = [[UITableView alloc]initWithFrame:self.frame style:UITableViewStylePlain];
    tbvAddFoodView.backgroundColor = [UIColor lightGrayColor];
    tbvAddFoodView.frame = self.tbvAddFoodView.frame = CGRectMake(0, self.frame.size.height / 9, self.frame.size.width, 7 * self.frame.size.height / 9);
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    self.tbvAddFoodView.tableFooterView = view;
    tbvAddFoodView.delegate = self;
    tbvAddFoodView.dataSource = self;
    tbvAddFoodView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tbvAddFoodView];
    self.tbvAddFoodView = tbvAddFoodView;
}

#pragma mark - 自定义方法
/**
 *  处理通知消息
 *
 *
 */
- (void)addFoodnotification

{
    int i = [GYTakeOrderTool getTakeListNum];
    
    
    if (i > 0) {
        self.btnHeader.hidden = NO;
        self.tbvAddFoodView.frame = CGRectMake(0, self.frame.size.height / 9, self.frame.size.width, 7 * self.frame.size.height / 9);
    }
    
    self.sum = i;
    [self.btnFooter setTitle:[NSString stringWithFormat:@"%@ (%d)",kLocalized(@"AddMenu"),i] forState:UIControlStateNormal];
    
}


#pragma mark - 创建btn
- (UIButton *)createdBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 5);
    btn.titleLabel.font = [UIFont systemFontOfSize:25.0];
    
    btn.backgroundColor = [UIColor colorWithRed:95.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0];
    [btn setTitleColor:[UIColor colorWithRed:253.0/255.0 green:209.0/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(addFoodheaderAndFooterClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - btn的点击事件

- (void)addFoodheaderAndFooterClick:(UIButton *)btn
{
    
    if (btn.tag == 101) {
        
        if ([self.delegate respondsToSelector:@selector(GYAddFoodViewPushVC:sumCount:)]) {
            [self.delegate GYAddFoodViewPushVC:btn sumCount:self.sum];
        }
    }
    
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"addFoodCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
    UIView *vback = [[UIView alloc]initWithFrame:cell.frame];
    vback.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:215.0/255.0 blue:163.0/255.0 alpha:1.0];
    cell.selectedBackgroundView = vback;
    GYTakeOrderListModel * model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.itemCustomCategoryName;
    cell.textLabel.font = [UIFont systemFontOfSize:24.0];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:95.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0];
   
    
    
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (kScreenHeight - 64)/9;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tbvAddFoodView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = kRedFontColor;
    if ([self.delegate respondsToSelector:@selector(GYAddFoodViewRowAtIndexPath:)]) {
        [self.delegate GYAddFoodViewRowAtIndexPath:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tbvAddFoodView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor colorWithRed:95.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0];
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    
    [self.tbvAddFoodView reloadData];
    
}

@end
