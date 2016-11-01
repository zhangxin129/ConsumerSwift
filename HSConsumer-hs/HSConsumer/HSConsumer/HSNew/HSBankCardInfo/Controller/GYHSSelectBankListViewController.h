//
//  GYHSSelectBankListViewController.h
//
//  Created by lizp on 16/9/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSBankListModel;
@protocol GYHSSelectBankListViewControllerDelegate<NSObject>

@optional

-(void)didSelectBank:(GYHSBankListModel *)model;

@end

@interface GYHSSelectBankListViewController: GYViewController

@property (nonatomic,weak) id<GYHSSelectBankListViewControllerDelegate>delegate;

@end
