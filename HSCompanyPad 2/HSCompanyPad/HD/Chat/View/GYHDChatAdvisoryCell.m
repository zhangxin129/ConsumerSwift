//
//  GYHDChatAdvisoryCell.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/17.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDChatAdvisoryCell.h"

@interface GYHDChatAdvisoryCell ()

@property(nonatomic, strong)UILabel *chatRecvTimeLabel;
@property(nonatomic, strong)UIView  *myContentView;
@property(nonatomic, strong)UILabel *chatCharacterLabel;

@end

@implementation GYHDChatAdvisoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
- (void)setup {
    //4. 发送时间
    self.contentView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];;
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.chatRecvTimeLabel = [[UILabel alloc] init];
    self.chatRecvTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.chatRecvTimeLabel.font = [UIFont systemFontOfSize:14.0f];
    self.chatRecvTimeLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.contentView addSubview:self.chatRecvTimeLabel];

    self.myContentView = [[UIView alloc] init];
    self.myContentView.backgroundColor = [UIColor colorWithHex:0xc5cad1];
    self.myContentView.layer.masksToBounds = YES;
    self.myContentView.layer.cornerRadius = 5;
    [self.contentView addSubview:self.myContentView];
    
    self.chatCharacterLabel = [[UILabel alloc] init];
    self.chatCharacterLabel.textAlignment = NSTextAlignmentCenter;
    self.chatCharacterLabel.font = [UIFont systemFontOfSize:14.0f];
    self.chatCharacterLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.chatCharacterLabel];

    
    @weakify(self);
    [self.chatRecvTimeLabel mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.mas_equalTo(0);
    }];
    
    [self.chatCharacterLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.chatRecvTimeLabel.mas_bottom).offset(26);
        make.centerX.equalTo(self.contentView);

    }];
    
    [self.myContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.chatCharacterLabel).offset(-6);
        make.left.equalTo(self.chatCharacterLabel).offset(-10);
        make.right.equalTo(self.chatCharacterLabel).offset(10);
        make.height.mas_equalTo(26);
        make.bottom.mas_equalTo(0);

    }];
    self.chatRecvTimeLabel.text = @" ";
    self.chatCharacterLabel.text = @" ";
}

-(void)setModel:(GYHDChatModel *)model{

    _model = model;
    self.chatCharacterLabel.text = model.messageContentString;
    self.chatRecvTimeLabel.text = model.messageRecvTimeString;
}

-(void)setSessionModel:(GYHDSessionRecordModel *)sessionModel{

    _sessionModel = sessionModel;
     NSDictionary *dict = [GYHDUtils stringToDictionary:sessionModel.msgContent];
    self.chatCharacterLabel.text =@"提示语";
    self.chatRecvTimeLabel.text = sessionModel.sendTimeFormat;

}

@end
