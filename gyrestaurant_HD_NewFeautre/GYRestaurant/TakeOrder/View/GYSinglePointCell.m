//
//  GYSinglePointCell.m
//  GYRestaurant
//
//  Created by apple on 15/10/21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSinglePointCell.h"
#import "GYNameAndSizeModel.h"
#import "GYPicUrlModel.h"
#import "GYFoodSpecModel.h"
#import "GYTakeOrderTool.h"

@interface GYSinglePointCell()
@property (weak, nonatomic) IBOutlet UILabel *lbNumber;
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lbFoodName;
@property (weak, nonatomic) IBOutlet UILabel *lbSpecifications;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbIntegral;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteAndRecovery;
@property (weak, nonatomic) IBOutlet UIButton *btnADD;
@property (weak, nonatomic) IBOutlet UIButton *btnReduction;



@property (nonatomic, assign) NSInteger valueCount;
@property (nonatomic, assign) BOOL status;
@property (nonatomic , copy)NSString *strKey;
@end

@implementation GYSinglePointCell

#pragma mark -系统方法
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.btnDeleteAndRecovery setTitleColor:kBlueFontColor forState:UIControlStateNormal];
    self.status = YES;
}



#pragma mark - 自定义方法

/**
 *  按钮点击事件
 *
 */
- (IBAction)click:(UIButton *)sender {
    
//    NSInteger maxFood = [(NSString *)kGetNSUser(@"maxFood")   intValue];
    
        if (sender.tag == 10) {
        if (self.valueCount > 0) {
            self.valueCount--;
            if (self.valueCount < 0) {
                
                return;
            }
            self.lbNumber.text = [@(self.valueCount) stringValue];
            
            [GYTakeOrderTool saveModelWithCount:self.valueCount model:self.sfModel];
          
         }
        }

    if(sender.tag == 11){

            self.valueCount++;
    
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
        [GYTakeOrderTool saveModelWithCount:[self.lbNumber.text integerValue] model:self.sfModel];
    
        self.status = !self.status;
    }
    //删除的菜品数量，存在中间值
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GYSinglePointCellDeleteNotification object:nil ];
    
}

/**
 *  模型重置方法
 *
 *  @param sfModel 
 */
- (void)setSfModel:(id)sfModel
{
        _sfModel = sfModel;
    
    if ([sfModel isKindOfClass:[GYSyncShopFoodsModel class]]) {
        GYSyncShopFoodsModel *fm = sfModel;
        GYPicUrlModel *puModel  = fm.picUrl[0];
        GYNameAndSizeModel *nsModel = puModel.pad[0];
        
        NSString *picnameStr = [kSaftToNSString(nsModel.name) substringToIndex:4];
        if (![picnameStr isEqualToString:@"null"]) {
            NSString *strUrl = [picHttpUrl stringByAppendingString:kSaftToNSString(nsModel.name)];
            [self.imgPic setImageWithURL:[NSURL URLWithString:strUrl] placeholder:[UIImage imageNamed:@"dafauftPicture"] options:kNilOptions completion:nil];
        }else{
            [self.imgPic setImage:[UIImage imageNamed:@"dafauftPicture"]];
            
        }

   //     self.imgPic.size = CGSizeMake(100, 85);
        self.lbFoodName.text = fm.foodName;
        self.lbPrice.text = [NSString stringWithFormat:@"%.2f",fm.foodPrice.doubleValue];
        self.lbIntegral.text = [NSString stringWithFormat:@"%.2f",fm.foodPv.doubleValue];
        self.lbNumber.text =  [GYTakeOrderTool getFoodNumWithFoodId:fm.foodId];
        self.valueCount = self.lbNumber.text.intValue;
  
    }else if([sfModel isKindOfClass:[GYFoodSpecModel class]]){
        
        GYFoodSpecModel *fm = sfModel;
        GYPicUrlModel *puModel  = fm.picUrl[0];
        GYNameAndSizeModel *nsModel = puModel.pad[0];
        NSString *picnameStr = [kSaftToNSString(nsModel.name) substringToIndex:4];
        if (![picnameStr isEqualToString:@"null"]) {
            NSString *strUrl = [picHttpUrl stringByAppendingString:kSaftToNSString(nsModel.name)];
            [self.imgPic setImageWithURL:[NSURL URLWithString:strUrl] placeholder:[UIImage imageNamed:@"dafauftPicture"] options:kNilOptions completion:nil];
        }else{
            [self.imgPic setImage:[UIImage imageNamed:@"dafauftPicture"]];
            
        }

        self.lbFoodName.text = fm.pName;
        self.lbPrice.text = [NSString stringWithFormat:@"%.2f",fm.price.doubleValue];
        self.lbIntegral.text = [NSString stringWithFormat:@"%.2f",fm.auction.doubleValue];
        self.lbNumber.text = [GYTakeOrderTool getFoodNumWithPid:fm.identify];
        self.lbSpecifications.text = fm.pVName;
        self.valueCount = self.lbNumber.text.intValue;

    }
}


@end
