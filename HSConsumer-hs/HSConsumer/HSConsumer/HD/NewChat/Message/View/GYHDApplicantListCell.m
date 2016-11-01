//
//  GYHDApplicantListCell.m
//  HSConsumer
//
//  Created by shiang on 16/4/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDApplicantListCell.h"
#import "GYHDMessageCenter.h"
#import "GYHDApplicantListModel.h"

@interface GYHDApplicantListCell ()
//
///**头像*/
//@property (nonatomic, weak) UIImageView* headImageView;
///**昵称*/
//@property (nonatomic, weak) UILabel* nikeNameLabel;
///**正文*/
//@property (nonatomic, weak) UILabel* contentLabel;
/**添加状态*/
@property (nonatomic, weak) UIButton* searchStatusButton;
/**
 *  添加状态
 */
@property (nonatomic, weak) UILabel* searchStatusLabel;
@end

@implementation GYHDApplicantListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    UIImageView* headImageView = [[UIImageView alloc] init];
//    [self.contentView addSubview:headImageView];
//    _headImageView = headImageView;
//
//    UILabel* nikeNameLabel = [[UILabel alloc] init];
//    nikeNameLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
//    [self.contentView addSubview:nikeNameLabel];
//    _nikeNameLabel = nikeNameLabel;

    UILabel* searchStatusLabel = [[UILabel alloc] init];
    searchStatusLabel.text = [GYUtils localizedStringWithKey:@"GYHD_Friend_already_agree"];
    searchStatusLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    searchStatusLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:searchStatusLabel];
    _searchStatusLabel = searchStatusLabel;

    UIButton* searchStatusButton = [[UIButton alloc] init];
    searchStatusButton.titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    [searchStatusButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_agree"] forState:UIControlStateNormal];
    [searchStatusButton setBackgroundImage:[UIImage imageNamed:@"gyhd_text_field_send_icom"] forState:UIControlStateNormal];
    [searchStatusButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:searchStatusButton];
    _searchStatusButton = searchStatusButton;

//    UILabel* contentLabel = [[UILabel alloc] init];
//    contentLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
//    contentLabel.textColor = [UIColor grayColor];
//    [self.contentView addSubview:contentLabel];
//    _contentLabel = contentLabel;

    WS(weakSelf);
//    [headImageView mas_remakeConstraints:^(MASConstraintMaker* make) {
//        make.centerY.equalTo(weakSelf.contentView);
//        make.left.mas_equalTo(12);
//        make.size.mas_equalTo(CGSizeMake(44, 44));
//    }];

//    [nikeNameLabel mas_remakeConstraints:^(MASConstraintMaker* make) {
//        make.left.equalTo(headImageView.mas_right).offset(12);
//        make.top.equalTo(headImageView);
//    }];

    [searchStatusLabel mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(weakSelf.leftImageView.mas_centerY);

    }];

    [searchStatusButton mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(weakSelf.leftImageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 35));
    }];
//    [contentLabel mas_remakeConstraints:^(MASConstraintMaker* make) {
//        make.left.equalTo(headImageView.mas_right).offset(12);
//        make.right.equalTo(searchStatusButton.mas_left).offset(-12);
//        make.bottom.equalTo(headImageView);
//    }];
}

