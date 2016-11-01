//
//  GYHDPushMsgListCell.m
//  GYRestaurant
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDPushMsgListCell.h"
#import "GYHDMessageCenter.h"
@interface GYHDPushMsgListCell()
@property(nonatomic,strong)UILabel *msgTitleLabel;
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *detailsLabel;
@property(nonatomic,strong)UIView  *tipView;
@end
@implementation GYHDPushMsgListCell

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
    @weakify(self);
    UIView*topView=[[UIView alloc]init];
    
    topView.backgroundColor=[UIColor colorWithRed:245/250.0 green:245/250.0 blue:245/250.0 alpha:1.0];
    
     [self addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.top.left.mas_equalTo(0);
        make.height.mas_equalTo(20);
        
    }];

    self.tipView=[[UIView alloc]init];
    
    self.tipView.backgroundColor=[UIColor colorWithRed:0/255.0 green:143.0/255.0 blue:215.0/255.0 alpha:1.0];
    self.tipView.layer.cornerRadius=5;
    self.tipView.clipsToBounds=YES;
    
    [self addSubview:self.tipView];
    
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(10, 10));
        
    }];
    
    self.btn = [[UIButton alloc]init];
    [self.btn setBackgroundImage:[UIImage imageNamed:@"HD_pusharrow"] forState:UIControlStateNormal];
    [self addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(10);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    self.timeLabel.textAlignment=NSTextAlignmentRight;
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(40);
        make.right.equalTo(self.btn.mas_left).offset(-10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(16);
    }];
    
    self.msgTitleLabel = [[UILabel alloc]init];
    self.msgTitleLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.msgTitleLabel.font = [UIFont systemFontOfSize:20.0];
    [self addSubview:self.msgTitleLabel];
    [self.msgTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(40);
        make.left.height.mas_equalTo(20);
        make.right.equalTo(self.timeLabel.mas_left).offset(0);
    }];
    
    self.detailsLabel = [[UILabel alloc]init];
    self.detailsLabel.font = [UIFont systemFontOfSize:16.0];
    self.detailsLabel.numberOfLines = 0;
    self.detailsLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    [self addSubview:self.detailsLabel];
    [self.detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.msgTitleLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-20);
    }];
}


-(void)setModel:(GYOrderMessageListModel *)model{
    
    _model=model;
    
    self.msgTitleLabel.text = model.messageListTitle;
    
    NSString *timeStr=[[GYHDMessageCenter sharedInstance]messageTimeStrFromTimerString:model.messageListTimer];
    self.timeLabel.text = timeStr;
    self.detailsLabel.text =model.messageListContent;
    if ([model.readStatus isEqualToString:@"0"]) {
        
        self.tipView.hidden=YES;
    }else{
        
        self.tipView.hidden=NO;
    }
    
}
@end
