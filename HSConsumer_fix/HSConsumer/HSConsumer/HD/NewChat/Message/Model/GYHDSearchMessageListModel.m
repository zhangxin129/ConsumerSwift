//
//  GYHDSearchMessageListModel.m
//  HSConsumer
//
//  Created by shiang on 16/7/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSearchMessageListModel.h"
#import "GYHDMessageCenter.h"

///**头像*/
//@property(nonatomic, copy)NSString *iconString;
///**昵称*/
//@property(nonatomic, copy)NSString *nameString;
///**详细*/
//@property(nonatomic, copy)NSString *detailString;
///**时间*/
//@property(nonatomic, copy)NSString *timeString;
//@property(nonatomic, copy)NSString *custID;

@implementation GYHDSearchMessageListModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
         if (dict[@"PUSH_MSG_ToID"]) {
            [self setupPushWithDictionary:dict];
         }else  {
             [self setupMessageWithDictionary:dict];
         }
    }
    return self;
}
- (void)setupPushWithDictionary:(NSDictionary*)dict {

        
    _messageBody = dict[GYHDDataBaseCenterPushMessageBody];
       NSInteger  _messageCode = [dict[GYHDDataBaseCenterPushMessageCode] integerValue];
        _detailString = dict[GYHDDataBaseCenterPushMessageContent];
        if (_messageCode == GYHDProtobufMessage01001 || _messageCode == GYHDProtobufMessage01002 || _messageCode == GYHDProtobufMessage01006 || _messageCode == GYHDProtobufMessage01007 || _messageCode == GYHDProtobufMessage01008 || _messageCode == GYHDProtobufMessage01009 || _messageCode == GYHDProtobufMessage01010) {
            self.nameString = @"互生消息";
            self.iconString =@"gyhd_huSheng_message_icon";
//            self.pushNextController = [GYHDMessageListViewController class];
//            if (_messageCode == GYHDProtobufMessage01001 || _messageCode == GYHDProtobufMessage01002) {
//                NSDictionary* dict = [GYUtils stringToDictionary:_detailString];
//                _detailString = dict[@"summary"];
//            }
//            else
                if (_messageCode == GYHDProtobufMessage01009) {
                NSDictionary* dict = [GYUtils stringToDictionary:_detailString];
                _detailString = [NSString stringWithFormat:[GYUtils localizedStringWithKey:@"GYHD_Company_Binding_husheng_tips"], dict[@"resNo"], dict[@"name"]];
            }
        }
        else if (_messageCode == GYHDProtobufMessage02001 || _messageCode == GYHDProtobufMessage02002 || _messageCode == GYHDProtobufMessage02003 || _messageCode == GYHDProtobufMessage02004 || _messageCode == GYHDProtobufMessage02005 || _messageCode == GYHDProtobufMessage02006 || _messageCode == GYHDProtobufMessage02007 || _messageCode == GYHDProtobufMessage02008 || _messageCode == GYHDProtobufMessage02021 || _messageCode == GYHDProtobufMessage02022 || _messageCode == GYHDProtobufMessage02023 || _messageCode == GYHDProtobufMessage02024 || _messageCode == GYHDProtobufMessage02025 || _messageCode == GYHDProtobufMessage02026 || _messageCode == GYHDProtobufMessage02027 || _messageCode == GYHDProtobufMessage02028 || _messageCode == GYHDProtobufMessage02029) {
            self.nameString = @"订单消息";
            self.iconString =@"gyhd_order_message_icon";
//            self.pushNextController = [GYHDMessageListViewController class];
        }
        else if (_messageCode == GYHDProtobufMessage02901 || _messageCode == GYHDProtobufMessage02902 || _messageCode == GYHDProtobufMessage02903 || _messageCode == GYHDProtobufMessage02904) {
            self.nameString = @"订阅消息";
            self.iconString = @"gyhd_order_message_icon";
        }
        else if (_messageCode == GYHDProtobufMessage04101 || _messageCode == GYHDProtobufMessage04102 || _messageCode == GYHDProtobufMessage04104) {
            self.nameString = [GYUtils localizedStringWithKey:@"GYHD_Friend_application_friend"];
            self.iconString = @"gyhd_add_friend_icon";
//            self.pushNextController = [GYHDApplicantListViewController class];
        }
        _timeString = [[GYHDMessageCenter sharedInstance] messageTimeStrFromTimerString:dict[GYHDDataBaseCenterPushMessageSendTime]];
        _custID = [dict[GYHDDataBaseCenterPushMessageCode] stringValue];

    if (_detailString) {
        NSMutableDictionary* attDict = [NSMutableDictionary dictionary];
        attDict[NSFontAttributeName] = [UIFont systemFontOfSize:KFontSizePX(24)];
        NSMutableAttributedString* messageListContentAttributedStr = [[GYHDMessageCenter sharedInstance] attStringWithString:_detailString imageFrame:CGRectMake(0, -2, KFontSizePX(24), KFontSizePX(24)) attributes:attDict];
        _detailAttributedString = messageListContentAttributedStr;
    }
}


- (void)setupMessageWithDictionary:(NSDictionary *)dict {
    _iconString = dict[@"Friend_Icon"];
    _nameString = dict[@"Friend_Name"];
    _detailString = dict[@"MSG_Content"];
    _messageID = dict[GYHDDataBaseCenterMessageID];
    _custID = dict[GYHDDataBaseCenterMessageCard];
    _timeString = [[GYHDMessageCenter sharedInstance] messageTimeStrFromTimerString:dict[@"MSG_SendTime"]];
    if (_detailString) {
        NSMutableDictionary* attDict = [NSMutableDictionary dictionary];
        attDict[NSFontAttributeName] = [UIFont systemFontOfSize:KFontSizePX(24)];
        NSMutableAttributedString* messageListContentAttributedStr = [[GYHDMessageCenter sharedInstance] attStringWithString:_detailString imageFrame:CGRectMake(0, -2, KFontSizePX(24), KFontSizePX(24)) attributes:attDict];
        _detailAttributedString = messageListContentAttributedStr;
    }
}
@end
