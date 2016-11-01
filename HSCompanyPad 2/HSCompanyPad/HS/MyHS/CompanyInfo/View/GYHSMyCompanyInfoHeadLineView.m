//
//  GYHSMyCompanyInfoHeadLineView.m
//  HSCompanyPad
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMyCompanyInfoHeadLineView.h"

@interface GYHSMyCompanyInfoHeadLineView ()
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation GYHSMyCompanyInfoHeadLineView

-(void)awakeFromNib{
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.lineView.customBorderType = UIViewCustomBorderTypeTop;
    self.lineView.customBorderLineWidth = @1;
    self.lineView.customBorderColor = kGrayE3E3EA;
}

@end
