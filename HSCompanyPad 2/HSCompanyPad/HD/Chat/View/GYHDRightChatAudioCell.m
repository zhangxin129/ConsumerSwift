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
@property (nonatomic, strong)UILabel * customerServiceLabel;//客服labael
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
    self.contentView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
//   客服显示
    
    self.customerServiceLabel=[[UILabel alloc]init];
    
    self.customerServiceLabel.font=[UIFont systemFontOfSize:12.0];
    
    self.customerServiceLabel.textAlignment=NSTextAlignmentRight;
    
    self.customerServiceLabel.backgroundColor=[UIColor clearColor];
    
    [self.contentView addSubview:self.customerServiceLabel];
    
    
    //1. 聊天背景
    UIImageView* chatbackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_chat_right_text_bg"]];
    chatbackgroundView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer* longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(chatbackgroundViewLongtap:)];
    [chatbackgroundView addGestureRecognizer:longTap];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chatbackgroundViewtap:)];
    [chatbackgroundView addGestureRecognizer:tap];

    
    [self.contentView addSubview:chatbackgroundView];
    _chatbackgroundView = chatbackgroundView;
    
    
    //3 .头像
    UIImageView* iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_defaultheadimg"]];
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
    recvTimeLabel.font = [UIFont systemFontOfSize:14.0f];
    recvTimeLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.contentView addSubview:recvTimeLabel];
    _chatRecvTimeLabel = recvTimeLabel;

    //2.2 音频展示View
    NSMutableArray* audioImageArray = [NSMutableArray array];
    for (int i = 1; i <= 3; i++) {
        [audioImageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"gyhd_audio_right_bg_%d", i]]];
    }
    UIImageView* chatAudioImageView = [[UIImageView alloc] init];
    chatAudioImageView.image = [UIImage imageNamed:@"gyhd_audio_right_bg_3"];
    chatAudioImageView.contentMode = UIViewContentModeCenter;
    chatAudioImageView.animationDuration = 0.6;
    chatAudioImageView.animationImages = audioImageArray;
    [self.contentView addSubview:chatAudioImageView];
    _chatAudioImageView = chatAudioImageView;
    /**音频时长*/
    UILabel* chatAudioTimeLabel = [[UILabel alloc] init];
    chatAudioTimeLabel.textColor = [UIColor grayColor];
    chatAudioTimeLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:chatAudioTimeLabel];
    _chatAudioTimeLabel = chatAudioTimeLabel;

    //3. 消息状态
    UIButton* chatStateButton = [[UIButton alloc] init];
    [chatStateButton addTarget:self action:@selector(chatStateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    chatStateButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    chatStateButton.imageView.animationDuration = 1.4f;

    NSMutableArray* imageArray = [NSMutableArray array];
    for (int i = 1; i < 6; i++) {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"gyhd_loading_icon_%d", i]];
        [imageArray addObject:image];
    }
    chatStateButton.imageView.animationImages = imageArray;
    [chatStateButton setImage:[UIImage imageNamed:@"gyhd_chat_failue_btn_normal"] forState:UIControlStateNormal];
