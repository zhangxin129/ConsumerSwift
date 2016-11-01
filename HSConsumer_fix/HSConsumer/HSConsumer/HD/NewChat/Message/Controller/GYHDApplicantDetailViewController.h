//
//  GYHDApplicantDetailViewController.h
//  HSConsumer
//
//  Created by shiang on 16/4/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDApplicantListModel.h"

//@class GYHDApplicantListModel;
@interface GYHDApplicantDetailViewController : UIViewController
/**用户申请详细*/
@property (nonatomic, strong) GYHDApplicantListModel* model;
@property (nonatomic, strong)NSDictionary *infoDict;
//@property(nonatomic, copy)NSString *infoString;

@end
