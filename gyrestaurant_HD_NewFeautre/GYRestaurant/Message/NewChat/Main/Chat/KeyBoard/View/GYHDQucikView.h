//
//  GYHDQucikView.h
//  GYRestaurant
//
//  Created by apple on 16/6/24.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GYHDQucikViewDelegate <NSObject>
- (void)GYHDQucikViewSelectQucikString:(NSString *)QucikString;
@end
@interface GYHDQucikView : UIView
@property(nonatomic,weak)id<GYHDQucikViewDelegate> delegate;
@end
