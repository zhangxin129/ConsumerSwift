//
//  GYEasybuyShopAddressViewController.h
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYEasybuyShopAddressViewController : GYViewController

@property (nonatomic, copy) NSString* itemId;
@property (nonatomic, copy) void (^blockAddress)(NSString*);

@end
