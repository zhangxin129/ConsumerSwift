//
//  GYHDEmojiView.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDEmojiChooseView.h"
@interface GYHDEmojiChooseView ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIPageControl*pageControl;
@end

@implementation GYHDEmojiChooseView

- (instancetype)initWithFrame:(CGRect)frame isCompany:(BOOL)isCompany {
    if (self = [super initWithFrame:frame]) {
        self.isCompany=isCompany;
        [self setup];
    }
    return self;
}

- (void)setup {
    
    CGFloat emojiScrollViewWtih;
    
    if (self.isCompany) {
        
        emojiScrollViewWtih=kScreenWidth-425;
        
        
    }else{
    
       emojiScrollViewWtih=kScreenWidth-455;
        
    }
    UIScrollView* emojiScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, emojiScrollViewWtih, 260)];
    emojiScrollView.pagingEnabled=YES;
    emojiScrollView.showsHorizontalScrollIndicator=NO;
    emojiScrollView.showsVerticalScrollIndicator=NO;
    emojiScrollView.contentSize=CGSizeMake(emojiScrollViewWtih*2,0);
    emojiScrollView.delegate=self;
    [self addSubview:emojiScrollView];
    
    self.pageControl=[[UIPageControl alloc]init];
    self.pageControl.numberOfPages=2;
    
    self.pageControl.pageIndicatorTintColor = [UIColor  lightGrayColor];
    
    self.pageControl.currentPageIndicatorTintColor =[UIColor  colorWithRed:0 green:148/255.0 blue:251/255.0 alpha:1.0];
    [self addSubview:self.pageControl];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.bottom.mas_equalTo(0);
        
        make.left.mas_equalTo(0);
        
        make.right.equalTo(emojiScrollView.mas_right);
        
        make.height.mas_equalTo(40);
        
    }];
    
    CGFloat distance_x = (emojiScrollViewWtih-30*11)/10;
    //    三循环布局
    
    for(NSInteger page=0;page<2;page++){
        
        
        for(NSInteger row=0;row<4;row++){
            
            
            for(NSInteger line=0;line<11;line++){
                
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake((30+distance_x)*line+page*(kScreenWidth-455), 20+(220/4)*row, 30, 30)];
                imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%03d",line+11*row+page*44+1]];
                imageView.tag=1000+line+11*row+page*44+1;
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myGes:)];
                imageView .userInteractionEnabled=YES;
                [imageView addGestureRecognizer:tap];
                [emojiScrollView addSubview:imageView];
                
                if (line+11*row+page*44==43) {
                    
                    imageView.image=[UIImage imageNamed:@"del"];
                    
                }
                
                if (line+11*row+page*44==87) {
                    
                    imageView.image=[UIImage imageNamed:@"del"];
                }
 
            }
            
        }
        
    }

}

-(void)myGes:(UIGestureRecognizer*)sender{
    
    NSInteger index = sender.view.tag-1000;
    
    UIImage*image=[(UIImageView*)sender.view image];
    
    DDLogInfo(@"%@%ld",image,index);
    if (index == 67) {
        index = 33;
    }
    if ([self.delegate respondsToSelector:@selector(GYHDEmojiView:selectEmojiName:)]) {
        [self.delegate GYHDEmojiView:self selectEmojiName:[NSString stringWithFormat:@"%03ld",index]];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGPoint point=scrollView.contentOffset;
    
    NSInteger index=round(point.x/self.frame.size.width);
    
    self.pageControl.currentPage=index;

}
@end
