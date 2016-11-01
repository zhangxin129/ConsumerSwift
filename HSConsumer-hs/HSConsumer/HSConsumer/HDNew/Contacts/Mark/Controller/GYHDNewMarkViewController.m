//
//  GYHDNewMarkViewController.m
//  HSConsumer
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDNewMarkViewController.h"
#import "GYHDMessageCenter.h"
#import "GYHDAddMarkViewController.h"
#import "GYHDMoveFriendViewController.h"
#import "GYHDMarkAddFriendCell.h"
#import "GYHDMoveFriendGroupModel.h"
#import "GYPinYinConvertTool.h"
#import "GYHDContactsMarkListModel.h"
#import "GYUtils+HSConsumer.h"
@interface GYHDNewMarkViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UIButton *saveBtn;//保存按钮
@property(nonatomic,strong)UITextField *markEditTextField;//标签显示按钮
@property(nonatomic,strong)UITableView* listTabelView;
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic, copy)NSString *selectCustIDString;
@end

@implementation GYHDNewMarkViewController
-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav];
    
    [self setupUI];
    if (self.model) {
        NSArray *DBfriendArray = [[GYHDMessageCenter sharedInstance] selectFriendWithTeamID:self.model.teamID];
    
        //    //1.首先加载数据数据
        self.dataArray = [self friendPinYinGroupWithArray:DBfriendArray];
        [self.listTabelView reloadData];
        self.markEditTextField.text = self.model.title;
//        [self.markEditTextField setTitle:self.model.title forState:UIControlStateNormal];
//        
//        [self.markEditTextField setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];
        
        [self.saveBtn setTitleColor:[UIColor colorWithHexString:@"#ef4136"] forState:UIControlStateNormal];
        
        self.saveBtn.userInteractionEnabled=YES;
        
        NSMutableString *custString = [NSMutableString string];
        for (NSString *custID in self.model.markListCustIDArray) {
            [custString appendFormat:@"%@,",custID];
        }
        if (custString.length) {
            [custString deleteCharactersInRange:NSMakeRange(custString.length-1, 0)];
        }
        self.selectCustIDString = custString;
    }
  
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
                
                if ([self.model.teamID isEqualToString:friendModel.moveFriendTeamID]) {
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
//                [friendModel addObserver:self forKeyPath:@"moveFriendSelectState" options:NSKeyValueObservingOptionNew context:nil];
                [friendGroupModel.moveFriendArray addObject:friendModel];
            }
        }
        if (friendGroupModel.moveFriendTitle && friendGroupModel.moveFriendArray.count > 0) {
            [friendGroupArray addObject:friendGroupModel];
        }
    }

    return friendGroupArray;
}
#pragma mark - 导航栏设置
-(void)setupNav{
    
    self.title=[GYUtils localizedStringWithKey:@"GYHD_Mark"];
    
    UIButton*backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    backBtn.frame=CGRectMake(0, 0, 44, 44);
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backBtn setImage:[UIImage imageNamed:@"gyhd_back_icon"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    self.saveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    self.saveBtn.frame=CGRectMake(0, 0, 32, 32);
    
    [self.saveBtn setTitle:[GYUtils localizedStringWithKey:@"GYHD_save"] forState:UIControlStateNormal];
    
//    没有添加标签名和成员之前保存按钮不可点击置灰
    
//    [self.saveBtn setTitleColor:[UIColor colorWithHexString:@"#ef4136"] forState:UIControlStateNormal];
//     self.saveBtn.userInteractionEnabled=YES;
    [self.saveBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:196/255.0 blue:193/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.saveBtn.userInteractionEnabled=NO;
    
    self.saveBtn.titleLabel.font=[UIFont systemFontOfSize:16.0];
    [self.saveBtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.saveBtn];
    
}

-(void)setupUI{

    UIView*bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,240)];
    
    bgView.backgroundColor=[UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];
    
    [self.view addSubview:bgView];
    
    UILabel*nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 17, 300, 20)];
    
    nameLabel.text=[GYUtils localizedStringWithKey:@"GYHD_MarkName"];
    
    nameLabel.textColor=[UIColor colorWithHexString:@"#666666"];
    
    nameLabel.font=[UIFont systemFontOfSize:16.0];
    
    [bgView addSubview:nameLabel];
    
