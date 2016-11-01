//
//  GYHSSelectCityViewController.h
//
//  Created by lizp on 16/9/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHSCityAddressModel.h"

@protocol GYHSSelectCityViewControllerDelegate<NSObject>

@optional

-(void)didSelectCity:(GYHSCityAddressModel *)model;
-(void)cityDismiss;

@end

@class GYHSSelectCountryViewController;
@interface GYHSSelectCityViewController: GYViewController


@property (nonatomic, copy) NSString *areaId;
@property (nonatomic, copy) NSString *didSelectArea;
@property (nonatomic, copy) NSString* provinceNo;

@property (nonatomic,weak) id<GYHSSelectCityViewControllerDelegate>delegate;
@property (nonatomic,weak) id<GYHSSelectCityViewControllerDelegate>dismissDelegate;

@end
