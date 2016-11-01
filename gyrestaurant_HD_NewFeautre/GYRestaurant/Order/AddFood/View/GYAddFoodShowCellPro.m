//
//  GYAddFoodShowCell.m
//  GYRestaurant
//
//  Created by apple on 15/11/2.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAddFoodShowCellPro.h"
#import "GYPicUrlModel.h"
#import "GYNameAndSizeModel.h"
#import "GYFoodSpecModel.h"
#import "GYTakeOrderTool.h"
@interface GYAddFoodShowCellPro()
@property (nonatomic, assign) NSInteger valueCount;
@property (nonatomic, assign) BOOL status;
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lbFoodName;
@property (weak, nonatomic) IBOutlet UILabel *lbSpecifications;

@property (weak, nonatomic) IBOutlet UILabel *lbPrice;

@property (weak, nonatomic) IBOutlet UILabel *lbIntegral;


@property (weak, nonatomic) IBOutlet UIButton *btnDeleteAndRecovery;

@property (weak, nonatomic) IBOutlet UIButton *btnADD;
@property (weak, nonatomic) IBOutlet UIButton *btnReduction;

@property (nonatomic, copy) NSString *strKey;
@end

@implementation GYAddFoodShowCellPro

#pragma mark - 系统方法
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.btnDeleteAndRecovery setTitleColor:kBlueFontColor forState:UIControlStateNormal];
    self.status = YES;
}

- (IBAction)clickBtn:(UIButton *)sender {
    if (sender.tag == 10) {
        if (self.valueCount > 0) {
            self.valueCount--;
            if (self.valueCount < 0) {
                return;
            }
            self.lbNumber.text = [@(self.valueCount) stringValue];
            
            [GYTakeOrderTool saveModelWithCount:self.valueCount model:self.sfModel];
            
        }}
    
    
    if(sender.tag == 11){
//        NSInteger maxFood = [(NSString *)kGetNSUser(@"maxFood")   intValue];
//        if (self.valueCount == maxFood) {
//            self.valueCount = 0 ;
//        }else{
            self.valueCount++;
//        }
        
        
        self.lbNumber.text = [@(self.valueCount) stringValue];
        [GYTakeOrderTool saveModelWithCount:self.valueCount model:self.sfModel];
        
    }
    
    if (sender.tag == 12 && self.status == YES) {
        [self.btnDeleteAndRecovery setTitle:kLocalized(@"Restore") forState:UIControlStateNormal];
        [self.btnDeleteAndRecovery setTitleColor:kRedFontColor forState:UIControlStateNormal];
        self.btnADD.hidden = YES;
        self.btnReduction.hidden = YES;
        self.strKey = [self valueForKey:@"reuseIdentifier"];
        kSetNSUser(self.strKey, self.lbNumber.text);
        
        self.lbNumber.text = [NSString stringWithFormat:@"%d",0];
        [GYTakeOrderTool saveModelWithCount:0 model:self.sfModel];
        
        
        self.status = !self.status;
    }else if (sender.tag == 12 && self.status == NO){
        
        [self.btnDeleteAndRecovery setTitle:kLocalized(@"Delete") forState:UIControlStateNormal];
        [self.btnDeleteAndRecovery setTitleColor:kBlueFontColor forState:UIControlStateNormal];
        self.btnADD.hidden = NO;
        self.btnReduction.hidden = NO;
        self.lbNumber.text = kGetNSUser(self.strKey);
        self.lbNumber.text = [NSString stringWithFormat:@"%ld",(long)self.valueCount];
        [GYTakeOrderTool saveModelWithCount:self.valueCount model:self.sfModel];
        self.status = !self.status;
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:GYAddFoodChangeNotification object:nil];
}

/**
 *  模型重置方法
 *
 *  @param sfModel <#sfModel description#>
 */
- (void)setSfModel:(id)sfModel
{
    _sfModel = sfModel;
    
    if ([sfModel isKindOfClass:[GYSyncShopFoodsModel class]]) {
        GYSyncShopFoodsModel *fm = sfModel;
        GYPicUrlModel *puModel  = fm.picUrl[0];
        GYNameAndSizeModel *nsModel = puModel.pad[0];
        
        NSString *strUrl = [picHttpUrl stringByAppendingString:kSaftToNSString(nsModel.name)];
        [self.imgPic setImageWithURL:[NSURL URLWithString:strUrl] placeholder:[UIImage imageNamed:@"dafauftPicture"] options:kNilOptions completion:nil];
        self.lbFoodName.text = fm.foodName;
        self.lbPrice.text = [NSString stringWithFormat:@"%.2f",fm.foodPrice.floatValue];
        self.lbIntegral.text = [NSString stringWithFormat:@"%.2f",fm.foodPv.floatValue];
        self.lbNumber.text =  [fm.selected[fm.foodId] stringValue];
        self.valueCount = self.lbNumber.text.integerValue;
    }else if([sfModel isKindOfClass:[GYFoodSpecModel class]]){
        
        GYFoodSpecModel *fm = sfModel;
        GYPicUrlModel *puModel  = fm.picUrl[0];
        GYNameAndSizeModel *nsModel = puModel.pad[0];
        NSString *strUrl = [picHttpUrl stringByAppendingString:kSaftToNSString(nsModel.name)];
        [self.imgPic setImageWithURL:[NSURL URLWithString:strUrl] placeholder:[UIImage imageNamed:@"dafauftPicture"] options:kNilOptions completion:nil];
        self.lbFoodName.text = fm.pName;;
        self.lbPrice.text = [NSString stringWithFormat:@"%.2f",fm.price.floatValue];
        self.lbIntegral.text = [NSString stringWithFormat:@"%.2f",fm.auction.floatValue];
        self.lbNumber.text = [GYTakeOrderTool getFoodNumWithPid:fm.identify ];
        self.lbSpecifications.text = fm.pVName;
        self.valueCount = self.lbNumber.text.integerValue;
    }
    
}

@end
