//
//  GYHDRealNameAuthConfirmViewController.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHDAuthConfirmDelegate <NSObject>
@optional
- (void)confirmRealNameAuth;
@end
@interface GYHDRealNameAuthConfirmViewController : GYViewController
@property (nonatomic, strong) NSMutableDictionary* dictInside;
@property (nonatomic, copy) NSString* strCreFaceUrl;
@property (nonatomic, copy) NSString* strCreBackUrl;
@property (nonatomic, copy) NSString* strCreHoldUrl;
@property (nonatomic, copy) NSString* strCreOtherFileUrl; //户籍地址变更
@property (nonatomic,weak)id<GYHDAuthConfirmDelegate> confirmDelegate;
@end
