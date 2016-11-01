//
//  GYHSAccountCell.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSAccountCell.h"

@interface GYHSAccountCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftW;


@end

@implementation GYHSAccountCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSpace:(NSInteger)space {
    _space = space;
    _rightW.constant = space;
    _leftW.constant = space;
    
}

@end