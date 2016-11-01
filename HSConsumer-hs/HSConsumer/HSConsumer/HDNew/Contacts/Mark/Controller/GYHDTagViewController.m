//
//  ViewController.m
//  Tags
//
//  Created by 赵春浩 on 16/8/15.
//  Copyright © 2016年 Mr Zhao. All rights reserved.
//

#import "GYHDTagViewController.h"
#import "GYHDTagView.h"
#import "GYHDGroupTagView.h"
#import "GYHDMessageCenter.h"
#import "UIViewExt.h"

@interface GYHDTagViewController ()<GYHDTagViewDelegate, TTGroupTagViewDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

/**
 *  记录输入标签的高度
 */
@property (assign, nonatomic) CGFloat inputHeight;
/**
 *  输入标签的背景视图(为了改变其高度)
 */
@property (strong, nonatomic) UIView *textBgView;
/**
 *  用来展示标签列表的
 */
@property (strong, nonatomic) UITableView *tableView;
/**
 *  存储获取的标签列表
 */
@property (strong, nonatomic) NSMutableArray *dataArr;

/**
 *  存储标签列表cell的高度
 */
@property (strong, nonatomic) NSMutableArray *heightArr;
/**
 *  记录输入框中输入的标签
 */
@property (strong, nonatomic) NSMutableArray *selectedTags;

@end

@implementation GYHDTagViewController {
    /**
     *  输入标签view
     */
    GYHDTagView *inputTagView;
    
}

#pragma mark - 懒加载数据
- (UIView *)textBgView {
    if (_textBgView == nil) {
        _textBgView = [[UIView alloc] init];
    }
    return _textBgView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.inputHeight,  [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height - (64 + self.inputHeight)) style:UITableViewStyleGrouped];
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)heightArr {
    if (_heightArr == nil) {
        _heightArr = [NSMutableArray array];
    }
    return _heightArr;
}

