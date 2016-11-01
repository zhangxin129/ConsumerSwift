//
//  GYHDAudioView.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDAudioChooseView.h"
#import "GYHDAudioTool.h"

@interface GYHDAudioChooseView ()<GYHDAudioToolDelegate>
@property(nonatomic, strong)UIButton *audioButton;
@property(nonatomic, strong)UIButton *listenButton;
@property(nonatomic, strong)UIButton *deleteButton;
@property(nonatomic, strong)UIImageView *oscillationImageView;
@property(nonatomic, strong)UILabel     *durationLabel;
@property(nonatomic, strong)UILabel     *tipsLabel;
@property(nonatomic, strong)UIButton *sendButton;
@property(nonatomic, strong)UIButton *cancelButton;
@property(nonatomic, strong)UIButton *playerButton;
@property(nonatomic, strong)GYHDAudioTool *audioTool;
/**提示title定时器*/
@property (nonatomic, strong) NSTimer* recordtimer;
/**录音长度*/
@property (nonatomic, assign)NSInteger audioTimeLength;
/**录音路径*/
@property (nonatomic, copy)NSString *audioPath;
@property(nonatomic, strong)UILongPressGestureRecognizer *longPress;
@property(nonatomic, assign)NSInteger selectState;   //1.播放选择，2发送选择，3.删除选择。4.取消手势
@end

@implementation GYHDAudioChooseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
        [self setupAuto];
    }
    return self;
}

