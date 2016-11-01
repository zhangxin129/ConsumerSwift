//
//  GYListCell.m
//  GYRestaurant
//
//  Created by apple on 15/10/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYListCell.h"
#import "GYTakeOrderListModel.h"
#import "GYLoginViewModel.h"
#import "GYSyncShopFoodsModel.h"
#import "GYFoodSpecModel.h"
#include "FoodListInModel.h"

@interface GYListCell ()
@property (weak, nonatomic) IBOutlet UILabel *numLable;
@property (weak, nonatomic) IBOutlet UILabel *classLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UILabel *pointLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *stateLable;
@property (weak, nonatomic) IBOutlet UIImageView *coinView;
@property (weak, nonatomic) IBOutlet UIImageView *pointView;

@property (nonatomic, strong) GYSyncShopFoodsModel *model;
//@property (nonatomic, strong) GYFoodSpecModel *mo;
@end

@implementation GYListCell

-(void)layoutSubviews{
    
//    self.numLable.adjustsFontSizeToFitWidth = YES;
//    self.classLable.adjustsFontSizeToFitWidth = YES;
//    self.nameLable.adjustsFontSizeToFitWidth = YES;
//    self.priceLable.adjustsFontSizeToFitWidth = YES;
//    self.pointLable.adjustsFontSizeToFitWidth = YES;
//    self.timeLable.adjustsFontSizeToFitWidth = YES;
//    self.stateLable.adjustsFontSizeToFitWidth = YES;
    
    [super layoutSubviews];
//    [self addBottomBorder];
//    [self setBottomBorderInset:YES];
    self.customBorderType = UIViewCustomBorderTypeBottom;
}

- (void)updateConstraints
{
    [super updateConstraints];
         [self.contentView removeConstraints:[self.contentView constraints]];
    
    float numLableW = 80;
    float classLableW = 65;
    float nameLableW = 101;
    float sizeLableW = 50;
    float priceLableW = 100;
    float pointLableW = 80;
    float timeLableW = 130;
    float stateLableW = 90;
    
    
     float x = (kScreenWidth - 0.15 * kScreenWidth - numLableW -classLableW - nameLableW-sizeLableW - priceLableW- pointLableW - timeLableW - stateLableW)/8;
    
    
    [self.numLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.top.equalTo(self.mas_top).offset(21);
        make.height.equalTo(@21);
        make.width.equalTo(@(numLableW));
        
    }];
    self.numLable.adjustsFontSizeToFitWidth = YES;
    
    [self.classLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( x + numLableW );
        make.top.equalTo(self.mas_top).offset(21);
        make.height.equalTo(@21);
        make.width.equalTo(@(classLableW));
        
    }];
  //  self.classLable.adjustsFontSizeToFitWidth = YES;
    
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8 + 2 * x + numLableW + classLableW );
        make.top.equalTo(self.mas_top).offset(21);
        make.height.equalTo(@21);
        make.width.equalTo(@(nameLableW));
        
    }];
  //  self.nameLable.adjustsFontSizeToFitWidth = NO;
    
    [self.sizeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( 3 * x + numLableW + classLableW +nameLableW + 20);
        make.top.equalTo(self.mas_top).offset(21);
        make.height.equalTo(@21);
        make.width.equalTo(@(sizeLableW));
        
    }];
   self.sizeLable.adjustsFontSizeToFitWidth = YES ;
    
    [self.coinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(4 * x + numLableW + classLableW + nameLableW + sizeLableW + 55);
        make.top.equalTo(self.mas_top).offset(21);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
        
    }];
    
    
    [self.priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(4 * x + numLableW + classLableW + nameLableW + sizeLableW + 75);
        make.top.equalTo(self.mas_top).offset(21);
        make.height.equalTo(@21);
        make.width.equalTo(@(priceLableW));
        
    }];
    self.priceLable.adjustsFontSizeToFitWidth = YES;
    
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5 * x + numLableW + classLableW + nameLableW + sizeLableW + priceLableW + 35);
        make.top.equalTo(self.mas_top).offset(24);
        make.height.equalTo(@15);
        make.width.equalTo(@(15));
        
    }];
    
    [self.pointLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5 * x + numLableW + classLableW + nameLableW + sizeLableW + priceLableW + 55);
        make.top.equalTo(self.mas_top).offset(21);
        make.height.equalTo(@21);
        make.width.equalTo(@(pointLableW));
        
    }];
    self.pointLable.adjustsFontSizeToFitWidth = YES;
    
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(6 * x + numLableW + nameLableW + classLableW + sizeLableW + priceLableW + pointLableW + 10);
        make.top.equalTo(self.mas_top).offset(21);
        make.height.equalTo(@21);
        make.width.equalTo(@(timeLableW));
        
    }];
    self.timeLable.adjustsFontSizeToFitWidth = YES;
    
    [self.stateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(21);
        make.height.equalTo(@21);
        make.width.equalTo(@(classLableW));
        make.left.equalTo(self.mas_left).offset(7 * x + numLableW + nameLableW + classLableW + sizeLableW + priceLableW + pointLableW + timeLableW + 5);
        
    }];
    self.stateLable.adjustsFontSizeToFitWidth = YES;
}




-(void)fillCellWithModel:(GYSyncShopFoodsModel *)model{
    
    if (_model != model) {
        _model = model;
    }
    
    

    GYLoginViewModel *viewModel = [[GYLoginViewModel alloc]init];
    
   NSArray *arr = (NSArray *) [viewModel  readFromPath:@"getFoodCategoryList" ];
    for (GYTakeOrderListModel *model1 in arr) {
        if ([model1.itemFoodIdList containsObject:model.foodId]) {
           [self.classLable setText:model1.itemCustomCategoryName];
            
        }
    }
    
    [self.numLable setText:[model valueForKey:@"code"]];
    [self.nameLable setText:[model valueForKey:@"foodName"]];
    // [self.sizeLable setText:[model valueForKey:@"foodNum"]];
//    [self.priceLable setText:[model valueForKey:@"foodPrice"]];
//    [self.pointLable setText:[model valueForKey:@"foodPv"]];
//    float time = [[model valueForKey:@"createTime"] floatValue];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:MM"];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
//    NSString *strtime = [formatter stringFromDate:date];
//    [self.timeLable setText:strtime];
    [self.timeLable setText:[model valueForKey:@"createTime"]];
    
    NSString *currentDateStr;
    NSString *str=[model valueForKey:@"createTime"];
    NSTimeInterval time=[str longLongValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time/1000];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    currentDateStr = [dateFormatter stringFromDate: detaildate];
    [self.timeLable setText:currentDateStr];
    
    
    self.stateLable.text = kLocalized(@"AlreadyOnline");

    if (model.foodSpec.count > 0) {
        
        for (GYFoodSpecModel *mo in model.foodSpec) {
            self.sizeLable.text = mo.pVName;
            self.priceLable.text = mo.price;
            self.pointLable.text = mo.auction;
        }
        
    }else{
        
        self.sizeLable.text = @"";
        self.priceLable.text = model.foodPrice;
        self.pointLable.text = model.foodPv;
        
    }
    
    

}

@end
