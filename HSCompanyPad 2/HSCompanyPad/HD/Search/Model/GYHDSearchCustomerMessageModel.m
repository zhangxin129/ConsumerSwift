//
//  GYHDSearchCustomerMessageModel.m
//  GYRestaurant
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSearchCustomerMessageModel.h"
#import "GYHDMessageCenter.h"
@implementation GYHDSearchCustomerMessageModel

/*
 @property(nonatomic,copy)NSString*msgCard;//客户custid
 @property(nonatomic,copy)NSString*time;//发送时间
 @property(nonatomic,copy)NSString*content;//发送内容
 @property(nonatomic,copy)NSString*msgIcon;//客户头像
 @property(nonatomic,copy)NSString*msgNote;//客户昵称
 @property(nonatomic,copy)NSString*msgID;
 */
-(void)initWithDict:(NSDictionary *)dict{

    _msgCard=dict[@"MSG_Card"];
    _UserState=dict[@"MSG_UserState"];
    //1. 接收时间
    NSString*timeStr = dict[@"MSG_SendTime"];
    NSArray*timeArr=[timeStr componentsSeparatedByString:@" "];
    if (timeArr.count>0) {
        
        _time=timeArr[0];
    }
    
    _msgID=dict[@"ID"];
    
     NSDictionary *bodyDict =  [GYHDUtils stringToDictionary:dict[@"MSG_Body"]];
    
    _content=bodyDict[@"msg_content"];
    switch ([bodyDict[@"msg_code"] integerValue]) {
        case 10:{
            //图片
            _content=kLocalized(@"GYHD_Picture");
        }
            break;
        case 13:{
            
            //            音频
            _content=kLocalized(@"GYHD_Audio");
            
            
        }break;
        case 14:{
            
            //            视频
            
            _content=kLocalized(@"GYHD_Video");
            
        }break;
        default:
            break;
    }

    _countrow =[dict[@"countrow"]integerValue];
    
    _msgIcon=dict[@"Friend_Icon"];
    
    _msgNote =dict[@"Friend_Name"];
    
    _friendUserType=dict[@"Friend_UserType"];
    
    if ([_UserState isEqualToString:@"e"]) {
        
        NSDictionary*friendDict=[[GYHDDataBaseCenter sharedInstance] selectfriendBaseWithCardStr:dict[@"MSG_Card"]];
        
        NSDictionary *friendDetailDict =  [GYHDUtils stringToDictionary:friendDict[@"Friend_Basic"]];
        
        _roleName= friendDetailDict[@"roleName"];
        
        _saleAndOperatorRelationList=friendDetailDict[@"saleAndOperatorRelationList"];
        
        _searchUserInfo=friendDetailDict[@"searchUserInfo"];
        
    }
    
}
@end
