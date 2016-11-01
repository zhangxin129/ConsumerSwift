//
//  GYHDPhoneFriendViewController.m
//  HSConsumer
//
//  Created by wangbiao on 16/10/17.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#import <unistd.h>
#import "GYHDPhoneFriendViewController.h"
#import "GYHDPhoneFriendCell.h"
//#import "GYHDPhoneFriendModel.h"
#import "GYHDSearchUserModel.h"
#import "GYHDMessageCenter.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "GYHDFriendDetailViewController.h"
#import "GYHDSearchUserDetailViewController.h"
#import "GYHDSearchUserModel.h"
#import "GYPinYinConvertTool.h"
#import "GYHDSearchUserViewController.h"
#import <AddressBook/AddressBook.h>

@interface GYHDPhoneFriendViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong)UITableView *phoneTableView;
@property(nonatomic, strong)NSArray *phoneArray;
@end

@implementation GYHDPhoneFriendViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录朋友";
    
    UIButton*searchBtn=[[UIButton alloc]init];
    [searchBtn setImage:[UIImage imageNamed:@"gyhd_search_icon"] forState:UIControlStateNormal];
    [searchBtn setTitle:[GYUtils localizedStringWithKey:@"GYHD_search"] forState:UIControlStateNormal];
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius = 16;
    [searchBtn setTitleColor:[UIColor colorWithRed:186/255.0f green:186/255.0f blue:186/255.0f alpha:1] forState:UIControlStateNormal];
    searchBtn.backgroundColor=[UIColor whiteColor];
    searchBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(32);
        
    }];
    
    self.phoneTableView = [[UITableView alloc] init];
    self.phoneTableView.dataSource = self;
    self.phoneTableView.delegate = self;
    [self.phoneTableView registerClass:[GYHDPhoneFriendCell class] forCellReuseIdentifier:NSStringFromClass([GYHDPhoneFriendCell class])];
    self.phoneTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.phoneTableView];
    
    [self.phoneTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchBtn.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
    }];
    [self loadPerson];
}
- (void)searchBtnClick {
    GYHDSearchUserViewController *searchViewController = [[GYHDSearchUserViewController alloc] init];
    [self.navigationController pushViewController:searchViewController animated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    UIButton *backtrackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backtrackButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [backtrackButton setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1] forState:UIControlStateNormal];
    backtrackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backtrackButton.frame = CGRectMake(0, 0, 80, 44);
    [backtrackButton setImage:kLoadPng(@"gyhd_back_icon") forState:UIControlStateNormal];
    backtrackButton.contentEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backtrackButton];
}
- (void)backClick:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)loadPerson
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            
            CFErrorRef *error1 = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
            [self copyAddressBook:addressBook];
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        [self copyAddressBook:addressBook];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
//            [hud turnToError:@"没有获取通讯录权限"];
        });
    }
}


