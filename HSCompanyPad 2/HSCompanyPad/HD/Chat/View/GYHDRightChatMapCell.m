//
//  GYHDRightChatMapCell.m
//  HSConsumer
//
//  Created by shiang on 16/7/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDRightChatMapCell.h"



@interface GYHDRightChatMapCell ()
/**用户头像*/
@property (nonatomic, strong) UIImageView* iconImageView;
/**接收时间*/
@property (nonatomic, strong) UILabel* chatRecvTimeLabel;
/**聊天背景*/
@property (nonatomic, strong) UIImageView* chatbackgroundView;
/**地图显示View*/
@property (nonatomic, strong) UIImageView *mapImageView;
/**地图标题*/
@property (nonatomic, strong) UILabel *mapTitleLabel;
/**地图地址*/
@property (nonatomic, strong) UILabel *mapAddressLabel;
/**发送内容状态*/
@property (nonatomic, strong) UIButton* chatStateButton;
@end

@implementation GYHDRightChatMapCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
- (void)setup {
    self.contentView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    //1 .头像
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 3;
    self.iconImageView.image = [UIImage imageNamed:@"gyhd_defaultheadimg"];
    self.iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageViewClick:)];
    [self.iconImageView addGestureRecognizer:tapGR];
    [self.contentView addSubview:self.iconImageView];
    
    //2. 发送时间
    self.chatRecvTimeLabel = [[UILabel alloc] init];
    self.chatRecvTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.chatRecvTimeLabel.font = [UIFont systemFontOfSize:14.0f];
    self.chatRecvTimeLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.contentView addSubview:self.chatRecvTimeLabel ];
    
    //1. 聊天背景
    self.chatbackgroundView = [[UIImageView alloc] init];
    self.chatbackgroundView.image = [UIImage imageNamed:@"gyhd_Map_right_bg"];
    [self.contentView addSubview:self.chatbackgroundView ];
    

    
    /**地图显示View*/
    self.mapImageView = [[UIImageView alloc] init];
    self.mapImageView.image = [UIImage imageNamed:@"gyhd_chat_map_icon"];
    [self.chatbackgroundView addSubview:self.mapImageView];
    /**地图标题*/
    self.mapTitleLabel = [[UILabel alloc] init];
    self.mapTitleLabel.numberOfLines = 2;
    [self.chatbackgroundView addSubview:self.mapTitleLabel];
    /**地图地址*/
    self.mapAddressLabel = [[UILabel alloc] init];
    self.mapAddressLabel.font = [UIFont systemFontOfSize:12];
    self.mapAddressLabel.numberOfLines = 0;
    self.mapAddressLabel.textColor = [UIColor colorWithRed:153.0 / 255.0f green:153.0 / 255.0f blue:153.0 / 255.0f alpha:1];
    [self.chatbackgroundView addSubview:self.mapAddressLabel];
    
    //3. 消息状态
    self.chatStateButton = [[UIButton alloc] init];
    [self.chatStateButton addTarget:self action:@selector(chatStateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.chatStateButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.chatStateButton.imageView.animationDuration = 1.4f;
    
    NSMutableArray* imageArray = [NSMutableArray array];
    for (int i = 1; i < 6; i++) {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"gyhd_loading_icon_%d", i]];
        [imageArray addObject:image];
    }
    self.chatStateButton.imageView.animationImages = imageArray;
    [self.chatStateButton setImage:[UIImage imageNamed:@"gyhd_chat_failue_btn_normal"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.chatStateButton];

    
    @weakify(self);
    [self.chatRecvTimeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.mas_equalTo(0);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.right.mas_equalTo(-10);
        make.height.width.mas_equalTo(44);
        make.top.equalTo(self.chatRecvTimeLabel.mas_bottom).offset(25);
    }];
    
    [self.chatbackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.iconImageView);
        make.left.mas_equalTo(60);
        make.right.equalTo(self.iconImageView.mas_left).offset(-5);
        make.bottom.mas_equalTo(-20);
    }];


    [self.mapImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.chatbackgroundView);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];

    [self.mapTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.mapImageView.mas_right).offset(10);
        make.top.equalTo(self.mapImageView);
        make.right.mas_equalTo(-10);
    }];

    [self.mapAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.mapImageView.mas_right).offset(10);
        make.right.mas_equalTo(-10);
        make.top.equalTo(self.mapTitleLabel.mas_bottom).offset(10);
        make.bottom.lessThanOrEqualTo(self.mapImageView);
    }];
    [self.chatStateButton mas_remakeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.centerY.equalTo(self.chatbackgroundView);
        make.right.equalTo(self.chatbackgroundView.mas_left).offset(-10);
    }];
    
    self.chatRecvTimeLabel.text = @"tttttt";
    self.mapTitleLabel.text = @"xxxxxx";
    self.mapAddressLabel.text = @"bbbbb";
}
- (void)chatStateButtonClick:(UIButton*)button
{
//    if ([self.delegate respondsToSelector:@selector(GYHDChatView:tapType:chatModel:)]) {
//        [self.delegate GYHDChatView:self tapType:GYHDChatTapResendButton chatModel:self.chatModel];
//    }
}
//- (void)setChatModel:(GYHDNewChatModel *)chatModel {
//    _chatModel = chatModel;
//    self.chatRecvTimeLabel.text = chatModel.chatRecvTime;
//    NSDictionary *bodyDict = [GYUtils stringToDictionary:chatModel.chatBody ];
//    self.mapTitleLabel.text = bodyDict[@"map_name"];
//    self.mapAddressLabel.text = bodyDict[@"map_address"];
//    switch (chatModel.chatSendState) {
//        case GYHDDataBaseCenterMessageSendStateSuccess: // 发送成功
//            [self.chatStateButton.imageView stopAnimating];
//            self.chatStateButton.hidden = YES;
//            
//            break;
//        case GYHDDataBaseCenterMessageSendStateSending:
//            
//            self.chatStateButton.hidden = NO;
//            [self.chatStateButton.imageView startAnimating];
//            break;
//        case GYHDDataBaseCenterMessageSendStateFailure:
//            self.chatStateButton.hidden = NO;
//            [self.chatStateButton.imageView stopAnimating];
//            break;
//        default:
//            break;
//    }
//
//}
- (void)viewTap:(UITapGestureRecognizer*)tap
{
//    if ([self.delegate respondsToSelector:@selector(GYHDChatView:tapType:chatModel:)]) {
//        [self.delegate GYHDChatView:self tapType:GYHDChatTapChatMap chatModel:self.chatModel];
//    }
}
- (void)iconImageViewClick:(UITapGestureRecognizer*)tap
{
//    if ([self.delegate respondsToSelector:@selector(GYHDChatView:tapType:chatModel:)]) {
//        [self.delegate GYHDChatView:self tapType:GYHDChatTapUserIcon chatModel:self.chatModel];
//    }
}
@end
