//
//  GYHDFriendCell.m
//  HSConsumer
//
//  Created by shiang on 16/1/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDFriendCell.h"
#import "GYHDMessageCenter.h"
#import "GYHDFriendModel.h"

@interface GYHDFriendCell ()
///**好友头像*/
//@property (nonatomic, weak) UIImageView* FriendIconIamgeView;
///**好友昵称*/
//@property (nonatomic, weak) UILabel* FriendNikeNameLabel;
///**好友签名*/
//@property (nonatomic, weak) UILabel* FriendSignatureLabel;
/**好友申请*/
@property (nonatomic, weak) UIButton* friendApplicationStatusButton;
@end

@implementation GYHDFriendCell

//+ (instancetype)cellWithTableView:(UITableView*)tableView
//{
//    static NSString* identifierString = @"GYHDFriendCellID";
//    GYHDFriendCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierString];
//    if (cell == nil) {
//        cell = [[GYHDFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierString];
//    }
//    return cell;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return self;
    [self setup];
    return self;
}

- (void)setup
{
//    UIImageView* FriendIconIamgeView = [[UIImageView alloc] init];
//    FriendIconIamgeView.layer.masksToBounds = YES;
//    FriendIconIamgeView.layer.cornerRadius = 3.0f;
//    [self.contentView addSubview:FriendIconIamgeView];
//    _FriendIconIamgeView = FriendIconIamgeView;
//
//    UILabel* FriendNikeNameLabel = [[UILabel alloc] init];
//    FriendNikeNameLabel.font = [UIFont systemFontOfSize:KFontSizePX(32.0f)];
//    [self.contentView addSubview:FriendNikeNameLabel];
//    _FriendNikeNameLabel = FriendNikeNameLabel;
//
//    UILabel* FriendSignatureLabel = [[UILabel alloc] init];
//    FriendSignatureLabel.font = [UIFont systemFontOfSize:KFontSizePX(24)];
//    FriendSignatureLabel.textColor = [UIColor colorWithRed:153 / 255.0f green:153 / 255.0f blue:153 / 255.0f alpha:1];
//    [self.contentView addSubview:FriendSignatureLabel];
//    _FriendSignatureLabel = FriendSignatureLabel;

    UIButton* friendApplicationStatusButton = [[UIButton alloc] init];
    friendApplicationStatusButton.titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(24.0f)];
    friendApplicationStatusButton.userInteractionEnabled = NO;

    [friendApplicationStatusButton setBackgroundImage:[UIImage imageNamed:@"gyhd_argee_btn_normal"] forState:UIControlStateNormal];

    [friendApplicationStatusButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_Awaiting_verification"] forState:UIControlStateSelected];
    [friendApplicationStatusButton setBackgroundImage:[UIImage imageNamed:@"btn-ignore_h"] forState:UIControlStateSelected];

    [self.contentView addSubview:friendApplicationStatusButton];
    _friendApplicationStatusButton = friendApplicationStatusButton;
    WS(weakSelf);
//    [FriendIconIamgeView mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.size.mas_equalTo(CGSizeMake(44.0f, 44.0f));
//        make.left.top.mas_equalTo(12.0f);
//    }];
//
//    [FriendNikeNameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.left.equalTo(weakSelf.FriendIconIamgeView.mas_right).offset(12);
//        make.top.equalTo(weakSelf.FriendIconIamgeView.mas_top);
//        make.height.equalTo(weakSelf.FriendIconIamgeView.mas_height).multipliedBy(0.5);
//    }];
//
//    [FriendSignatureLabel mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.left.equalTo(weakSelf.FriendIconIamgeView.mas_right).offset(12);
//        make.bottom.equalTo(weakSelf.FriendIconIamgeView);
//        make.height.equalTo(weakSelf.FriendIconIamgeView.mas_height).multipliedBy(0.5);
//        make.right.mas_equalTo(-47.0f);
//    }];

    [friendApplicationStatusButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(weakSelf.leftTopLabel);
        make.right.mas_equalTo(-24);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
}

- (void)setFriendModel:(GYHDFriendModel*)friendModel
{
    _friendModel = friendModel;
    [self.leftImageView setImageWithURL:[NSURL URLWithString:friendModel.FriendIconUrl] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
    if ([friendModel.FriendSignature isEqualToString:@"null"]) {

        self.leftBottomLabel.text = @"";
    }
    else {

        self.leftBottomLabel.text = kSaftToNSString(friendModel.FriendSignature);
    }
    self.leftTopLabel.text = friendModel.FriendNickName;
    if ([friendModel.friendApplicationStatus isEqualToString:@"1"]) {
        self.friendApplicationStatusButton.hidden = NO;
        [self.friendApplicationStatusButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_Friend_To_Apply_For"] forState:UIControlStateNormal];
        NSMutableDictionary* selectDict = [NSMutableDictionary dictionary];
        selectDict[@"User_Name"] = [friendModel.FriendCustID substringToIndex:11];
        NSArray* setArray = [[GYHDMessageCenter sharedInstance] selectInfoWithDict:selectDict TableName:GYHDDataBaseCenterUserSetingTableName];
        NSDictionary* setDict = setArray.lastObject;
        if (setDict[GYHDDataBaseCenterUserSetingSelectCount]) {

            NSInteger countI = [setDict[GYHDDataBaseCenterUserSetingSelectCount] integerValue];
            if (countI > 4) {
                self.friendApplicationStatusButton.selected = YES;
            }
            else {
                self.friendApplicationStatusButton.selected = NO;
            }
        }

    }else if ([friendModel.friendApplicationStatus isEqualToString:@"-1"]) {
        self.friendApplicationStatusButton.hidden = NO;
        [self.friendApplicationStatusButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_Friend_agree"] forState:UIControlStateNormal];
    }else {
        self.friendApplicationStatusButton.hidden = YES;
    }
    
}

@end
