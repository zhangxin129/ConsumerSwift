//
//  SecondTableViewCell.m
//  DropDownDemo
//
//  Created by apple on 14-11-27.
//  Copyright (c) 2014年 童明城. All rights reserved.
//

#import "GYEasyBuyThirdTableViewCell.h"

@implementation GYEasyBuyThirdTableViewCell {

    __weak IBOutlet UILabel* lbTitle;
}
- (void)awakeFromNib
{
    // Initialization code

    [self.btnSelected setBackgroundImage:[UIImage imageNamed:@"gyhe_check_mark_red.png"] forState:UIControlStateNormal];

    self.btnSelected.hidden = YES;
}

- (void)refreshUIWith:(NSString*)title
{

    lbTitle.text = title;
}

//实现多选的方法。
- (void)selectOneRow:(NSInteger)index WithSelected:(BOOL)selected
{

    if (selected) {
        lbTitle.textColor = kNavigationBarColor;
        self.btnSelected.hidden = NO;
    }
    else {
        lbTitle.textColor = [UIColor blackColor];
        self.btnSelected.hidden = YES;
    }



}

@end
