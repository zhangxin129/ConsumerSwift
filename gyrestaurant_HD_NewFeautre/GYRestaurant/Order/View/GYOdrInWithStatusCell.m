//
//  GYOdrInWithStatusCell.m
//  GYRestaurant
//
//  Created by apple on 15/12/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOdrInWithStatusCell.h"
#import "FoodListInModel.h"
@interface GYOdrInWithStatusCell ()

@property (weak, nonatomic) IBOutlet UIImageView *foodImView;
@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgCoinPrice;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgCoinAmount;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgPV;
@property (weak, nonatomic) IBOutlet UILabel *pvLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end


@implementation GYOdrInWithStatusCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    [self addBottomBorder];
//    [self setBottomBorderInset:YES];
    self.customBorderType = UIViewCustomBorderTypeBottom;
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
                [self.foodImView setImage:[UIImage imageNamed:@"dafauftPicture"]];
            }else{
                [self.foodImView setImageWithURL:[NSURL URLWithString:url] placeholder:nil options:kNilOptions completion:nil];
            }

            
        }else {
            [self.foodImView setImage:[UIImage imageNamed:@"dafauftPicture"]];
            
        }
        self.foodNameLabel.text = model.foodName;
        self.amountLabel.text = [NSString stringWithFormat:@"%.2f",[model.foodPrice floatValue]*[model.foodNum floatValue]];
        self.priceLabel.text = model.foodPrice;
        self.pvLabel.text = [NSString stringWithFormat:@"%.2f",[model.foodPv floatValue]*[model.foodNum floatValue]];
        self.numLabel.text = model.foodNum;
        self.sizeLabel.text = model.foodSpec.pVName;
        self.statusLabel.text = model.foodState;
    }
}


-(void)updateConstraints{
    [super updateConstraints];
    [self.contentView removeConstraints:[self.contentView constraints]];
    
    float width = (kScreenWidth-80)/7;
    
    [self.foodImView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.mas_top).offset(15);
        make.height.equalTo(@70);
        make.width.equalTo(@70);
    }];
    
    
    [self.foodNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(90);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@(width + 30));
    }];
  //  self.foodNameLabel.adjustsFontSizeToFitWidth = YES;
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(80 + width + 30);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@(width - 30));
    }];
    self.sizeLabel.adjustsFontSizeToFitWidth = YES;
    [self.imgCoinPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(80 + width *2 + 10);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@21);
    }];

    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(80 + width *2 +21 + 10);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@(width - 21 - 10));
    }];
    self.priceLabel.adjustsFontSizeToFitWidth = YES;
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(80 + width * 3);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@(width));
    }];
    self.numLabel.adjustsFontSizeToFitWidth = YES;
   
    [self.imgCoinAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(80 + width *4 + 10);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@21);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(80 + width *4 + 21 + 10);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@(width - 21 - 10));
    }];
    self.amountLabel.adjustsFontSizeToFitWidth= YES;
    
    
    [self.imgPV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(80 + width *5 + 10);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@21);
    }];
    
    [self.pvLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(80 + width *5 + 27 + 10);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@(width - 27 - 10));
    }];
    self.pvLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(80 + width * 6 );
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@(width));
    }];
    self.statusLabel.adjustsFontSizeToFitWidth =YES;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
