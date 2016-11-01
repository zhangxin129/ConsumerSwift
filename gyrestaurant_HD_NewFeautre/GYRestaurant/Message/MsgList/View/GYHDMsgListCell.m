//
//  GYHDMsgListCell.m
//  GYRestaurant
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDMsgListCell.h"
@interface GYHDMsgListCell()
@property(nonatomic,strong)UILabel *msgTitleLabel;
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *detailsLabel;
@property(nonatomic,strong)UIView  *tipView;
@end
@implementation GYHDMsgListCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
           [self setup];
       
    }
    return self;
}

-(void)setup{

    self.tipView=[[UIView alloc]init];
    
    self.tipView.backgroundColor=[UIColor colorWithRed:0/255.0 green:143.0/255.0 blue:215.0/255.0 alpha:1.0];
    self.tipView.layer.cornerRadius=5;
    self.tipView.clipsToBounds=YES;
    
    [self addSubview:self.tipView];
    
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(10, 10));
        
    }];
    @weakify(self);
    self.msgTitleLabel = [[UILabel alloc]init];

    self.msgTitleLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.msgTitleLabel.font = [UIFont systemFontOfSize:20.0];
    [self addSubview:self.msgTitleLabel];
    [self.msgTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.height.mas_equalTo(20);
        make.width.mas_equalTo(self.bounds.size.width - 32);
    }];
    
    self.btn = [[UIButton alloc]init];
    [self.btn setBackgroundImage:[UIImage imageNamed:@"icon_gd_1"] forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.btn.selected = NO;
    [self.btn setBackgroundImage:[UIImage imageNamed:@"icon_gd_2"] forState:UIControlStateSelected];
    [self addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.width.height.mas_equalTo(16);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];

    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.msgTitleLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(self.bounds.size.width - 40);
        make.height.mas_equalTo(16);
    }];
    self.detailsLabel = [[UILabel alloc]init];
    self.detailsLabel.font = [UIFont systemFontOfSize:16.0];
    self.detailsLabel.numberOfLines = 0;
    self.detailsLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    [self addSubview:self.detailsLabel];
    [self.detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-20);
//        make.width.mas_equalTo(self.bounds.size.width - 40);
    }];
}
-(void)setModel:(GYOrderMessageListModel *)model{

    _model=model;
    
    self.msgTitleLabel.text = model.messageListTitle;
    self.timeLabel.text = model.messageListTimer;
    self.detailsLabel.text =model.messageListContent;
    if ([model.readStatus isEqualToString:@"0"]) {
        
        self.tipView.hidden=YES;
    }else{
    
        self.tipView.hidden=NO;
    }
    
}

- (void)click:(UIButton *)btn {
    btn.selected = !btn.selected;
    
    if (_delegate &&[_delegate respondsToSelector:@selector(reFreshCellRowHight:)]) {
        
        
        [_delegate reFreshCellRowHight:100];
    }
    
    _model.isShowAllContent=!_model.isShowAllContent;
}



@end
