//
//  GYSurroundShopFirstCell.m
//  GYHSConsumer_SurroundVisit
//
//  Created by zhangqy on 16/3/18.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#import "GYSurroundShopVisitFirstCell.h"

@interface GYSurroundShopVisitFirstCell ()
@property (nonatomic, strong) UIImageView* backImageView;
@end

@implementation GYSurroundShopVisitFirstCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat width = [[UIScreen mainScreen] bounds].size.width;
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, [GYSurroundShopVisitFirstCell height])];
        _backImageView.contentMode = UIViewContentModeScaleToFill;
        _backImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        [_backImageView addGestureRecognizer:tap];
        [self.contentView addSubview:_backImageView];
    }
    return self;
}

- (void)imageTapped:(UITapGestureRecognizer*)tap
{
    UIViewController* infoVC = [[NSClassFromString(@"GYIGWelfareController") alloc] init];
    UIViewController* mainVC = (UIViewController*)self.superview.superview.superview.nextResponder;
    mainVC = mainVC.parentViewController;
    if (mainVC && infoVC && mainVC.navigationController) {
        infoVC.hidesBottomBarWhenPushed = YES;
        [mainVC.navigationController pushViewController:infoVC animated:YES];
    }
}

- (void)setImageURLString:(NSString*)imageURLString
{
    [_backImageView setImageWithURL:[NSURL URLWithString:imageURLString] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"]];
}

+ (CGFloat)height
{
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = width * 16 / 75;
    return height;
}

@end
