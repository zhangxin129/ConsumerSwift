//
//  GYHDCustomerServiceListCell.m
//  HSCompanyPad
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDCustomerServiceListCell.h"
@interface GYHDCustomerServiceListCell()
@property(nonatomic,strong)UILabel*sessionIDLabel;
@property(nonatomic,strong)UILabel*sessionStateLabel;
@property(nonatomic,strong)UILabel*customerServiceLabel;
@property(nonatomic,strong)UILabel*sessionTimeLabel;
@end
@implementation GYHDCustomerServiceListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
- (void)setup {

    self.sessionIDLabel = [[UILabel alloc] init];
    self.sessionIDLabel.font = [UIFont systemFontOfSize:15.0f];
    self.sessionIDLabel.textColor = [UIColor colorWithRed:61/255.0 green:151/255.0 blue:255/255.0 alpha:1.0];
    [self.contentView addSubview:self.sessionIDLabel];
    
    self.sessionStateLabel = [[UILabel alloc] init];
    self.sessionStateLabel.font = [UIFont systemFontOfSize:14.0f];
    self.sessionStateLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.contentView addSubview:self.sessionStateLabel];
    
    
    self.customerServiceLabel = [[UILabel alloc] init];
    self.customerServiceLabel.font = [UIFont systemFontOfSize:14.0f];
    self.customerServiceLabel.numberOfLines=0;
    self.customerServiceLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.contentView addSubview:self.customerServiceLabel];
    
    
    self.sessionTimeLabel = [[UILabel alloc] init];
    self.sessionTimeLabel.font = [UIFont systemFontOfSize:14.0f];
    self.sessionTimeLabel.numberOfLines=0;
    self.sessionTimeLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.contentView addSubview:self.sessionTimeLabel];
    
    
   
    @weakify(self);
    [self.sessionIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(10);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(150);
    }];
    
    [self.sessionStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.sessionIDLabel.mas_right).offset(20);
        make.width.mas_equalTo(60);
    }];
    
    [self.customerServiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.sessionStateLabel.mas_right).offset(20);
        make.width.mas_equalTo(110);
    }];
    
    [self.sessionTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.customerServiceLabel.mas_right).offset(20);
    }];
    
   
//    self.sessionIDLabel.text=@"123456789";
//    self.sessionStateLabel.text=@"结束会话";
//    self.customerServiceLabel.text=@"熬枯受淡\r\n爱上暗示健康";
//    self.sessionTimeLabel.text=@"2016-09-06 08:12:35   2016-09-06 08:12:35";
}

-(void)setModel:(GYHDCustomerServiceListModel *)model{

    _model=model;
    
    self.sessionIDLabel.text=model.sessionId;
    if ([model.sessionState isEqualToString:@"established"]) {
        
         self.sessionStateLabel.text=kLocalized(@"GYHD_Access_Session");
        
    }else if ([model.sessionState isEqualToString:@"closed"]){
    
     self.sessionStateLabel.text=kLocalized(@"GYHD_Endless_Session");
        
    }else if ([model.sessionState isEqualToString:@"switched"]){
        
        self.sessionStateLabel.text=kLocalized(@"GYHD_Swicth_Session");
        
    }else if ([model.sessionState isEqualToString:@"unready"]){
        
        self.sessionStateLabel.text=kLocalized(@"GYHD_Enterprise_Leave_Message");
        
    }
    self.customerServiceLabel.text=model.customerServiceListStr;
    self.sessionTimeLabel.text=model.sessionTimeListStr;
    
}
@end
