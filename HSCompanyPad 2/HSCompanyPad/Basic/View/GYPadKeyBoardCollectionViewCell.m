//
//  GYPadKeyBoardCollectionViewCell.m
//  test
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 wangbb. All rights reserved.
//

#import "GYPadKeyBoardCollectionViewCell.h"

@implementation GYPadKeyBoardCollectionViewCell

- (void)awakeFromNib {
    self.textLabel.textColor = [UIColor grayColor];
    self.textLabel.font = [UIFont boldSystemFontOfSize:21];
}

@end
