//
//  GYHEShopDetailFirstCell.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEShopDetailFirstCell.h"

@interface GYHEShopDetailFirstCell()

@property (weak, nonatomic) IBOutlet GYHSRedSelectBtn *phoneBtn2;
@property (weak, nonatomic) IBOutlet GYHSRedSelectBtn *ServerBtn3;
@property (weak, nonatomic) IBOutlet GYHSRedSelectBtn *toHomeServerBtn4;
@property (weak, nonatomic) IBOutlet GYHSRedSelectBtn *infoBtn5;




@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;



@end

@implementation GYHEShopDetailFirstCell

- (void)awakeFromNib {
    _height.constant = 0.5;
    for(GYHSRedSelectBtn *btn in self.contentView.subviews) {
        if([btn isKindOfClass:[GYHSRedSelectBtn class]]) {

            [btn setTitleColor:UIColorFromRGB(0xfb7d00) forState:UIControlStateSelected];
        
        }
    }
}
- (IBAction)selectBtn:(GYHSRedSelectBtn *)sender {

    if(sender.selected == YES) {
        sender.selected = NO;
        if([self.delegate respondsToSelector:@selector(hiddenFirstCell:)]) {
            [self.delegate hiddenFirstCell:self];
        }
        return ;
    }else {
        if([self.delegate respondsToSelector:@selector(firstCell:didSelectAtIndex:)]) {
            [self.delegate firstCell:self didSelectAtIndex:sender.tag - 1];
        }
        [self selectNO];
        _selectIndex = sender.tag - 1;
        sender.selected = !sender.selected;
    }
    
}
- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    [self selectNO];
    GYHSRedSelectBtn *btn = [self.contentView viewWithTag:selectIndex + 1];
    btn.selected = YES;
    
}
- (void)selectNO {
    for(GYHSRedSelectBtn *btn in self.contentView.subviews) {
        if([btn isKindOfClass:[GYHSRedSelectBtn class]]) {
            btn.selected = NO;
        }
    }
}

@end
