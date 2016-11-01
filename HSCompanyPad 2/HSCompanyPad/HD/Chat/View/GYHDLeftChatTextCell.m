//
//  GYHDLeftChatTextCell.m
//  HSConsumer
//
//  Created by shiang on 16/3/1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDLeftChatTextCell.h"
#import "GYHDUtils.h"

@interface GYHDLeftChatTextCell ()
/**用户头像*/
@property (nonatomic, weak) UIImageView* iconImageView;
/**接收时间*/
@property (nonatomic, weak) UILabel* chatRecvTimeLabel;
/**聊天背景*/
@property (nonatomic, weak) UIImageView* chatbackgroundView;
/**聊天文字类容*/
@property (nonatomic, weak) UILabel* chatCharacterLabel;
@end

@implementation GYHDLeftChatTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        [self setupAuto];
    }
    return self;
}

- (void)setup
{
    self.contentView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];;
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    //1. 聊天背景
    UIImageView* chatbackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_chat_left_text_bg"]];
    [self.contentView addSubview:chatbackgroundView];
    _chatbackgroundView = chatbackgroundView;
    //2. 文本聊天视图
    UILabel* chatCharacterLabel = [[UILabel alloc] init];
    chatCharacterLabel.userInteractionEnabled = YES;
    chatCharacterLabel.numberOfLines = 0;
    chatCharacterLabel.font = [UIFont systemFontOfSize:16.0f];
    chatCharacterLabel.textColor = [UIColor whiteColor];
    UILongPressGestureRecognizer* longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(chatCharacterLabelLongtap:)];
    [chatCharacterLabel addGestureRecognizer:longTap];
    [self.contentView addSubview:chatCharacterLabel];
    _chatCharacterLabel = chatCharacterLabel;
    //3 .头像
    UIImageView* iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_defaultheadimg"]];
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.cornerRadius = 3;
    iconImageView.userInteractionEnabled = YES;
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
    
    self.chatCharacterLabel.text = @" ";
//    self.chatRecvTimeLabel.attributedText = @"tttt";
    ;
    self.chatCharacterLabel.attributedText = [GYHDUtils EmojiAttributedStringFromString:@"[010][020]"];
}

- (void)setupAuto
{
    @weakify(self);

    [self.chatRecvTimeLabel mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.mas_equalTo(0);
    }];

    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.left.mas_equalTo(10);
        make.height.width.mas_equalTo(44);
        make.top.equalTo(self.chatRecvTimeLabel.mas_bottom).offset(25);
    }];

    [self.chatCharacterLabel mas_remakeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.equalTo(self.iconImageView).offset(6);
        make.left.equalTo(self.iconImageView.mas_right).offset(20);
        make.right.mas_lessThanOrEqualTo(-60);
        make.bottom.mas_equalTo(-20);
    }];

    [self.chatbackgroundView mas_remakeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.equalTo(self.chatCharacterLabel).offset(-5);
        make.left.equalTo(self.chatCharacterLabel).offset(-15);
        make.right.equalTo(self.chatCharacterLabel).offset(10);
        make.height.mas_greaterThanOrEqualTo(self.iconImageView);
        make.bottom.equalTo(self.chatCharacterLabel).offset(5);
    }];
}

- (void)setModel:(GYHDChatModel *)model {
    _model = model;
    self.chatCharacterLabel.attributedText = model.messageContentAttString;
    self.chatRecvTimeLabel.text = model.messageRecvTimeString;
    if ([model.infoModel.iconString hasPrefix:@"http"]) {
        
            [self.iconImageView setImageWithURL:[NSURL URLWithString:model.infoModel.iconString] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"]];
    }else{
    
    
        [self.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,model.infoModel.iconString]] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"]];
    }

}

-(void)setSessionModel:(GYHDSessionRecordModel *)sessionModel{
    
    _sessionModel=sessionModel;
    
    self.chatCharacterLabel.attributedText = sessionModel.messageContentAttString;
    self.chatRecvTimeLabel.text = sessionModel.sendTimeFormat;
    
    [self.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,sessionModel.senderHeadIcon]] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"]];
    
}

- (void)iconImageViewClick:(UITapGestureRecognizer*)tap
{
//    if ([self.delegate respondsToSelector:@selector(GYHDChatView:tapType:chatModel:)]) {
//        [self.delegate GYHDChatView:self tapType:GYHDChatTapUserIcon chatModel:self.model];
//    }
}

- (void)chatCharacterLabelLongtap:(UILongPressGestureRecognizer*)longTap
{
    if (longTap.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuController* menu = [UIMenuController sharedMenuController];

        UIMenuItem* copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyItemClicked:)];
//        UIMenuItem* deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteItemClicked:)];

        [menu setMenuItems:[NSArray arrayWithObjects:copyItem, nil]];
        [menu setTargetRect:self.chatCharacterLabel.bounds inView:self.chatCharacterLabel];
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
//    if ([self.delegate respondsToSelector:@selector(GYHDChatView:longTapType:selectOption:chatMessageID:)]) {
//        [self.delegate GYHDChatView:self longTapType:GYHDChatTapChatText selectOption:GYHDChatSelectDelete chatMessageID:self.chatModel.chatMessageID];
//    }
}

- (void)copyItemClicked:(id)sender
{

    UIPasteboard* pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.model.messageContentString;
}

@end
