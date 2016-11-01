//
//  GYHDMoveFriendViewController.m
//  HSConsumer
//
//  Created by shiang on 16/3/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDMoveFriendViewController.h"
#import "GYHDMessageCenter.h"
#import "GYHDMoveFriendGroupModel.h"
#import "GYPinYinConvertTool.h"
#import "GYHDMoveFriendCell.h"
#import "GYHDMoveFriendCollectionCell.h"



@interface GYHDMoveFriendViewController () <UITableViewDataSource, UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
/**移动button*/
@property (nonatomic, weak) UIButton* movieButton;
/**标题*/
@property (nonatomic, weak) UILabel* titleLabel;
/**选择tableView*/
@property (nonatomic, weak) UITableView* selectTableView;
/**移动好友数组*/
@property (nonatomic, strong) NSMutableArray* moveFriendArray;
/**选择的用户名称*/
@property (nonatomic, copy) NSString* selectAccountIDString;
@property (nonatomic, strong)NSMutableArray *selectArray;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong)UICollectionView *selectIconCollectionView;
@property (nonatomic, strong)UITextField *searchTextField;
@property (nonatomic, strong)UIImageView *searchImageView;
@property (nonatomic, strong)NSArray     *searchArray;
@end

@implementation GYHDMoveFriendViewController
- (NSMutableArray*)moveFriendArray
{
    if (!_moveFriendArray) {
        _moveFriendArray = [NSMutableArray array];
    }
    return _moveFriendArray;
}
- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}
- (NSArray *)searchArray {
    if (!_searchArray) {
        _searchArray = [NSArray array];
    }
    return _searchArray;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.moveString = @"确定";
    UIButton* cancelButton = [[UIButton alloc] init];
//    [cancelButton setTitleColor:[UIColor colorWithRed:153 / 255.0f green:153 / 255.0f blue:153 / 255.0f alpha:1] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_cancel"] forState:UIControlStateNormal];
    [self.view addSubview:cancelButton];

    UILabel* titleLabel = [[UILabel alloc] init];
//    titleLabel.textColor = [UIColor colorWithRed:153 / 255.0f green:153 / 255.0f blue:153 / 255.0f alpha:1];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = [GYUtils localizedStringWithKey:@"GYHD_select_contacts"];
    [self.view addSubview:titleLabel];
    _titleLabel = titleLabel;

    UIButton* movieButton = [[UIButton alloc] init];
    //    [movieButton setTitle:@"移入" forState:UIControlStateNormal];
//    [movieButton setTitleColor:[UIColor colorWithRed:153 / 255.0f green:153 / 255.0f blue:153 / 255.0f alpha:1] forState:UIControlStateNormal];
    [movieButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [movieButton addTarget:self action:@selector(movieButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:movieButton];
    _movieButton = movieButton;

    UITableView* selectTableView = [[UITableView alloc] init];
    selectTableView.dataSource = self;
    selectTableView.delegate = self;
    [selectTableView registerClass:[GYHDMoveFriendCell class] forCellReuseIdentifier:@"GYHDMoveFriendCellID"];
    [self.view addSubview:selectTableView];
    _selectTableView = selectTableView;
    
    [self.view addSubview: self.searchView];
    WS(weakSelf);
    [cancelButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(12);

    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(cancelButton);
        make.centerX.equalTo(weakSelf.view);
    }];
    [movieButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(cancelButton);
        make.right.mas_equalTo(-12);
    }];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cancelButton.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    
    [selectTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(weakSelf.searchView.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
    }];
}
- (UIView *)searchView {
    if (!_searchView) {
        _searchView = [[UIView alloc] init];
        _searchView.backgroundColor = [UIColor whiteColor];
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向为垂直流布局
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        //设置每个item的大小为100*100
        layout.itemSize = CGSizeMake(50, 50);
        self.selectIconCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
        
        self.selectIconCollectionView.pagingEnabled = YES;
        
        //代理设置
        self.selectIconCollectionView.delegate = self;
        self.selectIconCollectionView.dataSource = self;
        //注册item类型 这里使用系统的类型
        [self.selectIconCollectionView registerClass:[GYHDMoveFriendCollectionCell class] forCellWithReuseIdentifier:@"GYHDMoveFriendCollectionCell"];
        [_searchView addSubview:self.selectIconCollectionView];
        
        self.selectIconCollectionView.backgroundColor = [UIColor whiteColor];
        self.searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_search_icon"]];
        self.searchImageView.contentMode = UIViewContentModeCenter;
        self.searchImageView.backgroundColor = [UIColor whiteColor];
        [_searchView addSubview:self.searchImageView];
        
        self.searchTextField = [[UITextField alloc] init];
        [_searchView addSubview:self.searchTextField];
        self.searchTextField.placeholder = [GYUtils localizedStringWithKey:@"GYHD_search"];
        [self.searchTextField addTarget:self action:@selector(searchChange) forControlEvents:UIControlEventEditingChanged];
//        self.searchTextField.backgroundColor = [UIColor randomColor];
        WS(weakSelf);
        [self.selectIconCollectionView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.left.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-100);
        }];
        
        [self.searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.centerY.equalTo(weakSelf.searchView);
            make.size.mas_equalTo(CGSizeMake(34, 44));
        }];
        
        [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(0);
            make.left.mas_equalTo(40);
        }];
    }
    return _searchView;
}
- (void)searchChange {
    NSLog(@"%@",self.searchTextField.text);
    if (self.searchTextField.text.length > 0 ) {
        NSMutableArray *searchArray = [NSMutableArray array];
        for (GYHDMoveFriendGroupModel* froupModel in self.moveFriendArray) {
            
            NSString *property = @"moveFriendNikeName";
            NSString *value = self.searchTextField.text;
            //  该谓词的作用是如果元素中property属性含有值value时就取出放入新的数组内，这里是name包含Jack
            NSPredicate *p = [NSPredicate predicateWithFormat:@"%K CONTAINS %@", property, value];

            NSArray *array = [froupModel.moveFriendArray filteredArrayUsingPredicate:p];
            
            GYHDMoveFriendGroupModel *select = [[GYHDMoveFriendGroupModel alloc] init];
            select.moveFriendTitle = froupModel.moveFriendTitle;
            select.moveFriendArray = array.mutableCopy;
            if (array.count) {
                [searchArray addObject:select];
            }
            
        }
        self.searchArray = searchArray;
        [self.selectTableView reloadData];
    }

    
}
- (void)setMoveString:(NSString*)moveString
{
    _moveString = moveString;
    [self.movieButton setTitle:moveString forState:UIControlStateNormal];
}

