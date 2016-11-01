//
//  GYHDMessageDetailCell.m
//  HSCompanyPad
//
//  Created by shiang on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDMessageListCell.h"

@interface GYHDMessageListCell ()
/**未读状态ImageView*/
@property(nonatomic, strong)UIImageView *readImageView;
/**跳转状态imageView*/
@property(nonatomic, strong)UIImageView *pushImageView;
/**标题*/
@property(nonatomic, strong)UILabel     *titleLabel;
@property(nonatomic, strong)UILabel     *detailLabel;
@property(nonatomic, strong)UILabel     *timeLabel;
@property(nonatomic, strong)UIView      *myContentView;
@end

@implementation GYHDMessageListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
- (void)setup {

    self.myContentView = [[UIView alloc] init];
   
    [self.contentView addSubview:self.myContentView];
    
    self.readImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_message_blue_read_icon"]];
    [self.myContentView addSubview:self.readImageView];
    
    self.pushImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_message_push_icon"]];
    [self.myContentView addSubview:self.pushImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    self.titleLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.myContentView addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.font = [UIFont systemFontOfSize:14.0f];
    self.detailLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.myContentView addSubview:self.detailLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:14.0f];
    self.timeLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.myContentView addSubview:self.timeLabel];

    @weakify(self);
    [self.myContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.mas_equalTo(15);
        make.bottom.right.mas_equalTo(-15);
    }];

    [self.readImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.myContentView.mas_left);
        make.centerY.equalTo(self.myContentView.mas_top);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(22);
        make.right.mas_equalTo(-34);
        
//        make.left.lessThanOrEqualTo(self.titleLabel.mas_right).offset(10).priorityHigh();

    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(22);
        make.right.lessThanOrEqualTo(self.timeLabel.mas_left).offset(-10);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.right.mas_equalTo(-20);
        make.left.mas_equalTo(28);
        make.bottom.mas_equalTo(-20);
    }];
    [self.pushImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.timeLabel);
        make.left.equalTo(self.timeLabel.mas_right).offset(12);
    }];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    self.myContentView.backgroundColor = [UIColor whiteColor];
    
}


-(void)setModel:(GYOrderMessageListModel *)model{
    
    _model=model;
    
    self.titleLabel.text = model.messageListTitle;
    
    NSString *timeStr=[GYHDUtils messageTimeStrFromTimerString:model.messageListTimer];
    self.timeLabel.text = timeStr;
    self.detailLabel.text =model.messageListContent;
    
    if ([model.readStatus isEqualToString:@"0"]) {
        
        self.readImageView.hidden=YES;
    }else{
        
        self.readImageView.hidden=NO;
    }
    
}


@end
