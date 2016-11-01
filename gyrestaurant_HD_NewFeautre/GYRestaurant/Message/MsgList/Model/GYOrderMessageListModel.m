//
//  GYOrderMessageListModel.m
//  GYRestaurant
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOrderMessageListModel.h"
#import "GYHDMessageCenter.h"

@implementation GYOrderMessageListModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    
    self = [super init];
    if (!self) return self;
    [self setupWithDictionary:dict];
    return self;
}

- (void) setupWithDictionary:(NSDictionary *)dict;
{
    /*
     互生消息： '1001','1002','1003','1004','1005','2531','2532','1011','1012','1013','1014','1015','1016'
     
     订单消息： '2501','2502','2503','2504','2505','2506','2507','2508','2509','2510','2511','2512','2513','2514','2541','2542','2543','2544','2545','2546','2547'
     
     服务消息： '2801','2802','2803'
     */
    
    NSDictionary *bodyDict =  [Utils stringToDictionary:dict[@"PUSH_MSG_Body"]];
    //0. xiaoxi
    _messageListMessageBody = dict[@"PUSH_MSG_Body"];
    //1. 接收时间
    _messageListTimer = dict[@"PUSH_MSG_SendTime"];
    //2. 接收标题
    _messageListTitle   = bodyDict[@"msg_subject"];
    
    _messageListContent = dict[@"PUSH_MSG_Content"];
    
    _ID=dict[@"ID"];
    
    _readStatus=dict[@"PUSH_MSG_Read"];
    
    _isShowAllContent = NO;

    _submessgeCode  = dict[@"PUSH_MSG_Code"];
//    4类互生消息含有图文，特殊处理
    switch ([_submessgeCode integerValue]) {
        case 1001:
        case 1002:
        case 1003:
        case 1004:
        case 1005:
        {
            NSDictionary*tempDic=[Utils stringToDictionary:bodyDict[@"msg_content"]];
            
            _messageListContent=tempDic[@"summary"];
            _pageUrl= tempDic[@"pageUrl"];
            if (_pageUrl.length>0) {
                _isShowPage=YES;
            }
        
        }
            break;
               default:
            break;
    }

}
@end
