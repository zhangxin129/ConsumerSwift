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
#define kBackViewHeight 98

#import "GYHEFoodTitleViewController.h"
#import "GYHEFoodTitleCell.h"
#import "GYHSStaffManModel.h"
#import "KxMenu.h"

static  NSString *foodTitleCellID = @"GYHEFoodTitleCell";

@interface GYHEFoodTitleViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,GYHSRoleDescDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIButton * cancelButton;
@property (nonatomic, strong) UIView * backView;
//确认,取消
@property (nonatomic, strong) UIView * buttonView;

@property (nonatomic, strong) UIButton *helpBtn;

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) NSMutableArray *selectArr;

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
        _isSelect = select;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _backView = [[UIView alloc]initWithFrame:self.view.frame];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.3;
    [self.view addSubview:_backView];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEFoodTitleCell class]) bundle:nil] forCellReuseIdentifier:foodTitleCellID];
    
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
    
    [self setUI];
    
    [_dataSource enumerateObjectsUsingBlock:^(GYRoleListModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([_roleIdArray containsObject:obj.roleId]) {
            obj.isSelected = YES;
        }else{
            obj.isSelected = NO;
        }
        
        if (stop) {
            [self.tableView reloadData];
        }
    }];
    
}

-(void)setUI
{
    _buttonView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.tableView.frame), CGRectGetMaxY(_tableView.frame) , self.tableView.frame.size.width, kBackViewHeight)];
    _buttonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_buttonView];
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(40, kBackViewHeight - 68,_buttonView.frame.size.width/2 - 40, 33);
    [leftBtn setBackgroundColor:[UIColor redColor]];
    [leftBtn setTitle:@"确定" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(successClick) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.layer.cornerRadius = 5;
    [_buttonView addSubview:leftBtn];
    self.leftBtn = leftBtn;
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     rightBtn.frame = CGRectMake(CGRectGetMaxX(leftBtn.frame)+10,kBackViewHeight - 68,_buttonView.frame.size.width/2-45,33);
    [rightBtn setBackgroundColor:[UIColor lightGrayColor]];
    
    [rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.layer.cornerRadius = 5;
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
   
    //cell选中才调用代理方法
        if ([self.delegate respondsToSelector:@selector(transSelectedRoleArray:)]) {
            [self.delegate transSelectedRoleArray:self.selectArr];
            [self.view removeFromSuperview];
    }
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    GYHEFoodTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:foodTitleCellID];
    if (cell == nil) {
        cell = [[GYHEFoodTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:foodTitleCellID];
    }
    cell.delegate = self;
    cell.model = _dataSource[indexPath.row];
    cell.questionButton.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYHEFoodTitleCell *cell = (GYHEFoodTitleCell *)[tableView cellForRowAtIndexPath:indexPath];
    GYRoleListModel *selectModel = _dataSource[indexPath.row];
    selectModel.isSelected = !selectModel.isSelected;
    cell.isSelect = selectModel.isSelected;
    cell.model = selectModel;

    NSMutableArray* selectedArray = @[].mutableCopy;
    NSArray *cellArray = [tableView visibleCells];
    for (GYHEFoodTitleCell *cell in cellArray) {
        if (cell.isSelect == YES || cell.model.isSelected == YES) {
            [selectedArray addObject:cell.model];
        }
    }
    self.selectArr = selectedArray;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
#pragma mark -- GYHSRoleDescDelegate

- (void)pullDownRoleDesc:(GYRoleListModel *)model button:(int)button{
    NSArray* menuItems =
    @[
      
      [KxMenuItem menuItem:model.roleDesc
                     image:nil
                    target:self
                    action:nil],
      ];
    
    KxMenuItem* first = menuItems[0];
    first.foreColor = kGray333333;
    first.alignment = NSTextAlignmentCenter;
    CGRect frame = self.view.frame;
    frame.origin.y = (kScreenHeight - 300) / 2 + 14 + 60 *button;
    frame.origin.x = (kScreenWidth - 250) / 2  - 235;
    
    [KxMenu showMenuInWindowfromRect:frame menuItems:menuItems];
}

@end