- (void)setup {
    self.audioTool = [[GYHDAudioTool alloc] init];
    self.audioTool.delegate = self;
    self.audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.audioButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_audio_fsbtn_normal"] forState:UIControlStateNormal];
    [self.audioButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_audio_fsbtn_select"] forState:UIControlStateSelected];
    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    self.longPress.minimumPressDuration = 0.5;
    [self.audioButton addGestureRecognizer:self.longPress];
    [self addSubview:self.audioButton];
    
    self.listenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.listenButton setImage:[UIImage imageNamed:@"gyhd_chat_listen_btn_normal"] forState:UIControlStateNormal];
    [self.listenButton setImage:[UIImage imageNamed:@"gyhd_chat_listen_btn_select"] forState:UIControlStateSelected];
    [self addSubview:self.listenButton];

    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setImage:[UIImage imageNamed:@"gyhd_chat_delete_btn_normal"] forState:UIControlStateNormal];
    [self.deleteButton setImage:[UIImage imageNamed:@"gyhd_chat_delete_btn_select"] forState:UIControlStateSelected];
    [self addSubview:self.deleteButton];
    
    self.durationLabel = [[UILabel alloc] init];
    self.durationLabel.text = @"11";
    [self addSubview:self.durationLabel];
    
    self.oscillationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_chat_oscillation_1"]];
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 1; i <= 6; i++) {
        NSString *imageName = [NSString stringWithFormat:@"gyhd_chat_oscillation_%d",i];
        UIImage *image =  [UIImage imageNamed:imageName];
        [imageArray addObject:image];
    }
    self.oscillationImageView.animationImages = imageArray;
    self.oscillationImageView.animationDuration = 1;
    [self addSubview:self.oscillationImageView];
    
    
    NSMutableDictionary *attNormalDict = [NSMutableDictionary dictionary];
    attNormalDict[NSForegroundColorAttributeName] = [UIColor colorWithHex:0x3e8ffa];
    attNormalDict[NSFontAttributeName]= [UIFont systemFontOfSize:18.0f];
    
    NSMutableDictionary *attSelectDict = [NSMutableDictionary dictionary];
    attSelectDict[NSForegroundColorAttributeName] = [UIColor grayColor];
    attSelectDict[NSFontAttributeName]= [UIFont systemFontOfSize:18.0f];
    
    self.sendButton = [[UIButton alloc] init];
    [self.sendButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_audio_btn_normal"] forState:UIControlStateNormal];
    [self.sendButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_audio_btn_select"] forState:UIControlStateHighlighted];
    NSAttributedString *sendatt = [[NSAttributedString alloc] initWithString:kLocalized(@"GYHD_Send") attributes:attNormalDict];
    [self.sendButton setAttributedTitle:sendatt forState:UIControlStateNormal];
    NSAttributedString *sendSelectatt = [[NSAttributedString alloc] initWithString:kLocalized(@"GYHD_Send") attributes:attSelectDict];
    [self.sendButton setAttributedTitle:sendSelectatt forState:UIControlStateHighlighted];
    [self.sendButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sendButton];
    
    
    self.cancelButton = [[UIButton alloc] init];
    NSAttributedString *cancelAtt = [[NSAttributedString alloc] initWithString:kLocalized(@"GYHD_Cancel") attributes:attNormalDict];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_audio_btn_normal"] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_audio_btn_select"] forState:UIControlStateHighlighted];
    [self.cancelButton setAttributedTitle:cancelAtt forState:UIControlStateNormal];
    NSAttributedString *cancelSelectAtt = [[NSAttributedString alloc] initWithString:kLocalized(@"GYHD_Cancel") attributes:attSelectDict];
    [self.cancelButton setAttributedTitle:cancelSelectAtt forState:UIControlStateHighlighted];
    [self.cancelButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelButton];
    
    self.playerButton = [[UIButton alloc] init];
    [self.playerButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_player_audio_btn_normal"] forState:UIControlStateNormal];
    [self.playerButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_player_audio_btn_hight"] forState:UIControlStateHighlighted];
    [self.playerButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_player_audio_btn_select"] forState:UIControlStateSelected];
    [self.playerButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_player_audio_btn_disSelect"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [self.playerButton addTarget:self action:@selector(playerbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.playerButton];
    
    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.text = kLocalized(@"GYHD_Hold_To_Talk");
    self.tipsLabel.textColor = [UIColor colorWithHex:0xa0a0a0];
    self.tipsLabel.font = [UIFont systemFontOfSize:16.0f];
    self.tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.tipsLabel];
    
    self.listenButton.hidden = YES;
    self.deleteButton.hidden = YES;
    self.sendButton.hidden = YES;
    self.cancelButton.hidden = YES;
    self.playerButton.hidden = YES;
    self.oscillationImageView.hidden = YES;
    self.durationLabel.hidden = YES;
    self.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
}

- (void)setupAuto {
    @weakify(self);
    [self.audioButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];
    
    [self.listenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.audioButton.mas_left).offset(-90);
        make.top.equalTo(self.audioButton);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.audioButton.mas_right).offset(90);
        make.top.equalTo(self.audioButton);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
    
    [self.oscillationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.audioButton.mas_top).offset(-18);
        make.centerX.equalTo(self.audioButton);
    }];
    
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.oscillationImageView);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.bottom.mas_equalTo(0);
        make.height.mas_equalTo(55);
        make.right.equalTo(self.cancelButton.mas_left);
        make.width.equalTo(self.cancelButton);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(55);
        make.left.equalTo(self.sendButton.mas_right);
        make.width.equalTo(self.sendButton);
    }];
    
    [self.playerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         @strongify(self);
        make.top.left.bottom.right.equalTo(self.oscillationImageView);
    }];
    
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    
    CGPoint tapPoint = [longPress locationInView:self];
    CGPoint cent = self.center;
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
//            UIView *view1= self.superview;
//            UIView *view2= view1.superview;
//            UIView *view3= view2.superview;
//            UIView *view4= view3.superview;
//            UIView *view5= view4.superview;
//            NSLog(@"view1%@view2%@view3%@view4%@view5%@",view1,view2,view3,view4,view5);
            
            self.selectState = 0;
            if (!self.audioTool.isUsering) {
                [longPress cancelsTouchesInView];
                NSString* appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
                if (appName == nil) {
                    appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
                }
                [[[UIAlertView alloc] initWithTitle:kLocalized(@"GYHD_Cannot_Record") message:[NSString stringWithFormat:@"%@ %@ %@", kLocalized(@"GYHD_Please_In_The_Settings_Privacy_Microphone_Option_Allows"),appName,kLocalized(@"GYHD_Access_To_Your_Microphone")] delegate:nil cancelButtonTitle:kLocalized(@"GYHD_Comfirm") otherButtonTitles:nil] show];
                break;
            }
            [self.audioTool startRecord];
            self.audioTimeLength = 0;
            [_recordtimer invalidate];
            _recordtimer = nil;
            _recordtimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(listenRecord) userInfo:nil repeats:YES];
            [self.oscillationImageView startAnimating];
            self.audioButton.selected = YES;
            self.listenButton.hidden = NO;
            self.deleteButton.hidden = NO;
            self.oscillationImageView.hidden = NO;
            self.durationLabel.text = @"00:01";
            self.durationLabel.hidden = NO;
            self.tipsLabel.hidden = YES;
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(1), @(0.8), @(1.2), @(1)];
            animation.keyTimes = @[@(0), @(0.4), @(0.6), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.5;
            [self.audioButton.layer addAnimation:animation forKey:@"bouce"];

            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if (!self.audioTool.isUsering) {
                break;
            }
            if (tapPoint.x < cent.x - 100) {
                self.listenButton.selected = YES;
                self.deleteButton.selected = NO;
                self.tipsLabel.text = kLocalized(@"GYHD_Let_Go_Listen");
                self.tipsLabel.hidden = NO;
                self.oscillationImageView.hidden = YES;

                self.durationLabel.hidden = YES;
            }else if(tapPoint.x > cent.x + 100){
                self.listenButton.selected = NO;
                self.deleteButton.selected = YES;
                self.tipsLabel.text =kLocalized(@"GYHD_Go_Delete");
                self.tipsLabel.hidden = NO;
                self.oscillationImageView.hidden = YES;
                self.durationLabel.hidden = YES;
  
            }else {
                self.listenButton.selected = NO;
                self.deleteButton.selected = NO;
                self.tipsLabel.text = kLocalized(@"GYHD_Hold_To_Talk");
                self.tipsLabel.hidden = YES;
                self.oscillationImageView.hidden = NO;
                self.durationLabel.hidden = NO;

            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [_recordtimer invalidate];
            _recordtimer = nil;
            [self.audioTool stopRecord];
            if (!self.audioTool.isUsering) {
                break;
            }
            if (self.listenButton.selected) {

                self.sendButton.hidden = NO;
                self.cancelButton.hidden = NO;
                self.playerButton.hidden = NO;
                self.selectState = 1;
            }else if (self.deleteButton.selected) {

                self.selectState = 3;
            }else {

                self.selectState = 2;
                if (self.audioTool.recordFilsh) {
                    [self audioRecorderDidFinishRecordingWithPath:self.audioPath];
                }
                
            }
            self.audioButton.selected = NO;
            self.listenButton.selected = NO;
            self.deleteButton.selected = NO;
            self.listenButton.hidden = YES;
            self.deleteButton.hidden = YES;
            self.oscillationImageView.hidden = YES;
            [self.oscillationImageView stopAnimating];
            self.durationLabel.text = @" ";
            self.tipsLabel.text = kLocalized(@"GYHD_Hold_To_Talk");
            self.tipsLabel.hidden = NO;
            break;
        }
        default:
            break;
    }
}

