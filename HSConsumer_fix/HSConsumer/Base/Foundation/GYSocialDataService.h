//
//  GYSocialDataService.h
//  UMSocial_Sdk_Demo
//
//  Created by sqm on 16/6/2.
//  Copyright © 2016年 yeahugo. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    GYSocialSnsTypeNone = 0,
    GYSocialSnsTypeSina = 9, //sina weibo
    GYSocialSnsTypeQzone = 10,
    GYSocialSnsTypeTenc, //tencent weibo
    GYSocialSnsTypeRenr, //renren
    GYSocialSnsTypeDouban, //douban
    GYSocialSnsTypeWechatSession,
    GYSocialSnsTypeWechatTimeline,
    GYSocialSnsTypeWechatFavorite,
    GYSocialSnsTypeEmail,
    GYSocialSnsTypeSms,
    GYSocialSnsTypeMobileQQ,
    GYSocialSnsTypeFacebook,
    GYSocialSnsTypeTwitter,
    GYSocialSnsTypeYiXinSession,
    GYSocialSnsTypeYiXinTimeline,
    GYSocialSnsTypeLaiWangSession,
    GYSocialSnsTypeLaiWangTimeline,
    GYSocialSnsTypeInstagram,
    GYSocialSnsTypeWhatsApp,
    GYSocialSnsTypeLine,
    GYSocialSnsTypeTumblr,
    GYSocialSnsTypeKakaoTalk,
    GYSocialSnsTypeFlickr,
    GYSocialSnsTypePinterest,
    GYSocialSnsTypeAlipaySession,
    GYSocialSnsTypeNew
} GYSocialSnsType;
@class GYSocialDataModel;
@protocol UMSocialUIDelegate;
typedef void (^dispatch_gy_block)(GYSocialSnsType type);
@interface GYSocialDataService : NSObject

+ (void)postWithSocialDataModel:(GYSocialDataModel*)model presentedController:(UIViewController*)presentedController;
+ (void)postWithSocialDataModel:(GYSocialDataModel*)model presentedController:(UIViewController*)presentedController delegate:(id<UMSocialUIDelegate>)delegate;
@end

@interface GYSocaialShareView : UIView

@property (copy, nonatomic) dispatch_gy_block block;

@end

@class CLLocation, UMSocialUrlResource;
@interface GYSocialDataModel : NSObject
@property (nonatomic, strong) UIImage* image;
@property (nonatomic, strong) CLLocation* location;
@property (nonatomic, copy) NSString* content;
@property (nonatomic, strong) UMSocialUrlResource* urlResource;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* toUrl;
@end
