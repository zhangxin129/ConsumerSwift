//
//  GYHDContactsDetialView.h
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDOpereotrListModel.h"
typedef void (^sendMessageBlock) (NSString*custId);
@interface GYHDContactsDetialView : UIView
@property(nonatomic,strong)GYHDOpereotrListModel*model;
@property(nonatomic,copy)sendMessageBlock block;
@end
