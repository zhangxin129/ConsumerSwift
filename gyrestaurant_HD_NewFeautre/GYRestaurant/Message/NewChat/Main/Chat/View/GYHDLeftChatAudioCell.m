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

#import "GYHDLeftChatAudioCell.h"
#import "GYHDDataBaseCenter.h"
#import "GYHDNewChatModel.h"

@interface GYHDLeftChatAudioCell ()
/**用户头像*/
@property(nonatomic, weak)UIImageView *iconImageView;
/**接收时间*/
@property(nonatomic, weak)UILabel *chatRecvTimeLabel;
/**音频类容图片*/
@property(nonatomic, weak)UIImageView *chatAudioImageView;
/**音频时长*/
@property(nonatomic, weak)UILabel *chatAudioTimeLabel;
/**音频背景*/
@property(nonatomic, weak) UIImageView *chatbackgroundView;
/**音频读取状态*/
@property(nonatomic, weak) UIImageView *chatAudioReadyState;
@end

@implementation GYHDLeftChatAudioCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        
    }
    return self;
}
- (void)setup
{
    self.contentView.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
      [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    //1. 聊天背景
    UIImageView *chatbackgroundView = [[UIImageView alloc] init];
    chatbackgroundView.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(chatbackgroundViewLongtap:)];
    [chatbackgroundView addGestureRecognizer:longTap];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chatbackgroundViewtap:)];
    [chatbackgroundView addGestureRecognizer:tap];
    chatbackgroundView.image = [UIImage imageNamed:@"hd_chat_other_back"];
    [self.contentView addSubview:chatbackgroundView];
    _chatbackgroundView = chatbackgroundView;
    //3 .头像
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage imageNamed:@"defaultheadimg"];
    iconImageView.userInteractionEnabled = YES;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.cornerRadius = 3;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageViewClick:)];
    [iconImageView addGestureRecognizer:tapGR];
    [self.contentView addSubview:iconImageView];
    _iconImageView = iconImageView;
    
    //4. 发送时间
    UILabel *recvTimeLabel = [[UILabel alloc] init];
    recvTimeLabel.textAlignment =  NSTextAlignmentCenter;
    recvTimeLabel.font = [UIFont systemFontOfSize:KFontSizePX(22)];
    recvTimeLabel.textColor = [UIColor colorWithRed:153.0/255.0f green:153.0/255.0f blue:153.0/255.0f alpha:1];
    [self.contentView addSubview:recvTimeLabel];
    _chatRecvTimeLabel = recvTimeLabel;
    
    //2.2 音频展示View
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 1; i <= 3; i++) {
        [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"hd_audio_left_%d",i]]];
    }
    UIImageView *chatAudioImageView = [[UIImageView alloc] init];
    chatAudioImageView.image = [UIImage imageNamed:@"hd_audio_left_3"];
    chatAudioImageView.contentMode = UIViewContentModeCenter;
    chatAudioImageView.animationDuration = 0.6;
    chatAudioImageView.animationImages = imageArray;
    [self.contentView addSubview:chatAudioImageView];
    _chatAudioImageView = chatAudioImageView;
    /**音频时长*/
    UILabel *chatAudioTimeLabel = [[UILabel alloc] init];
    chatAudioTimeLabel.textColor = [UIColor grayColor];
    chatAudioTimeLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    [self.contentView addSubview:chatAudioTimeLabel];
    _chatAudioTimeLabel = chatAudioTimeLabel;

    UIImageView *chatAudioReadyState = [[UIImageView alloc] init];
    chatAudioReadyState.image = [UIImage imageNamed:@"red_point"];
    [self.contentView addSubview:chatAudioReadyState];
    _chatAudioReadyState = chatAudioReadyState;
    WS(weakSelf);
    [self.chatRecvTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.height.width.mas_equalTo(44);
        make.top.equalTo(weakSelf.chatRecvTimeLabel.mas_bottom).offset(25);
    }];
    
    [self.chatbackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(5);
        make.height.equalTo(weakSelf.iconImageView);
        make.width.mas_equalTo(10);
        make.bottom.mas_equalTo(-20);
        
    }];
    
    [self.chatAudioTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.chatbackgroundView);
        make.left.equalTo(weakSelf.chatbackgroundView.mas_right).offset(5);
    }];
    
    [self.chatAudioImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.chatbackgroundView);
        make.left.equalTo(weakSelf.chatbackgroundView).offset(20);
    }];
    [self.chatAudioReadyState mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(5, 5));
        make.top.equalTo(weakSelf.chatbackgroundView);
        make.left.equalTo(weakSelf.chatbackgroundView.mas_right);
    }];
}