//    self.markEditTextField=[UIButton buttonWithType:UIButtonTypeCustom];
//    self.markEditTextField.backgroundColor=[UIColor whiteColor];
//    self.markEditTextField.frame=CGRectMake(0, CGRectGetMaxY(nameLabel.frame)+7, kScreenWidth, 60);
//    [self.markEditTextField setTitle:[GYUtils localizedStringWithKey:@"GYHD_NoSetMarkName"] forState:UIControlStateNormal];
//    self.markEditTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [self.markEditTextField addTarget:self action:@selector(markShowClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.markEditTextField setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
//    [self.markEditTextField setTitleColor:[UIColor colorWithHexString:@"#eeeeee"] forState:UIControlStateNormal];
    
    
    self.markEditTextField = [[UITextField alloc] init];
    self.markEditTextField.frame = CGRectMake(0, CGRectGetMaxY(nameLabel.frame)+7, kScreenWidth, 60);
    self.markEditTextField.placeholder = [GYUtils localizedStringWithKey:@"GYHD_NoSetMarkName"];
    self.markEditTextField.backgroundColor = [UIColor whiteColor];
    self.markEditTextField.delegate = self;
    self.markEditTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.markEditTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.markEditTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [bgView addSubview:self.markEditTextField];
    
    UILabel*markMemberLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_markEditTextField.frame)+7, kScreenWidth, 20)];
    markMemberLabel.text= [NSString stringWithFormat:@"%@(0)",[GYUtils localizedStringWithKey:@"GYHD_MarkMember"]];
    
    markMemberLabel.textColor=[UIColor colorWithHexString:@"#666666"];
    
    [bgView addSubview:markMemberLabel];
    
    UIButton*addMemberBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    addMemberBtn.frame=CGRectMake(0,CGRectGetMaxY(markMemberLabel.frame)+7, kScreenWidth, 240-CGRectGetMaxY(markMemberLabel.frame));
    addMemberBtn.backgroundColor=[UIColor whiteColor];
    [addMemberBtn setTitle:[GYUtils localizedStringWithKey:@"GYHD_AddMark"] forState:UIControlStateNormal];
    [addMemberBtn setTitleColor:[UIColor colorWithHexString:@"#ef4136"] forState:UIControlStateNormal];
    [addMemberBtn addTarget:self action:@selector(addMemberClick) forControlEvents:UIControlEventTouchUpInside];
    addMemberBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [addMemberBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-250, 0, 0)];
    [addMemberBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [addMemberBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [addMemberBtn setImage:[UIImage imageNamed:@"gyhd_contants_addmember_icon"] forState:UIControlStateNormal];
    
    [bgView addSubview:addMemberBtn];
    
    
    self.listTabelView=[[UITableView alloc]init];
    
    self.listTabelView.rowHeight=88;
    
    self.listTabelView.delegate=self;
    
    self.listTabelView.dataSource=self;
    
    self.listTabelView .tableHeaderView=bgView;
    
    self.listTabelView.backgroundColor=[UIColor whiteColor];
    
    [self.listTabelView registerClass:[GYHDMarkAddFriendCell class] forCellReuseIdentifier:@"GYHDMarkAddFriendCell"];
    
    [self.view addSubview:self.listTabelView];
    
    [self.listTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-54);
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    GYHDMoveFriendGroupModel *groupModel = self.dataArray[section];
    return groupModel.moveFriendArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   GYHDMoveFriendGroupModel *groupModel =  self.dataArray[indexPath.section];
   GYHDMoveFriendModel *friendModel = groupModel.moveFriendArray[indexPath.row];
    GYHDMarkAddFriendCell *cell=[tableView dequeueReusableCellWithIdentifier:@"GYHDMarkAddFriendCell"];
    [cell.iconImgView setImageWithURL:[NSURL URLWithString:friendModel.moveFriendIconUrl] placeholder:[UIImage imageNamed:@"gyhd_contants_deafultheadportrait_icon"]];
    cell.nameLabel.text = friendModel.moveFriendNikeName;
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    GYHDMoveFriendGroupModel *groupModel =  self.dataArray[section];
    return groupModel.moveFriendTitle;
}

- (nullable NSArray<NSString*>*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    NSMutableArray* titleArray = [NSMutableArray array];
    for (GYHDMoveFriendGroupModel* model in self.dataArray) {
        [titleArray addObject:model.moveFriendTitle];
    }
    return titleArray;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return YES;
    }

    if (textField.text.length > 8) {
        return NO;
    }
    return  YES;
}
- (void)textChange {
    if (self.markEditTextField.text.length) {
        [self.saveBtn setTitleColor:[UIColor colorWithHexString:@"#ef4136"] forState:UIControlStateNormal];

        self.saveBtn.userInteractionEnabled=YES;
    }else {
        [self.saveBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:196/255.0 blue:193/255.0 alpha:1.0] forState:UIControlStateNormal];
        self.saveBtn.userInteractionEnabled=NO;
    }
}
//新建标签
//-(void)markShowClick{
//
//    GYHDAddMarkViewController*vc=[[GYHDAddMarkViewController alloc]init];
//    if (![self.markEditTextField.currentTitle isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_NoSetMarkName"]]) {
//        vc.defaultString = self.markEditTextField.currentTitle;
//    }
//
//    WS(weakSelf)
//    vc.block=^(NSString*markNameStr){
//    
//        [weakSelf.markEditTextField setTitle:markNameStr forState:UIControlStateNormal];
//            
//        [weakSelf.markEditTextField setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];
//            
//        [weakSelf.saveBtn setTitleColor:[UIColor colorWithHexString:@"#ef4136"] forState:UIControlStateNormal];
//            
//        weakSelf.saveBtn.userInteractionEnabled=YES;
//        
//        
//    };
//    [self.navigationController pushViewController:vc animated:YES];
//}

