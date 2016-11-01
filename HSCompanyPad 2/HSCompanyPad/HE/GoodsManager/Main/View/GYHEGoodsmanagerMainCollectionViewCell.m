//
//  GYHEGoodsmanagerMainCollectionViewCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHEGoodsmanagerMainCollectionViewCell.h"

@interface GYHEGoodsmanagerMainCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imagesView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *touchView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTopHeightConstraint;
@end

@implementation GYHEGoodsmanagerMainCollectionViewCell

- (void)awakeFromNib {
    _imageViewTopConstraint.constant = kDeviceProportion(_imageViewTopConstraint.constant);
    _imageViewWidthConstraint.constant = kDeviceProportion(_imageViewWidthConstraint.constant);
    _imageViewHeightConstraint.constant = kDeviceProportion(_imageViewHeightConstraint.constant);
    _labelTopHeightConstraint.constant = kDeviceProportion(_labelTopHeightConstraint.constant);
    
    self.titleLabel.font = kFont40;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.touchView addGestureRecognizer:tapRecognizer];
}

- (void) tapAction:(UITapGestureRecognizer*)tap {
    if (_imageViewBlock) {
        _imageViewBlock();
    }
}

-(void)setImage:(UIImage *)image {
    if (_image != image) {
        _image = image;
        self.imagesView.image = image;
    }
}

-(void)setTitleName:(NSString *)titleName {
    if (_titleName != titleName) {
        _titleName = titleName;
        self.titleLabel.text = titleName;
    }
}


@end
