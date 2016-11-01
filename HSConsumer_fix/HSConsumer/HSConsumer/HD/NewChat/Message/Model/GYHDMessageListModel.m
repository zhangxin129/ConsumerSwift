//
//  GYHDDingDanModel.m
//  HSConsumer
//
//  Created by shiang on 16/1/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDMessageListModel.h"
#import "GYHDMessageCenter.h"

@interface GYHDMessageListModel ()

@end

@implementation GYHDMessageListModel
+ (instancetype)dingDanModelWithDictionary:(NSDictionary*)dict;
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary*)dict
{

    self = [super init];
    if (!self)
        return self;
    [self setupWithDictionary:dict];
    return self;
}

- (void)setupWithDictionary:(NSDictionary*)dict
{

    _messageCode = [dict[GYHDDataBaseCenterPushMessageCode] integerValue];
    _messageListContent = dict[GYHDDataBaseCenterPushMessageContent];
    _messageBody = dict[GYHDDataBaseCenterPushMessageBody];
    _messageID = dict[GYHDDataBaseCenterPushMessageID];
    NSDictionary* bodyDict = [GYUtils stringToDictionary:_messageBody];
    _messageListTitle = bodyDict[@"msg_subject"];
//    if (_messageCode == GYHDProtobufMessage01001 || _messageCode == GYHDProtobufMessage01002) {
//        NSDictionary* dict = [GYUtils stringToDictionary:bodyDict[@"msg_content"]];
//        _messageListContent = dict[@"summary"];
//    }
 //   else
        if (_messageCode == GYHDProtobufMessage01009) {
        NSDictionary* dict = [GYUtils stringToDictionary:bodyDict[@"msg_content"]];
        _messageListContent = [NSString stringWithFormat:[GYUtils localizedStringWithKey:@"GYHD_Company_Binding_husheng_tips"], dict[@"entResNo"], dict[@"name"]];
    }
    _messageListTimer = [[GYHDMessageCenter sharedInstance] messageTimeStrFromTimerString:dict[GYHDDataBaseCenterPushMessageSendTime]];
    if (![_messageListContent isEqualToString:@""] && _messageListContent != nil) {
        NSMutableAttributedString* att = [[NSMutableAttributedString alloc] initWithString:_messageListContent];
        _messageListContentAttributedStr = att;
        [[GYHDMessageCenter sharedInstance] messageContentAttributedStringWithString:_messageListContent AttrString:att];
    }
}

@end
//        [[GYHDMessageCenter sharedInstance] messageContentAttributedStringWithString:_messageListContent AttrString:_messageListContentAttributedStr];

//    //0. xiaoxi
//    _messageListMessageBody = dict[@"MSG_Body"];
//    //1. 接收时间

//    //2. 接收标题

//

//    if (_messageListContent != nil)
//        _messageListContentAttributedStr = [[NSMutableAttributedString alloc] initWithString:_messageListContent];
//    _submessgeCode  = bodyDict[@"sub_msg_code"];

//    switch ([dict[GYHDDataBaseCenterMessageCard] integerValue]) {
//
//        case GYHDDataBaseCenterMessageTypeHuShengNews:
//        {
//            break;
//        }
//        case GYHDDataBaseCenterMessageTypeHuSheng:
//        {
//
//            if ([bodyDict[@"sub_msg_code"] integerValue]== GYHDDataBaseCenterPush1010201 ||
//                [bodyDict[@"sub_msg_code"] integerValue]== GYHDDataBaseCenterPush10101
//                ) {
//
//                NSDictionary *hushengDict = [GYUtils stringToDictionary:bodyDict[@"msg_content"]];
//                _messageListContent  = hushengDict[@"summary"];
//                _pageUrl = hushengDict[@"pageUrl"];
//            }
//            if (_messageListContent != nil)
//                _messageListContentAttributedStr = [[NSMutableAttributedString alloc] initWithString:_messageListContent];
//            break;
//        }
//        case GYHDDataBaseCenterMessageTypeFuWu:
//        {
//
//            break;
//        }
//        case GYHDDataBaseCenterMessageTypeDingDan:
//        {
//
//
//            NSString *msgID = bodyDict[@"msg_id"];
//            _orderId =  [msgID componentsSeparatedByString:@","].firstObject;
//            //1. 设置订单字符串颜色
//            _moderType  = bodyDict[@"msg_repast_type"];
//            if (![_messageListContent isEqualToString:@""] &&  _messageListContent != nil){
//                NSString *pattern = @"\\d{17}";
//                NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
//                NSArray *results = [regex matchesInString:_messageListContent options:0 range:NSMakeRange(0,_messageListContent.length)];
//                NSTextCheckingResult *result = results.firstObject;
//                [_messageListContentAttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1] range:result.range];
//            }
//            break;
//        }
//        case GYHDDataBaseCenterMessageTypeDingYue:
//        {
//            break;
//        }
//        default:
//            break;
//    }
//- (void) setupWithDictionary:(NSDictionary *)dict;
//{
//
//    NSDictionary *bodyDict =  [GYUtils stringToDictionary:dict[@"PUSH_MSG_Body"]];
//
//    NSInteger card = [dict[GYHDDataBaseCenterPushMessagePlantFromID] integerValue];
//    if (card == GYHDProtobufMessageHuxin) {
//
//        _messageListTitle   = bodyDict[@"msg_subject"];
//        _messageListContent = bodyDict[@"msg_content"];
//        _messageListTimer = [[GYHDMessageCenter sharedInstance] messageTimeStrFromTimerString:dict[GYHDDataBaseCenterMessageRevieTime]];
//
//    }else if (card == GYHDProtobufMessageHuSheng) {
//        _messageListTitle   = bodyDict[@"msg_subject"];
//        _messageListContent = bodyDict[@"msg_content"];
//        _messageListTimer = [[GYHDMessageCenter sharedInstance] messageTimeStrFromTimerString:dict[GYHDDataBaseCenterMessageRevieTime]];
//    }else if (card == GYHDProtobufMessageDianShang) {

//        _messageListContent = bodyDict[@"msg_content"];
//        _messageListTimer = [[GYHDMessageCenter sharedInstance] messageTimeStrFromTimerString:dict[GYHDDataBaseCenterMessageRevieTime]];
//    }
//    _messageBody = dict[GYHDDataBaseCenterPushMessageBody];
//    _messageCode = [dict[GYHDDataBaseCenterPushMessageCode] integerValue];
//    _messageData = dict[GYHDDataBaseCenterPushMessageData];
//    _messageID = [dict[GYHDDataBaseCenterPushMessageID] longLongValue];
//    if (![_messageListContent isEqualToString:@""] && _messageListContent != nil) {
//        _messageListContentAttributedStr = [[GYHDMessageCenter sharedInstance] attStringWithString:_messageListContent imageFrame:CGRectMake(0, 0, 10, 10) attributes:nil];
//    }
//}