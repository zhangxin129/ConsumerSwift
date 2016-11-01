//
//  GYHDNewMarkViewController.h
//  HSConsumer
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHDContactsMarkListModel;
@interface GYHDNewMarkViewController : GYViewController

///**分类名字*/
//@property(nonatomic, copy)NSString *teamID;
//@property(nonatomic, copy)NSString *teamName;
@property(nonatomic, strong)GYHDContactsMarkListModel *model;
@end