- (void)btnClick:(UIButton *)btn {
    if ([btn isEqual:self.sendButton]) {
        self.selectState = 2;
        [self audioRecorderDidFinishRecordingWithPath:self.audioPath];
        self.selectState = 0;
    }else if ([btn isEqual:self.cancelButton]) {
        [self.audioTool deleteAudioWithPath:self.audioPath];
    }
    self.sendButton.hidden = YES;
    self.cancelButton.hidden = YES;
    self.playerButton.hidden = YES;
    self.playerButton.selected = NO;
    [self.audioTool stopPlaying];
}
- (void)playerbtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        NSString *mp3Path = [NSString pathWithComponents:@[[GYHDUtils mp3folderNameString], self.audioPath]];

        [self.audioTool playMp3WithFilePath:mp3Path complete:^(GYHDAudioToolPlayerState state) {
        }];
    }else {
        [self.audioTool stopPlaying];
    }
}
- (void)listenRecord {
    
    if (self.audioTimeLength>=30) {
        [_recordtimer invalidate];
        _recordtimer = nil;
        [self.audioTool stopRecord];
        
    }else {
        self.audioTimeLength = ++self.audioTimeLength;
        self.durationLabel.text =[NSString stringWithFormat:@"00:%02ld",(long)self.audioTimeLength];
    }
}
- (void)audioRecorderDidFinishRecordingWithPath:(NSString *)mpath {
    DDLogInfo(@"%@",mpath);
//    UIView *view1= self.superview;
//    UIView *view2= view1.superview;
//    UIView *view3= view2.superview;
//    UIView *view4= view3.superview;
//    UIView *view5= view4.superview;
//    NSLog(@"view1%@view2%@view3%@view4%@view5%@",view1,view2,view3,view4,view5);
    self.audioPath = mpath;
    switch (self.selectState) {
        case 1:
        {
            DDLogInfo(@"开始试音");
            break;
        }
        case 2:
        {
            DDLogInfo(@"发送录音");
//            if(self.bloclk){
//                NSMutableDictionary *dict= [NSMutableDictionary dictionary];
//                dict[@"mp3Name"] = mpath;
//                dict[@"mp3Len"] =  [NSString stringWithFormat:@"%d",self.audioTimeLength];
//                self.bloclk(dict);
//            }
            
            if (self.audioTimeLength<=0 || !self.audioTimeLength) {
                
                [self.superview makeToast:kLocalized(@"GYHD_Recording_Time_Too_Short") duration:1.0 position:nil
                ];
                return ;
            }
            
            if ([self.delegate respondsToSelector:@selector(GYHDAudioChooseView:sendModel:)]) {
                GYHDSendModel *model = [[GYHDSendModel alloc] init];
                model.fileBaseName = mpath;
                model.sendString = [NSString stringWithFormat:@"%d",self.audioTimeLength];
                [self.delegate GYHDAudioChooseView:self sendModel:model];
            }
            break;
        }
        case 3:
        {
            DDLogInfo(@"删除录音");
            [self.audioTool deleteAudioWithPath:mpath];
            break;
        }
        default:
            break;
    }
}


@end
