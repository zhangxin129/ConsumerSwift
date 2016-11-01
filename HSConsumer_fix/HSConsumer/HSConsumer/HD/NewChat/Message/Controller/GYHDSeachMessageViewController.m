//
//  GYHDSeachMessageViewController.m
//  HSConsumer
//
//  Created by shiang on 16/4/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSeachMessageViewController.h"
#import "GYHDSeachMessageCell.h"
#import "GYHDSeachMessageModel.h"
#import "GYHDMessageCenter.h"
#import "GYShopAboutViewController.h"
#import "GYHDChatViewController.h"
#import "GYHDFriendDetailViewController.h"
#import "GYHDSearchMessageListViewController.h"

@interface GYHDSeachMessageViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITextField* searchTextField;
/**
 *  搜索消息数组
 */
@property (nonatomic, strong) NSMutableArray* seachGroupArray;
/**
 *  搜索消息tableview
 */
@property (nonatomic, weak) UITableView* seachMessageTableView;
/**
 *  未搜索到相关信息
 */
@property (nonatomic, weak) UILabel* zeroSeachLabel;
@end

@implementation GYHDSeachMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:235.0 / 255.0f green:235.0 / 255.0f blue:235.0 / 255.0f alpha:1.0f];
    //    UIView *view = [[UIView alloc] init];
    //    view.frame = CGRectMake(0, 0, kScreenWidth, 64);
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 50, 30);
    [backButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_cancel"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popClick) forControlEvents:UIControlEventTouchUpInside];
    //    [backButton setBackgroundImage:[UIImage imageNamed:@"gyhd_text_field_send_icom"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //    [view addSubview:backButton];

    //    [self.view addSubview:backButton];

    //搜索输入框
    UIView* leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0, 0, 20, 20);
    UIImageView* leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_search_bar_left_icon"]];
    [leftView addSubview:leftImageView];
    [leftImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.center.equalTo(leftView);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    UIButton* rightSearchButton = [[UIButton alloc] init];
    [rightSearchButton setBackgroundImage:[UIImage imageNamed:@"gyhd_search_bar_right_icon"] forState:UIControlStateNormal];
    [rightSearchButton addTarget:self action:@selector(rightSearchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    rightSearchButton.frame = CGRectMake(0, 0, 20, 20);
    UITextField* searchTextField = [[UITextField alloc] init];
    [searchTextField addTarget:self action:@selector(seachTextClick) forControlEvents:UIControlEventEditingChanged];
    searchTextField.background = [UIImage imageNamed:@"gyhd_search_bar_bg"];
    searchTextField.placeholder = [GYUtils localizedStringWithKey:@"GYHD_Search_friend_message_company"];
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    searchTextField.leftView = leftView;
    searchTextField.returnKeyType = UIReturnKeySearch;
    searchTextField.delegate = self;
    searchTextField.rightViewMode = UITextFieldViewModeAlways;
    searchTextField.rightView = rightSearchButton;
    //    [self.view addSubview:searchTextField];
    _searchTextField = searchTextField;
    searchTextField.frame = CGRectMake(0, 0, kScreenWidth - 120, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchTextField];

    UITableView* seachMessageTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped ];
    seachMessageTableView.delegate = self;
    seachMessageTableView.dataSource = self;

    [seachMessageTableView registerClass:[GYHDSeachMessageCell class] forCellReuseIdentifier:@"GYHDSeachMessageCellID"];
    seachMessageTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:seachMessageTableView];
    seachMessageTableView.backgroundColor = [UIColor colorWithRed:235.0 / 255.0f green:235.0 / 255.0f blue:235.0 / 255.0f alpha:1.0f];
    _seachMessageTableView = seachMessageTableView;

    UILabel* zeroSeachLabel = [[UILabel alloc] init];
    zeroSeachLabel.text = [GYUtils localizedStringWithKey:@"GYHD_zero_searchAddress"];
    [self.view addSubview:zeroSeachLabel];
    _zeroSeachLabel = zeroSeachLabel;

    WS(weakSelf);
    [zeroSeachLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.center.equalTo(weakSelf.view);
    }];

    //    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.mas_equalTo(-12);
    //        make.top.mas_equalTo(20);
    //        make.width.mas_equalTo(50);
    //        make.height.mas_equalTo(30);
    //    }];
    //    [searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(12);
    //        make.right.equalTo(backButton.mas_left).offset(-10);
    //        make.top.mas_equalTo(20);
    //        make.height.mas_equalTo(30);
    //
    //    }];

    [seachMessageTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(0);
        make.left.right.bottom.mas_equalTo(0);
    }];

    // Do any additional setup after loading the view.
}

