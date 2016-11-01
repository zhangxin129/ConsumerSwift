//
//  GYHDLeftChatImageCell.m
//  HSConsumer
//
//  Created by shiang on 16/3/1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDLeftChatVideoCell.h"
#import <YYKit/UIImageView+YYWebImage.h>


@interface GYHDLeftChatVideoCell ()
/**用户头像*/
@property (nonatomic, weak) UIImageView* iconImageView;
/**接收时间*/
@property (nonatomic, weak) UILabel* chatRecvTimeLabel;
/**图片*/
@property (nonatomic, weak) UIImageView* chatPictureImageView;
@property (nonatomic, weak) UIImageView *chatBackImageView;
/**图片状态*/
@property (nonatomic, weak) UIImageView* chatVideoReadyState;
@end

@implementation GYHDLeftChatVideoCell

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

    UIImageView* chatPictureImageView = [[UIImageView alloc] init];
    UILongPressGestureRecognizer* longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(chatPictureImageViewLongTap:)];
    [chatPictureImageView addGestureRecognizer:longTap];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chatVideoViewTap:)];
    [chatPictureImageView addGestureRecognizer:tap];
    chatPictureImageView.userInteractionEnabled = YES;
    chatPictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    chatPictureImageView.clipsToBounds = YES;
    [self.contentView addSubview:chatPictureImageView];
    _chatPictureImageView = chatPictureImageView;
    
    UIImageView *chatBackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_chat_image_left_bg"]];
    [self.contentView addSubview:chatBackImageView];
    _chatBackImageView = chatBackImageView;

    UIImageView* chatVideoReadyState = [[UIImageView alloc] init];
    chatVideoReadyState.image = [UIImage imageNamed:@"gyhd_unread_tips_icon"];
    [self.contentView addSubview:chatVideoReadyState];
    _chatVideoReadyState = chatVideoReadyState;

    [self.chatPictureImageView setImageWithURL:[NSURL URLWithString:@"https://gss0.bdstatic.com/5eR1dDebRNRTm2_p8IuM_a/res/r/image/2016-08-08/b9283b48bb8c4a914cd7a4d5a6daff9d.jpg"] options:kNilOptions];
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
    [self.chatPictureImageView mas_remakeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).offset(5);
        make.width.mas_equalTo(170);
        make.height.mas_equalTo(120);
        make.bottom.mas_equalTo(-20);
    }];
    [self.chatBackImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.bottom.right.equalTo(self.chatPictureImageView);
    }];

    [self.chatVideoReadyState mas_remakeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.size.mas_equalTo(CGSizeMake(5, 5));
        make.top.equalTo(self.chatPictureImageView);
        make.left.equalTo(self.chatPictureImageView.mas_right);
    }];
}


- (void)setModel:(GYHDChatModel *)model {
    _model = model;
    self.chatRecvTimeLabel.text = model.messageRecvTimeString;
    if ([model.infoModel.iconString hasPrefix:@"http"]) {
        
        [self.iconImageView setImageWithURL:[NSURL URLWithString:model.infoModel.iconString] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"]];
    }else{
        
        
        [self.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,model.infoModel.iconString]] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"]];
    }
    [self.chatPictureImageView setImageWithURL:[NSURL URLWithString:[[GYHDMessageCenter sharedInstance]appendAuthenticationStr:model.messageNetWorkBasePath]] placeholder:[UIImage imageNamed:@"gyhs_bigDefaultImage"]];
    if (model.fileRead.intValue) {
        self.chatVideoReadyState.hidden = YES;
    }else {
        self.chatVideoReadyState.hidden = NO;
    }

}

-(void)setSessionModel:(GYHDSessionRecordModel *)sessionModel{
    
    _sessionModel=sessionModel;
    
    self.chatRecvTimeLabel.text = sessionModel.sendTimeFormat;
    
    [self.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,sessionModel.senderHeadIcon]] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"]];
    
   [self.chatPictureImageView setImageWithURL:[NSURL URLWithString:[[GYHDMessageCenter sharedInstance]appendAuthenticationStr:sessionModel.messageNetWorkBasePath]] placeholder:[UIImage imageNamed:@"gyhs_bigDefaultImage"]];
    
    self.chatVideoReadyState.hidden = YES;
    
}

- (void)iconImageViewClick:(UITapGestureRecognizer*)tap
{
//    if ([self.delegate respondsToSelector:@selector(GYHDChatView:tapType:chatModel:)]) {
//        [self.delegate GYHDChatView:self tapType:GYHDChatTapUserIcon chatModel:self.chatModel];
//    }
}

- (void)chatVideoViewTap:(UITapGestureRecognizer*)longTap
{
    self.chatVideoReadyState.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(GYHDChatView:tapType:chatModel:)]) {
        [self.delegate GYHDChatView:self tapType:GYHDChatTapChatVideo chatModel:self.model];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(GYHDChatView:tapType:sessionModel:)]) {
        
        [self.delegate GYHDChatView:self tapType:GYHDChatTapChatVideo sessionModel:self.sessionModel];
    }
}

- (void)chatPictureImageViewLongTap:(UILongPressGestureRecognizer*)longTap
{
//    if (longTap.state == UIGestureRecognizerStateBegan) {
//        [self becomeFirstResponder];
//        UIMenuController* menu = [UIMenuController sharedMenuController];
//
//        //        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:[GYUtils localizedStringWithKey:@"HD_chat_copy"] action:@selector(copyItemClicked:)];
//        UIMenuItem* deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteItemClicked:)];
//        [menu setMenuItems:[NSArray arrayWithObjects:deleteItem, nil]];
//        [menu setTargetRect:self.chatPictureImageView.bounds inView:self.chatPictureImageView];
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
//        [self.delegate GYHDChatView:self longTapType:GYHDChatTapChatVideo selectOption:GYHDChatSelectDelete chatMessageID:self.chatModel.chatMessageID];
//    }
}

- (void)copyItemClicked:(id)sender
{

//    UIPasteboard* pboard = [UIPasteboard generalPasteboard];
//    NSDictionary* dict = [GYUtils stringToDictionary:self.chatModel.chatBody];
//    pboard.string = dict[@"msg_content"];

}

@end
