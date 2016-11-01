//
//  GYHETakeDishesCollectionViewCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHETakeDishesCollectionViewCell.h"
#import "GYNotificationHub.h"

@interface GYHETakeDishesCollectionViewCell()

@property(nonatomic, strong) UILabel *foodNameLable;
@property(nonatomic, strong) UILabel *foodPriceLable;
@property(nonatomic, strong) UILabel *foodPointLable;
@property(nonatomic, strong) UIImageView *foodPriceImageView;
@property(nonatomic, strong) UIImageView *foodPointImageView;
@property (nonatomic, strong) GYNotificationHub  *hubMsg;

@end
@implementation GYHETakeDishesCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.0f;
    self.backgroundColor = [UIColor colorWithRed:241/255.0 green:242/255.0 blue:244/255.0 alpha:1.0];
    
    self.foodNameLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, self.frame.size.width - 20, 30)];
    self.foodNameLable.text = @"湘味啤酒鸭";
    self.foodNameLable.textAlignment = NSTextAlignmentLeft;
    self.foodNameLable.font = [UIFont systemFontOfSize:18];
    self.foodNameLable.textColor = [UIColor grayColor];
    [self addSubview:self.foodNameLable];
    
    self.foodPriceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.foodNameLable.frame) + 10, 15, 15)];
    [self.foodPriceImageView setImage:[UIImage imageNamed:@"gyhe_coin_icon"]];
    [self addSubview:self.foodPriceImageView];
    
    self.foodPriceLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.foodPriceImageView.frame), CGRectGetMaxY(self.foodNameLable.frame) + 8, 40, 20)];
    self.foodPriceLable.textAlignment = NSTextAlignmentLeft;
    self.foodPriceLable.textColor = [UIColor redColor];
    self.foodPriceLable.text = @"100.00";
    self.foodPriceLable.font = [UIFont systemFontOfSize:10];
    [self addSubview:self.foodPriceLable];
    
    self.foodPointImageView =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.foodPriceLable.frame) + 5, CGRectGetMaxY(self.foodNameLable.frame) + 10, 15, 15)];
    [self.foodPointImageView setImage:[UIImage imageNamed:@"gyhe_point_icon"]];
    [self addSubview:self.foodPointImageView];
    
    self.foodPointLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.foodPointImageView.frame), CGRectGetMaxY(self.foodNameLable.frame) + 8, 50, 20)];
    self.foodPointLable.textAlignment = NSTextAlignmentLeft;
    self.foodPointLable.textColor = [UIColor blueColor];
    self.foodPointLable.text = @"100.00";
    self.foodPointLable.font = [UIFont systemFontOfSize:10];
    [self addSubview:self.foodPointLable];
    self.hubMsg = [[GYNotificationHub alloc] initWithView:self];
    [self.hubMsg moveCircleByX:0 Y:0];
    self.hubMsg.count = self.num;
    [self.hubMsg showCount];

    }


@end
