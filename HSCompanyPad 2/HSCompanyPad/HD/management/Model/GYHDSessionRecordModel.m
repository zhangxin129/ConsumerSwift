//
//  GYHDSessionRecordModel.m
//  HSCompanyPad
//
//  Created by apple on 16/10/12.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDSessionRecordModel.h"
#import "GYHDNetWorkTool.h"
@implementation GYHDSessionRecordModel

/*
 @property(nonatomic,copy)NSString * csOperNo;//客服编号
 @property(nonatomic,copy)NSString * fromId;//消息发送id
 @property(nonatomic,copy)NSString * msgContent;//消息内容
 @property(nonatomic,copy)NSString * receiverHeadIcon;//接受者头像
 @property(nonatomic,copy)NSString * receiverNickName;//接收者昵称
 @property(nonatomic,copy)NSString * sendTime;//发送时间戳
 @property(nonatomic,copy)NSString * sendTimeFormat;//发送时间格式化显示
 @property(nonatomic,copy)NSString * senderHeadIcon;//发送者头像
 @property(nonatomic,copy)NSString * senderNickName;//发送者昵称
 @property(nonatomic,copy)NSString * toId;//toid
 @property(nonatomic,assign)BOOL isRight;//是否居右显示
 */

-(void)initWithDict:(NSDictionary*)dict{
    
    self.csOperNo = dict[@"csOperNo"];
    self.fromId = dict[@"fromId"];
    self.msgContent = dict[@"msgContent"];
    NSDictionary*contentDict = [GYHDUtils stringToDictionary:self.msgContent];
    self.chatType = contentDict[@"msg_code"];
    switch ([self.chatType integerValue]) {
        case GYHDDataBaseCenterMessageChatText:{
            
            self.messageContentAttString = [GYHDUtils EmojiAttributedStringFromString:contentDict[@"msg_content"]];
        }break;
        case GYHDDataBaseCenterMessageChatPicture:{
            
            self.messageNetWorkBasePath = contentDict[@"msg_imageNailsUrl"];
            self.messageNetWorkDetailPath = contentDict[@"msg_content"];
        
        }break;
        case GYHDDataBaseCenterMessageChatMap:{//位置信息
            
        
        
        }break;
        case GYHDDataBaseCenterMessageChatFile:{//文件
            
            
            
        }break;
        case GYHDDataBaseCenterMessageChatAudio:{//音频
            
            NSString *timeNumber = [NSString stringWithFormat:@"%u_%d", arc4random_uniform(1000), (int)[[NSDate date] timeIntervalSince1970]];
            NSString *mp3Name = [NSString stringWithFormat:@"audio%@.mp3", timeNumber];
            NSString *mp3Path = [NSString pathWithComponents:@[[GYHDUtils mp3folderNameString], mp3Name]];
            [[GYHDNetWorkTool sharedInstance] downloadDataWithUrlString:[[GYHDMessageCenter sharedInstance]appendAuthenticationStr:contentDict[@"msg_content"]] filePath:mp3Path];

            self.messageNetWorkBasePath = contentDict[@"msg_fileSize"];
            self.messageNetWorkDetailPath = contentDict[@"msg_content"];
            self.messageFileDetailPath = mp3Name;
            self.messageFileBasePath = contentDict[@"msg_fileSize"];
            
        }break;
        case GYHDDataBaseCenterMessageChatVideo:{//视频
            
            NSString *timeNumber = [NSString stringWithFormat:@"%u_%d", arc4random_uniform(1000), (int)[[NSDate date] timeIntervalSince1970]];
            NSString *mp4Name = [NSString stringWithFormat:@"video%@.mp4",timeNumber];
            NSString *filePath = [NSString pathWithComponents:@[[GYHDUtils mp4folderNameString],mp4Name]];
            [[GYHDNetWorkTool sharedInstance] downloadDataWithUrlString:[[GYHDMessageCenter sharedInstance]appendAuthenticationStr:contentDict[@"msg_content"]] filePath:filePath];
            self.messageNetWorkBasePath = contentDict[@"msg_imageNail"];
            self.messageNetWorkDetailPath = contentDict[@"msg_content"];
            self.messageFileDetailPath = mp4Name;
            
        }break;
        case GYHDDataBaseCenterMessageChatGoods:{//商品信息
            
            
            
        }break;
        case GYHDDataBaseCenterMessageChatOrder:{//订单信息
            
            
             
        }break;
        case GYHDDataBaseCenterMessageTypeGreeting:{//提示语信息
            
            
             
        }break;
        default:
            break;
    }
    self.receiverHeadIcon = dict[@"receiverHeadIcon"];
    self.receiverNickName = dict[@"receiverNickName"];
    self.sendTime = dict[@"sendTime"];
    self.sendTimeFormat = [self createLastTimeWithTimeString:dict[@"sendTimeFormat"]];
    self.senderHeadIcon = dict[@"senderHeadIcon"];
    self.senderNickName = dict[@"senderNickName"];
    self.toId = dict[@"toId"];
    if ([dict[@"toId"] containsString:@"e"]) {
        
        self.isRight=NO;
        
    }else{
        
        self.isRight=YES;
        
    }
}

- (NSString *)createLastTimeWithTimeString:(NSString *)timeString {
    NSString *recvStrimg = nil;
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* currerDate = [fmt dateFromString:timeString];
    recvStrimg = [GYHDUtils messageTimeStrFromTimerString:timeString];
    if ([currerDate timeIntervalSince1970] < self.lastTime + 20) {
        recvStrimg = @"";
    }
    self.lastTime = [currerDate timeIntervalSince1970];
    return recvStrimg;
}
@end
