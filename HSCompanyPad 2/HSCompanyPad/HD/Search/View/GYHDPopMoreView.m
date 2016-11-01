//
//  GYHDPopMoreView.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDPopMoreView.h"



@interface GYHDPopMoreView () <UITableViewDataSource, UITableViewDelegate>
/**
 *  下拉选项
 */
@property (nonatomic, weak) UITableView* showTableView;

@property (nonatomic, weak) UIImageView* showImageView;
@end

@implementation GYHDPopMoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    UIImageView* showImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_pop_more_bg"]];
    showImageView.userInteractionEnabled = YES;
    [self addSubview:showImageView];
    _showImageView = showImageView;
    
    UITableView* showTableView = [[UITableView alloc] init];
    showTableView.dataSource = self;
    showTableView.delegate = self;
    showTableView.scrollEnabled = NO;
    showTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [showTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"popMoreCellID"];
    showTableView.backgroundColor = [UIColor clearColor];
    [showImageView addSubview:showTableView];
    _showTableView = showTableView;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.moreSelectArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"popMoreCellID"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = self.moreSelectArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    @weakify(self);
    if (_block) {
        @strongify(self);
        _block(self.moreSelectArray[indexPath.row]);
        [self disMiss];
    }
}

- (void)showBottomTo:(UIView *)view {
    CGRect vrect =  [view convertRect:view.frame toView:nil ];
    UIWindow* window = [UIApplication sharedApplication].windows.lastObject;
    [window addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    CGRect Frame = self.showImageView.frame;
    
    self.showImageView.frame = CGRectMake(vrect.origin.x, vrect.origin.y + vrect.size.height, Frame.size.width, Frame.size.height);

    [self.showTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
    }];

}
//- (void)show
//{
//    UIWindow* window = [UIApplication sharedApplication].windows.lastObject;
//    [window addSubview:self];
//    [self mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.top.left.bottom.right.mas_equalTo(0);
//    }];
//}

- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    [self disMiss];
}

- (void)disMiss
{
    [self removeFromSuperview];
}

- (void)setMoreSelectArray:(NSArray*)moreSelectArray
{
    _moreSelectArray = moreSelectArray;
    [self.showTableView reloadData];
    

}
@end
