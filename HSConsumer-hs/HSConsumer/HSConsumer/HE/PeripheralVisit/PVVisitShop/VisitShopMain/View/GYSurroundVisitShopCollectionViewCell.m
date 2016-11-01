//
//  GYSurroundVisitShopCollectionViewCell.m
//  GYHSConsumer_SurroundVisit
//
//  Created by zhangqy on 16/3/18.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSurroundVisitShopCollectionViewCell.h"

@interface GYSurroundVisitShopCollectionViewCell ()
@property (nonatomic, strong) UIImageView* logoImageView;
@property (nonatomic, strong) UILabel* titleLabel;
@end

@implementation GYSurroundVisitShopCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, self.contentView.bounds.size.width - 10, self.contentView.bounds.size.height - 20)];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_logoImageView];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.contentView.bounds.size.height - 18, self.contentView.bounds.size.width, 20)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)setImageURLString:(NSString*)imageURLString
{
    [_logoImageView setImageWithURL:[NSURL URLWithString:imageURLString] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"]];
}

- (void)setTitleString:(NSString*)titleString
{
    _titleLabel.text = titleString;
}

@end
