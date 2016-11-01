//
//  GYHEAddShoppingCarViewController.h
//
//  Created by lizp on 16/9/30.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHEGoodsDetailsModel.h"

@protocol GYHEAddShoppingCarViewControllerDelegate<NSObject>

@optional
-(void)didSelectGoodsName:(NSString *)name;

@end

@interface GYHEAddShoppingCarViewController: GYViewController

@property (nonatomic,weak) id<GYHEAddShoppingCarViewControllerDelegate>delegate;
@property (nonatomic,strong) GYHEGoodsDetailsModel *model;

@end
