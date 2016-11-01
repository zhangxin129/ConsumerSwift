//
//  GYHDAllMsgListModel.m
//  GYRestaurant
//
//  Created by apple on 16/7/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDAllMsgListModel.h"

@implementation GYHDAllMsgListModel
//@property(nonatomic,copy)NSString*iconImg;
//@property(nonatomic,copy)NSString*titlName;
//@property(nonatomic,copy)NSString*content;
//@property(nonatomic,copy)NSString*timeStr;
//@property(nonatomic,copy)NSString*messageUnreadCount;//消息未读数量
-(void)initWithDict:(NSDictionary*)dict{
    
    if ([_msgType isEqualToString:@"9"]) {
//      推送
        _pushMsgType=dict[@"PUSH_MSG_MainType"];
        
        _timeStr=dict[@"PUSH_MSG_SendTime"];
        
        _content=dict[@"PUSH_MSG_Content"];
        
        if ([dict[@"PUSH_MSG_MainType"] isEqualToString:@"1"]) {
            
          _titlName =@"系统消息";
            
            switch ([dict[@"PUSH_MSG_Code"] integerValue]) {
                case 1001:
                case 1002:
                case 1003:
                case 1004:
                case 1005:
                {
                    _content=dict[@"Summary"];
                    
                }
                    break;
                default:
                    break;
            }

        }else if ([dict[@"PUSH_MSG_MainType"] isEqualToString:@"2"]){
        
            _titlName =@"订单消息";
        
        }else{
        
            _titlName =@"服务消息";
        
        }
        
        NSString *topStatus = dict[@"topStatus"];
        
        if (!topStatus||[topStatus isKindOfClass:[NSNull class]]||topStatus.length==0) {
            
            //未置顶
            _messageState = GYHDPopMessageStateClearTop;
        }
        else{
            
            if (topStatus&&[topStatus isEqualToString:@"1"]) {
                
                //置顶状态
                _messageState = GYHDPopMessageStateTop;
                
            }
        }
        
        _messageTopTime = dict[@"topTime"];

    }else{
//    聊天
         _messageTopTime =dict[@"topTime"];
        
        if ([dict[GYHDDataBaseCenterUserSetingMessageTop] isEqualToString:@"0"]) {
            
            self.messageState = GYHDPopMessageStateTop;
        }else {
            self.messageState = GYHDPopMessageStateClearTop;
            
        }
        _titlName=dict[@"Friend_Name"];
        _iconUrl=dict[@"Friend_Icon"];
        _timeStr=dict[@"MSG_SendTime"];
        _content=dict[@"MSG_Content"];
        _msgCard=dict[@"Friend_CustID"];
        _MSG_UserState=dict[@"MSG_UserState"];
    }
}
@end
