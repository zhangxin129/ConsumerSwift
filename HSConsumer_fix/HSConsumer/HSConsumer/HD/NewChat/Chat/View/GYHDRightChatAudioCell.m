//
//  GYHDLeftChatAudioCell.m
//  HSConsumer
//
//  Created by shiang on 16/3/1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDRightChatAudioCell.h"
#import "GYHDMessageCenter.h"
#import "GYHDNewChatModel.h"

@interface GYHDRightChatAudioCell ()
/**用户头像*/
@property (nonatomic, weak) UIImageView* iconImageView;
/**接收时间*/
@property (nonatomic, weak) UILabel* chatRecvTimeLabel;
/**音频类容图片*/
@property (nonatomic, weak) UIImageView* chatAudioImageView;
/**音频时长*/
@property (nonatomic, weak) UILabel* chatAudioTimeLabel;
/**左边音频动画数组*/
@property (nonatomic, strong) NSArray* chatAudioLeftImageArray;
/**音频背景*/
@property (nonatomic, weak) UIImageView* chatbackgroundView;
/**消息状态*/
@property (nonatomic, weak) UIButton* chatStateButton;
@end

@implementation GYHDRightChatAudioCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.contentView.backgroundColor = [UIColor colorWithRed:245 / 255.0f green:245 / 255.0f blue:245 / 255.0f alpha:1];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    //1. 聊天背景
    UIImageView* chatbackgroundView = [[UIImageView alloc] init];
    chatbackgroundView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer* longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(chatbackgroundViewLongtap:)];
    [chatbackgroundView addGestureRecognizer:longTap];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chatbackgroundViewtap:)];
    [chatbackgroundView addGestureRecognizer:tap];
    chatbackgroundView.image = [UIImage imageNamed:@"gyhd_chat_self_back"];
    [self.contentView addSubview:chatbackgroundView];
    _chatbackgroundView = chatbackgroundView;
    //3 .头像
    UIImageView* iconImageView = [[UIImageView alloc] init];
    iconImageView.image = kLoadPng(@"gyhd_defaultheadimg");
    iconImageView.userInteractionEnabled = YES;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.cornerRadius = 3;
    UITapGestureRecognizer* tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageViewClick:)];
    [iconImageView addGestureRecognizer:tapGR];
    [self.contentView addSubview:iconImageView];
    _iconImageView = iconImageView;

    //4. 发送时间
    UILabel* recvTimeLabel = [[UILabel alloc] init];
    recvTimeLabel.textAlignment = NSTextAlignmentCenter;
    recvTimeLabel.font = [UIFont systemFontOfSize:KFontSizePX(22)];
    recvTimeLabel.textColor = [UIColor colorWithRed:153.0 / 255.0f green:153.0 / 255.0f blue:153.0 / 255.0f alpha:1];
    [self.contentView addSubview:recvTimeLabel];
    _chatRecvTimeLabel = recvTimeLabel;

    //2.2 音频展示View
    NSMutableArray* audioImageArray = [NSMutableArray array];
    for (int i = 1; i <= 3; i++) {
        [audioImageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"gyhd_audio_right_%d", i]]];
    }
    UIImageView* chatAudioImageView = [[UIImageView alloc] init];
    chatAudioImageView.image = [UIImage imageNamed:@"gyhd_audio_right_3"];
    chatAudioImageView.contentMode = UIViewContentModeCenter;
    chatAudioImageView.animationDuration = 0.6;
    chatAudioImageView.animationImages = audioImageArray;
    [self.contentView addSubview:chatAudioImageView];
    _chatAudioImageView = chatAudioImageView;
    /**音频时长*/
    UILabel* chatAudioTimeLabel = [[UILabel alloc] init];
    chatAudioTimeLabel.textColor = [UIColor grayColor];
    chatAudioTimeLabel.font = [UIFont systemFontOfSize:KFontSizePX(24)];
    [self.contentView addSubview:chatAudioTimeLabel];
    _chatAudioTimeLabel = chatAudioTimeLabel;

    //3. 消息状态
    UIButton* chatStateButton = [[UIButton alloc] init];
    [chatStateButton addTarget:self action:@selector(chatStateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    chatStateButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    chatStateButton.imageView.animationDuration = 1.4f;

    NSMutableArray* imageArray = [NSMutableArray array];
    for (int i = 1; i < 13; i++) {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"gyhd_loading_%d", i]];
        [imageArray addObject:image];
    }
    chatStateButton.imageView.animationImages = imageArray;
    [chatStateButton setImage:[UIImage imageNamed:@"gyhd_failure"] forState:UIControlStateNormal];
    [self.contentView addSubview:chatStateButton];
    _chatStateButton = chatStateButton;

    WS(weakSelf);
    [self.chatRecvTimeLabel mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.mas_equalTo(0);
    }];

    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.right.mas_equalTo(-10);
        make.height.width.mas_equalTo(44);
        make.top.equalTo(weakSelf.chatRecvTimeLabel.mas_bottom).offset(25);
    }];

    [self.chatbackgroundView mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(weakSelf.iconImageView);
        make.right.equalTo(weakSelf.iconImageView.mas_left).offset(-5);
        make.height.equalTo(weakSelf.iconImageView);
        make.width.mas_equalTo(20);
        make.bottom.mas_equalTo(-20);

    }];

    [self.chatAudioTimeLabel mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(weakSelf.chatbackgroundView);
        make.right.equalTo(weakSelf.chatbackgroundView.mas_left).offset(-10);
    }];

    [self.chatAudioImageView mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(weakSelf.chatbackgroundView);
        make.right.equalTo(weakSelf.chatbackgroundView).offset(-20);
    }];

    [self.chatStateButton mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(weakSelf.chatbackgroundView);
        make.right.equalTo(weakSelf.chatbackgroundView.mas_left).offset(-10);
    }];
}

