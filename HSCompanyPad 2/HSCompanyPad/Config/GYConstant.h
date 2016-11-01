//
//  Constant.h
//  HSConsumer
//
//  Created by apple on 14-10-9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//宏定义

#import <CocoaLumberjack/DDLog.h>
#import <GYKit/GYLogFormatter.h>
#import <GYKit/UIView+Toast.h>
#import <GYKit/GYKitConstant.h>
#import <GYKit/UIColor+HEX.h>
#import <Masonry/Masonry.h>
#import <YYKit/YYKitMacro.h>
#import "GYUtilsConst.h"
#import "AlertHeader.h"
#import <GYKit/UIView+Extension.h>
#import "GYLoginEn.h"
#import "GlobalData.h"
#import "GYUtils+companyPad.h"
#import <GYKit/NSString+GYExtension.h>
#import "GYNetWork.h"
#import "UITextField+GYHSPointTextField.h"

//UIImageView+YYWebImage.h

#define kCheckMemory 0


#define kGray878787 [UIColor colorWithHexString:@"#878787"]
#define kGray878694 [UIColor colorWithHexString:@"#878694"]
#define kGray878696 [UIColor colorWithHexString:@"#878696"]
#define kGray888888 [UIColor colorWithHexString:@"#888888"]
#define kGray999999 [UIColor colorWithHexString:@"#999999"]
#define kGray333333 [UIColor colorWithHexString:@"#333333"]
#define kGrayCCCCCC [UIColor colorWithHexString:@"#CCCCCC"]
#define kGray555555 [UIColor colorWithHexString:@"#555555"]
#define kGrayDDDDDD [UIColor colorWithHexString:@"#DDDDDD"]
#define kGrayDBDBEA [UIColor colorWithHexString:@"#DBDBEA"]
#define kGray868695 [UIColor colorWithHexString:@"#868695"]
#define kGray666666 [UIColor colorWithHexString:@"#666666"]
#define kGrayc8c8d8 [UIColor colorWithHexString:@"#c8c8d8"]
#define kGray777777 [UIColor colorWithHexString:@"#777777"]
#define kGray7D7D7D [UIColor colorWithHexString:@"#7D7D7D"]
#define kGrayCFCFDA [UIColor colorWithHexString:@"#CFCFDA"]
#define kGray868695 [UIColor colorWithHexString:@"#868695"]
#define kGray000000 [UIColor colorWithHexString:@"#000000"]
#define kGray535362 [UIColor colorWithHexString:@"#535362"]
#define kGrayE3E3EA [UIColor colorWithHexString:@"#E3E3EA"]
#define kGrayEEEEEE [UIColor colorWithHexString:@"#EEEEEE"]
#define kGrayF7F7F7 [UIColor colorWithHexString:@"#F7F7F7"]

#define kRedE40011 [UIColor colorWithHexString:@"#E40011"]
#define kRedFF6235 [UIColor colorWithHexString:@"#FF6235"]
#define kRedE50012 [UIColor colorWithHexString:@"#E50012"]
#define kRedE94F37 [UIColor colorWithHexString:@"#E94F37"]
#define kRedfa5a48 [UIColor colorWithHexString:@"#fa5a48"]
#define kRedff3a24 [UIColor colorWithHexString:@"#ff3a24"]

#define kBlue177EFD [UIColor colorWithHexString:@"#177EFD"]
#define kBlue0A59C1 [UIColor colorWithHexString:@"#0A59C1"]
#define kBlue0A59C2 [UIColor colorWithHexString:@"#0A59C2"]
#define kBlue0C69E9 [UIColor colorWithHexString:@"#0C69E9"]
#define kBlue0D6AEA [UIColor colorWithHexString:@"#0D6AEA"]
#define kBlue59A0FF [UIColor colorWithHexString:@"#59A0FF"]
#define kBlue64A9FD [UIColor colorWithHexString:@"#64A9FD"]
#define kBlue2d89f0 [UIColor colorWithHexString:@"#2d89f0"]
#define kBlueF2F2FD [UIColor colorWithHexString:@"#F2F2FD"]
#define kBlue70ADFE [UIColor colorWithHexString:@"#70ADFE"]
#define kBlue3793FF [UIColor colorWithHexString:@"#3793FF"]

#define kWhiteFFFFFF [UIColor colorWithHexString:@"#FFFFFF"]

#define kGreenB5FFB5 [UIColor colorWithHexString:@"#B5FFB5"]
#define kGreen87B500 [UIColor colorWithHexString:@"#87B500"]
#define kGreen008C00 [UIColor colorWithHexString:@"#008C00"]
#define kGreen008C23 [UIColor colorWithHexString:@"#008C23"]
#define kGreenF5F5F5 [UIColor colorWithHexString:@"#F5F5F5"]
#define kGreenF4F4F4 [UIColor colorWithHexString:@"#F4F4F4"]
#define kGreen48d78c [UIColor colorWithHexString:@"#48d78c"]
#define kGreen42c781 [UIColor colorWithHexString:@"#42c781"]
#define kGreenF9F9FB [UIColor colorWithHexString:@"#F9F9FB"]


#define kYellowF2B80A [UIColor colorWithHexString:@"#F2B80A"]

#define kPurple00002B [UIColor colorWithHexString:@"#00002B"]
#define kPurple000024 [UIColor colorWithHexString:@"#000024"]

