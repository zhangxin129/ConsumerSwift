//
//  GYHSSelectCountryViewController.h
//
//  Created by lizp on 16/9/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSCityAddressModel;
@protocol   GYHSSelectCountryViewControllerDelegate<NSObject>

@optional
-(void)selectArea:(GYHSCityAddressModel *)model;

@end

@interface GYHSSelectCountryViewController: GYViewController


@property (nonatomic,weak) id<GYHSSelectCountryViewControllerDelegate>delegate;

@end
