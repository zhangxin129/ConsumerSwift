//
//  FoodSeveiceCell.m
//  HSConsumer
//
//  Created by apple on 15/12/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FoodSeveiceCell.h"

@implementation FoodSeveiceCell

- (void)awakeFromNib
{
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        _seveiceArr = [NSMutableArray array];
    }
    return self;
}

- (void)setModel:(FDShopDetailModel*)model
{

    _model = model;

    NSString* str = @"0";

    [_seveiceArr removeAllObjects];

    if (self.model.tickets) {

        str = @"1";

        [_seveiceArr addObject:str];
    }
    if (self.model.takeOut) {

        str = @"2";

        [_seveiceArr addObject:str];
    }
    if (self.model.appointment) {

        str = @"3";

        [_seveiceArr addObject:str];
    }

    if (self.model.parking) {

        str = @"4";

        [_seveiceArr addObject:str];
    }

    if (self.model.pickUp) {

        str = @"5";

        [_seveiceArr addObject:str];
    }

    for (NSInteger i = 0; i < _seveiceArr.count; i++) {

        _BgView = [[UIView alloc] initWithFrame:CGRectMake(0, i * 30, self.bounds.size.width, 30)];

        if (i == _seveiceArr.count - 1) {
        }
        else {

            [_BgView addBottomBorder];
        }

        [self addSubview:_BgView];

        _imagView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 20, 20)];

        _imagView.layer.cornerRadius = 10;

        _imagView.clipsToBounds = YES;

        NSString* str = _seveiceArr[i];

        if ([str isEqualToString:@"1"]) {

            _imagView.image = [UIImage imageNamed:@"gyhe_food_main_ticket"];
        }
        else if ([str isEqualToString:@"2"]) {

            _imagView.image = [UIImage imageNamed:@"gyhe_food_main_wai"];
        }
        else if ([str isEqualToString:@"3"]) {

            _imagView.image = [UIImage imageNamed:@"gyhe_food_main_order"];
        }
        else if ([str isEqualToString:@"4"]) {

            _imagView.image = [UIImage imageNamed:@"gyhe_food_main_stop"];
        }
        else if ([str isEqualToString:@"5"]) {

            _imagView.image = [UIImage imageNamed:@"gyhe_food_main_ti"];
        }

        [_BgView addSubview:_imagView];

        _sevieceLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 3, 200, 25)];

        _sevieceLabel.font = [UIFont systemFontOfSize:11];

        //        _sevieceLabel.textColor=[UIColor clearColor];

        _sevieceLabel.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];

        if ([str isEqualToString:@"1"]) {

            _sevieceLabel.text = kLocalized(@"GYHE_Food_SupportUseCoupon");
        }
        else if ([str isEqualToString:@"2"]) {

            _sevieceLabel.text = kLocalized(@"GYHE_Food_SupportDelivery");
        }
        else if ([str isEqualToString:@"3"]) {

            _sevieceLabel.text = kLocalized(@"GYHE_Food_AdvanceReservation");
        }
        else if ([str isEqualToString:@"4"]) {

            _sevieceLabel.text = kLocalized(@"GYHE_Food_ParkingSupport");
        }
        else if ([str isEqualToString:@"5"]) {

            _sevieceLabel.text = kLocalized(@"GYHE_Food_TakeFromStore");
        }

        [_BgView addSubview:_sevieceLabel];
    }


}

@end
