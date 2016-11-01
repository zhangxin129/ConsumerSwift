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

#import "GYHDLeftChatImageCell.h"
#import "GYHDMessageCenter.h"
#import "GYHDNewChatModel.h"

@interface GYHDLeftChatImageCell ()
/**用户头像*/
@property (nonatomic, weak) UIImageView* iconImageView;
/**接收时间*/
@property (nonatomic, weak) UILabel* chatRecvTimeLabel;
/**图片*/
@property (nonatomic, weak) UIImageView* chatPictureImageView;
@end

@implementation GYHDLeftChatImageCell

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
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chatPictureImageViewTap:)];
    [chatPictureImageView addGestureRecognizer:tap];
    chatPictureImageView.userInteractionEnabled = YES;
    chatPictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    chatPictureImageView.clipsToBounds = YES;
    [self.contentView addSubview:chatPictureImageView];
    _chatPictureImageView = chatPictureImageView;
}

- (void)setChatModel:(GYHDNewChatModel*)chatModel
{
    _chatModel = chatModel;
    self.chatRecvTimeLabel.text = chatModel.chatRecvTime;
    NSDictionary* bodyDict = [GYUtils stringToDictionary:chatModel.chatBody];
    NSURL* url = [NSURL URLWithString:chatModel.chatIcon];
    [self.iconImageView setImageWithURL:url placeholder:kLoadPng(@"gyhd_defaultheadimg") options:kNilOptions completion:nil];
    UIImage* image = [UIImage imageNamed:@"gyhd_chat_other_back"];
    UIImageView* ImageView = [[UIImageView alloc] init];
    ImageView.frame = CGRectMake(0, 0, 120, 120);
    [ImageView setImage:[image stretchableImageWithLeftCapWidth:17 topCapHeight:17]];

    [self.chatPictureImageView setImageWithURL:[NSURL URLWithString:bodyDict[@"msg_imageNailsUrl"]] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:^(UIImage* _Nullable image, NSURL* _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError* _Nullable error) {
 
//        if (!image) {
//            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:self.chatModel.chatDataString options:0];
//            image = [UIImage imageWithData:imageData];
//            self.chatPictureImageView.image = image;
//        }
        CALayer *layer = ImageView.layer;
        layer.frame = (CGRect){{0, 0}, ImageView.layer.frame.size};
        self.chatPictureImageView.layer.mask = layer;
    }];
}

- (void)setupAuto
{
    WS(weakSelf);

    [self.chatRecvTimeLabel mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.mas_equalTo(0);
    }];

    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(10);
        make.height.width.mas_equalTo(44);
        make.top.equalTo(weakSelf.chatRecvTimeLabel.mas_bottom).offset(25);
    }];
    [self.chatPictureImageView mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(weakSelf.iconImageView);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(5);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(120);
        make.bottom.mas_equalTo(-20);
    }];
}

- (void)iconImageViewClick:(UITapGestureRecognizer*)tap
{
    if ([self.delegate respondsToSelector:@selector(GYHDChatView:tapType:chatModel:)]) {
        [self.delegate GYHDChatView:self tapType:GYHDChatTapUserIcon chatModel:self.chatModel];
    }
}

- (void)chatPictureImageViewTap:(UITapGestureRecognizer*)longTap
{
    if ([self.delegate respondsToSelector:@selector(GYHDChatView:tapType:chatModel:)]) {
        [self.delegate GYHDChatView:self tapType:GYHDChatTapChatImage chatModel:self.chatModel];
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
        [self.delegate GYHDChatView:self longTapType:GYHDChatTapChatImage selectOption:GYHDChatSelectDelete chatMessageID:self.chatModel.chatMessageID];
    }
}

- (void)copyItemClicked:(id)sender
{

    UIPasteboard* pboard = [UIPasteboard generalPasteboard];
    NSDictionary* dict = [GYUtils stringToDictionary:self.chatModel.chatBody];
    pboard.string = dict[@"msg_content"];

}

@end
