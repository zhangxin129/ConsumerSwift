//
//  GYHDCustomerServiceOnLineModel.m
//  HSCompanyPad
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDCustomerServiceOnLineModel.h"

@implementation GYHDCustomerServiceOnLineModel

//@property(nonatomic,copy)NSString*iconUrl;
//@property(nonatomic,copy)NSString*name;
//@property(nonatomic,copy)NSString*operNum;
//@property(nonatomic,copy)NSString*roleStr;
//@property(nonatomic,copy)NSString*kefuId;
//@property(nonatomic,assign)BOOL isSelect;

//currentPage = "<null>";
//custId = "w_e_0603211000080010000";
//entResNo = "";
//headImg = "http://192.168.229.27:8080/hsi-fs-server/fs/download/";
//operName = 8001;
//pageSize = "<null>";
//roleId = 301;
//roleName = "\U6258\U7ba1\U4f01\U4e1a\U7cfb\U7edf\U7ba1\U7406\U5458";
//totalRows = "<null>";
//userName = 8001;

-(void)initWithDict:(NSDictionary*)dict{

    self.isSelect=NO;
    
    self.iconUrl=dict[@"headImg"];
    
    self.name=dict[@"operName"];
    
    self.kefuId=dict[@"custId"];
    
    self.roleStr=dict[@"roleName"];
    
    self.operNum=dict[@"userName"];
    
}
@end
