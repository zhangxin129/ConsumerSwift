//
//  GYEasybuyOneDownView.h
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/3/30.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYEasybuyOneDownView;

@protocol GYEasybuyOneDownViewDelegate <NSObject>

- (void)easybuyOneDownTabViewDidSelected:(GYEasybuyOneDownView*)easybuyOneDownView Index:(NSInteger)index withArray:(NSArray*)arr;

@end

@interface GYEasybuyOneDownView : UIView

@property (nonatomic, weak) id<GYEasybuyOneDownViewDelegate> delegate;
@property (nonatomic, strong) NSArray* array;

@property (nonatomic, copy) NSString* tabViewCellKey;

@property (nonatomic, weak) UITableView* tabView;

@property (nonatomic, assign) BOOL hasHeight;

- (instancetype)initWithFrame:(CGRect)frame withCellName:(NSString*)cellName withFooterView:(UIView*)footer;

@end
