//
//  GYHSPurchToolsCollectionView.m
//  HSCompanyPad
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPurchToolsCollectionView.h"
#import "GYPurchaseToolsCell.h"

@interface GYHSPurchToolsCollectionView()

@end

@implementation GYHSPurchToolsCollectionView


- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        self.delegate = self;
//        self.dataSource = self;
        self.collectionViewLayout = layout;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
    }
    return  self;
}



@end
