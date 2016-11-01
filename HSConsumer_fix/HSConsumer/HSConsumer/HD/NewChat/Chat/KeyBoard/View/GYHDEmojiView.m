//
//  GYHDEmojiView.m
//  HSConsumer
//
//  Created by shiang on 16/2/24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDEmojiView.h"
#import "GYHDEmojiCell.h"
#import "GYHDMessageCenter.h"

@interface GYHDEmojiView () <UICollectionViewDataSource, UICollectionViewDelegate>
/**表情显示View*/
@property (nonatomic, weak) UICollectionView* emojiCollectionView;
/**图像数组*/
@property (nonatomic, strong) NSMutableArray* emojiArray;
/**分页*/
@property (nonatomic, weak) UIPageControl* page;
@end

@implementation GYHDEmojiView

- (NSMutableArray*)emojiArray
{

    //    NSMutableArray *chlidArray = [NSMutableArray array];
    //    if (!_emojiArray) {
    //        for (int i = 1; i < 60/23+1; i++) {
    //            NSMutableArray *array = [NSMutableArray array];
    //            int num = i * 24;
    //            for ( int j = num - 24 ; j <= num; j++) {
    //                NSLog(@"%d",j/3+(j%3 * 8 ));
    //                NSString *title = [NSString stringWithFormat:@"%d",j/3+(j%3 * 8 )];
    //                [array  addObject:title];
    //                if (j == num) {
    //                    NSLog(@"第");
    //                }
    //            }
    //            [chlidArray addObject:array];
    //        }
    //        _emojiArray = chlidArray;
    //    }
    if (!_emojiArray) {

        NSMutableArray* chlidArray = [NSMutableArray array];
        for (int z = 1; z <= 60 / 24 + 1; z++) {
            NSMutableArray* array = [NSMutableArray array];
            int k = z * 24;

            for (int i = 0; i < 8; i++) {

                for (int j = k - 24; j < k; j++) { //j = k+1-24

                    if (j % 8 == i) {
                        if (z == 1) {
                            if (j % 23 == 0 && j != 0) {
                                NSString* title = [NSString stringWithFormat:@"del"];
                                [array addObject:title];
                            }
                            else {
                                NSString* title = [NSString stringWithFormat:@"%03d", j + 1];
                                [array addObject:title];
                            }
                        }
                        else {
                            if ((j - z + 1) % 23 == 0 && j != k - 24) {
                                NSString* title = [NSString stringWithFormat:@"del"];
                                [array addObject:title];
                            }
                            else {
                                NSString* title = [NSString stringWithFormat:@"%03d", j - z + 1 + 1];
                                [array addObject:title];
                            }
                        }
                    }
                }
            }
            [chlidArray addObject:array];
        }
        _emojiArray = chlidArray;
    }
    return _emojiArray;
}

/*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect {
    // Drawing code
   }
 */
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
    WS(weakSelf);

    UIButton* sendButton = [[UIButton alloc] init];
    [sendButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_Send"] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"gyhd_text_field_send_icom"] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendButton];
    [sendButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.mas_equalTo(-4);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];

    //2. page
    UIPageControl* page = [[UIPageControl alloc] init];
    page.userInteractionEnabled = NO;
    page.numberOfPages = 3;
    page.currentPage = 0;
    page.currentPageIndicatorTintColor = [UIColor redColor];
    page.pageIndicatorTintColor = [UIColor grayColor];
    [self addSubview:page];
    _page = page;
    [page mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(weakSelf);
        make.bottom.equalTo(sendButton.mas_top).offset(10);
    }];

    //1. 展示photoView
    //创建一个layout布局类

    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat itemWH = (kScreenWidth) / 8;
    CGFloat itemH = (211 - 60) / 3;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake(itemWH, itemH);
    //创建collectionView 通过一个布局策略layout来创建
    UICollectionView* collect = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collect.pagingEnabled = YES;

    //代理设置
    collect.delegate = self;
    collect.dataSource = self;
    //注册item类型 这里使用系统的类型
    [collect registerClass:[GYHDEmojiCell class] forCellWithReuseIdentifier:@"emojiCellID"];
    [self addSubview:collect];
    _emojiCollectionView = collect;

    collect.backgroundColor = [UIColor whiteColor];
    [collect mas_makeConstraints:^(MASConstraintMaker* make) {

        make.left.top.right.equalTo(weakSelf);
        make.bottom.equalTo(page.mas_top).offset(10);
    }];
}

- (void)sendButton
{

    if ([self.delegate respondsToSelector:@selector(GYHDemojiVIewSendMessage)]) {
        [self.delegate GYHDemojiVIewSendMessage];
    }
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    NSInteger selectInt = (int)scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;

    self.page.currentPage = selectInt;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return self.emojiArray.count;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray* arrya = self.emojiArray[section];
    return arrya.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    GYHDEmojiCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"emojiCellID" forIndexPath:indexPath];
    NSString* title = self.emojiArray[indexPath.section][indexPath.row];
    //    cell.backgroundColor = [UIColor colorWithRed:drand48() green:drand48() blue:drand48() alpha:1];
    [cell setimageName:title];
    return cell;
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* imageName = self.emojiArray[indexPath.section][indexPath.row];
    if (imageName.integerValue <= 60 || [imageName isEqualToString:@"del"]) {
        if ([self.delegate respondsToSelector:@selector(GYHDEmojiView:selectEmojiName:)]) {
            [self.delegate GYHDEmojiView:self selectEmojiName:imageName];
        }
    }
}

@end
