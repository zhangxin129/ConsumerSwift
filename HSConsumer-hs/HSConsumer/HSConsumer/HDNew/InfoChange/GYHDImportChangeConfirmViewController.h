//
//  GYHDImportChangeConfirmViewController.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/18.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHDImportChangeConfirmViewController : GYViewController

@property (nonatomic, strong) NSMutableDictionary* oldmdictParams;
@property (nonatomic, strong) NSMutableArray* changeItem;
@property (nonatomic, strong) NSMutableDictionary* dictInside;
@property (nonatomic, copy) NSString* strCreFaceUrl;
@property (nonatomic, copy) NSString* strCreBackUrl;
@property (nonatomic, copy) NSString* strCreHoldUrl;
@property (nonatomic, copy) NSString* strCreOtherFileUrl; //户籍地址变更

@end
