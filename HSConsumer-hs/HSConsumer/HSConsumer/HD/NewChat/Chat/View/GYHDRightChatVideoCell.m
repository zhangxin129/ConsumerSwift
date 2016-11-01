//
//  GYHDRightChatImageCell.m
//  HSConsumer
//
//  Created by shiang on 16/3/1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDRightChatVideoCell.h"
#import "GYHDMessageCenter.h"
#import "GYHDNewChatModel.h"

@interface GYHDRightChatVideoCell ()
/**用户头像*/
@property (nonatomic, weak) UIImageView* iconImageView;
/**接收时间*/
@property (nonatomic, weak) UILabel* chatRecvTimeLabel;
/**图片*/
@property (nonatomic, weak) UIImageView* chatPictureImageView;
/**发送状态*/
@property (nonatomic, weak) UIButton* chatStateButton;
@end

@implementation GYHDRightChatVideoCell

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
    self.contentView.backgroundColor = [UIColor colorWithRed:245 / 255.0f green:245 / 255.0f blue:245 / 255.0f alpha:1];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
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
}

- (void)setChatModel:(GYHDNewChatModel*)chatModel
{
    _chatModel = chatModel;
    self.chatRecvTimeLabel.text = chatModel.chatRecvTime;
    NSDictionary* bodyDict = [GYUtils stringToDictionary:chatModel.chatBody];
    NSURL* url = [NSURL URLWithString:chatModel.chatIcon];
    [self.iconImageView setImageWithURL:url placeholder:kLoadPng(@"gyhd_defaultheadimg") options:kNilOptions completion:nil];
    UIImage* image = [UIImage imageNamed:@"gyhd_chat_self_back"];
    UIImageView* ImageView = [[UIImageView alloc] init];
    ImageView.frame = CGRectMake(0, 0, 170, 120);
    [ImageView setImage:[image stretchableImageWithLeftCapWidth:17 topCapHeight:17]];

    NSDictionary* videoDict = [GYUtils stringToDictionary:self.chatModel.chatDataString];

    NSString* thumbnailsImageNamePath = [NSString pathWithComponents:@[ [[GYHDMessageCenter sharedInstance] imagefolderNameString], videoDict[@"thumbnailsName"] ]];
    image = [UIImage imageWithContentsOfFile:thumbnailsImageNamePath];
    if (image) {
        self.chatPictureImageView.image = image;
        CALayer* layer = ImageView.layer;
        layer.frame = (CGRect){ { 0, 0 }, ImageView.layer.frame.size };
        self.chatPictureImageView.layer.mask = layer;
    }
    else {
        NSString *urlString =  [[GYHDMessageCenter sharedInstance] AdditionCheckWithUrlString:bodyDict[@"msg_imageNail"]];
        [self.chatPictureImageView setImageWithURL:[NSURL URLWithString:urlString] placeholder:nil options:kNilOptions completion:^(UIImage* _Nullable image, NSURL* _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError* _Nullable error) {
  
            CALayer *layer = ImageView.layer;
            layer.frame = (CGRect){{0, 0}, ImageView.layer.frame.size};
            self.chatPictureImageView.layer.mask = layer;
        }];
    }
    switch (chatModel.chatSendState) {

    case GYHDDataBaseCenterMessageSendStateSuccess: // 发送成功
        [self.chatStateButton.imageView stopAnimating];
        self.chatStateButton.hidden = YES;

        break;
    case GYHDDataBaseCenterMessageSendStateSending:
        self.chatStateButton.hidden = NO;
        [self.chatStateButton.imageView startAnimating];
        break;
    case GYHDDataBaseCenterMessageSendStateFailure:
        self.chatStateButton.hidden = NO;
        [self.chatStateButton.imageView stopAnimating];
        break;
    default:
        break;
    }
}

- (void)setupAuto
{
    WS(weakSelf);

    [self.chatRecvTimeLabel mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.mas_equalTo(0);
    }];

    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.right.mas_equalTo(-10);
        make.height.width.mas_equalTo(44);
        make.top.equalTo(weakSelf.chatRecvTimeLabel.mas_bottom).offset(25);
    }];
    [self.chatPictureImageView mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(weakSelf.iconImageView);
        make.right.equalTo(weakSelf.iconImageView.mas_left).offset(-5);
        make.width.mas_equalTo(170);
        make.height.mas_equalTo(120);
        make.bottom.mas_equalTo(-20);
    }];
    [self.chatStateButton mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(weakSelf.chatPictureImageView);
        make.right.equalTo(weakSelf.chatPictureImageView.mas_left).offset(-10);
    }];
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

- (void)chatVideoViewTap:(UITapGestureRecognizer*)longTap
{
    if ([self.delegate respondsToSelector:@selector(GYHDChatView:tapType:chatModel:)]) {
        [self.delegate GYHDChatView:self tapType:GYHDChatTapChatVideo chatModel:self.chatModel];
    }
}

- (void)chatPictureImageViewLongTap:(UILongPressGestureRecognizer*)longTap
{
    if (longTap.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuController* menu = [UIMenuController sharedMenuController];

        //        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:[GYUtils localizedStringWithKey:@"GYHD_chat_delete"] action:@selector(copyItemClicked:)];
        UIMenuItem* deleteItem = [[UIMenuItem alloc] initWithTitle:[GYUtils localizedStringWithKey:@"GYHD_chat_delete"] action:@selector(deleteItemClicked:)];
        [menu setMenuItems:[NSArray arrayWithObjects:deleteItem, nil]];
        [menu setTargetRect:self.chatPictureImageView.bounds inView:self.chatPictureImageView];
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
        [self.delegate GYHDChatView:self longTapType:GYHDChatTapChatVideo selectOption:GYHDChatSelectDelete chatMessageID:self.chatModel.chatMessageID];
    }
}

- (void)copyItemClicked:(id)sender
{

    UIPasteboard* pboard = [UIPasteboard generalPasteboard];
    NSDictionary *dict = [GYUtils stringToDictionary:self.chatModel.chatBody];
    pboard.string = dict[@"msg_content"];

}

@end
