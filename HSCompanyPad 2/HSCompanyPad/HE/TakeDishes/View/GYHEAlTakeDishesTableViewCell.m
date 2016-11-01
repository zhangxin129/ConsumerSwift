//
//  GYHEAlTakeDishesTableViewCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHEAlTakeDishesTableViewCell.h"
#import "UILabel+Category.h"

typedef NS_ENUM(NSInteger, buttonType) {
    reduceDishButtonType,
    addDishButtonType,
    deleteButtonType,
    recoverButtonType,
};

@interface GYHEAlTakeDishesTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *dishNameLable;
@property (weak, nonatomic) IBOutlet UILabel *dishPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *dishPointLable;
@property (weak, nonatomic) IBOutlet UIButton *reduceDishButton;
@property (weak, nonatomic) IBOutlet UILabel *dishNumLable;
@property (weak, nonatomic) IBOutlet UIButton *addDishButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteAndRecoverButton;
@property (nonatomic, assign) buttonType *type;
@property (nonatomic, assign) NSInteger valueCount;
@property (nonatomic, assign) BOOL status;


@end

@implementation GYHEAlTakeDishesTableViewCell




-(void)updateConstraints{
    [super updateConstraints];
    [self.contentView removeConstraints:[self.contentView constraints]];
    float dishNameLableW = 200;
    float dishPriceLableW = 100;
    float dishPointLableW = 100;
    float reduceDishButtonW = 30;
    float addDishButtonW = 30;
    float dishNumLableW = 40;
    float deleteAndRecoverButtonW = 40;
    float cellH = 30;
    float spaceW = (kScreenWidth - dishNameLableW - dishPriceLableW - dishPointLableW - reduceDishButtonW - dishNumLableW - addDishButtonW - deleteAndRecoverButtonW) / 5;
    
    [self.dishNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.equalTo(@(kDeviceProportion(cellH)));
        make.width.equalTo(@(kDeviceProportion(dishNameLableW)));
    }];
    
    [self.dishPriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20 + spaceW + dishNameLableW);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.equalTo(@(kDeviceProportion(cellH)));
        make.width.equalTo(@(kDeviceProportion(dishPriceLableW)));
    }];
    
    [self.dishPointLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20 + spaceW * 2 + dishNameLableW + dishPriceLableW);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.equalTo(@(kDeviceProportion(cellH)));
        make.width.equalTo(@(kDeviceProportion(dishPointLableW)));
    }];
    
    [self.reduceDishButton setBackgroundImage:[UIImage imageNamed:@"gyhe_reduceBtn_normal"] forState:UIControlStateNormal];
    [self.reduceDishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20 + spaceW * 3 + dishNameLableW + dishPriceLableW + dishPointLableW);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.equalTo(@(kDeviceProportion(cellH)));
        make.width.equalTo(@(kDeviceProportion(reduceDishButtonW)));
    }];
        
    self.dishNumLable.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.dishNumLable.layer.borderWidth = 1.0f;
    self.valueCount = self.dishNumLable.text.intValue;
    [self.dishNumLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20 + spaceW * 3 + dishNameLableW + dishPriceLableW + dishPointLableW + reduceDishButtonW);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.equalTo(@(kDeviceProportion(cellH)));
        make.width.equalTo(@(kDeviceProportion(dishNumLableW)));
    }];
    
    [self.addDishButton setBackgroundImage:[UIImage imageNamed:@"gyhe_addBtn_normal"] forState:UIControlStateNormal];
    [self.addDishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20 + spaceW * 3 + dishNameLableW + dishPriceLableW + dishPointLableW + reduceDishButtonW + dishNumLableW);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.equalTo(@(kDeviceProportion(cellH)));
        make.width.equalTo(@(kDeviceProportion(addDishButtonW)));
    }];
    
    [self.deleteAndRecoverButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.status = YES;
       [self.deleteAndRecoverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20 + spaceW * 4 + dishNameLableW + dishPriceLableW + dishPointLableW + reduceDishButtonW + dishNumLableW + addDishButtonW);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.equalTo(@(kDeviceProportion(cellH)));
        make.width.equalTo(@(kDeviceProportion(deleteAndRecoverButtonW)));
    }];
}



- (IBAction)buttonAction:(UIButton *)sender {
    if (sender == self.reduceDishButton) {
        if (self.valueCount > 0) {
            self.valueCount--;
            if (self.valueCount < 0) {
                
                return;
            }
            self.dishNumLable.text = [@(self.valueCount) stringValue];
        }
    }else if (sender == self.addDishButton){
        self.valueCount++;
        
        self.dishNumLable.text = [@(self.valueCount) stringValue];
    
    }
    
    if(sender == self.deleteAndRecoverButton && self.status == YES){
        
        [self.deleteAndRecoverButton setTitle:kLocalized(@"恢复") forState:UIControlStateNormal];
        [self.deleteAndRecoverButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.reduceDishButton setBackgroundImage:[UIImage imageNamed:@"gyhe_reduceBtn_disable"] forState:UIControlStateNormal];
        self.reduceDishButton.userInteractionEnabled = NO;
        [self.addDishButton setBackgroundImage:[UIImage imageNamed:@"gyhe_addBtn_disable"] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor colorWithRed:248 / 255.0 green:224 / 255.0 blue:225 / 255.0 alpha:1.0];
        self.addDishButton.userInteractionEnabled = NO;
        self.dishNumLable.textColor = [UIColor lightGrayColor];
        self.status = !self.status;
        return;
    }else if (sender == self.deleteAndRecoverButton && self.status == NO)
        
        [self.deleteAndRecoverButton setTitle:kLocalized(@"删除") forState:UIControlStateNormal];
    [self.deleteAndRecoverButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [self.reduceDishButton setBackgroundImage:[UIImage imageNamed:@"gyhe_reduceBtn_normal"] forState:UIControlStateNormal];
    self.reduceDishButton.userInteractionEnabled = YES;
    [self.addDishButton setBackgroundImage:[UIImage imageNamed:@"gyhe_addBtn_normal"] forState:UIControlStateNormal];
    self.addDishButton.userInteractionEnabled = YES;
    self.dishNumLable.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor clearColor];
    self.status = !self.status;
}

@end