- (void)setTeamID:(NSString*)teamID
{
    _teamID = teamID;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadTeamFriend];
}

/**好友列表*/
- (void)loadTeamFriend
{
    WS(weakSelf);
    NSArray  *DBfriendArray = nil;
    if ([self.moveString isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_move_in"]]) {
     
        DBfriendArray =  [[GYHDMessageCenter sharedInstance] selectFriendWithTeamID:nil];
  
    } else {
    
        DBfriendArray = [[GYHDMessageCenter sharedInstance] selectFriendWithTeamID:self.teamID];

    }

    //    //1.首先加载数据数据
    self.moveFriendArray = [self friendPinYinGroupWithArray:DBfriendArray];
    [weakSelf.selectTableView reloadData];
}

/**好友按字母分组*/
- (NSMutableArray*)friendPinYinGroupWithArray:(NSArray*)array
{
    NSArray* ABCArray = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#", nil];
    NSMutableArray* friendGroupArray = [NSMutableArray array];
    for (NSString* key in ABCArray) {
        GYHDMoveFriendGroupModel* friendGroupModel = [[GYHDMoveFriendGroupModel alloc] init];
        for (NSDictionary* dict in array) {

            //1. 转字母
            NSString* tempStr = dict[GYHDDataBaseCenterFriendName];
            if (!tempStr || tempStr.length == 0) {
                tempStr = @"未设置名称";
            }
            if ([GYUtils isIncludeChineseInString:dict[GYHDDataBaseCenterFriendName]]) {
                tempStr = [GYPinYinConvertTool chineseConvertToPinYinHead:dict[GYHDDataBaseCenterFriendName]];
            }
            //2. 获取首字母
            NSString* firstLetter;
            if (tempStr.length >= 1) {
                firstLetter = [[tempStr substringToIndex:1] uppercaseString];
            }
            if (![ABCArray containsObject:firstLetter]) {
                tempStr = [@"#" stringByAppendingString:tempStr];
                firstLetter = [[tempStr substringToIndex:1] uppercaseString];
            }

            //3. 加入数组
            if ([firstLetter isEqualToString:key]) {

                friendGroupModel.moveFriendTitle = key;
                GYHDMoveFriendModel* friendModel = [[GYHDMoveFriendModel alloc] initWithDictionary:dict];

                if ([self.teamID isEqualToString:friendModel.moveFriendTeamID] && [self.moveString isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_move_in"]]) {
                    friendModel.TeamSelf = YES;
                }
                else {
                    friendModel.TeamSelf = NO;
                }
                if (self.selectCustIDString) {
                    NSArray *custIDArray = [self.selectCustIDString componentsSeparatedByString:@","];
                    NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF = %@",friendModel.moveFriendAccountID];
                    NSArray *fArray =  [custIDArray filteredArrayUsingPredicate:p];
                    if (fArray.count) {
                        friendModel.TeamSelf = YES;
                    }
                }
                [friendModel addObserver:self forKeyPath:@"moveFriendSelectState" options:NSKeyValueObservingOptionNew context:nil];
                [friendGroupModel.moveFriendArray addObject:friendModel];
            }
        }
        if (friendGroupModel.moveFriendTitle && friendGroupModel.moveFriendArray.count > 0) {
            [friendGroupArray addObject:friendGroupModel];
        }
    }

    return friendGroupArray;
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary<NSString*, id>*)change context:(void*)context
{
    if ([keyPath isEqualToString:@"moveFriendSelectState"]) {
        if (self.searchTextField.text.length > 0) {
            self.searchTextField.text = nil;
            [self.selectTableView reloadData];
        }
        int selectCount = 0;
        NSMutableString* selectCountString = [[NSMutableString alloc] init];
        for (GYHDMoveFriendGroupModel* froupModel in self.moveFriendArray) {
            for (GYHDMoveFriendModel* friendModel in froupModel.moveFriendArray) {
                if (friendModel.moveFriendSelectState || friendModel.TeamSelf) {
//                                    if (friendModel.moveFriendSelectState ) {
                    selectCount++;
                    [selectCountString appendFormat:@"%@,", friendModel.moveFriendAccountID];
                }
            }
        }
        NSString* title = nil;
        if (selectCount) {
            title = [NSString stringWithFormat:@"%@(%d)", self.moveString, selectCount];
        }
        else {
            title = self.moveString;
        }
        if (selectCountString.length) {
            [selectCountString deleteCharactersInRange:NSMakeRange(selectCountString.length - 1, 1)];
        }
        self.selectAccountIDString = selectCountString;
        [self.movieButton setTitle:title forState:UIControlStateNormal];
        
        NSMutableArray *selectArray = [NSMutableArray array];
        for (GYHDMoveFriendGroupModel* froupModel in self.moveFriendArray) {
            
            NSPredicate *p = [NSPredicate predicateWithFormat:@"moveFriendSelectState = TRUE || TeamSelf = TRUE"];
            NSArray *array = [froupModel.moveFriendArray filteredArrayUsingPredicate:p];
            
            GYHDMoveFriendGroupModel *select = [[GYHDMoveFriendGroupModel alloc] init];
            select.moveFriendTitle = froupModel.moveFriendTitle;
            select.moveFriendArray = array.mutableCopy;
            if (array.count) {
                [selectArray addObject:select];
            }
            
        }
        self.selectArray = selectArray;
        [self.selectIconCollectionView reloadData];
        if (self.selectArray.count) {
            self.searchImageView.hidden = YES;
            [self.searchTextField mas_updateConstraints:^(MASConstraintMaker *make) {
                CGFloat leftW = 50 * selectCount;
                if (leftW > kScreenWidth -100) {
                    leftW = kScreenWidth -100;
                }
                make.left.mas_equalTo(leftW);
            }];
        }else {
            self.searchImageView.hidden = NO;
            [self.searchTextField mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(40);
            }];

        }
    }
}

- (void)dealloc
{
    for (GYHDMoveFriendGroupModel* froupModel in self.moveFriendArray) {
        for (GYHDMoveFriendModel* friendModel in froupModel.moveFriendArray) {
            [friendModel removeObserver:self forKeyPath:@"moveFriendSelectState"];
        }
    }
}

- (void)movieTitle:(NSString*)title
{
    self.titleLabel.text = title;
}

- (void)movieButtonClick
{

    if (self.arrayblock) {
        self.arrayblock(self.selectArray);
    }
    if (self.block) {
        self.block(self.selectAccountIDString);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    NSInteger count = 0;
    if (self.searchTextField.text.length > 0 ) {
        count = self.searchArray.count;
    }else {
        count = self.moveFriendArray.count;
    }
    return count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
        NSInteger count = 0;
    if (self.searchTextField.text.length > 0 ) {
        GYHDMoveFriendGroupModel* model = self.searchArray[section];
        count =  model.moveFriendArray.count;
    }else {
        GYHDMoveFriendGroupModel* model = self.moveFriendArray[section];
        count =  model.moveFriendArray.count;
    }
    return count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    UITableViewCell *cell = nil;
    if (self.searchTextField.text.length > 0 ) {
        GYHDMoveFriendGroupModel* model = self.searchArray[indexPath.section];
        GYHDMoveFriendModel* friendModel = model.moveFriendArray[indexPath.row];
        GYHDMoveFriendCell* basecell = [tableView dequeueReusableCellWithIdentifier:@"GYHDMoveFriendCellID"];
        basecell.model = friendModel;
        cell = basecell;
    }else {
        GYHDMoveFriendGroupModel* model = self.moveFriendArray[indexPath.section];
        GYHDMoveFriendModel* friendModel = model.moveFriendArray[indexPath.row];
        GYHDMoveFriendCell* basecell = [tableView dequeueReusableCellWithIdentifier:@"GYHDMoveFriendCellID"];
        basecell.model = friendModel;
        cell = basecell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 66.0f;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (self.searchTextField.text.length > 0 ) {
        GYHDMoveFriendGroupModel* model = self.searchArray[section];
        title = model.moveFriendTitle;
    }else {
        GYHDMoveFriendGroupModel* model = self.moveFriendArray[section];
        title = model.moveFriendTitle;
    }
    return title;
}

- (nullable NSArray<NSString*>*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    NSMutableArray* titleArray = [NSMutableArray array];
    for (GYHDMoveFriendGroupModel* model in self.moveFriendArray) {
        [titleArray addObject:model.moveFriendTitle];
    }
    return titleArray;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.selectArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    GYHDMoveFriendGroupModel* model = self.selectArray[section];
    return model.moveFriendArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GYHDMoveFriendCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GYHDMoveFriendCollectionCell" forIndexPath:indexPath];
    GYHDMoveFriendGroupModel* model = self.selectArray[indexPath.section];
    GYHDMoveFriendModel* friendModel = model.moveFriendArray[indexPath.row];
    cell.model = friendModel;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GYHDMoveFriendGroupModel* model = self.selectArray[indexPath.section];
    GYHDMoveFriendModel* friendModel = model.moveFriendArray[indexPath.row];
    friendModel.moveFriendSelectState = NO;
    [self.selectTableView reloadData];
    [self.selectIconCollectionView reloadData];
    NSLog(@"%@",friendModel);
    
}
@end