//    [chatStateButton setImage:[UIImage imageNamed:@"gyhd_chat_failue_btn_select"] forState:UIControlStateSelected];
    [self.contentView addSubview:chatStateButton];
    _chatStateButton = chatStateButton;

    @weakify(self);
    [self.chatRecvTimeLabel mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.mas_equalTo(0);
    }];

    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.right.mas_equalTo(-10);
        make.height.width.mas_equalTo(44);
        make.top.equalTo(self.chatRecvTimeLabel.mas_bottom).offset(25);
    }];

    [self.customerServiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.iconImageView).offset(0);
        make.right.equalTo(self.iconImageView.mas_left).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    
    [self.chatbackgroundView mas_remakeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.equalTo(self.customerServiceLabel.mas_bottom).offset(6);
        make.right.equalTo(self.iconImageView.mas_left).offset(-5);
        make.height.equalTo(self.iconImageView);
        make.width.mas_equalTo(200);
        make.bottom.mas_equalTo(-20);

    }];



    [self.chatAudioImageView mas_remakeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.centerY.equalTo(self.chatbackgroundView);
        make.right.equalTo(self.chatbackgroundView).offset(-20);
    }];
    
    [self.chatAudioTimeLabel mas_remakeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.centerY.equalTo(self.chatAudioImageView);
        make.right.equalTo(self.chatAudioImageView.mas_left).offset(-10);
    }];

    [self.chatStateButton mas_remakeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.centerY.equalTo(self.chatbackgroundView);
        make.right.equalTo(self.chatbackgroundView.mas_left).offset(-10);
    }];
    
    self.chatRecvTimeLabel.text = @"1tttttt";
    self.chatAudioTimeLabel.text = @"30\"";
}
- (void)setModel:(GYHDChatModel *)model {
    _model = model;
    
    [self.customerServiceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.iconImageView).offset(0);
        make.right.equalTo(self.iconImageView.mas_left).offset(-10);
        make.height.mas_equalTo(0);
    }];
    
    self.chatRecvTimeLabel.text = model.messageRecvTimeString;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:model.infoModel.iconString] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"]];
    self.chatAudioTimeLabel.text = [NSString stringWithFormat:@"%@\"",model.messageFileBasePath];
    NSInteger  w = 100 +(model.messageFileBasePath.integerValue * 10);
    [self.chatbackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(w);
    }];
    if (model.messageSendState == GYHDDataBaseCenterMessageSendStateSending) {
        self.chatStateButton.hidden = NO;
        [self.chatStateButton.imageView startAnimating];
    }else if (model.messageSendState == GYHDDataBaseCenterMessageSendStateFailure) {
        [self.chatStateButton.imageView stopAnimating];
        self.chatStateButton.hidden = NO;
    }else if (model.messageSendState == GYHDDataBaseCenterMessageSendStateSuccess) {
        [self.chatStateButton.imageView stopAnimating];
        self.chatStateButton.hidden = YES;
    }
}
- (void)setSessionModel:(GYHDSessionRecordModel *)sessionModel {
    _sessionModel = sessionModel;
     self.customerServiceLabel.text=[NSString stringWithFormat:@"%@(%@)",sessionModel.senderNickName,sessionModel.csOperNo];
    self.chatRecvTimeLabel.text = sessionModel.sendTimeFormat;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,sessionModel.senderHeadIcon]] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"]];
    self.chatAudioTimeLabel.text = [NSString stringWithFormat:@"%@\"",sessionModel.messageFileBasePath];
    NSInteger  w = 100 +(sessionModel.messageFileBasePath.integerValue * 10);
    [self.chatbackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(w);
    }];
    
    self.chatStateButton.hidden = YES;
}


- (void)iconImageViewClick:(UITapGestureRecognizer*)tap
{
//    if ([self.delegate respondsToSelector:@selector(GYHDChatView:tapType:chatModel:)]) {
//        [self.delegate GYHDChatView:self tapType:GYHDChatTapUserIcon chatModel:self.chatModel];
//    }
}

- (void)chatStateButtonClick:(UIButton*)button
{
    [self.chatStateButton.imageView startAnimating];
    
    if ([self.delegate respondsToSelector:@selector(GYHDChatView:tapType:chatModel:)]) {
        [self.delegate GYHDChatView:self tapType:GYHDChatTapResendButton chatModel:self.model];
    }
    
    
}

- (void)chatbackgroundViewtap:(UITapGestureRecognizer*)tap
{
    if ([self.delegate respondsToSelector:@selector(GYHDChatView:tapType:chatModel:)]) {
        [self.delegate GYHDChatView:self tapType:GYHDChatTapChatAudio chatModel:self.model];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(GYHDChatView:tapType:sessionModel:)]) {
        
        [self.delegate GYHDChatView:self tapType:GYHDChatTapChatAudio sessionModel:self.sessionModel];
    }
}

- (void)chatbackgroundViewLongtap:(UILongPressGestureRecognizer*)longTap
{
//    if (longTap.state == UIGestureRecognizerStateBegan) {
//        [self becomeFirstResponder];
//        UIMenuController* menu = [UIMenuController sharedMenuController];
//
//        //        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:[GYUtils localizedStringWithKey:@"HD_chat_copy"] action:@selector(copyItemClicked:)];
//        UIMenuItem* deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteItemClicked:)];
//        [menu setMenuItems:[NSArray arrayWithObjects:deleteItem, nil]];
//        [menu setTargetRect:self.chatbackgroundView.bounds inView:self.chatbackgroundView];
//        [menu setMenuVisible:YES animated:YES];
//    }
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
//    if ([self.delegate respondsToSelector:@selector(GYHDChatView:longTapType:selectOption:chatMessageID:)]) {
//        [self.delegate GYHDChatView:self longTapType:GYHDChatTapChatAudio selectOption:GYHDChatSelectDelete chatMessageID:self.chatModel.chatMessageID];
//    }
}

- (void)copyItemClicked:(id)sender
{

//    UIPasteboard* pboard = [UIPasteboard generalPasteboard];
//    NSDictionary* dict = [GYUtils stringToDictionary:self.chatModel.chatBody];
//    pboard.string = dict[@"msg_content"];
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
