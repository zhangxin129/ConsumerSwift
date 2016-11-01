//
//  GYHDMessageModel.m
//  HSConsumer
//
//  Created by shiang on 15/12/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  这这里设置好要跳转的控制器

#import "GYHDMessageModel.h"
#import "GYHDChatViewController.h"
#import "GYHDMessageListViewController.h"
#import "GYHDApplicantListViewController.h"

@interface GYHDMessageModel ()

@property (nonatomic, strong, readwrite) NSMutableAttributedString* messageContentAttributedString;
@property (nonatomic, assign, readwrite) GYHDPopMessageState messageState;
@property (nonatomic, strong, readwrite) UIColor* userNameColoer;
@property (nonatomic, copy, readwrite) NSString* unreadMessageCountStr;
@property (nonatomic, copy, readwrite) NSString* messageCard;
@property (nonatomic, copy, readwrite) NSString* messageContentStr;
@property (nonatomic, copy, readwrite) NSString* messageTimeStr;
@property (nonatomic, copy, readwrite) NSString* userNameStr;
@property (nonatomic, strong, readwrite) NSURL* userIconUrl;
@property (nonatomic, assign, readwrite) Class pushNextController;
@property (nonatomic, assign, readwrite) CGFloat cellHeight;
@property (nonatomic, copy) NSString* messageBody;
@property (nonatomic, assign, readwrite) NSInteger messageCode;
@end

@implementation GYHDMessageModel
+ (instancetype)messageModelWithDictionary:(NSDictionary*)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary*)dict
{

    self = [super init];
    if (!self)
        return self;
    _messgeTopString = dict[GYHDDataBaseCenterUserSetingMessageTop];
    // 只能在此地方写sql
    NSString* str = [NSString stringWithFormat:@"%@", dict[GYHDDataBaseCenterUserSetingMessageTop]];
    if (str.length > 7) {
        self.messageState = GYHDPopMessageStateClearTop;
    }
    else {
        self.messageState = GYHDPopMessageStateTop;
    }

    
    if (dict[GYHDDataBaseCenterPushMessagePlantFromID]) {

        [self setupPushWithDictionary:dict];
    }
    else {

        [self setupChatWithDictionary:dict];
    }
    return self;
}

- (void)setupPushWithDictionary:(NSDictionary*)dict
{


    _messageCode = [dict[GYHDDataBaseCenterPushMessageCode] integerValue];
    _messageContentStr = dict[GYHDDataBaseCenterPushMessageContent];
    if (_messageCode == GYHDProtobufMessage01001 || _messageCode == GYHDProtobufMessage01002 || _messageCode == GYHDProtobufMessage01006 || _messageCode == GYHDProtobufMessage01007 || _messageCode == GYHDProtobufMessage01008 || _messageCode == GYHDProtobufMessage01009 || _messageCode == GYHDProtobufMessage01010) {
        self.userNameStr = @"互生消息";
        self.userIconUrl = [NSURL fileURLWithPath:[self imageFilePathWithImageName:@"gyhd_huSheng_message_icon"]];
        self.pushNextController = [GYHDMessageListViewController class];
//        if (_messageCode == GYHDProtobufMessage01001 || _messageCode == GYHDProtobufMessage01002) {
//            NSDictionary* dict = [GYUtils stringToDictionary:_messageContentStr];
//            _messageContentStr = dict[@"summary"];
//        }
//        else
            if (_messageCode == GYHDProtobufMessage01009) {
            NSDictionary* dict = [GYUtils stringToDictionary:_messageContentStr];
            _messageContentStr = [NSString stringWithFormat:[GYUtils localizedStringWithKey:@"GYHD_Company_Binding_husheng_tips"], dict[@"resNo"], dict[@"name"]];
        }
    }
    else if (_messageCode == GYHDProtobufMessage02001 || _messageCode == GYHDProtobufMessage02002 || _messageCode == GYHDProtobufMessage02003 || _messageCode == GYHDProtobufMessage02004 || _messageCode == GYHDProtobufMessage02005 || _messageCode == GYHDProtobufMessage02006 || _messageCode == GYHDProtobufMessage02007 || _messageCode == GYHDProtobufMessage02008 || _messageCode == GYHDProtobufMessage02021 || _messageCode == GYHDProtobufMessage02022 || _messageCode == GYHDProtobufMessage02023 || _messageCode == GYHDProtobufMessage02024 || _messageCode == GYHDProtobufMessage02025 || _messageCode == GYHDProtobufMessage02026 || _messageCode == GYHDProtobufMessage02027 || _messageCode == GYHDProtobufMessage02028 || _messageCode == GYHDProtobufMessage02029) {
        self.userNameStr = @"订单消息";
        self.userIconUrl = [NSURL fileURLWithPath:[self imageFilePathWithImageName:@"gyhd_order_message_icon"]];
        self.pushNextController = [GYHDMessageListViewController class];
    }
    else if (_messageCode == GYHDProtobufMessage02901 || _messageCode == GYHDProtobufMessage02902 || _messageCode == GYHDProtobufMessage02903 || _messageCode == GYHDProtobufMessage02904) {
        self.userNameStr = @"订阅消息";
        self.userIconUrl = [NSURL fileURLWithPath:[self imageFilePathWithImageName:@"gyhd_order_message_icon"]];
    }
    else if (_messageCode == GYHDProtobufMessage04101 || _messageCode == GYHDProtobufMessage04102 || _messageCode == GYHDProtobufMessage04104) {
        self.userNameStr = [GYUtils localizedStringWithKey:@"GYHD_Friend_application_friend"];
        self.userIconUrl = [NSURL fileURLWithPath:[self imageFilePathWithImageName:@"gyhd_add_friend_icon"]];
        self.pushNextController = [GYHDApplicantListViewController class];
    }
    _messageTimeStr = [[GYHDMessageCenter sharedInstance] messageTimeStrFromTimerString:dict[GYHDDataBaseCenterPushMessageSendTime]];
    _messageCard = [dict[GYHDDataBaseCenterPushMessageCode] stringValue];
    _unreadMessageCountStr = [[GYHDMessageCenter sharedInstance] UnreadMessageCountWithCard:_messageCard];
    if (![self.messageContentStr isEqualToString:@""] && self.messageContentStr != nil) {
        NSMutableAttributedString* att = [[NSMutableAttributedString alloc] initWithString:_messageContentStr];
        _messageContentAttributedString = att;
        [[GYHDMessageCenter sharedInstance] messageContentAttributedStringWithString:_messageContentStr AttrString:att];
    }
}

