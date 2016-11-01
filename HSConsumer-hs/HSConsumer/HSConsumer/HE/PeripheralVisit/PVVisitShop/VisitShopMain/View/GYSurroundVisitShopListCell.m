//
//  GYSurroundShopListCell.m
//  GYHSConsumer_SurroundVisit
//
//  Created by zhangqy on 16/3/22.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSurroundVisitShopListCell.h"

@interface GYSurroundVisitShopListCell ()
@property (weak, nonatomic) IBOutlet UIImageView* shopImageView;
@property (weak, nonatomic) IBOutlet UILabel* companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* categoryNamesLabel;
@property (weak, nonatomic) IBOutlet UILabel* addrLabel;
@property (weak, nonatomic) IBOutlet UILabel* distLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* seperateLineWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* quanWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* reachWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* sellWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* cashWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* takeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* quanSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* reachSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* sellSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* cashSpace;

@end

@implementation GYSurroundVisitShopListCell

- (void)awakeFromNib
{
    _seperateLineWidthConstraint.constant = 1 / [UIScreen mainScreen].scale;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(GYSurroundVisitShopListModel*)model
{
    _model = model;
    NSString* picURL = nil;
    picURL = model.url ? model.url : model.shopPic;
    [_shopImageView setImageWithURL:[NSURL URLWithString:picURL] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"]];
    _companyNameLabel.text = model.companyName;
    _categoryNamesLabel.text = model.categoryNames;
    _addrLabel.text = model.addr;
    CGFloat dist = model.dist.floatValue;
    _distLabel.text = [NSString stringWithFormat:@"%.1fkm", dist];

    _quanWidth.constant = 16;
    _quanSpace.constant = 2;

    _reachWidth.constant = 16;
    _reachSpace.constant = 2;

    _sellWidth.constant = 16;
    _sellSpace.constant = 2;

    _cashWidth.constant = 16;
    _cashSpace.constant = 2;

    _takeWidth.constant = 16;

    if (!model.beQuan) {
        _quanWidth.constant = 0;
        _quanSpace.constant = 0;
    }
    if (!model.beReach) {
        _reachWidth.constant = 0;
        _reachSpace.constant = 0;
    }
    if (!model.beSell) {
        _sellWidth.constant = 0;
        _sellSpace.constant = 0;
    }
    if (!model.beCash) {
        _cashWidth.constant = 0;
        _cashSpace.constant = 0;
    }
    if (!model.beTake) {
        _takeWidth.constant = 0;
    }
}

- (IBAction)telBtnClicked:(id)sender
{
    NSString* num = [NSString stringWithFormat:@"telprompt:%@", _model.tel];
    NSURL* url = [NSURL URLWithString:num];
    [[UIApplication sharedApplication] openURL:url];
}

@end
