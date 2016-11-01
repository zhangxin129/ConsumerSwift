//
//  GYHDQucikView.m
//  GYRestaurant
//
//  Created by apple on 16/6/24.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDQucikView.h"
@interface GYHDQucikView()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView*qucikTableView;
@property(nonatomic,strong)NSMutableArray*qucikDataAarr;
@end
@implementation GYHDQucikView
-(instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        self.qucikDataAarr=[@[@"快捷回复内容1",@"快捷回复内容2",@"快捷回复内容3",@"快捷回复内容4",@"快捷回复内容5",@"快捷回复内容6"]mutableCopy];
        
        [self.qucikTableView reloadData];
    }
    
    return self;
}

-(UITableView *)qucikTableView{

    if (!_qucikTableView) {
        
        _qucikTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-350, 211)];
        _qucikTableView.delegate=self;
        _qucikTableView.dataSource=self;
        [_qucikTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self addSubview:_qucikTableView];
    }
    return _qucikTableView;
}

-(NSMutableArray *)qucikDataAarr{

    if (!_qucikDataAarr) {
        
        _qucikDataAarr=[NSMutableArray array];
        
    }
    return _qucikDataAarr;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.qucikDataAarr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    
    cell.textLabel.text=self.qucikDataAarr[indexPath.row];
    
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (_delegate &&[_delegate respondsToSelector:@selector(GYHDQucikViewSelectQucikString:)]) {
        
        [_delegate GYHDQucikViewSelectQucikString:self.qucikDataAarr[indexPath.row]];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
@end
