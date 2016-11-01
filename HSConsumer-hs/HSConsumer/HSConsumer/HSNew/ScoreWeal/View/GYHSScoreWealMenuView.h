//
//  GYHSScoreWealMenuView.h
//  HSConsumer
//
//  Created by lizp on 16/9/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSScoreWealMenuViewDelegate<NSObject>

@optional

-(void)selectLeftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex;

@end

@interface GYHSScoreWealMenuView : UIView

@property (nonatomic,weak) id<GYHSScoreWealMenuViewDelegate>delegate;


-(instancetype)initWithFrame:(CGRect)frame LeftTitle:(NSArray<NSString *> *)leftTitle rightTitle:(NSArray<NSString *> *)rightTitle;

@end
