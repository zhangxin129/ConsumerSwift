//
//  GYHEVisitSurroundSearchVC.m
//  HSConsumer
//
//  Created by 吴文超 on 16/10/17.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEVisitSurroundSearchVC.h"
#import "Masonry.h"
#import "GYHESearchCollectionCell.h"
#import "GYAlertView.h"
//
#import "GYEasybuySearchDetailViewController.h"
#import "GYHECollectionViewLeftAlignedLayout.h"

//临时实验
//#import "GYHEVisitListViewController.h"
//#import "GYHETakeawayListViewController.h"

//
#import "GYHESearchShopVC.h"
#import "GYHEVisitListModel.h"
#import "GYHESearchGoodsVC.h"

#define kSearchCell @"searchCell"
#define kGap 2
#define kCellId @"cellId"
#define kRemoveTag 1222

#define kCollectionViewTag 1542
#define kTableViewTag 1632
#define kGoodsOrShopsViewTag 1854
//
typedef void (^buttonClickBlock)(NSInteger buttonIndex);

@interface GYHEVisitSurroundSearchVC ()<UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>//

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *historyWordsArray;//本地存储的搜索词

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *automatedKeyWordsArray;//联想词

@property (nonatomic, copy) NSString *keyUserDefault;//本地化
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIButton* btnSearch;
@property (nonatomic, strong) UIButton* btnCancel;
@property (nonatomic, assign) BOOL isAreadySearch;


@property (nonatomic, strong)NSMutableArray *dataArry; //数据源
@end

@implementation GYHEVisitSurroundSearchVC
#pragma mark - 生命周期
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = kNavigationBarColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.view.backgroundColor                            = kDefaultVCBackgroundColor;
    //测试
//    self.contentTabelType = kShopsType;//kShopsType //kGoodsType
    [self setNavItem];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.historyWordsArray                    = nil;

    self.textField.placeholder = @"请输入搜索内容";


    if (kScreenWidth < 325 && [self.textField.placeholder
                               isEqualToString:kLocalized(@"GYHE_Easybuy_pleaseEnterSearchShops")])
    {
        [self.textField
         setValue:[UIFont boldSystemFontOfSize:12]
        forKeyPath :@"_placeholderLabel.font"];
    }   //本地化读取

    [self.textField becomeFirstResponder];
    if (self.contentTabelType == kGoodsType) {
        self.searchShowType = kGYHESearchShowTable;
        [self setUpTableView];
        return;
    }
    self.searchShowType = kGYHESearchShowCollection;
    [self setUpCollection];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(searchTextFieldTextChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];

    }

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 生成集合视图
- (void)setUpCollection
{
    NSArray *arr = [self.view subviews];
    
    for (UIView* view in arr) {
        [view removeFromSuperview];
    }
    
    [self.view
     addSubview:self.collectionView];
    self.collectionView.tag             = kCollectionViewTag;
    self.collectionView.backgroundColor = [UIColor whiteColor];

    [self.collectionView
     registerClass:[GYHESearchCollectionCell class]
     forCellWithReuseIdentifier:kCellId];

    //注册headerView
    [self.collectionView
     registerClass:[UICollectionReusableView class]
     forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
            withReuseIdentifier:@"reusableView"];
}

#pragma mark - 生成表视图
- (void)setUpTableView
{
    if (self.isAreadySearch == YES) {
        return;
    }
    NSArray *arr = [self.view subviews];
    
    for (UIView* view in arr) {
        [view removeFromSuperview];
    }
    
    [self.view
     addSubview:self.tableView];
    self.tableView.tag = kTableViewTag;
    [_tableView registerClass:[UITableViewCell class]
       forCellReuseIdentifier:kSearchCell];
    [_tableView reloadData];
}

-(void)setupGoodsOrShopsView{
    NSArray *arr = [self.view subviews];
    for (UIView* view in arr) {
        [view removeFromSuperview];
    }
#pragma mark - 此处需要好好修改
    
    if (self.contentTabelType == kShopsType) {
//先跳过来 再在里面去做数据请求功能
        GYHESearchShopVC* vc = [[GYHESearchShopVC alloc] init];
        vc.searchWord = self.textField.text;
        [self.view
         addSubview:vc.view];
        [self addChildViewController:vc];
        vc.view.tag = kGoodsOrShopsViewTag;

    }
    else if (self.contentTabelType == kGoodsType) {
        GYHESearchGoodsVC* vc = [[GYHESearchGoodsVC alloc] init];
        
        [self.view
         addSubview:vc.view];
        [self addChildViewController:vc];
        vc.view.tag = kGoodsOrShopsViewTag;
    }
    

}

