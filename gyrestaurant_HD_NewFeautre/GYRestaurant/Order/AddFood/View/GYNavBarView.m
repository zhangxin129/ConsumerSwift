//
//  GYAddFoodHeaderView.m
//  GYRestaurant
//
//  Created by apple on 15/10/28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYNavBarView.h"
#import "GYTakeOrderTool.h"
@interface GYNavBarView()<UITextFieldDelegate,UISearchBarDelegate>
{
    UITextField *tfSearch;
}
@end

@implementation GYNavBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addFoodnotification) name:GYAddFoodChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addFoodnotification) name:GYAddFoodCollecionViewChangeNotification object:nil];
    }
    return self;
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GYAddFoodCollecionViewChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GYAddFoodChangeNotification object:nil];
}

- (void)setup
{
    UIButton *gybtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gybtn.frame = CGRectMake(0, 15, 150, 44);
    [gybtn setImage:[UIImage imageNamed:@"40back"] forState:UIControlStateNormal];
    [gybtn setImage:[UIImage imageNamed:@"40back+"] forState:UIControlStateHighlighted];
    [gybtn setTitle:kLocalized(@"AddMenu") forState:UIControlStateNormal];
    [gybtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [gybtn addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    gybtn.imageEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 120);
    gybtn.titleLabel.font = [UIFont systemFontOfSize:kBackFont];
    [self addSubview:gybtn];
    
    UILabel *lbOrderNumber = [[UILabel alloc] initWithFrame:CGRectMake(136, 20, 80, 44)];
//    lbOrderNumber.font = [UIFont systemFontOfSize:20.0];
    lbOrderNumber.text = kLocalized(@"ordernumber");
    lbOrderNumber.adjustsFontSizeToFitWidth = YES;
    lbOrderNumber.textColor = [UIColor lightGrayColor];
    lbOrderNumber.textAlignment = NSTextAlignmentRight;
    [self addSubview:lbOrderNumber];
    
    UILabel *lbShowOrderNumber = [[UILabel alloc] initWithFrame:CGRectMake(216, 20, 210, 44)];
//    lbShowOrderNumber.font = [UIFont systemFontOfSize:20.0];
    lbShowOrderNumber.adjustsFontSizeToFitWidth = YES;
    lbShowOrderNumber.textColor = [UIColor lightGrayColor];
    lbShowOrderNumber.textAlignment = NSTextAlignmentLeft;
    [self addSubview:lbShowOrderNumber];
    self.lbShowOrderNumber = lbShowOrderNumber;
    
    UILabel *lbOrderPrice = [[UILabel alloc] initWithFrame:CGRectMake(406, 20, 80, 44)];
//    lbOrderNumber.font = [UIFont systemFontOfSize:20.0];
    lbOrderPrice.adjustsFontSizeToFitWidth = YES;
    lbOrderPrice.text = kLocalizedAddParams(kLocalized(@"OrderAmount"), @":");
    lbOrderPrice.textColor = [UIColor lightGrayColor];
    lbOrderPrice.textAlignment = NSTextAlignmentRight;
    [self addSubview:lbOrderPrice];
    
    UIImageView *imgPrice = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"coin.png"]];
    imgPrice.frame = CGRectMake(486, 33, 20, 20);
    [self addSubview:imgPrice];
    
    UILabel *lbShowOrderPrice = [[UILabel alloc] initWithFrame:CGRectMake(506, 20, 80, 44)];
    lbShowOrderPrice.adjustsFontSizeToFitWidth = YES;
    lbShowOrderPrice.textColor = kRedFontColor;
    lbShowOrderPrice.textAlignment = NSTextAlignmentLeft;
    [self addSubview:lbShowOrderPrice];
    self.lbShowOrderPrice = lbShowOrderPrice;
    
    UITextField *searchTF = [[UITextField alloc] initWithFrame:CGRectMake(kScreenWidth - 440 , 20, 270, 40)];
    searchTF.delegate = self;
    searchTF.placeholder = kLocalized(@"Pleaseenteraproductnameorphoneticcode");
    [searchTF setBackground:[UIImage imageNamed:@"Query-2"]];
    [searchTF addTarget:self action:@selector(searchFoodAAA:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:searchTF];


    UIButton *btnAddFood=[UIButton buttonWithType:UIButtonTypeCustom];
    btnAddFood.frame = CGRectMake(kScreenWidth - 150, 20, 130, 40);
    [btnAddFood setTitle:kLocalized(@"ConfirmAddDish") forState:UIControlStateNormal];
    btnAddFood.titleLabel.font = [UIFont systemFontOfSize:25.0];
    [btnAddFood setBackgroundImage:[UIImage imageNamed:@"placeOrder"] forState:UIControlStateNormal];
        [btnAddFood addTarget:self action:@selector(addFood:dishNum:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnAddFood];
    
}
- (void)addFoodnotification

{
    int i = [GYTakeOrderTool getTakeListNum];
    self.sum = i;

}

- (void)addFood:(UIButton *)button dishNum:(int)dishNum
{
    if ([self.delegate respondsToSelector:@selector(GYNavBarViewAddFood:dishNum:)]) {
        button.enabled = NO;
        [self.delegate GYNavBarViewAddFood:button dishNum:self.sum];
        button.enabled = YES;
    }
}
- (void)popBack
{
    if ([self.delegate respondsToSelector:@selector(GYNavBarViewpopBack)]) {
        [self.delegate GYNavBarViewpopBack];
    }
}

- (void)searchFoodAAA:(UITextField *)searchTF
{

    if ([self.delegate respondsToSelector:@selector(GYNavBarViewAddsearchFoodAAA:)]) {
        [self.delegate GYNavBarViewAddsearchFoodAAA:[searchTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }
}


@end
