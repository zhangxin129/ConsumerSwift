//
//  GYAddFoodCell.m
//  GYRestaurant
//
//  Created by apple on 15/10/28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAddFoodCell.h"
#import "GYNotificationHub.h"
#import "GYSyncShopFoodsModel.h"
#import "GYPicUrlModel.h"
#import "GYFoodSpecModel.h"
#import "GYNameAndSizeModel.h"
#import "GYTakeOrderTool.h"
@interface GYAddFoodCell()

@property (nonatomic, weak) UIImageView *imgPicUrl;
@property (nonatomic, weak) UIButton *btnReduction;
@property (nonatomic, weak) UIButton *btnPlus;
@property (nonatomic, weak) UILabel *lbFoodName;
@property (nonatomic, weak) UIImageView *imgFoodPrice;
@property (nonatomic, weak) UILabel *lbFoodPrice;
@property (nonatomic, weak) UIImageView *imgFoodPv;
@property (nonatomic, weak) UILabel *lbFoodPv;
@property (nonatomic, strong) GYNotificationHub *hubMsg;
@end
@implementation GYAddFoodCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        
    }
    return self;
}

- (void)setup
{
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UIImageView *imgPicUrl = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 125)];
    imgPicUrl.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imgPicUrl];
    self.imgPicUrl = imgPicUrl;
    imgPicUrl.layer.borderWidth = 1;
    imgPicUrl.layer.borderColor = [UIColor lightGrayColor].CGColor;

    UILabel *lbFoodName = [[UILabel alloc]init];
    lbFoodName.frame = CGRectMake(10, self.frame.size.height - 110, self.frame.size.width - 20, 45);
    lbFoodName.textColor = [UIColor darkGrayColor];
    lbFoodName.font = [UIFont systemFontOfSize:24.0];
    lbFoodName.backgroundColor = [UIColor clearColor];
    [self addSubview:lbFoodName];
    self.lbFoodName = lbFoodName;
    
    UIImageView *imgFoodPrice = [[UIImageView alloc]init];
    imgFoodPrice.image = [UIImage imageNamed:@"currency.png"];
    imgFoodPrice.frame = CGRectMake(10, self.frame.size.height - 40, 20, 20);
    [self addSubview:imgFoodPrice];
    self.imgFoodPrice = imgFoodPrice;
    
    UILabel *lbFoodPrice = [[UILabel alloc]init];
    lbFoodPrice.frame = CGRectMake(30, self.frame.size.height - 45, (self.frame.size.width - 60) / 2, 30);
    lbFoodPrice.adjustsFontSizeToFitWidth = YES;
    lbFoodPrice.textColor = kRedFontColor;
    [self addSubview:lbFoodPrice];
    self.lbFoodPrice = lbFoodPrice;
    
    UIImageView *imgFoodPv = [[UIImageView alloc]init];
    imgFoodPv.frame = CGRectMake(CGRectGetMaxX(lbFoodPrice.frame), self.frame.size.height - 37, 20, 15);
    imgFoodPv.image = [UIImage imageNamed:@"PV.png"];
    [self addSubview:imgFoodPv];
    self.imgFoodPv = imgFoodPv;
    
    UILabel *lbFoodPv = [[UILabel alloc]init];
    lbFoodPv.frame = CGRectMake(CGRectGetMaxX(imgFoodPv.frame), self.frame.size.height - 45, (self.frame.size.width - 60) / 2, 30);
    lbFoodPv.textColor = kBlueFontColor;
    lbFoodPv.adjustsFontSizeToFitWidth = YES;
    [self addSubview:lbFoodPv];
    self.lbFoodPv = lbFoodPv;
    
    GYNotificationHub *hubMsg = [[GYNotificationHub alloc]initWithView:self];
    [hubMsg moveCircleByX:-15 Y:15]; // moves the circle five pixels left and 5 down
    [hubMsg increment];
    [hubMsg hideCount]; // uncomment for a blank
    self.hubMsg = hubMsg;
}

-(void)setModel:(GYSyncShopFoodsModel *)model
{
    _model = model;
    
    self.lbFoodName.text = model.foodName;
    if (model.foodSpec.count == 0) {
        self.lbFoodPrice.text = model.foodPrice;
        self.lbFoodPv.text = model.foodPv;
    }else{
        float price, pv, tempPrice = 1000000, tempPv = 1000000;
        for (GYFoodSpecModel *foodModel in model.foodSpec) {
            price = [foodModel.price floatValue];
            pv = [foodModel.auction floatValue];
            tempPrice = MIN(price, tempPrice);
            tempPv = MIN(pv, tempPv);
        }
        self.lbFoodPrice.text = [NSString stringWithFormat:@"%.2f起",tempPrice];
        self.lbFoodPv.text = [NSString stringWithFormat:@"%.2f起",tempPv];
    }
    GYPicUrlModel *m  = model.picUrl[0];
    GYNameAndSizeModel *nsModel = m.pad[0];
    self.hubMsg.count = [GYTakeOrderTool getAllFoodNumWithModel:model];
    [self.hubMsg showCount];

    NSString *strUrl = [picHttpUrl stringByAppendingString:kSaftToNSString(nsModel.name)];
    [self.imgPicUrl setImageWithURL:[NSURL URLWithString:strUrl] placeholder:[UIImage imageNamed:@"dafauftPicture"] options:kNilOptions completion:nil];
}

@end
