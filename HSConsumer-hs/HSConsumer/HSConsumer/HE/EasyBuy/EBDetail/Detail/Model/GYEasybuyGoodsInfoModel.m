//
//  GYEasybuyGoodsInfoModel.m
//  HSConsumer
//
//  Created by zhangqy on 15/11/11.
//  Copyright © 2015年 GYKJ. All rights reserved.
//

#import "GYEasybuyGoodsInfoModel.h"

@implementation GYEasybuyGoodsinfoPropListModel

//求GYEasybuyGoodsInfoPropListTableViewCell高度
- (void)getPropListCellHeightWithTitle:(NSString *)name subs:(NSArray *)subs {
    _propListCellHeight = 80;

    CGFloat currentWidthRange = 10;
    NSInteger currentRow = 0;
    for (int i = 0; i < subs.count; i++) {
        GYEasybuyGoodsinfoPropListSubsModel* subModel = subs[i];
        NSString* vname = subModel.vname;
        
        CGFloat btnWidth = [vname sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}].width + 8;
        if (btnWidth + currentWidthRange > kScreenWidth - 40) {
            currentRow++;
            _propListCellHeight += 41;
            currentWidthRange = 10;
        }
        currentWidthRange += btnWidth + 40;
    }
}


@end

@implementation GYEasybuyGoodsinfoPropListSubsModel



@end

@implementation GYEasybuyGoodsInfoModel

//求GYEasybuyGoodsInfoTableViewCell高度
- (void)getGoodsInfoCellHeightWithTitle:(NSString *)title beTicket:(BOOL)beTicket  {
    CGRect rect = [title boundingRectWithSize:CGSizeMake(kScreenWidth - 102, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    //无抵扣券时的高度
    if (!beTicket) {
        
        _goodsInfoCellHeight = 186 + rect.size.height - 47;
    }
    else {
        _goodsInfoCellHeight =  186 + rect.size.height;

    }
}

@end
