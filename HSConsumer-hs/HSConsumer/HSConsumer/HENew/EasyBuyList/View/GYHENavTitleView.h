//
//  GYHENavTitleView.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHENavTitleViewDelegate <NSObject>
@optional
-(void)cityBtn;
-(void)search;
@end
@interface GYHENavTitleView : UIView
@property (weak, nonatomic) IBOutlet UIView *nationalView;
@property (weak, nonatomic) IBOutlet UIButton *localBtn;


@property (weak, nonatomic) IBOutlet UIView *localView;
@property (weak, nonatomic) IBOutlet UIButton *nationalBtn;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;

@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (nonatomic,weak)id<GYHENavTitleViewDelegate> delegate;
@end