- (void)setChatModel:(GYHDNewChatModel*)chatModel
{
    _chatModel = chatModel;
    self.chatRecvTimeLabel.text = chatModel.chatRecvTime;
    NSDictionary* dict = [GYUtils stringToDictionary:chatModel.chatBody];
    NSURL* url = [NSURL URLWithString:chatModel.chatIcon];
    [self.iconImageView setImageWithURL:url placeholder:kLoadPng(@"gyhd_defaultheadimg") options:kNilOptions completion:nil];

    NSDictionary* dataDict = [GYUtils stringToDictionary:chatModel.chatDataString];
    CGFloat audioW = 0;
    if (dataDict[@"mp3Len"] && dataDict[@"mp3"]) {
        self.chatAudioTimeLabel.text = [NSString stringWithFormat:@"%ld\"", [dataDict[@"mp3Len"] integerValue]];
        audioW = 40 + [dataDict[@"mp3Len"] integerValue] * 5;
    }
    else {
        self.chatAudioTimeLabel.text = [NSString stringWithFormat:@"%ld\"", [dict[@"msg_fileSize"] integerValue]];
        audioW = 40 + [dict[@"msg_fileSize"] integerValue] * 5;
    }

    switch (chatModel.chatSendState) {

    case GYHDDataBaseCenterMessageSentStateSuccess: // 发送成功
        [self.chatStateButton.imageView stopAnimating];
        self.chatStateButton.hidden = YES;

        break;
    case GYHDDataBaseCenterMessageSentStateSending:

        self.chatStateButton.hidden = NO;
        [self.chatStateButton.imageView startAnimating];
        break;
    case GYHDDataBaseCenterMessageSentStateFailure:

        self.chatStateButton.hidden = NO;
        [self.chatStateButton.imageView stopAnimating];
        break;
    default:
        break;
    }
    //    WS(weakSelf);
    [self.chatbackgroundView mas_updateConstraints:^(MASConstraintMaker* make) {
        make.width.mas_equalTo(audioW);
    }];

    //    [self.chatbackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(weakSelf.iconImageView);
    //        make.right.equalTo(weakSelf.iconImageView.mas_left);
    //        make.height.equalTo(weakSelf.iconImageView);
    //        make.width.mas_equalTo(audioW);
    //        make.bottom.mas_equalTo(-20);
    //
    //    }];
    //
    //    [self.chatAudioTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(weakSelf.chatbackgroundView);
    //        make.right.equalTo(weakSelf.chatbackgroundView.mas_left).offset(-5);
    //    }];
    //
    //    [self.chatAudioImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(weakSelf.chatbackgroundView);
    //        make.right.equalTo(weakSelf.chatbackgroundView).offset(-20);
    //    }];
    //
    //
    //    [self.chatStateButton mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(weakSelf.chatbackgroundView);
    //        make.right.equalTo(weakSelf.chatbackgroundView.mas_left).offset(-5);
    //    }];
    //
}

- (void)iconImageViewClick:(UITapGestureRecognizer*)tap
{
    if ([self.delegate respondsToSelector:@selector(GYHDChatView:tapType:chatModel:)]) {
        [self.delegate GYHDChatView:self tapType:GYHDChatTapUserIcon chatModel:self.chatModel];
    }
}

- (void)chatStateButtonClick:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(GYHDChatView:tapType:chatModel:)]) {
        [self.delegate GYHDChatView:self tapType:GYHDChatTapResendButton chatModel:self.chatModel];
    }
}

- (void)chatbackgroundViewtap:(UITapGestureRecognizer*)tap
{
    if ([self.delegate respondsToSelector:@selector(GYHDChatView:tapType:chatModel:)]) {
        [self.delegate GYHDChatView:self tapType:GYHDChatTapChatAudio chatModel:self.chatModel];
    }
}

- (void)chatbackgroundViewLongtap:(UILongPressGestureRecognizer*)longTap
{
    if (longTap.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuController* menu = [UIMenuController sharedMenuController];

        //        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:[GYUtils localizedStringWithKey:@"GYHD_chat_delete"] action:@selector(copyItemClicked:)];
        UIMenuItem* deleteItem = [[UIMenuItem alloc] initWithTitle:[GYUtils localizedStringWithKey:@"GYHD_chat_delete"] action:@selector(deleteItemClicked:)];
        [menu setMenuItems:[NSArray arrayWithObjects:deleteItem, nil]];
        [menu setTargetRect:self.chatbackgroundView.bounds inView:self.chatbackgroundView];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copyItemClicked:)) {
        return YES;
    }
    else if (action == @selector(deleteItemClicked:)) {
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

#pragma mark 实现成为第一响应者方法
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)deleteItemClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(GYHDChatView:longTapType:selectOption:chatMessageID:)]) {
        [self.delegate GYHDChatView:self longTapType:GYHDChatTapChatAudio selectOption:GYHDChatSelectDelete chatMessageID:self.chatModel.chatMessageID];
    }
}

- (void)copyItemClicked:(id)sender
{

    UIPasteboard* pboard = [UIPasteboard generalPasteboard];
    NSDictionary* dict = [GYUtils stringToDictionary:self.chatModel.chatBody];
    pboard.string = dict[@"msg_content"];
}

- (void)startAudioAnimation
{
    [self.chatAudioImageView startAnimating];
}

- (void)stopAudioAnimation {
    [self.chatAudioImageView stopAnimating];
}

- (BOOL)isAudioAnimation {
    return [self.chatAudioImageView isAnimating];
}

@end
