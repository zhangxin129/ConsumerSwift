//
//  GYHDSearchPushMessageModel.m
//  GYRestaurant
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSearchPushMessageModel.h"

@implementation GYHDSearchPushMessageModel
/**
 @property(nonatomic,copy)NSString*titleName;
 @property(nonatomic,copy)NSString*content;
 @property(nonatomic,copy)NSString*time;
 @property(nonatomic,copy)NSString*pageUrl;
 */

-(void)initWithDict:(NSDictionary *)dict{

    NSDictionary *bodyDict =  [Utils stringToDictionary:dict[@"PUSH_MSG_Body"]];
    //1. 接收时间
    NSString*timeStr = dict[@"PUSH_MSG_SendTime"];
    NSArray*timeArr=[timeStr componentsSeparatedByString:@" "];
    if (timeArr.count>0) {
        
        _time=timeArr[0];
    }
    //2. 接收标题
    _titleName   = bodyDict[@"msg_subject"];
// _titleName =   [self attributeStringWithContent:bodyDict[@"msg_subject"] keyWords:@[_kerWord]];
    
    
//    接收内容
    _content = dict[@"PUSH_MSG_Content"];
//    _content =   [self attributeStringWithContent:dict[@"PUSH_MSG_Content"] keyWords:@[_kerWord]];
    
    _countrow =[dict[@"countrow"]integerValue];
    
    _msgCode  = dict[@"PUSH_MSG_Code"];
    
    _msgMainType=dict[@"PUSH_MSG_MainType"];
    //    4类互生消息含有图文，特殊处理
    switch ([_msgCode integerValue]) {
        case 1001:
        case 1002:
        case 1003:
        case 1004:
        case 1005:
        {
            NSDictionary*tempDic=[Utils stringToDictionary:bodyDict[@"msg_content"]];
            
            _content=tempDic[@"summary"];
            
            _pageUrl= tempDic[@"pageUrl"];
          
        }
            break;
        default:
            break;
    }

}

@end
