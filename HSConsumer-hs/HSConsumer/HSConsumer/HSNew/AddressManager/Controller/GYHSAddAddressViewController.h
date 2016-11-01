//
//  GYHSAddAddressViewController.h
//
//  Created by lizp on 16/9/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GYHSAddAddressViewControllerDelegate<NSObject>

@optional
-(void)refreshGoodList;

@end

@class GYAddressModel,GYAddressListModel;
@interface GYHSAddAddressViewController: GYViewController

@property (nonatomic,weak) id<GYHSAddAddressViewControllerDelegate>delegate;

@property (nonatomic, assign) BOOL boolstr; //用来控制push源，两个页面公用一个controller,用来区分
@property (nonatomic, assign) BOOL isFood; //区分餐饮  和零售
@property (nonatomic, copy) NSString *addrId;

//@property (nonatomic, strong) GYAddressModel *model;
@property (nonatomic, strong) GYAddressListModel *model;



@end
