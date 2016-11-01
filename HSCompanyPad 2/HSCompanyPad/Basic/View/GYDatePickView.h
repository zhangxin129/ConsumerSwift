//
//  GYDatePickView.h
//  HSCompanyPad
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 wangbb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DatePickViewType) {
    DatePickViewTypeYear,
    DatePickViewTypeDate,
    DatePickViewTypeDateAndTime
};

typedef void(^ComfirmBlock)(NSString *dateString);

/*!
 *日期视图
 */
@interface GYDatePickView : UIView

-(instancetype)initWithDatePickViewType:(DatePickViewType)type;
- (void)show;
@property (nonatomic, copy) ComfirmBlock dateBlcok;

@end
