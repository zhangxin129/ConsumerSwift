//
//  FDSelecteFoodCell.m
//  HSConsumer
//
//  Created by apple on 15/12/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FDSelecteFoodCell.h"
#import "FDFoodDetailModel.h"
@implementation FDSelecteFoodCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)cellValueChangedChoosedModel:(FDChoosedFoodModel*)model Cell:(UITableViewCell*)cell View:(UIView*)view
{
}

- (void)showFoodFormatChoosedVC:(FDChoosedFoodModel*)model
{
}

- (void)setModel:(FDChoosedFoodModel*)model
{
    if (model != nil) {
        _model = model;
        FDFoodDetailModel* fmodel = model.food;
        FDFoodFormatModel* format = model.format;

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
                _cashLabel.text = [NSString stringWithFormat:@"%.2f", price];
            }
            else {
                _cashLabel.text = [NSString stringWithFormat:@"%.2f起", price1 < price2 ? price1 : price2];
            }
            if ([format1.auction isEqualToString:format2.auction]) {
                _pvLabel.text = [NSString stringWithFormat:@"%.2f", pv];
            }
            else {
                _pvLabel.text = [NSString stringWithFormat:@"%.2f起", pv1 < pv2 ? pv1 : pv2];
            }
        }
        else {

            _cashLabel.text = [NSString stringWithFormat:@"%.2f", price];
            _pvLabel.text = [NSString stringWithFormat:@"%.2f", pv];
        }

        if (_model.count > 0 && self.isChoosedFoodCell) {
            _countLabel.text = @(_model.count).stringValue;
        }
    }
}

- (IBAction)btnAddClicked:(UIButton*)sender
{

    FDFoodDetailModel* fmodel = _model.food;
    NSArray* formats = fmodel.foodFormat;
    if (formats.count > 1 && !_isChoosedFoodCell) {

        [_delegate showFoodFormatChoosedVC:_model];
    }
    else {
        _model.count++;
        _countLabel.text = @(_model.count).stringValue;

        [_delegate cellValueChangedChoosedModel:_model Cell:self View:nil];
    }
}

- (IBAction)btnMinusClicked:(id)sender
{
    _model.count--;
    if (_model.count < 0) {
        _model.count = 0;
    }
    _countLabel.text = @(_model.count).stringValue;
    [_delegate cellValueChangedChoosedModel:_model Cell:self View:nil];
}

@end
