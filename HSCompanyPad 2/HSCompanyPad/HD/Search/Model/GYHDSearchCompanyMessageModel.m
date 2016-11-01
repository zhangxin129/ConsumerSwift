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
    NSString*timeStr = dict[@"MSG_SndTime"];
//    NSArray*timeArr=[timeStr componentsSeparatedByString:@" "];
//    if (timeArr.count>0) {
//        
//        _time=timeArr[0];
//    }
    _time=[GYHDUtils messageTimeStrFromTimerString:timeStr];
    _msgID=dict[@"ID"];
    
    NSDictionary *bodyDict =  [GYHDUtils stringToDictionary:dict[@"MSG_Body"]];
    
    _content=dict[@"MSG_Content"];
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
//    _msgIcon=bodyDict[@"msg_icon"];
//    
//    _msgNote =dict[@"msg_note"];
    
    if ([_UserState isEqualToString:@"e"]) {
        
        NSDictionary*friendDict=[[GYHDDataBaseCenter sharedInstance] selectfriendBaseWithCardStr:dict[@"MSG_Card"]];
        
        NSDictionary *friendDetailDict =  [GYHDUtils stringToDictionary:friendDict[@"Friend_Basic"]];
        
        _roleName= friendDetailDict[@"roleName"];
        
        _saleAndOperatorRelationList=friendDetailDict[@"saleAndOperatorRelationList"];
        
        _searchUserInfo=friendDetailDict[@"searchUserInfo"];
        
    }
    
}
@end
