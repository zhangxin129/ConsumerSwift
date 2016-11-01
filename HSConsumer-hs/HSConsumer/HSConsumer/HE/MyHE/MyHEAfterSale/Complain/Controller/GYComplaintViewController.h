//
//  GYComplaintViewController.h
//  HSConsumer
//
//  Created by kuser on 16/4/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYComplaintViewController : GYViewController

@property (weak, nonatomic) IBOutlet UIButton* commitBtn;
@property (nonatomic, copy) NSString* refId;
@property (nonatomic, copy) NSString* orderId;

@end