#pragma mark - 显示视图情况判断
//根据需要显示视图
- (void)addNeededViewWithShowType:(SearchShowType)searchShowType
{
    if (searchShowType == kGYHESearchShowCollection)
    {
        [self setUpCollection];
    }
    else if (searchShowType == kGYHESearchShowTable)
    {
        [self setUpTableView];
    }
    else if (searchShowType == kGYHESearchShowContent)
    {
        [self setupGoodsOrShopsView];
    }
}

#pragma mark - 设置导航栏
//设置导航栏
- (void)setNavItem
{
    //左边的黑色箭头
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame           = CGRectMake(0, 0, 9, 18);
    btnBack.backgroundColor = [UIColor clearColor];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"gyhs_main_leftArrow"]
                       forState:UIControlStateNormal];
    [btnBack addTarget:self
                action:@selector(back:)
      forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];

    //右边的搜索按钮
    [self setSearchBtn];

    //中间的输入框
    self.navigationItem.titleView = [self setMiddleView];
}
//做一个Button
-(UIButton*)giveBtnStr:(NSString*)string{
    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.frame           = CGRectMake(0, 0, 30, 30);
    btnSearch.imageEdgeInsets = UIEdgeInsetsMake(6, 30, 6, 0);
    btnSearch.backgroundColor = [UIColor clearColor];
    NSString *titleStr = string;
    [btnSearch setTitle:titleStr
               forState:UIControlStateNormal];
    
    NSMutableAttributedString *aAttributedString = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [aAttributedString addAttribute:NSFontAttributeName             //文字字体
                              value:[UIFont systemFontOfSize:15]
                              range:NSMakeRange(0, 2)];
    [btnSearch setAttributedTitle:aAttributedString
                         forState:UIControlStateNormal];
    [btnSearch setTitleColor:[UIColor grayColor]
                    forState:UIControlStateNormal];
    return btnSearch;
}
//生成取消按钮
-(void)setCancelBtn{
    [self.btnSearch removeFromSuperview];
    self.self.navigationItem.rightBarButtonItem = nil;
    
    self.btnCancel = [self giveBtnStr:kLocalized(@"取消")];
    [self.btnCancel addTarget:self
                       action:@selector(back:)
             forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnCancel];
}
//生成搜索按钮
-(void)setSearchBtn{
    [self.btnCancel removeFromSuperview];
    self.self.navigationItem.rightBarButtonItem = nil;
    self.btnSearch = [self giveBtnStr:kLocalized(@"搜索")];
    [self.btnSearch addTarget:self
                       action:@selector(saveDataAndShowSearchContent)
             forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnSearch];
}

#pragma mark - 点搜索按钮或 搜索功能 方法实现
//显示搜索内容，并将搜索数据存到本地
- (void)saveDataAndShowSearchContent
{
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@" "];
    NSString *str             = [[self.textField.text
                      componentsSeparatedByCharactersInSet:doNotWant] componentsJoinedByString:@""];
    if (self.textField.text.length == 0 || str.length == 0)
    {
        NSString *msg = @"搜索没有内容";
        [self.textField resignFirstResponder];
        [GYUtils showMessage:msg];
        return;
    }
    if (_contentTabelType == kShopsType) {
        [self saveData];
    }
    
    [self.view
     endEditing:YES];
    
    //搜索之后 搜索按钮变成 取消 两个字
    [self setCancelBtn];
    [self.textField becomeFirstResponder];
    
    //变更状态
    self.searchShowType = kGYHESearchShowContent;
    self.isAreadySearch = YES;
    //做显示
    [self addNeededViewWithShowType:self.searchShowType];
    
}