#define kLocalized(key) NSLocalizedString(key, nil)

//屏幕比例
#define kDeviceProportion(num) ([UIScreen mainScreen].bounds.size.width == 1366 ? 1.33 : 1) * num
//扫描框到top的距离
#define kOffRect 200

//头部视图总高度，包括状态栏以及头部与底部视图的间隔
#define kMainHeadHeight 97
//导航栏实际高度
#define kMainHeadNavHeight 65
//默认控制器的背景色
#define kDefaultVCBackgroundColor kRGBA(240, 240, 240, 1)

//导航栏高度
#define kNavigationHeight 44

//字体pt转换为px
#define kFont18 [UIFont systemFontOfSize:18 * 1 / 2]
#define kFont20 [UIFont systemFontOfSize:20 * 1 / 2]
#define kFont24 [UIFont systemFontOfSize:24 * 1 / 2]
#define kFont28 [UIFont systemFontOfSize:28 * 1 / 2]
#define kFont30 [UIFont systemFontOfSize:30 * 1 / 2]
#define kFont32 [UIFont systemFontOfSize:32 * 1 / 2]
#define kFont34 [UIFont systemFontOfSize:34 * 1 / 2]
#define kFont36 [UIFont systemFontOfSize:36 * 1 / 2]
#define kFont38 [UIFont systemFontOfSize:38 * 1 / 2]
#define kFont40 [UIFont systemFontOfSize:40 * 1 / 2]
#define kFont42 [UIFont systemFontOfSize:42 * 1 / 2]
#define kFont48 [UIFont systemFontOfSize:48 * 1 / 2]
#define kFont100 [UIFont systemFontOfSize:100 * 1 / 2]
//主页头部背景色
#define kMainHeadColor [UIColor blackColor]
//导航栏字体颜色
#define kNavigationTitleColor kRGBA(255, 255, 255, 1)
//默认遮罩背景色
#define kMaskViewColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]

//设备IP
#define kIp [UIDevice currentDevice].ipAddressCell ? [UIDevice currentDevice].ipAddressCell : [UIDevice currentDevice].ipAddressWIFI
#define kDeviceIp kIp ? kIp : @""

//获得AppDelegate
#define kAppDelegate [[UIApplication sharedApplication] delegate]

//常用CELL主标题字体大小
#define kCellTitleFont [UIFont systemFontOfSize:15]

//----------------------系统常量 ----------------------------
//id类型安全转换成字符串
#define kSaftToNSString(v)  [GYUtils saftToNSString:v]

#define globalData [GlobalData shareInstance]

#define GY_HSDOMAINAPPENDING(url) [[[GYLoginEn sharedInstance] getLoginUrl] stringByAppendingString:url]
#define GY_APPFILTERAPPENDING(url) [[[GYLoginEn sharedInstance] getFilterUrl] stringByAppendingString:url]
#define GY_ReDOMAINAPPENDING(url) [[[GYLoginEn sharedInstance] getReconsitution] stringByAppendingString:url]
#define GY_RETAILDOMAINAPPENDING(url) [globalData.loginModel.phapiUrl stringByAppendingString:url]
#define GY_FOODOMAINAPPENDING(url) [globalData.loginModel.foodUrl stringByAppendingString:url]
#define GY_PICTUREAPPENDING(fileId) [NSString stringWithFormat:@"%@%@?channel=%@&userId=%@&token=%@&isPub=1", globalData.loginModel.picUrl, kSaftToNSString(fileId), GYChannelType, globalData.loginModel.custId, globalData.loginModel.token]
#define GYHE_PICTUREAPPENDING(url) [NSString stringWithFormat:@"%@%@?channel=%@&userId=%@&token=%@&isPub=1", globalData.loginModel.hsecTfsUrl, kSaftToNSString(url), GYChannelType, globalData.loginModel.custId, globalData.loginModel.token]
typedef void (^HTTPSuccess)(id responsObject);
typedef void (^HTTPFailure)();
typedef void (^HTTPCancel)();

#define kErrorRetcodeMsg ([responsObject[GYNetWorkCodeKey] isEqualToNumber:@160467] || [responsObject[GYNetWorkCodeKey] isEqualToNumber:@160411]) ? responsObject[@"msg"] : ((globalData.dicErrConfig[kSaftToNSString(responsObject[GYNetWorkCodeKey])]) ? (globalData.dicErrConfig[kSaftToNSString(responsObject[GYNetWorkCodeKey])]) : kLocalized(@"HE_NetworkError"))

#define kErrorReturncodeMsg ([returnValue[GYNetWorkCodeKey] isEqualToNumber:@160467] || [returnValue[GYNetWorkCodeKey] isEqualToNumber:@160411]) ? returnValue[@"msg"] : ((globalData.dicErrConfig[kSaftToNSString(returnValue[GYNetWorkCodeKey])]) ? (globalData.dicErrConfig[kSaftToNSString(returnValue[GYNetWorkCodeKey])]) : kLocalized(@"HE_NetworkError"))

#define kisReleaseEn [GYLoginEn isReleaseEn] //是否为生产发布环境 否：NO 是：YES


//是否为空或是[NSNull null]
#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
//数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))

//判断字符是否为空
#define kBlankNSString(v) [GYUtils isBlankString:v]


