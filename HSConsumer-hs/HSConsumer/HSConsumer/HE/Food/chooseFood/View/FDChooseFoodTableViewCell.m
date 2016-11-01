//
//  FDChooseFoodTableViewCell.m
//  HSConsumer
//
//  Created by zhangqy on 15/9/21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FDChooseFoodTableViewCell.h"

#import "FDFoodDetailModel.h"

@interface FDChooseFoodTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView* foodPic;
@property (weak, nonatomic) IBOutlet UILabel* foodName;
@property (weak, nonatomic) IBOutlet UILabel* foodPrice;
@property (weak, nonatomic) IBOutlet UILabel* foodPv;
@property (weak, nonatomic) IBOutlet UIButton* btnAdd;
@property (weak, nonatomic) IBOutlet UIButton* btnMinus2;

@property (weak, nonatomic) IBOutlet UILabel* salesNumLabel;
@property (weak, nonatomic) IBOutlet UIButton* btnMinus;
@property (weak, nonatomic) IBOutlet UILabel* numLabel;
@property (weak, nonatomic) IBOutlet UILabel* animatedLabel;
@property (nonatomic, assign) CGRect rect;
@end

@implementation FDChooseFoodTableViewCell

- (void)awakeFromNib
{
    _foodPic.clipsToBounds = YES;
    self.animatedLabel.layer.cornerRadius = 10;
    self.animatedLabel.clipsToBounds = YES;

    self.foodPic.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setModel:(FDChoosedFoodModel*)model
{
    if (model != nil) {
        _model = model;
        FDFoodDetailModel* fmodel = model.food;
        FDFoodFormatModel* format = model.format;
        if (fmodel.foodPicParsed == nil) {
        }
        else {

            [_foodPic setImageWithURL:[NSURL URLWithString:[globalData.tfsDomain stringByAppendingString:fmodel.foodPicParsed]] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
        }
        if (_isChoosedFoodCell && fmodel.foodFormat.count > 1) {
            _foodName.text = [fmodel.name stringByAppendingString:[NSString stringWithFormat:@"(%@)", format.pVName]];
        }
        else {
            _foodName.text = fmodel.name;
        }
        CGFloat price = format.price.floatValue;
        CGFloat pv = format.auction.floatValue;
        NSArray* formats = fmodel.foodFormat;
        if (formats.count > 1 && !self.isChoosedFoodCell) {

            FDFoodFormatModel* format1 = formats[0];
            FDFoodFormatModel* format2 = formats[formats.count - 1];

            CGFloat price1 = format1.price.floatValue;
            CGFloat pv1 = format1.auction.floatValue;
            CGFloat price2 = format2.price.floatValue;
            CGFloat pv2 = format2.auction.floatValue;
            if ([format1.price isEqualToString:format2.price]) {
                _foodPrice.text = [NSString stringWithFormat:@"%.2f", price];
            }
            else {
                _foodPrice.text = [NSString stringWithFormat:@"%.2f%@", price1 < price2 ? price1 : price2, kLocalized(@"GYHE_Food_Start")];
            }
            if ([format1.auction isEqualToString:format2.auction]) {
                _foodPv.text = [NSString stringWithFormat:@"%.2f", pv];
            }
            else {
                _foodPv.text = [NSString stringWithFormat:@"%.2f%@", pv1 < pv2 ? pv1 : pv2, kLocalized(@"GYHE_Food_Start")];
            }
        }
        else {

            _foodPrice.text = [NSString stringWithFormat:@"%.2f", price];
            _foodPv.text = [NSString stringWithFormat:@"%.2f", pv];
        }

        if (_model.count > 0 && self.isChoosedFoodCell) {
            _numLabel.text = @(_model.count).stringValue;
            _numLabel.hidden = NO;
            _btnMinus.hidden = NO;
            _btnMinus2.hidden = NO;
        }
        else {
            _numLabel.hidden = YES;
            _btnMinus.hidden = YES;
            _btnMinus2.hidden = YES;
        }
        if (!self.isChoosedFoodCell) {
            NSObject* num = _model.food.saleNum;
            if (!num || [num isKindOfClass:[NSNull class]]) {
                _salesNumLabel.text = [NSString stringWithFormat:@"%@%ld%@", kLocalized(@"GYHE_Food_Sold"), (long)_model.salesCount, kLocalized(@"GYHE_Food_Part")];
            }
            else {
                _salesNumLabel.text = [NSString stringWithFormat:@"%@%@%@", kLocalized(@"GYHE_Food_Sold"), _model.food.saleNum, kLocalized(@"GYHE_Food_Part")];
            }
        }
    }
}

- (IBAction)btnAddClicked:(UIButton*)sender
{

    _rect = self.animatedLabel.frame;
    FDFoodDetailModel* fmodel = _model.food;
    NSArray* formats = fmodel.foodFormat;
    if (formats.count > 1 && !_isChoosedFoodCell) {
        [_delegat showFoodFormatChoosedVC:_model];
    }
    else {
        _model.count++;
        _numLabel.text = @(_model.count).stringValue;

        [UIView animateWithDuration:0.5 animations:^{


            self.animatedLabel.hidden = NO;

            self.animatedLabel.frame = CGRectMake(self.rect.origin.x, self.rect.origin.y-3, self.rect.size.width, self.rect.size.height);

        } completion:^(BOOL finished) {

            self.animatedLabel.hidden = YES;
            self.animatedLabel.frame = self.rect;

        }];

        [_delegat cellValueChangedChoosedModel:_model Cell:self View:_foodPic];
    }
}

- (IBAction)btnMinusClicked:(id)sender
{
    _model.count--;
    if (_model.count < 0) {
        _model.count = 0;
    }
    _numLabel.text = @(_model.count).stringValue;

    [_delegat cellValueChangedChoosedModel:_model Cell:self View:_foodPic];
}

@end
