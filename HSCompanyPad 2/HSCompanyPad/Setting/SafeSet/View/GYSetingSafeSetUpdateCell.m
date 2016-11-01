//
//  GYSetingSafeSetUpdateCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/16.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYSetingSafeSetUpdateCell.h"

@interface GYSetingSafeSetUpdateCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *space;
@property (weak, nonatomic) IBOutlet UIButton *btnUploadPicturn;
@property (weak, nonatomic) IBOutlet UIButton *btnLoadDownPictrun;


@end

@implementation GYSetingSafeSetUpdateCell

- (void)awakeFromNib {
    
    self.titleLabel.textColor = kGray333333;
    
    self.space.constant = kDeviceProportion(self.space.constant);
    self.btnUploadPicturn.backgroundColor = kRedE50012;
    self.btnLoadDownPictrun.backgroundColor = kGray878696;
    
    self.btnLoadDownPictrun.layer.cornerRadius = 6;
    self.btnLoadDownPictrun.layer.borderColor = kGray878696.CGColor;
    self.btnLoadDownPictrun.layer.borderWidth = 1;
    
    self.btnUploadPicturn.layer.cornerRadius = 6;
    self.btnUploadPicturn.layer.borderColor = kRedE50012.CGColor;
    self.btnUploadPicturn.layer.borderWidth = 1;
}



- (IBAction)comfirmAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(safeSetupdateCellTouch:button:)]) {
        [self.delegate safeSetupdateCellTouch:safeSetUpdateTouchEventUpload button:sender];
    }
    
}

- (IBAction)cancelAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(safeSetupdateCellTouch:button:)]) {
        [self.delegate safeSetupdateCellTouch:safeSetUpdateTouchEventDownload button:sender];
    }
}

@end
