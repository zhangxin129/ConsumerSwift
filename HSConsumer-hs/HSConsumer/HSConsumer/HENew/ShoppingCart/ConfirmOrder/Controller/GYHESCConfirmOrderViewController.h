//
//  GYHESCConfirmOrderViewController.h
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/26.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHESCConfirmOrderViewController : GYViewController

@property (nonatomic, strong) NSMutableArray* dataSourceArray;
@property (nonatomic, copy) NSString* isRightAway; //是否立即购买 0 否 1 是
@property (nonatomic, strong) NSDictionary* goodsDict;
@property (nonatomic, strong) NSDictionary* skuDict;
@property (nonatomic, copy) NSString* goodsNumber;

@end