- (void)copyAddressBook:(ABAddressBookRef)addressBook
{
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSMutableArray *phoneArray = [NSMutableArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for ( int i = 0; i < numberOfPeople; i++){

        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        
        NSMutableString *name =[ NSMutableString string];
        //读取电话多值
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        if (firstName.length) {
            [name appendString:firstName];
        }
        if (lastName.length) {
            [name appendString:lastName];
        }

        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {

            //获取电话Label
            NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
            //获取該Label下的电话值
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            NSLog(@"%@, %@, %@, %@",personPhoneLabel, personPhone,firstName, lastName);
            if (personPhone.length) {
                NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
                personPhone = [personPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
                if ([personPhone isMobileNumber]) {
                    infoDict[@"mobile"] = personPhone;
                    infoDict[@"bookName"] = name.length ? name:personPhone;
                    dict[personPhone] = infoDict;
                }
            }
        }
    }
    NSMutableDictionary *sendDict =[NSMutableDictionary dictionary];
    sendDict[@"phoneContactList"] = [dict allValues];
    sendDict[@"custId"] = globalData.loginModel.custId;
    WS(weakSelf);
    [[GYHDMessageCenter sharedInstance] getUserByPhoneContactsWithDict:sendDict RequetResult:^(NSDictionary *resultDict) {
        NSLog(@"%@",resultDict);
        if ([resultDict[@"retCode"] integerValue] == 200) {
            NSMutableArray *array = [NSMutableArray array];
            
            
            for (NSDictionary *dict in resultDict[@"rows"]) {
                GYHDSearchUserModel *model = [[GYHDSearchUserModel alloc] init];
                model.iconString = [NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl, dict[@"headPic"]];
                model.nameString = dict[@"nickname"];
                model.hushengString = dict[@"resNo"];
                model.sign = dict[@"sign"];
                model.address = dict[@"area"];
                model.hobby = dict[@"hobby"];
                model.userType = dict[@"searchType"];
                model.custID = dict[@"friendId"];
                model.bookName = dict[@"bookName"];
                if ([dict[@"friendStatus"] isKindOfClass:[NSString class]]) {
                    model.friendStatus = dict[@"friendStatus"];
                }else {
                    model.friendStatus = [dict[@"friendStatus"] stringValue];
                }
                
                if ([dict[@"headPic"] hasPrefix:@"http"]) {
                    model.iconString = dict[@"headPic"];
                }
                else {
                    model.iconString = [NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl, dict[@"headPic"]];
                }
                
                [array addObject:model];
            }

//            weakSelf.phoneArray = array;
           weakSelf.phoneArray = [self contactsListWithArray:array];
            [weakSelf.phoneTableView reloadData];
        }else {
            
        }
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.phoneArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GYHDSearchUserGroupModel *model = self.phoneArray[section];
    return model.userArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYHDPhoneFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GYHDPhoneFriendCell class])];
     GYHDSearchUserGroupModel *groupmodel = self.phoneArray[indexPath.section];
    cell.model = groupmodel.userArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([GYHDPhoneFriendCell class]) configuration:^(GYHDPhoneFriendCell *cell) {
        GYHDSearchUserGroupModel *groupmodel = self.phoneArray[indexPath.section];
        cell.model = groupmodel.userArray[indexPath.row];

    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GYHDSearchUserGroupModel *groupmodel = self.phoneArray[indexPath.section];
    GYHDSearchUserModel *model =  groupmodel.userArray[indexPath.row];
    if ([model.friendStatus isEqualToString:@"2"]) {
        GYHDFriendDetailViewController *vc = [[GYHDFriendDetailViewController alloc] init];
        vc.FriendCustID=model.hushengString;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        GYHDSearchUserDetailViewController *userDetailViewController = [[GYHDSearchUserDetailViewController alloc] init];
        userDetailViewController.userModel = model;
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController pushViewController:userDetailViewController animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  18.0f;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 18)];
    GYHDSearchUserGroupModel* groupModel = self.phoneArray[section];
    label.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
    label.backgroundColor = [UIColor colorWithRed:235.0 / 255.0f green:235.0 / 255.0f blue:235.0 / 255.0f alpha:1.0f];
    label.font = [UIFont systemFontOfSize:KFontSizePX(24)];
    label.text =  [NSString stringWithFormat:@"  %@",groupModel.title];
    return label;
}
- (nullable NSArray<NSString*>*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    NSMutableArray* titleArray = [NSMutableArray array];
    for (GYHDSearchUserGroupModel* model in self.phoneArray) {
        [titleArray addObject:model.title];
    }
    return titleArray;
}

- (NSMutableArray *)contactsListWithArray:(NSArray *)array {
    NSArray *ABCArray = [NSArray arrayWithObjects: @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z",@"#", nil];
    NSMutableArray *groupArray = [NSMutableArray array];
    for (NSString *key in ABCArray) {
        GYHDSearchUserGroupModel *groupModel = [[GYHDSearchUserGroupModel alloc]init];
        for (GYHDSearchUserModel *listModel in array) {
            
            //1. 转字母
            NSString * tempStr =listModel.bookName;
            if (!tempStr || tempStr.length == 0) {
                tempStr = @"未设置名称";
            }
            if (tempStr) {
                tempStr = [[tempStr substringToIndex:1] uppercaseString];
            }
            if ([GYPinYinConvertTool isIncludeChineseInString:tempStr]) {
                tempStr = [GYPinYinConvertTool chineseConvertToPinYinHead:tempStr];
            }
            //2. 获取首字母
            NSString *firstLetter;
            if (tempStr.length >= 1) {
                firstLetter = [[tempStr substringToIndex:1] uppercaseString];
            }
            if (![ABCArray containsObject:firstLetter]) {
                tempStr = [@"#" stringByAppendingString:tempStr];
                firstLetter = [[tempStr substringToIndex:1] uppercaseString];
            }
            //3. 加入数组
            if([firstLetter isEqualToString:key]) {
                groupModel.title = key;
                [groupModel.userArray addObject:listModel];
            }
        }
        if (groupModel.title && groupModel.userArray.count > 0) {
            [groupArray addObject:groupModel];
        }
    }
    return  groupArray;
}
@end
//            for (NSDictionary *dict in resultDict[@"rows"]) {
//                GYHDPhoneFriendModel *model = [[GYHDPhoneFriendModel alloc] init];
//                model.phoneNikeName = dict[@"bookName"];
//                model.huShengNikeName = dict[@"nickname"];
//
//                model.friendCustID = dict[@"friendId"];
//
//                if ([dict[@"headPic"] hasPrefix:@"http"]) {
//                    model.iconName = dict[@"headPic"];
//                }
//                else {
//                   model.iconName =  [NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,dict[@"headPic"]];
//                }
//                [array addObject:model];
//
//            }
//    for ( int i = 0; i < numberOfPeople; i++){
//        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
//
//        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
//        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
//
//        //读取middlename
//        NSString *middlename = (NSString*)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
//        //读取prefix前缀
//        NSString *prefix = (NSString*)ABRecordCopyValue(person, kABPersonPrefixProperty);
//        //读取suffix后缀
//        NSString *suffix = (NSString*)ABRecordCopyValue(person, kABPersonSuffixProperty);
//        //读取nickname呢称
//        NSString *nickname = (NSString*)ABRecordCopyValue(person, kABPersonNicknameProperty);
//        //读取firstname拼音音标
//        NSString *firstnamePhonetic = (NSString*)ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty);
//        //读取lastname拼音音标
//        NSString *lastnamePhonetic = (NSString*)ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty);
//        //读取middlename拼音音标
//        NSString *middlenamePhonetic = (NSString*)ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty);
//        //读取organization公司
//        NSString *organization = (NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty);
//        //读取jobtitle工作
//        NSString *jobtitle = (NSString*)ABRecordCopyValue(person, kABPersonJobTitleProperty);
//        //读取department部门
//        NSString *department = (NSString*)ABRecordCopyValue(person, kABPersonDepartmentProperty);
//        //读取birthday生日
//        NSDate *birthday = (NSDate*)ABRecordCopyValue(person, kABPersonBirthdayProperty);
//        //读取note备忘录
//        NSString *note = (NSString*)ABRecordCopyValue(person, kABPersonNoteProperty);
//        //第一次添加该条记录的时间
//        NSString *firstknow = (NSString*)ABRecordCopyValue(person, kABPersonCreationDateProperty);
//        NSLog(@"第一次添加该条记录的时间%@\n",firstknow);
//        //最后一次修改該条记录的时间
//        NSString *lastknow = (NSString*)ABRecordCopyValue(person, kABPersonModificationDateProperty);
//        NSLog(@"最后一次修改該条记录的时间%@\n",lastknow);
//
//        //获取email多值
//        ABMultiValueRef email = ABRecordCopyValue(person, kABPersonEmailProperty);
//        int emailcount = ABMultiValueGetCount(email);
//        for (int x = 0; x < emailcount; x++)
//        {
//            //获取email Label
//            NSString* emailLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(email, x));
//            //获取email值
//            NSString* emailContent = (__bridge NSString*)ABMultiValueCopyValueAtIndex(email, x);
//        }
//        //读取地址多值
//        ABMultiValueRef address = ABRecordCopyValue(person, kABPersonAddressProperty);
//        int count = ABMultiValueGetCount(address);
//
//        for(int j = 0; j < count; j++)
//        {
//            //获取地址Label
//            NSString* addressLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(address, j);
//            //获取該label下的地址6属性
//            NSDictionary* personaddress =(__bridge NSDictionary*) ABMultiValueCopyValueAtIndex(address, j);
//            NSString* country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
//            NSString* city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];
//            NSString* state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
//            NSString* street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
//            NSString* zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];
//            NSString* coutntrycode = [personaddress valueForKey:(NSString *)kABPersonAddressCountryCodeKey];
//        }
//
//        //获取dates多值
//        ABMultiValueRef dates = ABRecordCopyValue(person, kABPersonDateProperty);
//        int datescount = ABMultiValueGetCount(dates);
//        for (int y = 0; y < datescount; y++)
//        {
//            //获取dates Label
//            NSString* datesLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(dates, y));
//            //获取dates值
//            NSString* datesContent = (NSString*)ABMultiValueCopyValueAtIndex(dates, y);
//        }
//        //获取kind值
//        CFNumberRef recordType = ABRecordCopyValue(person, kABPersonKindProperty);
//        if (recordType == kABPersonKindOrganization) {
//            // it's a company
//            NSLog(@"it's a company\n");
//        } else {
//            // it's a person, resource, or room
//            NSLog(@"it's a person, resource, or room\n");
//        }
//
//
//        //获取IM多值
//        ABMultiValueRef instantMessage = ABRecordCopyValue(person, kABPersonInstantMessageProperty);
//        for (int l = 1; l < ABMultiValueGetCount(instantMessage); l++)
//        {
//            //获取IM Label
//            NSString* instantMessageLabel = (NSString*)ABMultiValueCopyLabelAtIndex(instantMessage, l);
//            //获取該label下的2属性
//            NSDictionary* instantMessageContent =(NSDictionary*) ABMultiValueCopyValueAtIndex(instantMessage, l);
//            NSString* username = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageUsernameKey];
//
//            NSString* service = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageServiceKey];
//        }
//
//        //读取电话多值
//        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
//        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
//        {
//            //获取电话Label
//            NSString * personPhoneLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
//            //获取該Label下的电话值
//            NSString * personPhone = (NSString*)ABMultiValueCopyValueAtIndex(phone, k);
//
//        }
//
//        //获取URL多值
//        ABMultiValueRef url = ABRecordCopyValue(person, kABPersonURLProperty);
//        for (int m = 0; m < ABMultiValueGetCount(url); m++)
//        {
//            //获取电话Label
//            NSString * urlLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(url, m));
//            //获取該Label下的电话值
//            NSString * urlContent = (NSString*)ABMultiValueCopyValueAtIndex(url,m);
//        }
//
//        //读取照片
//        NSData *image = (NSData*)ABPersonCopyImageData(person);
//
//    }

