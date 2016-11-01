//
//  GYHDSetingViewController.m
//  HSConsumer
//
//  Created by shiang on 16/7/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSetingViewController.h"
#import "GYHDSetingCell.h"
//#import "GYHDSetingModel.h"
#import "GYHDSetingGroupModel.h"
#import "GYHDMessageCenter.h"

@interface GYHDSetingViewController ()<UITableViewDataSource,UITableViewDelegate,GYHDSetingCellDelegate>

@property(nonatomic, strong)UITableView *setTableView;
@property(nonatomic, strong)NSArray *dataArray;

@end



@implementation GYHDSetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =[GYUtils localizedStringWithKey:@"GYHD_seting"];
    self.setTableView = [[UITableView alloc] init];
    self.setTableView.dataSource = self;
    self.setTableView.delegate = self;
    [self.setTableView registerClass:[GYHDSetingCell class] forCellReuseIdentifier:@"GYHDSetingCellID"];
    self.setTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.setTableView];
    [self.setTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)setingArrayWithArray:(NSArray *)accountArray {
    WS(weakSelf)
    
    //         NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    //         NSMutableArray *accountArray = [NSMutableArray arrayWithArray: [accountDefaults objectForKey:KUserDefaultAccount]];
    
    NSMutableArray *array  = [NSMutableArray array];
        GYHDSetingGroupModel *setGroupModel = [[GYHDSetingGroupModel alloc] init];
        setGroupModel.headTitle = [GYUtils localizedStringWithKey:@"GYHD_message_Notice"];
        NSMutableArray *setArray = [NSMutableArray array];
    
    
        GYHDSetingModel *allDayModel = [[GYHDSetingModel alloc] init];
        allDayModel.title = [GYUtils localizedStringWithKey:@"GYHD_DND_day"];
        allDayModel.setting = [(NSNumber *)accountArray[0][0] boolValue];
    
        [setArray addObject:allDayModel];
    
        GYHDSetingModel *nightModel = [[GYHDSetingModel alloc] init];
        nightModel.title = [GYUtils localizedStringWithKey:@"GYHD_DND_night"];
        nightModel.setting = [(NSNumber *)accountArray[0][1] boolValue];
        [setArray addObject:nightModel];
    
        GYHDSetingModel *soundModel = [[GYHDSetingModel alloc] init];
        soundModel.title = [GYUtils localizedStringWithKey:@"GYHD_DND_sound"];
        soundModel.setting = [(NSNumber *)accountArray[0][2] boolValue];
        [setArray addObject:soundModel];
    
        GYHDSetingModel *shockModel = [[GYHDSetingModel alloc] init];
        shockModel.title = [GYUtils localizedStringWithKey:@"GYHD_DND_shock"];
        shockModel.setting = [(NSNumber *)accountArray[0][3] boolValue];
        [setArray addObject:shockModel];
        setGroupModel.setingArray = setArray;
        [array addObject:setGroupModel];
    
    
    
        GYHDSetingGroupModel *perGroupModel = [[GYHDSetingGroupModel alloc] init];
        perGroupModel.headTitle = [GYUtils localizedStringWithKey:@"GYHD_personal_privacy"];
        NSMutableArray *personArray = [NSMutableArray array];
    
        GYHDSetingModel *addFriendModel = [[GYHDSetingModel alloc] init];
        addFriendModel.title = [GYUtils localizedStringWithKey:@"GYHD_Allow_others_to_add_me_as_a_friend"];
        addFriendModel.setting =[(NSNumber *)accountArray[1][0] boolValue];
        [personArray addObject:addFriendModel];
    
        GYHDSetingModel *searchMessageModel = [[GYHDSetingModel alloc] init];
        searchMessageModel.title = [GYUtils localizedStringWithKey:@"GYHD_I_searched_through_some_of_the_information"];
        searchMessageModel.setting =[(NSNumber *)accountArray[1][1] boolValue];
        [personArray addObject:searchMessageModel];
    
    
        GYHDSetingModel *searchPhoneModel = [[GYHDSetingModel alloc] init];
        if (![GlobalData shareInstance].loginModel.cardHolder) {
            searchPhoneModel.title = [GYUtils localizedStringWithKey:@"GYHD_search_with_phone"];
        }else {
            searchPhoneModel.title = [GYUtils localizedStringWithKey:@"GYHD_search_with_Husheng"];
        }
    
        searchPhoneModel.setting = [(NSNumber *)accountArray[1][2] boolValue];
        [personArray addObject:searchPhoneModel];
        
        perGroupModel.setingArray = personArray;
        [array addObject:perGroupModel];
        weakSelf.dataArray = array;
        [weakSelf.setTableView reloadData];
}

