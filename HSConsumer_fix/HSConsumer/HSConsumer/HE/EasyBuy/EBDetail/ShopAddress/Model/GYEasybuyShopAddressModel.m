//
//  GYEasybuyShopAddressModel.m
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEasybuyShopAddressModel.h"

@implementation GYEasybuyShopAddressModel


-(GYEasybuyShopAddressModel *)initWithDic:(NSDictionary *)dic {

    GYEasybuyShopAddressModel *model  = [[GYEasybuyShopAddressModel alloc] initWithDictionary:dic error:nil];
    UILabel *label = [[UILabel alloc ]init];
    label.numberOfLines = 0 ;
    label.text = model.addr;
    CGSize size = [self adaptiveWithWidth:kScreenWidth-30 label:label];
    if(size.height < 32) {
        model.cellHeight = 90;
    }else  {
        model.cellHeight = size.height -32 +90;
    }
    return model;
}

- (CGSize)adaptiveWithWidth:(CGFloat)width label:(UILabel*)label
{
    label.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return size;
}

@end
