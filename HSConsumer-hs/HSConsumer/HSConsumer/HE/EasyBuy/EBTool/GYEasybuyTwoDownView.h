//
//  GYEasybuyTwoDownView.h
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/3/30.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEasybuyOneDownView.h"

@class GYEasybuyTwoDownView;

@protocol GYEasybuyTwoDownViewDelegate <NSObject>

- (void)firstTabViewDidSelect:(GYEasybuyTwoDownView*)easybuyTwoDownView Index:(NSInteger)index withArray:(NSArray*)arr;
- (void)secondTabViewDidSelect:(GYEasybuyTwoDownView*)easybuyTwoDownView Index:(NSInteger)index withArray:(NSArray*)arr;

@end

@interface GYEasybuyTwoDownView : UIView

@property (nonatomic, weak) id<GYEasybuyTwoDownViewDelegate> delegate;
@property (nonatomic, strong) NSArray* firstArray;
@property (nonatomic, strong) NSArray* secondArray;

@property (nonatomic, copy) NSString* oneTabViewCellKey;
@property (nonatomic, copy) NSString* twoTabViewCellKey;

@property (nonatomic, copy) NSString* secondCellName;

@property (nonatomic, strong) GYEasybuyOneDownView* firstTabView;
@property (nonatomic, strong) GYEasybuyOneDownView* secondTabView;

@property (nonatomic, assign) NSInteger currentSelectIndex;

- (instancetype)initWithFrame:(CGRect)frame withFirstCellName:(NSString*)cellName withFirstViewWidth:(float)width;

@end
