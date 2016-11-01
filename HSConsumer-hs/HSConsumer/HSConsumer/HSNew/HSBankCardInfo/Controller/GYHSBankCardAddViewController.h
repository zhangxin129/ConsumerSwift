//
//  GYHSBankCardAddViewController.h
//
//  Created by lizp on 16/9/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GYHSBankCardAddViewControllerDelegate<NSObject>

@optional
-(void)addBankCardSuccess;

@end

@interface GYHSBankCardAddViewController: GYViewController

@property (nonatomic,weak) id<GYHSBankCardAddViewControllerDelegate>delegate;

@end
