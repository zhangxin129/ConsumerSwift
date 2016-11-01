//
//  GYDatePiker.h
//  Buding
//
//  Created by 00 on 14-11-3.
//  Copyright (c) 2014年 00. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYDatePikerDelegate <NSObject>

- (void)getDate:(NSString*)date WithDate:(NSDate*)date;

@end
@interface GYDatePiker : UIView

@property (nonatomic, strong) NSDate* selectDate;

@property (nonatomic, weak) id<GYDatePikerDelegate> delegate; //代理

- (id)initWithFrame:(CGRect)frame date:(NSDate*)date;

- (void)noMaxTime;
@end
