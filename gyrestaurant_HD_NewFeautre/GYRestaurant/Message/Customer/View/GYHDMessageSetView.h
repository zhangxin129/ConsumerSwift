//
//  GYHDMessageSetView.h
//  GYRestaurant
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GYHDMessageSetViewDelegate <NSObject>
-(void)backPersonInfo;
@end

@interface GYHDMessageSetView : UIView
@property(nonatomic,weak)id <GYHDMessageSetViewDelegate> delegate;
@end
