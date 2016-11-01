//
//  MyCollectionViewCell.m
//  DaGeng
//
//  Created by fu on 15/5/14.
//  Copyright (c) 2015年 fu. All rights reserved.
//

#import "GYPhotoCollectionViewCell.h"
@interface GYPhotoCollectionViewCell()

@end
@implementation GYPhotoCollectionViewCell 



- (IBAction)click:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(cell:didSelected:)]) {
        [self.delegate cell:self didSelected:sender.selected];
    }
    
}


@end