- (NSMutableArray *)selectedTags {
    if (_selectedTags == nil) {
        _selectedTags = [NSMutableArray array];
    }
    return _selectedTags;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"标签";
    self.inputHeight = 50;
    self.view.backgroundColor = [UIColor grayColor];// kCOLOR(245);
    [self addSubviews];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setData];
    
    //设置视图是否延伸到StatusBar的后面
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        //刷新状态栏样式
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
//    if (self.bqlabStr.length > 0) {
//        [inputTagView addTags:self.selectedTags];
//    }
    UIButton *barBtn = [[UIButton alloc] init];
    [barBtn setTitle:@"保存" forState:UIControlStateNormal];
    [barBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [barBtn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    [barBtn addTarget:self action:@selector(barBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    barBtn.frame = CGRectMake(0, 0, 66, 44);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barBtn];
}
- (void)barBtnClcik {
    NSLog(@"%@",self.selectedTags);
//    NSMutableString *selectTag = [NSMutableString string];
    

    NSArray *teamArray =  [[GYHDMessageCenter sharedInstance] selectInfoEqualDict:nil TableName:GYHDDataBaseCenterFriendTeamTableName];
    NSMutableString *teamID = [NSMutableString string];
    for (NSDictionary *teamDict in teamArray) {
        for (NSString *tag in self.selectedTags) {
            if ([tag isEqualToString:teamDict[@"Tream_Name"]]) {
                [teamID appendFormat:@"%@,",teamDict[@"Tream_ID"]];
            }
        }
        
    }
    if (teamID.length) {
       [teamID deleteCharactersInRange:NSMakeRange(teamID.length -1, 1)];
    }
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    sendDict[@"teamId"] = teamID;
    sendDict[@"userId"] =  [NSString stringWithFormat:@"c_%@",globalData.loginModel.custId];
    sendDict[@"friendId"] = [NSString stringWithFormat:@"c_%@",self.friendCustID];
    sendDict[@"originalTeamId"] = @"";

    [[GYHDMessageCenter sharedInstance] MovieFriendToTagWithDict:sendDict RequetResult:^(NSDictionary *resultDict) {
        UIWindow *windows = [UIApplication sharedApplication].keyWindow;
        [windows makeToast:[GYUtils localizedStringWithKey:@"GYHD_success"] duration:1.0f position:CSToastPositionCenter];
        [[GYHDMessageCenter sharedInstance] getFriendListRequetResult:^(NSArray *resultArry) {
            
        }];
    }];
    NSLog(@"%@",teamID);
}
#pragma mark - 获取顾客标签的列表
- (void)setData {
    NSDictionary* dict = [[GYHDMessageCenter sharedInstance] selectFriendBaseWithCardString:self.friendCustID];
    NSDictionary* friendDict = [GYUtils stringToDictionary:dict[@"Friend_Basic"]];
    NSString *friendTeam = friendDict[@"teamName"];
    if (friendTeam.length) {
        self.selectedTags = [NSMutableArray arrayWithArray:[friendTeam componentsSeparatedByString:@","]];
    }

    NSArray *teamArray =  [[GYHDMessageCenter sharedInstance] selectInfoEqualDict:nil TableName:GYHDDataBaseCenterFriendTeamTableName];
  
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *teamDict in teamArray) {
        [array addObject:teamDict[@"Tream_Name"]];
    }
    self.dataArr = [NSMutableArray arrayWithArray:@[array]];
  
    
    [self.tableView reloadData];
    
}


#pragma mark - 加载子视图
- (void)addSubviews {
    
    UIView *textBgView = [[UIView alloc] init];
    textBgView.layer.borderColor = [UIColor greenColor].CGColor;
    textBgView.layer.borderWidth = 0.5;
    
    [self.view addSubview:textBgView];
    self.textBgView = textBgView;
    [textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo([NSNumber numberWithFloat:self.inputHeight]);
    }];
    
    inputTagView = [[GYHDTagView alloc] initWithFrame:CGRectMake(0, 0,self.view.width ,self.inputHeight)];
    inputTagView.translatesAutoresizingMaskIntoConstraints=YES;
    inputTagView.delegate = self;
    
//    {// 这些属性有默认值, 可以不进行设置
//        inputTagView.inputBgColor = kRandomColor;
//        inputTagView.inputPlaceHolderTextColor = kRandomColor;
//        inputTagView.inputTextColor = kRandomColor;
//        inputTagView.inputBorderColor = kRandomColor;
//        inputTagView.bgColor = kRandomColor;
//        inputTagView.textColor = kRandomColor;
//        inputTagView.borderColor = kRandomColor;
//        inputTagView.selBgColor = kRandomColor;
//        inputTagView.selTextColor = kRandomColor;
//        inputTagView.selBorderColor = kRandomColor;
//    }
//    
    // KVO监测其高度是否发生改变(改变的话就需要修改下边的所有控件的frame)
    [inputTagView addObserver:self forKeyPath:@"changeHeight" options:NSKeyValueObservingOptionNew context:nil];
    
    [textBgView addSubview:inputTagView];
    
    // 这里刷新是为了如果没有已经存在的标签(bqlabStr)传进来的话就会出问题
    [inputTagView layoutTagviews];
    [inputTagView resignFirstResponder];
    
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor grayColor];// kCOLOR(245);
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.backgroundColor = kCOLOR(245);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSelectedTag)];
    [cell.contentView addGestureRecognizer:tap];
    [cell.contentView addSubview:[self addHistoryViewTagsWithCGRect:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, 44) andIndex:indexPath]];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.heightArr.count > 0) {
        return [self.heightArr[indexPath.section] floatValue];
        
    } else {
        return 44.0;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

#pragma mark - 返回组标题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, 40)];
    bgView.backgroundColor = [UIColor grayColor];//kCOLOR(245);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 12.5, 15, 15)];
    view.backgroundColor = [self getGroupTitleColorWithIndex:section];
    view.layer.cornerRadius = 2;
    [bgView addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 10,  [UIScreen mainScreen].bounds.size.width - 35, 20)];
    if (self.dataArr.count > 0) {
        label.text = @"输入标签";
    }
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:label];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSelectedTag)];
    
    [bgView addGestureRecognizer:tap];
    
    return bgView;
    
}

- (UIColor *)getGroupTitleColorWithIndex:(NSInteger)section {
    return [UIColor blackColor];
//    NSInteger index = section % 4;
//    
//    switch (index) {
//        case 0:
//            return kCustomColor(255, 102, 102);
//            break;
//            
//        case 1:
//            return kCustomColor(153, 153, 255);
//            break;
//        case 2:
//            return kCustomColor(51, 204, 153);
//            break;
//            
//        default:
//            return kCustomColor(255, 153, 0);
//            break;
//    }
    
}


