//
//  GYSettingMainCollectionViewCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYSettingMainCollectionViewCell.h"

@interface GYSettingMainCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *touchView;

@property (weak, nonatomic) IBOutlet UIImageView* imageView;
@property (weak, nonatomic) IBOutlet UILabel* titleNameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* imageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* imageWeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* labeiHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* labelSpaceConstraint;

@end

@implementation GYSettingMainCollectionViewCell

- (void)awakeFromNib
{
    _imageHeightConstraint.constant = kDeviceProportion(_imageHeightConstraint.constant);
    _imageWeightConstraint.constant = kDeviceProportion(_imageWeightConstraint.constant);
    _topConstraint.constant = kDeviceProportion(_topConstraint.constant);
    _labeiHeightConstraint.constant = kDeviceProportion(_labeiHeightConstraint.constant);
    _labelSpaceConstraint.constant =  kDeviceProportion(_labelSpaceConstraint.constant);
    
    self.titleNameLabel.font = kFont40;
    
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
        self.imageView.image = image;
    }
}

-(void)setTitleName:(NSString *)titleName {
    if (_titleName != titleName) {
        _titleName = titleName;
        self.titleNameLabel.text = titleName;
    }
}


@end
