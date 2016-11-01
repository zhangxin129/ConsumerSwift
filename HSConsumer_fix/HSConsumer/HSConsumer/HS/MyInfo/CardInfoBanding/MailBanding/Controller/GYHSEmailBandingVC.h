//
//  GYHSEmailBandingVC.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/28.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GYHSEmailBandingVCPageEmum) {
    GYHSEmailBandingVCPageAdd,
    GYHSEmailBandingVCPageModify
};

@interface GYHSEmailBandingVC : GYViewController

@property (nonatomic, assign) GYHSEmailBandingVCPageEmum pageType;

@end