//中间输入框部分布局
- (UIView *)setMiddleView
{
    UIView *vHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    vHead.backgroundColor = [UIColor whiteColor];
    UIView *vTitleView = [[UIView alloc] initWithFrame:CGRectMake(5, 4, kScreenWidth - 100, 32)];
    vTitleView.backgroundColor     = [UIColor colorWithRed:235.0 / 255.0f
                                                     green:235.0 / 255.0f
                                                      blue:235.0 / 255.0f
                                                     alpha:1.0f];
    vTitleView.layer.masksToBounds = YES;
    vTitleView.layer.cornerRadius  = 16;


    UITextField *tfInputSearchText = [[UITextField alloc] initWithFrame:CGRectMake(15, 4, CGRectGetWidth(vTitleView.frame) - 20, 25)];
    tfInputSearchText.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    imageView.image                            = [UIImage imageNamed:@"gyhd_search_icon"];
    tfInputSearchText.leftView                 = imageView;
//    tfInputSearchText.borderStyle              = UITextBorderStyleRoundedRect;
    tfInputSearchText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

    tfInputSearchText.contentMode                   = UIViewContentModeScaleToFill;
    tfInputSearchText.returnKeyType                 = UIReturnKeySearch;
    tfInputSearchText.delegate                      = self;
    tfInputSearchText.clearButtonMode               = UITextFieldViewModeWhileEditing;
    tfInputSearchText.enablesReturnKeyAutomatically = YES;
    tfInputSearchText.textColor                     = [UIColor colorWithRed:95.0 / 255.0f
                                                                      green:95.0 / 255.0f
                                                                       blue:95.0 / 255.0f
                                                                      alpha:1.0f];
    tfInputSearchText.backgroundColor               = [UIColor colorWithRed:235.0 / 255.0f
                                                                      green:235.0 / 255.0f
                                                                       blue:235.0 / 255.0f
                                                                      alpha:1.0f];
    [tfInputSearchText addTarget:self
                          action:@selector(tfAtEditing:)
                forControlEvents:UIControlEventEditingChanged];
//    [vTitleView addSubview:btnChooseType];
    [vTitleView addSubview:tfInputSearchText];
    tfInputSearchText.placeholder = kLocalized(@"请输入搜索内容");
    tfInputSearchText.font        = [UIFont systemFontOfSize:14];
    self.textField                = tfInputSearchText;
    [vHead addSubview:vTitleView];
    return vHead;
}

//存数据
- (void)saveData
{
    for (int i = 0; i < self.historyWordsArray.count; i++)
    {
        if ([self.historyWordsArray[i]
             isEqualToString:self.textField.text])
        {
            [self.historyWordsArray
             removeObject:self.historyWordsArray[i]];
        }
    }
    [self.historyWordsArray
     insertObject:self.textField.text
          atIndex:0];
    [self saveImmediately];
    [self.collectionView reloadData];
}

- (void)tfAtEditing:(UITextField *)sender
{
    if (sender.text.length > 10)
    {
        [GYUtils showToast:kLocalized(@"不能大于10个字")];
        sender.text = [sender.text
                       substringToIndex:10];
    }
}

#pragma mark - 更新联想词库
//更新联想词库
- (void)updateSearchResultsForSearchWords:(NSString *)words
{
    [self.automatedKeyWordsArray removeAllObjects];
    //NSPredicate 谓词
    NSPredicate *searchPredicate0 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", words];//@self contains[cd] //@"SELF CONTAINS %@" //@"SELF MATCHES %@"
    NSMutableArray* arr1 = [[self.items
                      filteredArrayUsingPredicate:searchPredicate0] mutableCopy];
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", words];//@self contains[cd] //@"SELF CONTAINS %@" //@"SELF MATCHES %@"
    NSMutableArray* arr2 = [[self.items
                                    filteredArrayUsingPredicate:searchPredicate] mutableCopy];
    [self.automatedKeyWordsArray addObjectsFromArray:arr1];
    [self.automatedKeyWordsArray addObjectsFromArray:arr2];
    
   self.automatedKeyWordsArray = [self deleteTheRepeatItems:self.automatedKeyWordsArray];
    //刷新表格
//    [self.tableView reloadData];
}

