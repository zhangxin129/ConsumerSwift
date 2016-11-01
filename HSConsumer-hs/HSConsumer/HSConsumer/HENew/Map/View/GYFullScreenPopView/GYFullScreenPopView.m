//
//  GYFullScreenPopView.m
//  GYFullScreenPopView
//
//  Created by xiaoxh on 16/9/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GYFullScreenPopView.h"
#import "GYFullPopOneCell.h"
#import "GYFullPopTwoCell.h"
#import "GYHEAreaLocationModel.h"

@interface GYFullScreenPopView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *onetableView;
@property (nonatomic,strong)UITableView *twotableView;
@property (nonatomic,strong)NSMutableArray *oneArray;
@property (nonatomic,strong)NSMutableArray *twoArray;
@property (nonatomic,strong)NSIndexPath *indexPath;
@end
@implementation GYFullScreenPopView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //蒙版
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return self;
}
-(void)show
{
    //蒙版加入window上
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"arealocationlist" ofType:@"txt"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    for (NSDictionary* oneDic in dict[@"data"]) {
        GYHEAreaLocationModel* oneModel = [[GYHEAreaLocationModel alloc] initWithDictionary:oneDic error:nil];
        [self.oneArray addObject:oneModel];
       
        if ([oneModel.areaCode isEqualToString:@"11"]) {
            
               self.twoArray = oneModel.childs;
        }
    }
    [self.onetableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYFullPopOneCell class]) bundle:nil] forCellReuseIdentifier:@"GYFullPopOneCell"];
    [self.twotableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYFullPopTwoCell class]) bundle:nil] forCellReuseIdentifier:@"GYFullPopTwoCell"];
}
-(void)dismiss
{
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.onetableView) {
        return self.oneArray.count;
    }else {
        return self.twoArray.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.onetableView) {
        GYFullPopOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYFullPopOneCell"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        GYHEAreaLocationModel *model = self.oneArray[indexPath.row];
        tableView.backgroundColor = [kCorlorFromHexcode(0xfb7d00) colorWithAlphaComponent:0.8];
        cell.provinceNameLb.text = model.areaName;
        if (self.indexPath) {
            if (indexPath.row == 0) {
                cell.lineView.hidden = NO;
            }
        }
        if (indexPath.row == self.indexPath.row) {
             cell.lineView.hidden = NO;
        }else{
             cell.lineView.hidden = YES;
        }
        return cell;
    }else {
        GYFullPopTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYFullPopTwoCell"];
       tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        GYHEChildsModel *model = self.twoArray[indexPath.row];
        tableView.backgroundColor = [kCorlorFromHexcode(0xffffff) colorWithAlphaComponent:0.8];
        cell.cityNameLb.text = model.areaName;
        return cell;
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView == self.onetableView) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 110, 44);
        btn.layer.cornerRadius = 16;
        [btn setImage:[UIImage imageNamed:@"gyhe_pack_up"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        return btn;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == self.onetableView) {
        return 30;
    }
    return 0.1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.twotableView) {
       
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
         GYHEAreaLocationModel *model = self.twoArray[indexPath.row];
        NSMutableArray *array;
        if (model.childs.count>0) {
            array = model.childs;
        }else{
            array = self.twoArray;
        }
        if ([_delegate respondsToSelector:@selector(fullcityName:nsAray:)]) {
           [self.delegate fullcityName:model.areaName nsAray:array];
            globalData.selectedCityName = model.areaName;
           
        }
        [self dismiss];
    }else{
        [self.twoArray removeAllObjects];
        GYFullPopOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYFullPopOneCell"];
        cell.lineView.hidden = NO;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSString* path = [[NSBundle mainBundle] pathForResource:@"arealocationlist" ofType:@"txt"];
        NSData* data = [NSData dataWithContentsOfFile:path];
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary* oneDic in dict[@"data"]) {
            GYHEAreaLocationModel* oneModel = [[GYHEAreaLocationModel alloc] initWithDictionary:oneDic error:nil];
              if ([[self.oneArray[indexPath.row] areaCode] isEqualToString:oneModel.areaCode]) {
                  self.twoArray  = oneModel.childs;
              }
        }
        if (self.twoArray.count * 40 < kScreenHeight-170) {
            CGRect rect = self.twotableView.frame;
            rect.size.height = self.twoArray.count * 40;
            self.twotableView.frame = rect;
        }
        self.indexPath = indexPath;
        [self.onetableView reloadData];
        [self.twotableView reloadData];
    }
}
#pragma mark －－ Lazy loading
-(UITableView*)onetableView
{
    if (!_onetableView) {
        _onetableView = [[UITableView alloc] initWithFrame:CGRectMake(30, 30, 130, kScreenHeight-90) style:UITableViewStylePlain];
        _onetableView.dataSource = self;
        _onetableView.delegate = self;
        _onetableView.backgroundColor = [UIColor orangeColor];
        _onetableView.layer.cornerRadius = 10;
        [self addSubview:_onetableView];
    }
    return _onetableView;
}
-(UITableView*)twotableView
{
    if (!_twotableView) {
        _twotableView = [[UITableView alloc] initWithFrame:CGRectMake(160, 70, 130, kScreenHeight-170)];
        _twotableView.backgroundColor = [UIColor grayColor];
        _twotableView.dataSource = self;
        _twotableView.delegate = self;
        _twotableView.layer.cornerRadius = 10;
        [self addSubview:_twotableView];
    }
    return _twotableView;
}
-(NSMutableArray*)oneArray
{
    if (!_oneArray) {
        _oneArray = [[NSMutableArray alloc] init];
    }
    return _oneArray;
}
-(NSMutableArray*)twoArray
{
    if (!_twoArray) {
        _twoArray = [[NSMutableArray alloc] init];
    }
    return _twoArray;
}
@end
