//
//  GYHDSearchCompanyMessageModel.m
//  GYRestaurant
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSearchCompanyMessageModel.h"
#import "GYHDMessageCenter.h"
/*
 @property(nonatomic,copy)NSString*msgCard;//操作员custid
 @property(nonatomic,copy)NSString*time;//发送时间
 @property(nonatomic,copy)NSString*content;//发送内容
 @property(nonatomic,copy)NSString*msgIcon;//操作员头像
 @property(nonatomic,copy)NSString*msgNote;//操作员昵称
 @property(nonatomic,copy)NSString*msgID;
 */
@implementation GYHDSearchCompanyMessageModel

-(void)initWithDict:(NSDictionary *)dict{

    _msgCard=dict[@"MSG_Card"];
    
    //1. 接收时间
    NSString*timeStr = dict[@"MSG_SendTime"];
    NSArray*timeArr=[timeStr componentsSeparatedByString:@" "];
    if (timeArr.count>0) {
        
        _time=timeArr[0];
    }
    
    _msgID=dict[@"ID"];
    
    NSDictionary *bodyDict =  [Utils stringToDictionary:dict[@"MSG_Body"]];
    
    _content=bodyDict[@"msg_content"];
    
    switch ([bodyDict[@"msg_code"] integerValue]) {
        case 10:{
            //图片
            _content=@"[图片]";
        }
            break;
        case 13:{
            
            //            音频
            _content=@"[音频]";
            
            
        }break;
        case 14:{
            
            //            视频
            
            _content=@"[视频]";
            
        }break;
        default:
            break;
    }
    
    _msgIcon=bodyDict[@"msg_icon"];
    
    _msgNote =bodyDict[@"msg_note"];
    
    NSDictionary*friendDict=[[GYHDMessageCenter sharedInstance] selectFriendBaseWithCardString:dict[@"MSG_Card"]];
    
    NSDictionary *friendDetailDict =  [Utils stringToDictionary:friendDict[@"Friend_Basic"]];
    
    _roleName= friendDetailDict[@"roleName"];
    
    _saleAndOperatorRelationList=friendDetailDict[@"saleAndOperatorRelationList"];
    
    _searchUserInfo=friendDetailDict[@"searchUserInfo"];
    
}

@end