- (void)setChatModel:(GYHDNewChatModel *)chatModel
{
    _chatModel = chatModel;
    self.chatRecvTimeLabel.text = chatModel.chatRecvTime;
    
    NSDictionary *dict = [Utils stringToDictionary:chatModel.chatBody];
    NSDictionary*basicDic=[[GYHDMessageCenter sharedInstance] selectFriendBaseWithCardString:chatModel.chatCard];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,basicDic[@"Friend_Icon"]]];
//    NSURL *url = [NSURL URLWithString:dict[@"msg_icon"]];
    [self.iconImageView setImageWithURL:url placeholder:[UIImage imageNamed:@"defaultheadimg"] options:kNilOptions completion:nil];
    
    self.chatAudioTimeLabel.text = [NSString stringWithFormat:@"%@\"",dict[@"msg_fileSize"]];
    CGFloat audioW = 40 +  [dict[@"msg_fileSize"] integerValue] * 5;
    
    [self.chatbackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(audioW);
    }];
    
      NSDictionary *saveDict = [Utils stringToDictionary:chatModel.chatDataString];
    if ([saveDict[@"read"] integerValue]) {
        self.chatAudioReadyState.hidden = YES;
    } else {
        self.chatAudioReadyState.hidden = NO;

    }
}

- (void)iconImageViewClick:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(GYHDChatView:tapType:chatModel:)]) {
        [self.delegate GYHDChatView:self tapType:GYHDChatTapUserIcon chatModel:self.chatModel];
    }
}

- (void)chatbackgroundViewtap:(UITapGestureRecognizer *)tap
{
    self.chatAudioReadyState.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(GYHDChatView:tapType:chatModel:)]) {
        [self.delegate GYHDChatView:self tapType:GYHDChatTapChatAudio chatModel:self.chatModel];
    }
}
- (void)chatbackgroundViewLongtap:(UILongPressGestureRecognizer *)longTap
{
//    if (longTap.state==UIGestureRecognizerStateBegan) {
//        [self becomeFirstResponder];
//        UIMenuController *menu=[UIMenuController sharedMenuController];
//
//        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:[Utils localizedStringWithKey:@"删除"] action:@selector(deleteItemClicked:)];
//        [menu setMenuItems:[NSArray arrayWithObjects:deleteItem,nil]];
//        [menu setTargetRect:self.chatbackgroundView.bounds inView:self.chatbackgroundView];
//        [menu setMenuVisible:YES animated:YES];
//    }
//    
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if(action ==@selector(copyItemClicked:)){
        return YES;
    }else if (action==@selector(deleteItemClicked:)){
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}
#pragma mark  实现成为第一响应者方法
-(BOOL)canBecomeFirstResponder{
    return YES;
}
-(void)deleteItemClicked:(id)sender{
    if ([self.delegate respondsToSelector:@selector(GYHDChatView:longTapType:selectOption:chatMessageID:)]) {
        [self.delegate GYHDChatView:self longTapType:GYHDChatTapChatAudio selectOption:GYHDChatSelectDelete chatMessageID:self.chatModel.chatMessageID];
    }
}
-(void)copyItemClicked:(id)sender{
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    NSDictionary *dict = [Utils stringToDictionary:self.chatModel.chatBody];
    pboard.string = dict[@"msg_content"];
    
}


- (void)startAudioAnimation
{

    [self.chatAudioImageView startAnimating];
}
- (void)stopAudioAnimation
{
    [self.chatAudioImageView stopAnimating];
}
- (BOOL)isAudioAnimation
{
    return  [self.chatAudioImageView isAnimating];
}
@end
