//
//  GYHESCChooseAreaViewController.h
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/24.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHESCChooseAreaModel;

typedef void (^chooseBlock)(GYHESCChooseAreaModel* model);

@interface GYHESCChooseAreaViewController : GYViewController

@property (nonatomic, copy) NSString* vShopId;
@property (nonatomic, copy) NSString* itemId;
@property (nonatomic, strong) NSIndexPath* CartIndexPath;

@property (nonatomic, strong) chooseBlock chooseBlock;

@end
