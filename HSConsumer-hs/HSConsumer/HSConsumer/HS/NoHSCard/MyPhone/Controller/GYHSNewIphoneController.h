//
//  GYHSNewIphoneController.h
//  HSConsumer
//
//  Created by liss on 16/4/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHSNewIphoneController : GYViewController
@property (weak, nonatomic) IBOutlet UILabel* iphone;
@property (weak, nonatomic) IBOutlet UILabel* isSeting;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* isSetingConstraint;
@property (weak, nonatomic) IBOutlet UIImageView* image;
@property (weak, nonatomic) IBOutlet UIButton* btn;
@property (nonatomic, copy) NSString* iphonestr;
@property (nonatomic, copy) NSString* ipSetStr;
@property (nonatomic, copy) NSString* imageName;
@property (nonatomic, assign) float setFloat;
@property (nonatomic, assign) BOOL isbtnH;
@end