- (void)popClick
{
    [self.navigationController popViewControllerAnimated:YES];
    //    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightSearchButtonClick:(UIButton*)button
{
    self.searchTextField.text = nil;
}

- (void)seachTextClick
{
    if (self.searchTextField.text.length == 0) {
        self.seachGroupArray = nil;
        [self.seachMessageTableView reloadData];
        return;
    };
//    if (self.searchTextField.text.length < 2) {
//        return;
//    }
    if (self.searchTextField.text.length > 10) {
        self.searchTextField.text = [self.searchTextField.text substringToIndex:10];
        return;
    }
    NSMutableArray* searchArray = [NSMutableArray array];
    NSArray* dbArray = [[GYHDMessageCenter sharedInstance] selectSearchMessageWithString:self.searchTextField.text];
    if (dbArray.count == 0)
        return;
    for (int i = 0; i < 3; i++) {
        NSArray* array = dbArray[i];
        GYHDSeachMessageGroupModel* groupModel = [[GYHDSeachMessageGroupModel alloc] init];
        for (NSDictionary* dict in array) {

            NSMutableDictionary* attDict = [NSMutableDictionary dictionary];
            attDict[NSForegroundColorAttributeName] = [UIColor redColor];

            GYHDSeachMessageModel* model = [[GYHDSeachMessageModel alloc] initWithDict:dict];
            NSString* pattern = self.searchTextField.text;
            NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
            //            NSArray *contentResults = [regex matchesInString:model.seachContent options:0 range:NSMakeRange(0, model.seachContent.length)];
            //            NSTextCheckingResult *contresult = [contentResults firstObject];
            //            NSMutableAttributedString *attContent = [[NSMutableAttributedString alloc] initWithString:model.seachContent];
            //            [attContent setAttributes:attDict range:contresult.range];
            //            model.seachAttContent = attContent;
//
//            if (i == 0) {
//                //                NSInteger count =   [[GYHDMessageCenter sharedInstance] countWithCustID:model.custID];
//                NSInteger count = [[GYHDMessageCenter sharedInstance] countWithCustID:model.custID searchString:self.searchTextField.text];
//                NSString* messageCount = [NSString stringWithFormat:@"%ld条相关聊天记录", (long)count];
//                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                dict[NSForegroundColorAttributeName] = [UIColor redColor];
//                NSMutableAttributedString *att  = [[NSMutableAttributedString alloc] initWithString:messageCount];
//                [att addAttributes:dict range:NSMakeRange(0, 1)];
//                model.seachAttContent = att;
//            }
//            else {
            if (model.seachContent) {
                NSString* enmojiPattern = @"\\[[0-9]{3}\\]";
                NSRegularExpression* emojiRegex = [[NSRegularExpression alloc] initWithPattern:enmojiPattern options:0 error:nil];
                // 2.测试字符串
                NSArray* enmojiResults = [emojiRegex matchesInString:model.seachContent options:0 range:NSMakeRange(0, model.seachContent.length)];
                // 3.遍历结果
                [enmojiResults enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult* result, NSUInteger idx, BOOL* _Nonnull stop) {
                    NSString *imageName = [[model.seachContent substringWithRange:result.range] substringWithRange:NSMakeRange(1, 3)];
                    NSTextAttachment *textAtt = [[NSTextAttachment alloc] init];
                    UIImage *image = [UIImage imageNamed:imageName];
                    if (image) {
                        textAtt.image = image;
                        textAtt.bounds = CGRectMake(0, 0, 10, 10);
                        NSAttributedString *att = [NSAttributedString attributedStringWithAttachment:textAtt];
                        [model.seachAttContent replaceCharactersInRange:result.range withAttributedString:att];
                    }
                }];
            }

//            }
            // 2.测试字符串
            NSArray* results = [regex matchesInString:model.seachName options:0 range:NSMakeRange(0, model.seachName.length)];
            // 3.遍历结果
            NSTextCheckingResult* result = [results firstObject];
            NSMutableAttributedString* attName = [[NSMutableAttributedString alloc] initWithString:model.seachName];

            [attName setAttributes:attDict range:result.range];
            model.seachAttName = attName;
            [groupModel.seachMessageArray addObject:model];
        }
        if (groupModel.seachMessageArray.count) {
            switch (i) {
            case 0:
                groupModel.seachTitle = [GYUtils localizedStringWithKey:@"GYHD_chat"];
                break;
            case 1:
                groupModel.seachTitle = [GYUtils localizedStringWithKey:@"GYHD_user_addfriedn_friend"];
                break;
            case 2:
                groupModel.seachTitle = [GYUtils localizedStringWithKey:@"GYHD_Company"];
                break;
            default:
                break;
            }
            [searchArray addObject:groupModel];
        }
    }
    self.seachGroupArray = searchArray;
    if (searchArray.count > 0) {
        self.zeroSeachLabel.hidden = YES;
    }
    else {
        self.zeroSeachLabel.hidden = NO;
    }
    [self.seachMessageTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.seachGroupArray.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    GYHDSeachMessageGroupModel* model = self.seachGroupArray[section];
    if (model.showMore) {
        return model.seachMessageArray.count;
    }
    else {
        if (model.seachMessageArray.count > 5) {
            return 5;
        }
        else {
            return model.seachMessageArray.count;
        }
    }
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    GYHDSeachMessageGroupModel *model = self.seachGroupArray[section];
//    return model.seachTitle;
//}
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
//    return @"xxxx";
//}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    GYHDSeachMessageGroupModel* model = self.seachGroupArray[section];
    if (model.seachMessageArray.count > 5 && !model.showMore) {
        return 40;
    }
    else {
        return 0;
    }
    //    if (model.showMore) {
    //        return 0;
    //    }else {
    //        if (model.seachMessageArray.count >1) {
    //
    //        }else {
    //            return 0;
    //
    //        }
    //    }
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textColor = [UIColor grayColor];
    GYHDSeachMessageGroupModel* model = self.seachGroupArray[section];
    label.text = [NSString stringWithFormat:@"  %@", model.seachTitle];
    [label addBottomBorder];
    [label addTopBorder];
    return label;
}
- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{

    GYHDSeachMessageGroupModel* model = self.seachGroupArray[section];
    if (model.showMore || model.seachMessageArray.count <= 5) {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
    else {

        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        NSString* title = [NSString stringWithFormat:[GYUtils localizedStringWithKey:@"GYHD_Search_see_more"], model.seachTitle];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gyhd_red_search_icon"] forState:UIControlStateNormal];
        [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn addBottomBorder];
        [btn addTopBorder];

        UIImageView* moreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_more_gd"]];
        [btn addSubview:moreImageView];
        [moreImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.mas_equalTo(-12);
            make.centerY.equalTo(btn);
        }];
        return btn;
    }
}
- (void)btnClick:(UIButton*)btn
{
    for (GYHDSeachMessageGroupModel* groupModel in self.seachGroupArray) {
        if ([btn.currentTitle rangeOfString:groupModel.seachTitle].location != NSNotFound) {
            groupModel.showMore = YES;
            [self.seachMessageTableView reloadData];
            break;
        }
    }
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHDSeachMessageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDSeachMessageCellID"];
    GYHDSeachMessageGroupModel* groupModel = self.seachGroupArray[indexPath.section];
    GYHDSeachMessageModel* model = groupModel.seachMessageArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 66.0f;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHDSeachMessageGroupModel* groupModel = self.seachGroupArray[indexPath.section];
    GYHDSeachMessageModel* model = groupModel.seachMessageArray[indexPath.row];

    if ([groupModel.seachTitle isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_chat"]]) {
        GYHDSearchMessageListViewController *listViewController = [[GYHDSearchMessageListViewController alloc] init];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"searchString"] = self.searchTextField.text;
        dict[@"custID"] = model.custID;
        listViewController.searchDict= dict;
        [self.navigationController pushViewController:listViewController animated:YES];
//
//        GYHDChatViewController* NextVC = [[GYHDChatViewController alloc] init];
//        NextVC.messageCard = model.custID;
//        [self.navigationController pushViewController:NextVC animated:YES];
    }
    else if ([groupModel.seachTitle isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_user_addfriedn_friend"]]) {
        GYHDFriendDetailViewController* NextVC = [[GYHDFriendDetailViewController alloc] init];
        NextVC.FriendCustID = model.custID;
        [self.navigationController pushViewController:NextVC animated:YES];
    }
    else if ([groupModel.seachTitle isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_Company"]]) {

        NSDictionary* companyDict = [[GYHDMessageCenter sharedInstance] selectFriendBaseWithCardString:model.custID];
        GYShopAboutViewController* vc = [[GYShopAboutViewController alloc] init];
        vc.strVshopId = companyDict[GYHDDataBaseCenterFriendInfoTeamID];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end

//    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 100);
//    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
//
//
//    footView.backgroundColor =[UIColor whiteColor];
//    UIImageView *searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_search_bar_left_icon"]];
//    [footView addSubview:searchImageView];
//
//    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.font = [UIFont systemFontOfSize:12.0f];
//    titleLabel.backgroundColor = [UIColor redColor];
//    NSString *title = [NSString stringWithFormat:@"查看更多%@的%@",self.searchTextField.text,model.seachTitle];
//    titleLabel.text = title;
//    [footView addSubview:titleLabel];
//
//    UIImageView *moreImgaeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_search_bar_left_icon"]];
//    [footView addSubview:moreImgaeView];
//    [footView addBottomBorder];
//
//    [searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(12);
//        make.centerY.equalTo(footView);
//    }];
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(searchImageView.mas_right).offset(12);
//        make.right.mas_lessThanOrEqualTo(-24);
//        make.centerY.equalTo(footView);
//    }];
//    [moreImgaeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-12);
//        make.centerY.equalTo(footView);
//    }];
//    return footView;
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    NSMutableDictionary *attDict = [NSMutableDictionary dictionary];
//    attDict[NSForegroundColorAttributeName] = [UIColor redColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:attDict];
//
//
//}
//- (void)ignoreClick {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.barTintColor = kNavBackgroundColor;
//    NSMutableDictionary *attDict = [NSMutableDictionary dictionary];
//    attDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:attDict];
//}