- (void)loadData {
    
    WS(weakSelf);
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    __block NSMutableArray *accountArray = [(NSMutableArray *)[accountDefaults objectForKey:KUserDefaultAccount] mutableCopy];
    if (!accountArray) {
        [accountDefaults setObject:@[@[@0,@0,@1,@1],@[@0,@1,@0]] forKey:KUserDefaultAccount];
        accountArray = @[@[@0,@0,@1,@1],@[@0,@1,@0]].mutableCopy;
    }
    [self setingArrayWithArray:accountArray];
    [[GYHDMessageCenter sharedInstance ]searchPrivacyRequetResult:^(NSDictionary *resultDict) {
        if ([resultDict[@"retCode"] integerValue] == 200) {
            [accountArray removeLastObject];
            NSDictionary *reDict = [(NSArray *)resultDict[@"rows"] lastObject];
            if ([reDict[@"searchMe"] isEqualToString:@"0"]) {
                [accountArray addObject:@[@1,@0,@0,]];
            }else if ([reDict[@"searchMe"] isEqualToString:@""] || [reDict[@"searchMe"] isEqualToString:@"1"]) {
                [accountArray addObject:@[@0,@1,@0,]];
            }else if ([reDict[@"searchMe"] isEqualToString:@"3"] || [reDict[@"searchMe"] isEqualToString:@"2"]) {
                [accountArray addObject:@[@0,@0,@1,]];
            }
             [weakSelf setingArrayWithArray:accountArray];
        }
    }];
    
}

- (void)swithClickWithCell:(GYHDSetingCell *)cell {
    GYHDSetingModel *selectModel = cell.model;
    for (int i= 0 ; i < self.dataArray.count; ++i) {
        GYHDSetingGroupModel *group  = self.dataArray[i];
        if (i ==0) {
            for (int j = 0 ; j < group.setingArray.count ; j++) {
                GYHDSetingModel *model = group.setingArray[j];
//                if ([model.title compare:selectModel.title] == NSOrderedSame && selectModel.setting   ) {
                if ([model.title isEqualToString:selectModel.title]  && selectModel.setting  ) {
                    
                
//                    NSLog(@"第几个选中%@",model.index);
                    if (j == 0) {
                        GYHDSetingModel *model = group.setingArray[j+1];
                        model.setting = NO;
                    }else {
                        GYHDSetingModel *model = group.setingArray[j-1];
                        model.setting = NO;
                    }
                    break;
                }
            }
        }else {
            GYHDSetingModel *model1 = group.setingArray[0];
            GYHDSetingModel *model2 = group.setingArray[1];
            GYHDSetingModel *model3 = group.setingArray[2];

             if ([model1.title isEqualToString:selectModel.title] && model1.setting   ) {
                model2.setting = model3.setting = NO;
             }else if ([model2.title isEqualToString:selectModel.title] && model2.setting   ) {
                model1.setting = model3.setting = NO;
             }else if ([model3.title isEqualToString:selectModel.title]  && model3.setting   ) {
                model1.setting = model2.setting = NO;
             }else if ([model1.title isEqualToString:selectModel.title]&& !model1.setting   ) {
                 model2.setting = YES;
                 model3.setting = NO;
             }else if ([model2.title isEqualToString:selectModel.title] && !model2.setting   ) {
                 model1.setting = NO;
                 model3.setting = YES;
             }else if ([model3.title isEqualToString:selectModel.title]  && !model3.setting   ) {
                 model2.setting = YES;
                 model1.setting = NO;
             }
            NSString  *select = @"1";
            if (model1.setting) {
                select = @"0";
            }else if (model2.setting) {
                select = @"1";
            }else if (model3.setting) {
                if ([GlobalData shareInstance].loginModel.cardHolder) {
                    select =@"2";
                }else {
                    select =@"2";
                }
            }
            [[GYHDMessageCenter sharedInstance] updatePrivacyWithString:select RequetResult:^(NSDictionary *resultDict) {
                
            }];
            
        }
     
    }
 
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *setArray = [NSMutableArray array];
    for (GYHDSetingGroupModel *group in self.dataArray) {
        NSMutableArray *array = [NSMutableArray array];
        for (GYHDSetingModel *model in group.setingArray) {
            [array addObject:@(model.setting)];
        }
        [setArray addObject:array];
    }
    [accountDefaults setObject:setArray forKey:KUserDefaultAccount];
    [self.setTableView reloadData];
    
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.dataArray.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GYHDSetingGroupModel *groupModel = self.dataArray[section];
    return groupModel.setingArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 2;
    GYHDSetingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDSetingCellID"];
    cell.delegate =self;
    GYHDSetingGroupModel *groupModel = self.dataArray[indexPath.section];
    GYHDSetingModel *model = groupModel.setingArray[indexPath.row];
    model.index = indexPath;
    cell.model = model;
    return cell;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 18)];
    GYHDSetingGroupModel *groupModel = self.dataArray[section];
    //    groupModel.friendGroupTitle;
    label.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
    label.backgroundColor = [UIColor colorWithRed:235.0 / 255.0f green:235.0 / 255.0f blue:235.0 / 255.0f alpha:1.0f];
    label.font = [UIFont systemFontOfSize:12];
    label.text =  [NSString stringWithFormat:@"  %@",groupModel.headTitle];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.0f;
}
@end
