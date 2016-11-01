//
//  GYEasybuyCategoryCell.m
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/3/31.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEasybuyCategoryCell.h"
#import "UIView+CustomBorder.h"

@interface GYEasybuyCategoryCell ()

@property (nonatomic, strong) UIView* redView;
@property (nonatomic, strong) UIView* backView;

@end

@implementation GYEasybuyCategoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    _backView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_backView];

    _redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, self.frame.size.height)];
    _redView.backgroundColor = [UIColor redColor];
    [_backView addSubview:_redView];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(GYEasybuyColumnClassModel*)model
{
    _model = model;

    self.textLabel.text = model.name;
    self.textLabel.font = [UIFont systemFontOfSize:16];
    if (model.isSelected) {
        self.textLabel.textColor = [UIColor redColor];
        _redView.hidden = NO;
        _backView.backgroundColor = [UIColor whiteColor];
    }
    else {
        self.textLabel.textColor = [UIColor blackColor];
        _redView.hidden = YES;
        _backView.backgroundColor = kDefaultVCBackgroundColor;
    }
}

@end
