//
//  GYHEFoodTitleViewController.m
//  GYFood
//
//  Created by apple on 15/10/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#define backViewHeight 60
#define kLableBackColor [UIColor whiteColor]
#import "GYHEFoodTitleViewController.h"
@interface GYHEFoodTitleViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIButton * cancelButton;
@property (nonatomic, strong) UIView * backView;
//确认,取消
@property (nonatomic, strong) UIView * buttonView;
//表头的label
@property (nonatomic, strong) UILabel * headerLabel;
//下划线
@property (nonatomic, strong) UIView * line;
@end

@implementation GYHEFoodTitleViewController
-(id)initWithFrame:(CGRect)frame titleArray:(NSArray *)array heardTitle:(NSString *)heardTitle select:(BOOL)select;
{
    if (self = [super init]) {
    _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _dataSource = array;
        _heardString = heardTitle;
        _flag = select;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _backView = [[UIView alloc]initWithFrame:self.view.frame];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.3;
    [self.view addSubview:_backView];
    
    UILabel * headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.tableView.frame),CGRectGetMinY(self.tableView.frame) - 30,self.tableView.frame.size.width, 30)];
    headerLabel.backgroundColor = kLableBackColor;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.text = self.heardString;
    _headerLabel = headerLabel;
    [self.view addSubview:_headerLabel];
    
    //下划线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.tableView.frame),CGRectGetMaxY(self.headerLabel.frame) - 0.5, _headerLabel.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor blackColor];
    line.alpha = 0.2;
    _line = line;
    [self.view addSubview:_line];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //解决cell下划线与左边边界有15像素的距离
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view addSubview:_tableView];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(CGRectGetMinX(self.tableView.frame),CGRectGetMaxY(_tableView.frame),self.tableView.frame.size.width, 30);
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"food_button_deepselect"] forState:UIControlStateNormal];
    [_cancelButton setBackgroundColor:[UIColor lightGrayColor]];
    [_cancelButton addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
    
    [self setUI];
    
    if (!_flag) {
        //底部只有一个取消按钮
        self.buttonView.hidden = YES;
        _headerLabel.hidden = YES;
        _line.hidden = YES;
    }
    else{
        //底部有取消,确定按钮
        self.cancelButton.hidden = YES;
        _headerLabel.hidden = NO;
        _line.hidden = NO;
    }

}

-(void)setUI
{
    _buttonView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.tableView.frame), CGRectGetMaxY(_tableView.frame), self.tableView.frame.size.width, backViewHeight)];
    _buttonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_buttonView];

    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, 15,_buttonView.frame.size.width/2 - 15, 30);
  //  [leftBtn setBackgroundImage:[UIImage imageNamed:@"food_button_fewnormal"] forState:UIControlStateNormal];
    [leftBtn setBackgroundColor:[UIColor lightGrayColor]];
    
    [leftBtn setTitle:kLocalized(@"Cancel") forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:leftBtn];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(CGRectGetMaxX(leftBtn.frame)+10,15,_buttonView.frame.size.width/2-15,30);
   // [rightBtn setBackgroundImage:[UIImage imageNamed:@"food_button_deepselect"] forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:kRedFontColor];
    [rightBtn setTitle:kLocalized(@"Determine") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(successClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonView addSubview:rightBtn];

}

-(void)click
{
    [self.view removeFromSuperview];
}

//取消
-(void)removeView
{
    [self.view removeFromSuperview];
}

//确认
-(void)successClick
{
    NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
   
    if (indexPath == nil) {
        if ([self.headerLabel.text isEqualToString:kLocalized(@"SelectDeliveryStaff")]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:kLocalized(@"PleaseSelectDelivery") delegate:self cancelButtonTitle:kLocalized(@"Determine") otherButtonTitles:nil];
        [alert show];
        }
        else if ([self.headerLabel.text isEqualToString:kLocalized(@"SelectStore")]){
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:kLocalized(@"PleaseSelectStore") delegate:self cancelButtonTitle:kLocalized(@"Determine") otherButtonTitles:nil];
            [alert show];
        }
    }
     //cell选中才调用代理方法
    else{
        if ([self.delegate respondsToSelector:@selector(foodTitleViewController:didSelectedIndex:)]) {
            [self.delegate foodTitleViewController:self didSelectedIndex:(int)indexPath.row];
            [self.view removeFromSuperview];
        }
    }
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    cell.textLabel.text =[NSString stringWithFormat:@"%@",self.dataSource[indexPath.row]];
     //cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = kNavigationBarColor;
    cell.textLabel.backgroundColor = kLableBackColor;
   
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_flag == NO) {
        if ([self.delegate respondsToSelector:@selector(foodTitleViewController:didSelectedIndex:)]) {
        [self.delegate foodTitleViewController:self didSelectedIndex:(int)indexPath.row];
      }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
@end
