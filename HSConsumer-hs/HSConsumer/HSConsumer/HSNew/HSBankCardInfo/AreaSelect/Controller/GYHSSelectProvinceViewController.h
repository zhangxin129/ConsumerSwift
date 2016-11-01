//
//  GYHSSelectProvinceViewController.h
//
//  Created by lizp on 16/9/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSSelectProvinceViewControllerDelegate<NSObject>

@optional

-(void)provinceDismiss;

@end

@class GYHSSelectCountryViewController;
@interface GYHSSelectProvinceViewController: GYViewController


@property (nonatomic,weak) id<GYHSSelectProvinceViewControllerDelegate>delegate;
@property (nonatomic, copy) NSString *areaId;
@property (nonatomic, copy) NSString *didSelectArea;

@property (nonatomic,weak) id countryVC;

@end
