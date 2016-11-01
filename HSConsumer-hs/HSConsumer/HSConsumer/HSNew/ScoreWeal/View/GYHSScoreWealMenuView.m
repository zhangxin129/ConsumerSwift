//
//  GYHSScoreWealMenuView.m
//  HSConsumer
//
//  Created by lizp on 16/9/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kGYHSScoreWealMenuViewTag 500

#import "GYHSScoreWealMenuView.h"
#import "YYKit.h"
#import "GYHSTools.h"

@interface GYHSScoreWealMenuView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *leftTitle;//左边标题数组
@property (nonatomic,strong) NSArray *rightTitle;//右边标题数组
@property (nonatomic,strong) UILabel *leftLabel;//左边标题
@property (nonatomic,strong) UILabel *rightLabel;//右边标题
@property (nonatomic,strong) UITableView *tableView;//下拉菜单
@property (nonatomic,assign) NSInteger menuType;//  0未选择任何 1 选择左边 2 选择右边
@property (nonatomic,strong) UIControl *overlayControl;//背景
@property (nonatomic,assign) NSInteger leftIndex;// 左边选择的下标
@property (nonatomic,assign) NSInteger rightIndex;// 右边选择的下标

@end

@implementation GYHSScoreWealMenuView

-(instancetype)initWithFrame:(CGRect)frame LeftTitle:(NSArray<NSString *> *)leftTitle rightTitle:(NSArray<NSString *> *)rightTitle {

    if(self = [super initWithFrame:frame]) {
        self.leftTitle = leftTitle;
        self.rightTitle = rightTitle;
        [self setUp];
    }
    return self;
}



-(void)setUp {
    
    self.menuType = 0;
    self.leftIndex = 0;
    self.rightIndex = 0;
    
    for (NSInteger i = 0; i<2; i++) {
        UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(i*self.bounds.size.width/2, 0, self.bounds.size.width/2, self.bounds.size.height)];
        control.tag = kGYHSScoreWealMenuViewTag +i;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i+1)+self.bounds.size.width/2-30+7, self.bounds.size.height/2-8, 16, 16)];
        imageView.image = [UIImage imageNamed:@"gy_hd_down_arrow"];
        [control addSubview:imageView];
        UILabel *label;
        if(i == 0) {
            self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width/2-30, self.bounds.size.height)];
            self.leftLabel.text = self.leftTitle[0];
            label = self.leftLabel;
           
        }else if(i == 1) {
            self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width/2-30, self.bounds.size.height)];
            self.rightLabel.text = self.rightTitle[0];
            label = self.rightLabel;
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.font = kScoreWealMenuFont;
        label.textColor = UIColorFromRGB(0x333333);
        [control addSubview:label];
        
        [self addSubview:control];
        
        [control addTarget:self action:@selector(controlClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2, 10, 1, (self.bounds.size.height-20))];
    lineView.backgroundColor = UIColorFromRGB(0xebebeb);
    [self addSubview:lineView];
    
    self.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
    self.layer.borderWidth = 0.5;
    
}

-(void)controlClick:(UIControl *)sender {
    
    [self.overlayControl removeFromSuperview];
    self.overlayControl = nil;
    if(sender.tag - kGYHSScoreWealMenuViewTag == 0) {
        if(self.menuType == 0) {
            self.menuType = 1;
        }else if (self.menuType == 1) {
            self.menuType = 0;
        }else if (self.menuType == 2) {
            self.menuType = 1;
        }
    }else if (sender.tag - kGYHSScoreWealMenuViewTag == 1) {
        if(self.menuType == 0) {
            self.menuType = 2;
        }else if (self.menuType == 1) {
            self.menuType = 2;
        }else if (self.menuType == 2) {
            self.menuType = 0;
        }
    }
    
    
    if (self.menuType == 0) {
        [self.tableView removeFromSuperview];
    }else {
        [self.tableView removeFromSuperview];
        if (self.menuType == 1) {
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height *self.leftTitle.count) style:UITableViewStylePlain];
        }else if (self.menuType == 2) {
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2, 0, self.bounds.size.width/2, self.bounds.size.height *self.rightTitle.count) style:UITableViewStylePlain];
        }
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.showsVerticalScrollIndicator = NO;
        [self.overlayControl addSubview:self.tableView];
    }
}


#pragma mark - tableView delegate 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(self.menuType == 1) {
        return self.leftTitle.count;
    }else if (self.menuType == 2) {
        return self.rightTitle.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.font = kScoreWealMenuFont;
    if(self.menuType == 1) {
        cell.textLabel.text = self.leftTitle[indexPath.row];
    }else if (self.menuType == 2) {
        cell.textLabel.text = self.rightTitle[indexPath.row];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.menuType == 1) {
        self.leftLabel.text = self.leftTitle[indexPath.row];
        self.leftIndex = indexPath.row;
    }else if (self.menuType == 2) {
        self.rightLabel.text = self.rightTitle[indexPath.row];
        self.rightIndex = indexPath.row;
    }
    self.menuType = 0;
    [tableView removeFromSuperview];
    [self.overlayControl removeFromSuperview];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectLeftIndex:rightIndex:)]) {
        [self.delegate selectLeftIndex:self.leftIndex rightIndex:self.rightIndex];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return self.bounds.size.height;
}

//点击背景消失
-(void)overlayControlClick {
    [self.tableView removeFromSuperview];
    [self.overlayControl removeFromSuperview];
    self.overlayControl = nil;
    self.menuType = 0;
}

#pragma mark - 懒加载
-(UIControl *)overlayControl {

    if(!_overlayControl) {
        _overlayControl = [[UIControl alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bottom, self.bounds.size.width, self.superview.frame.size.height-self.bottom)];
        _overlayControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [_overlayControl addTarget:self action:@selector(overlayControlClick) forControlEvents:UIControlEventTouchUpInside];
        [self.superview addSubview:_overlayControl];
    }
    return _overlayControl;
}

@end
