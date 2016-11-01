//
//  GYSelectTitleViewController.m
//  HSCompanyPad
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYSelectTitleViewController.h"
#import "GYSelectTitleCell.h"
#import "GYHSStaffManModel.h"

#define backViewHeight 60
#define kLableBackColor [UIColor whiteColor]
//导航栏颜色
#define kNavigationBarColor kRGBA(0, 160, 223, 1)
#define kRedFontColor [UIColor colorWithRed:230/255.0f green:33/255.0f blue:41/255.0f alpha:1.0f]

static NSString *selectTitleCellID = @"GYSelectTitleCell";
@interface GYSelectTitleViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIButton * cancelButton;
@property (nonatomic, strong) UIView * backView;
//确认,取消
@property (nonatomic, strong) UIView * buttonView;
//表头的label
@property (nonatomic, strong) UILabel * headerLabel;
//下划线
@property (nonatomic, strong) UIView * line;

@property (nonatomic, strong) NSMutableArray *selectArr;

@end

@implementation GYSelectTitleViewController

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

    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYSelectTitleCell class]) bundle:nil] forCellReuseIdentifier:selectTitleCellID];
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
    leftBtn.frame = CGRectMake(40, 15,_buttonView.frame.size.width/2 - 40, 30);
    [leftBtn setBackgroundColor:[UIColor redColor]];
    [leftBtn setTitle:@"确定" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(successClick) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.layer.cornerRadius = 5;
    [_buttonView addSubview:leftBtn];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(CGRectGetMaxX(leftBtn.frame)+10,15,_buttonView.frame.size.width/2-45,30);
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
    
    if ([self.delegate respondsToSelector:@selector(transSelectedShopNameArray:)]) {
        [self.delegate transSelectedShopNameArray:self.selectArr];
        [self.view removeFromSuperview];
        }
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYSelectTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:selectTitleCellID];
    if (cell == nil) {
        cell = [[GYSelectTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectTitleCellID];
    }
    cell.model = _dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GYSelectTitleCell *cell = (GYSelectTitleCell *)[tableView cellForRowAtIndexPath:indexPath];
    GYRelationShopsModel *selectModel = _dataSource[indexPath.row];
    selectModel.isSelected = !selectModel.isSelected;
    cell.isSelect = selectModel.isSelected;
    cell.model = selectModel;
    
    NSMutableArray* selectedArray = @[].mutableCopy;
    NSArray *cellArray = [tableView visibleCells];
    for (GYSelectTitleCell *cell in cellArray) {
        if (cell.isSelect == YES) {
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

@end