#pragma mark - 添加标签列表视图
- (GYHDGroupTagView *)addHistoryViewTagsWithCGRect:(CGRect)rect andIndex:(NSIndexPath *)indexPath{
    
    
    GYHDGroupTagView *tagView = [[GYHDGroupTagView alloc] initWithFrame:rect];
    tagView.tag = indexPath.section + 1000;
    tagView.translatesAutoresizingMaskIntoConstraints=YES;
    tagView.delegate = self;
    tagView.changeHeight = 0;
    tagView.backgroundColor = [UIColor clearColor];

//    {// 这些属性颜色有默认值, 可以设置也可以不设置
//        tagView.bgColor = kRandomColor;
//        tagView.textColor = kRandomColor;
//        tagView.borderColor = kRandomColor;
//        tagView.selBgColor = kRandomColor;
//        tagView.selTextColor = kRandomColor;
//        tagView.selBorderColor = kRandomColor;
//        
//    }
    
    
    
    
    if (self.dataArr.count > 0) {
        [tagView addTags:self.dataArr[indexPath.section]];
    }
    // 这里存储tagView的最大高度, 是为了设置cell的行高
    if (self.heightArr.count) {
        [self.heightArr removeObjectAtIndex:indexPath.row];
        [self.heightArr insertObject:[NSString stringWithFormat:@"%f", tagView.changeHeight] atIndex:indexPath.row];
    }else {
        [self.heightArr addObject:[NSString stringWithFormat:@"%f", tagView.changeHeight]];
    }

    

    
    
    // 在这里处理上下标签的对应关系, 上边出现的标签如果下边也有的话就要修改其状态(改为选中状态)
    {
        
        if (self.selectedTags.count != 0) {
            NSArray *tags = self.selectedTags;
            [inputTagView addTags:tags];
            NSMutableArray *arr = [NSMutableArray array];
            for (int i = 0; i < tags.count; i ++) {
                
                NSArray *result = [tagView.tagStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", tags[i]]];
                
                if (result.count != 0) {
                    [arr addObject:tags[i]];
                    
                }
                
            }
            [tagView setTagStringsSelected:arr];
            
        }
        
    }
    
    return tagView;
    
}

#pragma mark - TTGroupTagViewDelegate
// 点击下边的固定标签列表, 对应上边的标签是删除还是添加(通过这个代理方法实现)
- (void)buttonClick:(NSString *)string and:(BOOL)isDelete {
    
    if (isDelete) {// 删除
        
        inputTagView.deleteString = string;
        [self.selectedTags removeObject:string];
    } else {// 添加
        
        [inputTagView addTags:@[string]];
        [self.selectedTags addObject:string];
    }
}

#pragma mark - GYHDTagViewDelegate
// 点击上边的输入标签并且删除之后,看下边是否有对应的标签, 有的话就修改其状态
- (void)deleteBtnClick:(NSString *)string {
    
    [self.selectedTags removeObject:string];
    // 遍历下边的固定标签, 看是否有相同的
    for (int j = 0; j < self.dataArr.count; j ++) {
        NSArray *lists = self.dataArr[j];
        NSArray *result = [lists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", string]];
        
        if (result.count != 0) {
            // 获取到对应的分组标签, 改变其标签的状态
            GYHDGroupTagView *tagView = [self.view viewWithTag:j + 1000];
            tagView.deleteString = string;
            return;
        }
    }
    
}

#pragma mark - 上边的输入标签, 输入完成之后, 遍历下边的固定标签, 看是否有相同的, 如果有相同的, 就修改其状态(这里也包括刚进入这个页面的时候从上个页面传进来的标签)
- (void)finishInput:(NSString *)string {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int j = 0; j < self.dataArr.count; j ++) {
        NSArray *lists = self.dataArr[j];
        NSArray *result = [lists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", string]];
        
        if (result.count != 0) {
            [arr addObject:string];
            GYHDGroupTagView *tagView = [self.view viewWithTag:j + 1000];
            // 修改对应标签的状态为选中状态
            [tagView setTagStringsSelected:arr];
            
            return;
        }else {
            NSMutableArray *arrayM = [NSMutableArray arrayWithArray:self.dataArr[0]];
            [arrayM addObject:string];
            self.dataArr[0] = arrayM;
            [self.selectedTags addObject:string];
            [self.tableView reloadData];
        }
    }
}


#pragma mark - 当被观察的值发生变化，上面那个添加的观察就会生效，而生效后下一步做什么，由下面这个方法决定，下面会输出变化值，即change
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    self.inputHeight = [[change valueForKey:@"new"] floatValue];
    [self.textBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithFloat:self.inputHeight]);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.frame = CGRectMake(0, self.inputHeight,  [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - self.inputHeight - 64);
    }];
    
}

#pragma mark - 添加的手势方法(用来取消inputView中的被选中的标签)
- (void)cancelSelectedTag {
    
    [inputTagView layoutTagviews];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [inputTagView layoutTagviews];
    [inputTagView endEditing:YES];
}


#pragma mark - set方法
//- (void)setBqlabStr:(NSString *)bqlabStr {
//    if (_bqlabStr != bqlabStr) {
//        _bqlabStr = bqlabStr;
//    }
//    if (bqlabStr.length > 0) {
//        NSArray *tags = [self.bqlabStr componentsSeparatedByString:@" "];
//        self.selectedTags = [NSMutableArray arrayWithArray:tags];
//    }
//    
//}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [inputTagView removeObserver:self forKeyPath:@"changeHeight"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