- (void)searchTextFieldTextChange
{
    if (_textField.text.length > 0)
    {
        //拿到联想词
        [self updateSearchResultsForSearchWords:self.textField.text];

        self.searchShowType = kGYHESearchShowTable;
    }
    else
    {
        self.isAreadySearch = NO;
        [self.automatedKeyWordsArray removeAllObjects];
        self.searchShowType = _contentTabelType == kGoodsType? kGYHESearchShowTable : kGYHESearchShowCollection;
        
    }
    [self setSearchBtn];
    [self addNeededViewWithShowType:self.searchShowType];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self saveDataAndShowSearchContent];
    return YES;
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.historyWordsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GYHESearchCollectionCell *cell = (GYHESearchCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellId
                                                                                                           forIndexPath:indexPath];

    if (!cell)
    {
        cell = [[GYHESearchCollectionCell alloc] init];
    }
    
    NSArray *arr = [cell.contentView subviews];
    
    for (UIView* view in arr) {
        [view removeFromSuperview];
    }
    


    UILabel *botlabel = [[UILabel alloc] init];
    botlabel.tag  = kRemoveTag;
    botlabel.text = self.historyWordsArray[indexPath.row];//[NSString stringWithFormat:@"[%ld,%ld]",(long)indexPath.section,(long)indexPath.row];
    botlabel.font = [UIFont systemFontOfSize:13.0];
    CGSize size = [self giveLabelWith:botlabel.font
                             nsstring:botlabel.text];
    botlabel.frame = CGRectMake(20, 7, size.width + 1, size.height + 1);

    botlabel.textAlignment = NSTextAlignmentCenter;
    botlabel.textColor     = [UIColor blackColor];

    botlabel.backgroundColor = [UIColor clearColor];
    [cell.contentView
     addSubview:botlabel];

    cell.contentView.backgroundColor     = [UIColor colorWithRed:235.0 / 255.0f
                                                           green:235.0 / 255.0f
                                                            blue:235.0 / 255.0f
                                                           alpha:1.0f];                                                          //[UIColor yellowColor];
    cell.contentView.layer.cornerRadius  = 15;
    cell.contentView.layer.masksToBounds = NO;

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(handLongPress:)];
    [cell addGestureRecognizer:longPress];
    longPress.minimumPressDuration = 1.0f;
    longPress.delegate             = self;
    longPress.view.tag             = indexPath.row;

    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = self.historyWordsArray[indexPath.row];
    CGSize size    = [self giveLabelWith:[UIFont systemFontOfSize:13.0]
                                nsstring:text];
    return CGSizeMake(size.width + 40, 30);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);//上 左 下 右
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

// 设置头部
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                              withReuseIdentifier:@"reusableView"
                                                                                     forIndexPath:indexPath];
    headerView.backgroundColor = [UIColor whiteColor];


    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhe_food_clearHistory"]];

    UIButton *btn = [[UIButton alloc] init];
    [btn addTarget:self
               action:@selector(clearHistory)
     forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:imgView];
    [headerView addSubview:btn];

    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView).offset(15);
        make.width.height.mas_equalTo(15);
        make.right.equalTo(headerView).offset(-20);
    }];
    //按钮和图片视图一样大
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(headerView);
    }];

    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text      = kLocalized(@"搜索记录");
    textLabel.font      = [UIFont systemFontOfSize:13];
    textLabel.textColor = [UIColor blackColor];
    [headerView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView).offset(15);
        make.left.equalTo(headerView).offset(10);
        make.width.equalTo(@70);
        make.height.equalTo(@21);
    }];

    [headerView addTopBorder];//边缘加线
    return headerView;
}

//点击item方法 如果是带删除图标状态 点击还原 如果正常状态 点击再搜索
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GYHESearchCollectionCell *cell = (GYHESearchCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];

    NSArray *arr = [cell.contentView subviews];

    if (arr.count > 1)
    {
        UIView *view = arr[arr.count - 1];
        [view removeFromSuperview];
    }
    else
    {
        if (self.historyWordsArray.count > indexPath.row)
        {
            //前面有删除图标的状态全还原
            for (GYHESearchCollectionCell *cell in collectionView.visibleCells) {
                NSArray *arr = [cell.contentView subviews];
                
                if (arr.count > 1)
                {
                    UIView *view = arr[arr.count - 1];
                    [view removeFromSuperview];
                }
            }
            
            self.textField.text = self.historyWordsArray[indexPath.row];
            [self saveDataAndShowSearchContent];
        }
    }
}

#pragma mark - 手势方法
//长按的处理方法
- (void)handLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        

        NSIndexPath *indexPath         = [NSIndexPath indexPathForRow:recognizer.view.tag
                                                            inSection:0];
        GYHESearchCollectionCell *cell = (GYHESearchCollectionCell *)[self.collectionView
                                                                      cellForItemAtIndexPath:indexPath];
        NSArray *arr = [cell.contentView subviews];
        
        if (arr.count > 1)
        {
            return;
        }
        //添加个删除小图标
        UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width - 10, -5, 15, 15)];
        cell.contentView.userInteractionEnabled = YES;
        [cell.contentView
         addSubview:imageBtn];
        [imageBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_clear_button"]
                            forState:UIControlStateNormal];
        imageBtn.tag = recognizer.view.tag;
        [imageBtn addTarget:self
                     action:@selector(deleteOneItem:)
           forControlEvents:UIControlEventTouchUpInside];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        //结束长按
    }
}

