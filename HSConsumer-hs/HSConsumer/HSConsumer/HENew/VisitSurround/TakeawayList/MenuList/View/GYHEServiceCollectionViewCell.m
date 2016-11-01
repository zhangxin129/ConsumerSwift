//
//  GYHEServiceCollectionViewCell.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEServiceCollectionViewCell.h"
#import "GYHETools.h"

@implementation GYHEServiceCollectionViewCell

- (void)awakeFromNib {
    [self.titleBtn setTitleColor:kBlackBtn forState:UIControlStateNormal];
}

- (IBAction)serviceBtn:(UIButton*)sender {
    if ([_serviceDelegate respondsToSelector:@selector(serviceBtn:indexPath:)]) {
        [self.serviceDelegate serviceBtn:sender indexPath:self.indexPath];
    }
    
}

@end
