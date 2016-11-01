//
//  GYHDCustomerModel.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDCustomerModel.h"

@implementation GYHDCustomerModel

-(void)initModelWithDic:(NSDictionary*)dic{
    
    self.Friend_Name=dic[@"Friend_Name"];
    self.User_MessageTop=dic[@"User_MessageTop"];
    self.Friend_detailed=dic[@"Friend_detailed"];
    self.MSG_ToID=dic[@"MSG_ToID"];
    self.MSG_FromID=dic[@"MSG_FromID"];
    self.User_Name=dic[@"User_Name"];
    self.MSG_UserState=dic[@"MSG_UserState"];
    self.Tream_ID=dic[@"Tream_ID"];
    self.MSG_SendTime=dic[@"MSG_SendTime"];
    self.MSG_Body=dic[@"MSG_Body"];
    self.Friend_CustID=dic[@"Friend_CustID"];
    self.Friend_UserType=dic[@"Friend_UserType"];
    self.MSG_DataString=dic[@"MSG_DataString"];
    self.Friend_ID=dic[@"Friend_ID"];
    self.MSG_ID=dic[@"MSG_ID"];
    self.Friend_Basic=dic[@"Friend_Basic"];
    self.ID=dic[@"ID"];
    self.MSG_Card=dic[@"MSG_Card"];
    self.MSG_State=dic[@"MSG_State"];
    self.Friend_MessageTop=dic[@"Friend_MessageTop"];
    self.MSG_RecvTime=dic[@"MSG_RecvTime"];
    self.Friend_Icon=dic[@"Friend_Icon"];
    self.MSG_Type=dic[@"MSG_Type"];
    self.MSG_Read=dic[@"MSG_Read"];
    self.MSG_Self=dic[@"MSG_Self"];
    self.content=dic[@"MSG_Content"];
    self.timeStr=dic[@"MSG_SendTime"];
    self.sessionId=dic[@"Friend_SessionID"];
}

@end