//添加成员
-(void)addMemberClick{

//    if ([self.markEditTextField.currentTitle isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_NoSetMarkName"]]) {
//        return;
//    }
    if (self.markEditTextField.text == nil) {
        return;
    }
    GYHDMoveFriendViewController *vc = [[GYHDMoveFriendViewController alloc] init];
    WS(weakSelf);
    vc.block = ^(NSString* message){
        if (!weakSelf.selectCustIDString) {
            weakSelf.selectCustIDString = message;
        }else {
            weakSelf.selectCustIDString = [NSString stringWithFormat:@"%@,%@",weakSelf.selectCustIDString,message];
        }

    };

    vc.arrayblock = ^(NSArray* modelArray) {
        weakSelf.dataArray =  [NSMutableArray arrayWithArray:modelArray];
        [weakSelf.listTabelView reloadData];

    };
    vc.selectCustIDString = weakSelf.selectCustIDString;
    [self presentViewController:vc animated:YES completion:nil];

//    [self.navigationController pushViewController:vc animated:YES];
    DDLogInfo(@"添加成员");
}

#pragma mark -添加好友或企业到通讯录
-(void)saveClick{
    
    DDLogInfo(@"保存");
    WS(weakSelf);
    if (self.model) {
      
            NSDictionary *myDict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"teamId"] = self.model.teamID;
            dict[@"userId"] =  myDict[@"Friend_ID"];
            dict[@"friendId"] = self.selectCustIDString;
            
            NSMutableDictionary *insertDict = [NSMutableDictionary dictionary];
            insertDict[GYHDDataBaseCenterFriendTeamTeamID] = dict[@"teamId"];
            insertDict[GYHDDataBaseCenterFriendTeamName] =   self.markEditTextField.text;
            [[GYHDMessageCenter sharedInstance] insertInfoWithDict:insertDict TableName:GYHDDataBaseCenterFriendTeamTableName];
            [[GYHDMessageCenter sharedInstance] MovieFriendWithDict:dict RequetResult:^(NSDictionary *resultDict) {
                
                if ([resultDict[@"retCode"] integerValue] == 200) {
                    NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
                    updateDict[GYHDDataBaseCenterFriendInfoTeamID] = dict[@"teamId"];
                    
                    for (NSString *custID in [self.selectCustIDString componentsSeparatedByString:@","]) {
                        NSMutableDictionary *condDict = [NSMutableDictionary dictionary];
                        condDict[GYHDDataBaseCenterFriendFriendID] = custID;
                        
                        NSDictionary *userDict = [[GYHDMessageCenter sharedInstance] selectInfoWithDict:condDict TableName:GYHDDataBaseCenterFriendTableName].lastObject;
                        if (userDict[@"Friend_TeamID"]) {
                            updateDict[GYHDDataBaseCenterFriendInfoTeamID] =  [NSString stringWithFormat:@"%@,%@",userDict[@"Friend_TeamID"],dict[@"teamId"]];
                        }
                        [[GYHDMessageCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:condDict TableName:GYHDDataBaseCenterFriendTableName];
                    }
                    
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        
    }else {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"teamName"] = self.markEditTextField.text ;

        [[GYHDMessageCenter sharedInstance] createFriendTeamWithDict:dict RequetResult:^(NSDictionary *resultDict) {
            NSLog(@"%@",resultDict);
            if (resultDict[@"teamId"]) {
                NSDictionary *myDict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"teamId"] = resultDict[@"teamId"];
                dict[@"userId"] =  myDict[@"Friend_ID"];
                dict[@"friendId"] = self.selectCustIDString;
                
                NSMutableDictionary *insertDict = [NSMutableDictionary dictionary];
                insertDict[GYHDDataBaseCenterFriendTeamTeamID] = dict[@"teamId"];
                insertDict[GYHDDataBaseCenterFriendTeamName] =   weakSelf.markEditTextField.text;
                [[GYHDMessageCenter sharedInstance] insertInfoWithDict:insertDict TableName:GYHDDataBaseCenterFriendTeamTableName];
                [[GYHDMessageCenter sharedInstance] MovieFriendWithDict:dict RequetResult:^(NSDictionary *resultDict) {
                    
                    if ([resultDict[@"retCode"] integerValue] == 200) {
                        NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
                        updateDict[GYHDDataBaseCenterFriendInfoTeamID] = dict[@"teamId"];
                        
                        for (NSString *custID in [self.selectCustIDString componentsSeparatedByString:@","]) {
                            NSMutableDictionary *condDict = [NSMutableDictionary dictionary];
                            condDict[GYHDDataBaseCenterFriendFriendID] = custID;
                            [[GYHDMessageCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:condDict TableName:GYHDDataBaseCenterFriendTableName];
                        }
                        
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }
        }];

        
    }

    
}

-(void)backClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