//点击了删除图标的删除方法
- (void)deleteOneItem:(UIButton *)recognizer
{
    WS(weakSelf);
    [self.collectionView
     performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:recognizer.tag
                                                    inSection:0];

        NSMutableArray *temp = [NSMutableArray arrayWithArray:weakSelf.historyWordsArray];
        [temp removeObjectAtIndex:indexPath.row];
        weakSelf.historyWordsArray = temp;

        [weakSelf saveImmediately];

        NSArray *deleteItems = @[indexPath];
        [weakSelf.collectionView
         deleteItemsAtIndexPaths:deleteItems];
    }
              completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

#pragma mark - UITableViewDataSource
//表视图的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CGRect rect = self.tableView.frame;
    rect.size.height = self.automatedKeyWordsArray.count * 40 + 40;
    if (rect.size.height > kScreenHeight - 64)
    {
        rect.size.height = kScreenHeight - 64;
    }
    self.tableView.frame = rect;
    return self.automatedKeyWordsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchCell
                                                            forIndexPath:indexPath];
    if (self.automatedKeyWordsArray.count > indexPath.row)
    {
        cell.textLabel.text = self.automatedKeyWordsArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.automatedKeyWordsArray.count > indexPath.row)
    {
        self.textField.text = self.automatedKeyWordsArray[indexPath.row];
        [self saveDataAndShowSearchContent];
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)historyWordsArray
{
    if (!_historyWordsArray)
    {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSArray *arr       = [ud objectForKey:self.keyUserDefault];
        _historyWordsArray = [[NSMutableArray alloc] initWithArray:arr];
    }
    return _historyWordsArray;
}

- (NSMutableArray *)automatedKeyWordsArray
{
    if (!_automatedKeyWordsArray)
    {
        _automatedKeyWordsArray = [NSMutableArray array];
    }
    return _automatedKeyWordsArray;
}

//开始调用的源数据 从中拿联想词
- (NSMutableArray *)items
{
    if (!_items)
    {
        _items = [NSMutableArray arrayWithArray:@[ @"11", @"22", @"33", @"12", @"21", @"32", @"31", @"32", @"23", @"1", @"2", @"3", @"11", @"22", @"33", @"12", @"21", @"32", @"31", @"32", @"23", @"1", @"2", @"3", @"11", @"22", @"33", @"12", @"21", @"32", @"31", @"32", @"23",@"1", @"2", @"3"]];
    }
    return _items;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView            = [[UITableView alloc] initWithFrame:CGRectMake(0, kGap, kScreenWidth, kScreenHeight - 64 - kGap)];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.rowHeight  = 40;
    }
    return _tableView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        //1.初始化layout

        GYHECollectionViewLeftAlignedLayout *layout = [[GYHECollectionViewLeftAlignedLayout alloc] init];

        //设置headerView的尺寸大小
        layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 50);


        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kGap, kScreenWidth, kScreenHeight - 64 - kGap)
                                             collectionViewLayout      :layout];

        _collectionView.dataSource = self;
        _collectionView.delegate   = self;
    }
    return _collectionView;
}

- (NSString *)keyUserDefault
{
    return @"searchGoodsHistoryArray";
}

#pragma mark - 私有方法
//及时保存
- (void)saveImmediately
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:self.historyWordsArray
           forKey:self.keyUserDefault];
    [ud synchronize];
}

//清空历史记录
- (void)clearHistory
{
    WS(weakSelf);
    [GYAlertView showMessage:@"确认删除全部搜索记录?"
           cancleButtonTitle:kLocalized(@"取消")
          confirmButtonTitle:@"确定"
                 cancleBlock:^{
    }
                confirmBlock:^{
        //弹出提示框 提示框点确定再进行数据删除
        [weakSelf.historyWordsArray removeAllObjects];
        [weakSelf saveImmediately];
        [weakSelf.collectionView reloadData];
    }];
}

//返回
- (void)back:(UIButton *)sender
{
    [self.navigationController
     popViewControllerAnimated:YES];
}

//给label返回一个宽高
- (CGSize)giveLabelWith:(UIFont *)fnt nsstring:(NSString *)string
{
    UILabel *label = [[UILabel alloc] init];
    label.text = string;
    return [label.text
            sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil]];
}

//去掉数组中的重复元素
-(NSMutableArray*)deleteTheRepeatItems:(NSMutableArray*)dataArray{

    NSMutableArray *listAry = [[NSMutableArray alloc]init];
    for (NSString *str in dataArray) {
        if (![listAry containsObject:str]) {
            [listAry addObject:str];
        }
    }
    return listAry;
}

//传递的数据源
-(NSMutableArray *)dataArry{
    if (!_dataArry) {
        _dataArry = @[].mutableCopy;
    }
    return _dataArry;
}


@end





