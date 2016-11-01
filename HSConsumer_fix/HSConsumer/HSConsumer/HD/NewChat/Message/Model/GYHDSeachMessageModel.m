//
//  GYHDSeachMessageModel.m
//  HSConsumer
//
//  Created by shiang on 16/4/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSeachMessageModel.h"
#import "GYHDMessageCenter.h"


@implementation GYHDSeachMessageGroupModel
- (NSMutableArray*)seachMessageArray
{
    if (!_seachMessageArray) {
        _seachMessageArray = [NSMutableArray array];
    }
    return _seachMessageArray;
}

@end



@interface GYHDSeachMessageModel ()
/**消息Code*/
@property (nonatomic, assign) NSInteger messageCode;
@end

@implementation GYHDSeachMessageModel
- (instancetype)initWithDict:(NSDictionary*)dict
{

    if (self = [super init]) {
        if (dict[@"tp_count"]) {
            _seachContent = [NSString stringWithFormat:@"%@条相关消息", dict[@"tp_count"]];
            _seachAttContent = [[NSMutableAttributedString alloc] initWithString:_seachContent];
        }

        if (dict[@"PUSH_MSG_ToID"]) {
            [self setupPushWithDictionary:dict];
        }else {
            _custID = dict[@"Friend_CustID"];
            _seachName = dict[@"Friend_Name"];
            if (![dict[@"Friend_Icon"] isKindOfClass:[NSNull class]]) {
                _seachIcon = dict[@"Friend_Icon"];
            }
            else {
                _seachIcon = @"";
            }
            if (![dict[GYHDDataBaseCenterMessageSendTime] isKindOfClass:[NSNull class]]) {
                _seachTime = dict[GYHDDataBaseCenterMessageSendTime];
                _seachTime = [[GYHDMessageCenter sharedInstance] messageTimeStrFromTimerString:_seachTime];
            }
            else {
                _seachTime = @"";
            }
        }

    }
    return self;
}
- (void)setupPushWithDictionary:(NSDictionary*)dict {
    
    self.messageCode = [dict[GYHDDataBaseCenterPushMessageCode] integerValue];
    _custID = [dict[@"PUSH_MSG_Code"] stringValue];

    if (_messageCode == GYHDProtobufMessage01001 || _messageCode == GYHDProtobufMessage01002 || _messageCode == GYHDProtobufMessage01006 || _messageCode == GYHDProtobufMessage01007 || _messageCode == GYHDProtobufMessage01008 || _messageCode == GYHDProtobufMessage01009 || _messageCode == GYHDProtobufMessage01010) {
        self.seachName = @"互生消息";
        self.seachIcon = [self imageFilePathWithImageName:@"gyhd_huSheng_message_icon"];

    }
    else if (_messageCode == GYHDProtobufMessage02001 || _messageCode == GYHDProtobufMessage02002 || _messageCode == GYHDProtobufMessage02003 || _messageCode == GYHDProtobufMessage02004 || _messageCode == GYHDProtobufMessage02005 || _messageCode == GYHDProtobufMessage02006 || _messageCode == GYHDProtobufMessage02007 || _messageCode == GYHDProtobufMessage02008 || _messageCode == GYHDProtobufMessage02021 || _messageCode == GYHDProtobufMessage02022 || _messageCode == GYHDProtobufMessage02023 || _messageCode == GYHDProtobufMessage02024 || _messageCode == GYHDProtobufMessage02025 || _messageCode == GYHDProtobufMessage02026 || _messageCode == GYHDProtobufMessage02027 || _messageCode == GYHDProtobufMessage02028 || _messageCode == GYHDProtobufMessage02029) {
        self.seachName = @"订单消息";
//        self.seachIcon = [NSURL fileURLWithPath:[self imageFilePathWithImageName:@"gyhd_order_message_icon"]];
        self.seachIcon = [self imageFilePathWithImageName:@"gyhd_order_message_icon"];
//        self.pushNextController = [GYHDMessageListViewController class];
    }
    else if (_messageCode == GYHDProtobufMessage02901 || _messageCode == GYHDProtobufMessage02902 || _messageCode == GYHDProtobufMessage02903 || _messageCode == GYHDProtobufMessage02904) {
        self.seachName = @"订阅消息";
        self.seachIcon = [self imageFilePathWithImageName:@"gyhd_order_message_icon"];
    }
  
    _seachTime = [[GYHDMessageCenter sharedInstance] messageTimeStrFromTimerString:dict[GYHDDataBaseCenterPushMessageSendTime]];
//    _messageCard = [dict[GYHDDataBaseCenterPushMessageCode] stringValue];
//    _unreadMessageCountStr = [[GYHDMessageCenter sharedInstance] UnreadMessageCountWithCard:_messageCard];
//    if (![self.messageContentStr isEqualToString:@""] && self.messageContentStr != nil) {
//        NSMutableAttributedString* att = [[NSMutableAttributedString alloc] initWithString:_seachContent];
//        _messageContentAttributedString = att;
//        [[GYHDMessageCenter sharedInstance] messageContentAttributedStringWithString:_seachContent AttrString:att];
//    }

}

- (NSString*)imageFilePathWithImageName:(NSString*)imageName
{
    UIImage* image = [UIImage imageNamed:imageName];
    NSData* imageData = UIImagePNGRepresentation(image);
    NSString* fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageName]];
    [imageData writeToFile:fullPath atomically:NO];
    return fullPath;
}
@end
