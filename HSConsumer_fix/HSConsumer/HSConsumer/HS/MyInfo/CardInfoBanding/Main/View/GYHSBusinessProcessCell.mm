//
//  GYHSBusinessProcessCell.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/18.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSBusinessProcessCell.h"
#import "Masonry.h"
#import "GYHSConstant.h"
@interface GYHSBusinessProcessCell ()

@property (nonatomic, strong) UIImageView* cellImageView;
@property (nonatomic, strong) UILabel* titleLable;
@property (nonatomic, strong) UILabel* stateLable;
@property (nonatomic, strong) UIImageView* arrowImageView;

@end

@implementation GYHSBusinessProcessCell

#pragma mark - lift cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.cellImageView];
        [self.contentView addSubview:self.titleLable];
        [self.contentView addSubview:self.stateLable];
        [self.contentView addSubview:self.arrowImageView];

        WS(weakSelf);
        [self.cellImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerY.equalTo(weakSelf.contentView);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.left.mas_equalTo(16);
        }];

        [self.titleLable sizeToFit];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerY.equalTo(weakSelf.contentView);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth - 170, 21));
            make.left.equalTo(weakSelf.cellImageView.mas_right).offset(10);
        }];

        [self.stateLable sizeToFit];
        [self.stateLable mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerY.equalTo(weakSelf.contentView);
            make.size.mas_equalTo(CGSizeMake(80, 21));
            make.left.equalTo(weakSelf.titleLable.mas_right).offset(5);
        }];

        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerY.equalTo(weakSelf.contentView);
            make.size.mas_equalTo(CGSizeMake(10, 17));
            make.right.equalTo(weakSelf.contentView).with.offset(-16);
        }];
    }

    return self;
}

- (void)awakeFromNib
{
}

- (void)cellContent:(NSString*)imageName title:(NSString*)title state:(NSString*)state
{
    self.cellImageView.image = [UIImage imageNamed:imageName];
    self.titleLable.text = title;
    self.stateLable.text = state;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - getter and setter
- (UIImageView*)cellImageView
{
    if (_cellImageView == nil) {
        _cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _cellImageView.contentMode = UIViewContentModeScaleAspectFit;
    }

    return _cellImageView;
}

- (UILabel*)titleLable
{
    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.textColor = kCellItemTitleColor;
        _titleLable.font = kCellTitleFont;
    }

    return _titleLable;
}

- (UILabel*)stateLable
{
    if (_stateLable == nil) {
        _stateLable = [[UILabel alloc] init];
        _stateLable.textColor = kCellItemTitleColor;
        _stateLable.font = kCellTitleFont;
        _stateLable.textAlignment = NSTextAlignmentRight;
    }

    return _stateLable;
}

- (UIImageView*)arrowImageView
{
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(294, 23, 10, 17)];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage* image = [UIImage imageNamed:@"hs_cell_btn_right_arrow"];
        _arrowImageView.image = image;
    }

    return _arrowImageView;
}
@end