- (void)setModel:(GYHDApplicantListModel*)model
{
    _model = model;
    self.leftTopLabel.text = model.applicantNikeNameString;
    self.leftBottomLabel.text = model.applicantCont;
    [self.leftImageView setImageWithURL:[NSURL URLWithString:model.applicantHeadImageUrlString] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];

    switch (model.applicantUserStatus) {
    case 0:
        self.searchStatusButton.hidden = NO;
        self.searchStatusLabel.hidden = YES;
        break;
        case 2:
        {
            self.searchStatusButton.hidden = YES;
            self.searchStatusLabel.hidden = NO;
            self.searchStatusLabel.text = [GYUtils localizedStringWithKey:@"GYHD_Frined_already_Ignored"];
            break;
        }
    case 200:
    case 501:
        {
            self.searchStatusButton.hidden = YES;
            self.searchStatusLabel.hidden = NO;
            self.searchStatusLabel.text = [GYUtils localizedStringWithKey:@"GYHD_Friend_already_agree"];
        break;
        }
        case 810:
        case 811:
        {
            self.searchStatusButton.hidden = YES;
            self.searchStatusLabel.hidden = NO;
            self.searchStatusLabel.text = [GYUtils localizedStringWithKey:@"GYHD_Friend_Reached_the_limit"];
            break;
        }
    default:
        break;
    }
}

- (void)searchButtonClick
{
    NSDictionary* dict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
    NSMutableDictionary* insideDict = [NSMutableDictionary dictionary];
    insideDict[@"accountId"] = dict[@"Friend_ID"];
    insideDict[@"accountNickname"] = dict[@"Friend_Name"];
    insideDict[@"accountHeadPic"] = dict[@"Friend_Icon"];
    insideDict[@"req_info"] = @"11";
    insideDict[@"friendId"] = self.model.applicantID;
    insideDict[@"friendNickname"] = self.model.applicantNikeNameString;
    insideDict[@"friendStatus"] = @"2";
    insideDict[@"friendHeadPic"] = self.model.applicantHeadImageUrlString;
    WS(weakSelf);
    [[GYHDMessageCenter sharedInstance] deleteFriendWithDict:insideDict RequetResult:^(NSDictionary* resultDict) {
            UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
        if ([resultDict[@"retCode"] isEqualToString:@"200"]  ||
            [resultDict[@"retCode"] isEqualToString:@"501"]  ||
            [resultDict[@"retCode"] isEqualToString:@"810"]  ||
            [resultDict[@"retCode"] isEqualToString:@"811"]  ) {
            if ([resultDict[@"retCode"] isEqualToString:@"200"]  ||
                [resultDict[@"retCode"] isEqualToString:@"501"]) {
                [GYUtils showToast:[resultDict[@"retCode"] isEqualToString:@"501"] ? [GYUtils localizedStringWithKey:@"GYHD_Friend_add_already"] :[GYUtils localizedStringWithKey:@"GYHD_Friend_add_success"] duration:1.0f position:CSToastPositionCenter];
                weakSelf.searchStatusLabel.text = [GYUtils localizedStringWithKey:@"GYHD_Friend_already_agree"];
            }else {
                [GYUtils showToast:resultDict[@"message"] duration:1.0f position:CSToastPositionCenter];
                weakSelf.searchStatusLabel.text = [GYUtils localizedStringWithKey:@"GYHD_Friend_Reached_the_limit"];
            }
            
            weakSelf.model.applicantUserStatus = 1;
            weakSelf.searchStatusButton.hidden = YES;
            weakSelf.searchStatusLabel.hidden = NO;
            NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithDictionary:[GYUtils stringToDictionary:weakSelf.model.applicantBody]];
            bodyDict[@"status"] = resultDict[@"retCode"];
            NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
            updateDict[GYHDDataBaseCenterPushMessageBody] = [GYUtils dictionaryToString:bodyDict];
            NSMutableDictionary *condDict = [NSMutableDictionary dictionary];
            condDict[GYHDDataBaseCenterPushMessageID] = weakSelf.model.applicantMessageID;
            [[GYHDMessageCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:condDict TableName:GYHDDataBaseCenterPushMessageTableName];
            NSMutableDictionary *frienddeletedict = [NSMutableDictionary dictionary];
            frienddeletedict[@"friendChange"] = @(100);
            frienddeletedict[@"toID"] =  updateDict[@"friendId"];
            [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:frienddeletedict];
            
        }else {
            [GYUtils showToast:resultDict[@"message"] duration:1.0f position:CSToastPositionCenter];
        }
    }];
}

@end