- (void)setupChatWithDictionary:(NSDictionary*)dict
{
    _messageBody = dict[GYHDDataBaseCenterMessageBody];
    _messageTimeStr = [[GYHDMessageCenter sharedInstance] messageTimeStrFromTimerString:dict[GYHDDataBaseCenterMessageSendTime]];
    _messageCard = dict[GYHDDataBaseCenterMessageCard];

    _unreadMessageCountStr = [[GYHDMessageCenter sharedInstance] UnreadMessageCountWithCard:_messageCard];
    //1. 设置属性的内容
    self.messageContentStr = dict[GYHDDataBaseCenterMessageContent];
    NSMutableDictionary* condDict = [NSMutableDictionary dictionary];
    condDict[GYHDDataBaseCenterFriendMessageType] = GYHDDataBaseCenterFocusOnBusiness;
    NSString* card = dict[GYHDDataBaseCenterMessageCard];
    condDict[GYHDDataBaseCenterFriendCustID] = [card substringToIndex:11];
    NSDictionary* reDict = [[[GYHDMessageCenter sharedInstance] selectInfoWithDict:condDict TableName:GYHDDataBaseCenterFriendTableName] lastObject];

    NSMutableDictionary* temporarycondDict = [NSMutableDictionary dictionary];
    temporarycondDict[GYHDDataBaseCenterFriendMessageType] = GYHDDataBaseCenterTemporaryBusiness;
    NSString* temporarycard = dict[GYHDDataBaseCenterMessageCard];
    temporarycard = [temporarycard substringToIndex:11];
    temporarycondDict[GYHDDataBaseCenterFriendCustID] = temporarycard;
    NSArray* tempArray = [[GYHDMessageCenter sharedInstance] selectInfoWithDict:temporarycondDict TableName:GYHDDataBaseCenterFriendTableName];

    NSMutableDictionary* friendcondDict = [NSMutableDictionary dictionary];
    friendcondDict[GYHDDataBaseCenterFriendMessageType] = GYHDDataBaseCenterFriends;
    friendcondDict[GYHDDataBaseCenterFriendCustID] = dict[GYHDDataBaseCenterMessageCard];
    NSDictionary* friendDict = [[[GYHDMessageCenter sharedInstance] selectInfoWithDict:friendcondDict TableName:GYHDDataBaseCenterFriendTableName] lastObject];

    if (reDict.allKeys.count > 0) {
        self.userNameStr = reDict[GYHDDataBaseCenterFriendName];
        self.userIconUrl = [NSURL URLWithString:reDict[GYHDDataBaseCenterFriendIcon]];
    }
    else if (tempArray.count > 0) {
        for (NSDictionary* adict in tempArray) {
            if (![adict[GYHDDataBaseCenterFriendName] isKindOfClass:[NSNull class]]) {
                self.userNameStr = adict[GYHDDataBaseCenterFriendName];
                self.userIconUrl = [NSURL URLWithString:adict[GYHDDataBaseCenterFriendIcon]];
            }
        }
    }
    else {
        self.userNameStr = friendDict[GYHDDataBaseCenterFriendName];
        self.userIconUrl = [NSURL URLWithString:friendDict[GYHDDataBaseCenterFriendIcon]];
    }
    self.pushNextController = [GYHDChatViewController class];
    if (![self.messageContentStr isEqualToString:@""] && self.messageContentStr != nil) {
        NSMutableAttributedString* att = [[NSMutableAttributedString alloc] initWithString:_messageContentStr];
        _messageContentAttributedString = att;
        [[GYHDMessageCenter sharedInstance] messageContentAttributedStringWithString:_messageContentStr AttrString:att];
    }

    if ([dict[GYHDDataBaseCenterFriendFriendID] rangeOfString:@"c"].location != NSNotFound) {
        self.userNameColoer = [UIColor blackColor];
    }
    else {
        self.userNameColoer = [UIColor colorWithRed:114 / 255.0f green:147 / 255.0f blue:207 / 255.0f alpha:1];
    }
}

