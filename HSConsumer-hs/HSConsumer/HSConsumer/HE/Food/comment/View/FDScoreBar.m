//
//  GYRateBar.m
//  Test
//
//  Created by zhangqy on 15/10/21.
//  Copyright © 2015年 zhangqy. All rights reserved.
//

#import "FDScoreBar.h"

@interface FDScoreBar ()
@property (assign, nonatomic) NSInteger width;
@property (assign, nonatomic) NSInteger height;
@property (assign, nonatomic) NSInteger ivWidth;
@end

@implementation FDScoreBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bottomView = [[UIView alloc] initWithFrame:self.bounds];
        _bottomView.backgroundColor = [UIColor clearColor];
        [self addSubview:_bottomView];
        _topView = [[UIView alloc] initWithFrame:self.bounds];
        _topView.backgroundColor = [UIColor clearColor];
        [self addSubview:_topView];
        [self setupBottomView];
        [self setupTopView];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topViewTapped:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame selectImage:(UIImage*)selectImage unSelectImage:(UIImage*)unSelectImage
{
    self.clipsToBounds = YES;
    _width = frame.size.width;
    _height = frame.size.height;
    _selectImage = selectImage;
    _unSelectImage = unSelectImage;
    _canTouch = YES;
    _ivWidth = _width / 3;
    return [self initWithFrame:frame];
}

- (void)setupBottomView
{
    for (int i = 0; i < 3; i++) {
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(i * _ivWidth, 0, _ivWidth - 2, _height)];
        iv.contentMode = UIViewContentModeScaleAspectFit;
        iv.image = _unSelectImage;
        [_bottomView addSubview:iv];
    }
}

- (void)setupTopView
{
    [self setWidth:0 view:_topView];
    _topView.clipsToBounds = YES;
    for (int i = 0; i < 3; i++) {
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(i * _ivWidth, 0, _ivWidth - 2, _height)];
        iv.contentMode = UIViewContentModeScaleAspectFit;
        iv.image = _selectImage;
        [_topView addSubview:iv];
    }
}

- (void)topViewTapped:(UITapGestureRecognizer*)tap
{
    if (!_canTouch) {
        return;
    }
    [self setWidth:0 view:_topView];

    CGPoint point = [tap locationInView:self];
    _score = point.x / _ivWidth + 1;
    [self setScore:_score];
}

- (void)setWidth:(NSInteger)width view:(UIView*)view
{
    CGRect rect = view.frame;
    rect.size.width = width;
    view.frame = rect;
}

- (void)setScore:(NSInteger)score
{
    [self setWidth:0 view:_topView];
    _score = score;
    [self setWidth:score * _ivWidth view:_topView];
    if (_block) {
        _block();
    }
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    if (!_canTouch) {
        return;
    }
    [self setWidth:0 view:_topView];
    CGPoint point = [[touches anyObject] locationInView:self];
    _score = point.x / _ivWidth + 1;
    [self setScore:_score];
}

@end
