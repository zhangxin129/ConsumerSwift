//
//  GYHSDocModel.h
//  HSCompanyPad
//
//  Created by sqm on 16/9/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, GYHSExampleDoc) {
    GYHSExampleDocJoinActivity = 1006, //参与积分活动业务办理申请书
    GYHSExampleDocStopActivity= 1005, //停止积分活动业务办理申请书
    GYHSExampleDocQuit = 1004, //企业注销业务办理申请书
    GYHSExampleDocResetPwd = 1002, //重置交易密码业务办理申请书
    GYHSExampleDocImportant = 1001, //重要信息变更业务办理申请书
    GYHSExampleDocContactPersonAuthorizedToScan = 1007, //联系人授权委托书扫描件
    GYHSExampleDocHandheldBusinessLicense = 1023, //手持营业执照
    GYHSExampleDocBankLicense = 1031, //银行开户许可证

};
@interface GYHSDocModel : NSObject
@property (nonatomic, copy) NSString *docCode;//唯一标识
@property (nonatomic, copy) NSString *docName;//文档名称
@property (nonatomic, copy) NSString *fileId;//文件ID
@property (nonatomic, copy) NSString *fileType;//文件类型 normalFile applyFile

@property (nonatomic, assign) GYHSExampleDoc docIdentify;//本地标记
@property (nonatomic, strong) NSURL *docUrl;//本地拼接链接
@property (nonatomic, copy) NSString *localPath;

@end
