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

@interface GYHDEmojiView ()<UICollectionViewDataSource,UICollectionViewDelegate>
/**表情显示View*/
@property(nonatomic,weak)UICollectionView *emojiCollectionView;
/**图像数组*/
@property(nonatomic, strong)NSMutableArray *emojiArray;
/**分页*/
@property(nonatomic, weak)UIPageControl *page;

@property(nonatomic, strong)UIImageView*emojiView;
@end

@implementation GYHDEmojiView



- (NSMutableArray *)emojiArray
{
    
//    NSMutableArray *chlidArray = [NSMutableArray array];
//    if (!_emojiArray) {
//        for (int i = 1; i < 60/23+1; i++) {
//            NSMutableArray *array = [NSMutableArray array];
//            int num = i * 24;
//            for ( int j = num - 24 ; j <= num; j++) {
//                DDLogCInfo(@"%d",j/3+(j%3 * 8 ));
//                NSString *title = [NSString stringWithFormat:@"%d",j/3+(j%3 * 8 )];
//                [array  addObject:title];
//                if (j == num) {
//                    DDLogCInfo(@"第");
//                }
//            }
//            [chlidArray addObject:array];
//        }
//        _emojiArray = chlidArray;
//    }
    if (!_emojiArray) {

        NSMutableArray *chlidArray = [NSMutableArray array];
        for (int z = 1; z <=1; z ++) {
            NSMutableArray *array = [NSMutableArray array];
            int k = z * 64;
            
            for (int i = 0; i < 16; i++) {

                for ( int j = k - 64; j < k; j++) { //j = k+1-24

                    if (j%16 == i) {
                        if (z == 1) {
                                if (j % 63 ==0 && j != 0) {
                                    NSString *title = [NSString stringWithFormat:@"del"];
                                    [array  addObject:title];
                                }else {
                                    NSString *title = [NSString stringWithFormat:@"%03d",j+1];
                                    [array  addObject:title];
                                }
                            }else {
                                if ((j-z+1) % 63 ==0 && j !=  k - 64) {
                                    NSString *title = [NSString stringWithFormat:@"del"];
                                    [array  addObject:title];
                                }else {
                                    NSString *title = [NSString stringWithFormat:@"%03d",j-z+1+1];
                                    [array  addObject:title];
                                }

                            }
                    }
                    
                }
            }
            [chlidArray addObject: array];
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
//        [self setup];
        
        //   更改页面布局，采用九宫格

        CGFloat width = 35;
        CGFloat higth = 35;
        CGFloat distance_x = (kScreenWidth-350-35*16)/15;
        CGFloat distance_y =(211-(35*4)-(5*2))/3;
        
        
        for (int i = 0; i<4; i++) {
            
            for (int j = 0; j<16; j++) {
                
                self.emojiView=[[UIImageView alloc]initWithFrame:CGRectMake((width+distance_x)*j, 5+(higth+distance_y)*i, 35, 35)];
                self.emojiView.userInteractionEnabled=YES;
//                self.emojiView.backgroundColor=[UIColor redColor];
                UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myGes:)];
                [self.emojiView addGestureRecognizer:tap];
                self.emojiView.tag=1000+j+16*i+1;
                NSString*emojiStr=[NSString stringWithFormat:@"%03d",j+16*i+1];
                self.emojiView.image=[UIImage imageNamed:emojiStr];
                
                if (j+16*i==63) {
                    
                    self.emojiView.image=[UIImage imageNamed:@"del"];
                }

                [self addSubview:self.emojiView];
            }
            
        }
    }
    return self;
}

-(void)myGes:(UITapGestureRecognizer*)tap{
    
    NSInteger index = tap.view.tag-1000;
    NSString *imageName;
    
    if (index==64) {
        
        imageName=@"del";
        
    }else{
    
        imageName=[NSString stringWithFormat:@"%03ld",index];
    
    }
  
    if (imageName.integerValue <= 60 || [imageName isEqualToString:@"del"]) {
        
        if ([self.delegate respondsToSelector:@selector(GYHDEmojiView:selectEmojiName:)]) {
            [self.delegate GYHDEmojiView:self selectEmojiName:imageName];
        }
    }
    
}
- (void)setup
{
        WS(weakSelf);
    DDLogCInfo(@"设置相关属性");
//    UIButton *sendButton = [[UIButton alloc] init];
//    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
//    [sendButton setBackgroundImage:[UIImage imageNamed:@"HD_sendBtn"] forState:UIControlStateNormal];
//    [sendButton addTarget:self action:@selector(sendButton) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:sendButton];
//    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(-4);
//        make.right.mas_equalTo(-12);
//    }];
    
    //2. page
    UIPageControl *page = [[UIPageControl alloc] init];
    page.numberOfPages = 3;
    page.currentPage = 0;
    page.currentPageIndicatorTintColor = [UIColor redColor];
    page.pageIndicatorTintColor = [UIColor grayColor];
    page.hidden=YES;
    [self addSubview:page];
    _page = page;
    [page mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf);
        make.bottom.equalTo(self);
    }];
    
    //1. 展示photoView
    //创建一个layout布局类
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat itemWH =(kScreenWidth-350) / 16;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake(itemWH, 38);
    //创建collectionView 通过一个布局策略layout来创建
    UICollectionView * collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    collect.pagingEnabled = YES;

    
    //代理设置
    collect.delegate=self;
    collect.dataSource=self;
    //注册item类型 这里使用系统的类型
    [collect registerClass:[GYHDEmojiCell class] forCellWithReuseIdentifier:@"emojiCellID"];
    [self addSubview:collect];
    _emojiCollectionView = collect;
//    暂时不用到 add zhangx
    collect.hidden=YES;
    collect.backgroundColor = [UIColor whiteColor];
    [collect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf);
        make.bottom.equalTo(page.mas_top).offset(10);
    }];
    
}
- (void)sendButton
{
    DDLogCInfo(@"发送按钮");
    if ([self.delegate respondsToSelector:@selector(GYHDemojiVIewSendMessage)]) {
        [self.delegate GYHDemojiVIewSendMessage];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
        NSInteger selectInt = (int)scrollView.contentOffset.x /self.bounds.size.width ;
    DDLogCInfo(@"%ld",(long)selectInt);
    DDLogCInfo(@"%f",scrollView.contentOffset.x );
    
    self.page.currentPage = selectInt;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.emojiArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *arrya = self.emojiArray[section];
    return arrya.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GYHDEmojiCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"emojiCellID" forIndexPath:indexPath];
    NSString *title = self.emojiArray[indexPath.section][indexPath.row];
    [cell setimageName:title];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *imageName = self.emojiArray[indexPath.section][indexPath.row];
    if (imageName.integerValue <= 60 || [imageName isEqualToString:@"del"]) {
        if ([self.delegate respondsToSelector:@selector(GYHDEmojiView:selectEmojiName:)]) {
            [self.delegate GYHDEmojiView:self selectEmojiName:imageName];
        }
    }
}
@end
