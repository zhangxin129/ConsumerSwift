//
//  GYHDCustomerInfoView.h
//  HSEnterprise
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDCustomerDetailModel.h"
@protocol GYHDCustomerInfoViewDelegate <NSObject>
-(void)uploadImg;
-(void)loadSetView;
@end
@interface GYHDCustomerInfoView : UIView
@property(nonatomic,strong)GYHDCustomerDetailModel*model;
@property(nonatomic,strong) UIImageView *iconsImageView ;
@property(nonatomic,weak)id <GYHDCustomerInfoViewDelegate> delegate;
@property(nonatomic,strong) UIView *setView;
@end
