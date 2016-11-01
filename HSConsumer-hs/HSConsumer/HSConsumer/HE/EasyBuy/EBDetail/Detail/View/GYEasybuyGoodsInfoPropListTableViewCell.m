//
//  GYEasybuyGoodsInfoPropListTableViewCell.m
//  HSConsumer
//
//  Created by zhangqy on 15/11/17.
//  Copyright © 2015年 GYKJ. All rights reserved.
//

#import "GYEasybuyGoodsInfoPropListTableViewCell.h"

@interface GYEasybuyGoodsInfoPropListTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel* nameLabel;
//@property (strong, nonatomic) IBOutlet UIView *btnView;

@end

@implementation GYEasybuyGoodsInfoPropListTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.backgroundColor = kDefaultVCBackgroundColor;
}

- (void)setModel:(GYEasybuyGoodsinfoPropListModel*)model
{
    _model = model;
    if (model) {
//        self.height = 80;
        _model = model;
        self.nameLabel.text = model.name;
        NSArray* subs = model.subs;
        CGFloat currentWidthRange = 10;
        NSInteger currentRow = 0;
        for(UIView *view in self.btnView.subviews) {
            [view removeFromSuperview];
        }
        for (int i = 0; i < subs.count; i++) {
            GYEasybuyGoodsinfoPropListSubsModel *mod =subs[i];
            NSString* vname = mod.vname;
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.selected = mod.isSelected;
            btn.tag = i;
            
            UIEdgeInsets insets = UIEdgeInsetsMake(2, 2, 30, 30);
            UIImage* img1 = [UIImage imageNamed:@"gycommon_sku_unselected"];
            UIImage* img2 = [UIImage imageNamed:@"gycommon_sku_selected"];
            UIImage* unSelImg = [img1 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
            UIImage* selImg = [img2 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
            [btn setBackgroundImage:unSelImg forState:UIControlStateNormal];
            [btn setBackgroundImage:selImg forState:UIControlStateSelected];
            
            CGFloat btnWidth = [vname sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}].width + 8;
            if (btnWidth + currentWidthRange > kScreenWidth - 40) {
                currentRow++;
                currentWidthRange = 10;
            }
            btn.frame = CGRectMake(currentWidthRange, currentRow * 41, btnWidth + 20, 31);
            currentWidthRange += btnWidth + 40;
            [btn setTitle:vname forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            btn.backgroundColor = [UIColor whiteColor];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.btnView addSubview:btn];
        }
    }
}

- (void)btnAction:(UIButton*)btn
{
    for (UIButton* button in self.btnView.subviews) {
        if ([button isKindOfClass:[UIButton class]] && button != btn) {
            button.selected = NO;
        }
    }
    btn.selected = !btn.selected;

    if (btn.selected) {

        NSUInteger i = [btn tag];
        if(_model.subs.count > i) {
            GYEasybuyGoodsinfoPropListSubsModel *mod = _model.subs[i];
            _selectedStr = [NSString stringWithFormat:@"%@", mod.vid];
            _block(_selectedStr,btn.tag);
        }
        
    }
    else {

        _block(nil,btn.tag);
    }
}

@end
