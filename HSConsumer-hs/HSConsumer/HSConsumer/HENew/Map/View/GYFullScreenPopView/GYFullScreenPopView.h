//
//  GYFullScreenPopView.h
//  GYFullScreenPopView
//
//  Created by xiaoxh on 16/9/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYFullScreenPopDelegate <NSObject>
@optional
-(void)fullcityName:(NSString*)cityName  nsAray:(NSMutableArray*)array;


@end
@interface GYFullScreenPopView : UIView
-(void)show;

@property(nonatomic,weak)id<GYFullScreenPopDelegate> delegate;
@end