/**
 * 为了统一方法, 将图片写入沙盒，返回路劲
 */
- (NSString*)imageFilePathWithImageName:(NSString*)imageName
{
    UIImage* image = [UIImage imageNamed:imageName];
    NSData* imageData = UIImagePNGRepresentation(image);
    NSString* fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageName]];
    [imageData writeToFile:fullPath atomically:NO];
    return fullPath;
}

@end

//        case GYHDDataBaseCenterMessageChatText:     //文本消息
//        {
//            self.messageContentStr    = bodyDict[@"msg_content"];
//            self.userNameStr          = bodyDict[@"msg_note"];
//            self.userIconUrl          = [NSURL URLWithString:bodyDict[@"msg_icon"]];
//            self.pushNextController   = [GYHDChatViewController class];
//            break;
//        }
//        case GYHDDataBaseCenterMessageChatPicture:  //图片消息
//        {
//            self.messageContentStr    = [GYUtils localizedStringWithKey:@"GYHD_Chat_image_message"];
//            self.userNameStr          = bodyDict[@"msg_note"];
//            self.userIconUrl          = [NSURL URLWithString:bodyDict[@"msg_icon"]];
//            self.pushNextController   = [GYHDChatViewController class];
//            break;
//        }
//        case GYHDDataBaseCenterMessageChatFile:     //文件消息
//        {
//            break;
//        }
//        case GYHDDataBaseCenterMessageChatAudio:    //音频消息
//        {
//            self.messageContentStr    = @"[音频]";
//            self.userNameStr          = bodyDict[@"msg_note"];
//            self.userIconUrl          = [NSURL URLWithString:bodyDict[@"msg_icon"]];
//            self.pushNextController   = [GYHDChatViewController class];
//            break;
//        }
//        case GYHDDataBaseCenterMessageChatVideo:    //视频消息
//        {
//            self.messageContentStr    = [GYUtils localizedStringWithKey:@"GYHD_Chat_video_message"];
//            self.userNameStr          = bodyDict[@"msg_note"];
//            self.userIconUrl          = [NSURL URLWithString:bodyDict[@"msg_icon"]];
//            self.pushNextController   = [GYHDChatViewController class];
//            break;
//        }
//    switch ([bodyDict[@"sub_msg_code"] integerValue]) {
//        case GYHDDataBaseCenterMessageTypeHuShengNews:
//        case GYHDDataBaseCenterMessageTypeHuSheng:
//        case GYHDDataBaseCenterMessageTypeFuWu:
//        case GYHDDataBaseCenterMessageTypeDingDan:
//        case GYHDDataBaseCenterMessageTypeDingYue:
//        {
//            self.userNameColoer = [UIColor colorWithRed:26.0f / 255.0f green:26.0f / 255.0f  blue:26.0f / 255.0f  alpha:1];
//            break;
//        }
//        case GYHDDataBaseCenterMessageChatText:     //文本消息
//        {
//            break;
//        }
//        case GYHDDataBaseCenterMessageChatPicture:  //图片消息
//        {
//            break;
//        }
//        case GYHDDataBaseCenterMessageChatFile:     //文件消息
//        {
//            break;
//        }
//        case GYHDDataBaseCenterMessageChatAudio:    //音频消息
//        {
//            break;
//        }
//        case GYHDDataBaseCenterMessageChatVideo:    //视频消息
//        {

//            break;
//        }
//        default:
//            break;
//    }