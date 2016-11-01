//
//  GYSurroundShopVisitThirdCell.m
//  GYHSConsumer_SurroundVisit
//
//  Created by zhangqy on 16/3/21.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSurroundShopVisitThirdCell.h"
#import "GYSearchShopsViewController.h"

@interface GYSurroundShopVisitThirdCell ()
@property (weak, nonatomic) IBOutlet UIImageView* leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView* rightImageView;

@end

@implementation GYSurroundShopVisitThirdCell

- (void)awakeFromNib
{
    // Initialization code
    self.contentView.backgroundColor = kDefaultVCBackgroundColor;
    UITapGestureRecognizer* leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftImageTapped:)];
    [_leftImageView addGestureRecognizer:leftTap];
    UITapGestureRecognizer* rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightImageTapped:)];
    [_rightImageView addGestureRecognizer:rightTap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLeftImageURLString:(NSString*)leftImageURLString
{
    [_leftImageView setImageWithURL:[NSURL URLWithString:leftImageURLString] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"]];
}

- (void)setRightImageURLString:(NSString*)rightImageURLString
{
    [_rightImageView setImageWithURL:[NSURL URLWithString:rightImageURLString] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"]];
}

- (void)leftImageTapped:(id)sender
{
    //    UIViewController *infoVC = [[NSClassFromString(@"GYSurroundShopListController") alloc] init];
    UIViewController* mainVC = (UIViewController*)self.superview.superview.superview.nextResponder;
    mainVC = mainVC.parentViewController;

    GYSearchShopsViewController* infoVC = [[GYSearchShopsViewController alloc] init];
    infoVC.modelID = @"";
    infoVC.strSortType = @"5";

    if (mainVC && infoVC && mainVC.navigationController) {
        infoVC.hidesBottomBarWhenPushed = YES;
        [mainVC.navigationController pushViewController:infoVC animated:YES];
    }
}

- (void)rightImageTapped:(id)sender
{
    UIViewController* infoVC = [[NSClassFromString(@"GYIGRankController") alloc] init];
    UIViewController* mainVC = (UIViewController*)self.superview.superview.superview.nextResponder;
    mainVC = mainVC.parentViewController;
    if (mainVC && infoVC && mainVC.navigationController) {
        infoVC.hidesBottomBarWhenPushed = YES;
        [mainVC.navigationController pushViewController:infoVC animated:YES];
    }
}

@end
