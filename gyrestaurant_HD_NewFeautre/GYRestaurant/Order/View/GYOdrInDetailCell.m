//
//  GYOdrInDetailCell.m
//  GYRestaurant
//
//  Created by ios007 on 15/10/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOdrInDetailCell.h"
#import "FoodListInModel.h"
#import "NSObject+HXAddtions.h"

@interface GYOdrInDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *foodImgView;//食物图
@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel;//食物名称
@property (weak, nonatomic) IBOutlet UILabel *specificationsLabel;//规格
@property (weak, nonatomic) IBOutlet UIImageView *imgPrice;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//单价
@property (weak, nonatomic) IBOutlet UILabel *foodNumLabel;//数量
@property (weak, nonatomic) IBOutlet UIImageView *imgAmount;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;//金额
@property (weak, nonatomic) IBOutlet UIImageView *imgPv;
@property (weak, nonatomic) IBOutlet UILabel *pvLabel;//积分
@property (weak, nonatomic) IBOutlet UILabel *stautLabel;//状态

@end

@implementation GYOdrInDetailCell

-(void)layoutSubviews{
    [super layoutSubviews];
//    [self addBottomBorder];
//    [self setBottomBorderInset:YES];
    self.customBorderType = UIViewCustomBorderTypeBottom;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setModel:(FoodListInModel *)model{

    if (_model != model) {
        _model = model;
        
        self.foodNameLabel.text = model.foodName;
        if (model.picUrl.length > 0) {
            NSData *data = [model.picUrl dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSDictionary *dic = arr.firstObject;
            
            NSString *url = [NSString stringWithFormat:@"%@%@",picHttpUrl,dic[@"name"]];
            NSString *picNameStr = [dic[@"name"] substringToIndex:4];
            if ([picNameStr isEqualToString:@"null"]) {
                [self.foodImgView setImage:[UIImage imageNamed:@"dafauftPicture"]];
            }else{
                [self.foodImgView setImageWithURL:[NSURL URLWithString:url] placeholder:nil options:kNilOptions completion:nil];
            }

            
        }else {
            [self.foodImgView setImage:[UIImage imageNamed:@"dafauftPicture"]];
        
        }
   
              // self.foodImgView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.foodNumLabel.text = model.foodNum;

        self.priceLabel.text = model.foodPrice;
        self.priceLabel.tintColor = kRedFontColor;
        
        
        float sumPv = [model.foodNum floatValue] *[model.foodPv floatValue];
        if (self.deleteBtn.hidden == NO) {
            self.amountLabel.text = [NSString stringWithFormat:@"%.2f",[model.foodPrice floatValue]*[model.foodNum floatValue]];
            self.pvLabel.text = [NSString stringWithFormat:@"%.2f",sumPv];
          //  self.pvLabel.tintColor = kBlueFontColor;
          self.pvLabel.tintColor = kBlueFontColor;
        }else{
            self.amountLabel.text = @"0.00";
            self.pvLabel.text = @"0.00";
            self.pvLabel.tintColor = kBlueFontColor;
        }
        
        self.stautLabel.text = model.foodState;
        self.specificationsLabel.text = model.foodSpec.pVName;
 
    }
}

- (IBAction)deleteBtn:(UIButton *)sender {
    if ([self.delagete respondsToSelector:@selector(deleteFoodId:)]) {
        [self.delagete deleteFoodId:self.model];
    }
}

-(void)updateConstraints
{
    [super updateConstraints];
    
    [self.contentView removeConstraints:[self.contentView constraints]];
    float width = (kScreenWidth-80)/8;
    
    [self.foodImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.mas_top).offset(15);
        make.height.equalTo(@70);
        make.width.equalTo(@70);
    }];
    
    [self.foodNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(90);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@(width));
    }];
 //   self.foodNameLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.specificationsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(80 + width);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@(width));
    }];
    self.specificationsLabel.adjustsFontSizeToFitWidth = YES;
    [self.imgPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(80 + width *2 + 20);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@21);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(80 + width *2 + 20 +21);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@(width - 20 - 21));
    }];
    self.priceLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.foodNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(80 + width *3);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@(width));
    }];
    self.foodNumLabel.adjustsFontSizeToFitWidth = YES;
    [self.imgAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(80 + width *4 + 20);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@21);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(80 + width *4 + 20 + 21);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@(width - 20 - 21));
    }];
    self.amountLabel.adjustsFontSizeToFitWidth = YES;
    [self.imgPv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(80 + width *5 + 20);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@27);
    }];
    
    [self.pvLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(80 + width *5 + 20 +27);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@(width - 27 - 20));
    }];
    self.pvLabel.adjustsFontSizeToFitWidth = YES;
    [self.stautLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(80 + width *6);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@(width - 40));
    }];
  //  self.stautLabel.adjustsFontSizeToFitWidth = self;
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(80 + width *7);
        make.top.equalTo(self.mas_top).offset(35);
        make.height.equalTo(@30);
        make.width.equalTo(@(width - 40));
    }];
    
  
}

@end
