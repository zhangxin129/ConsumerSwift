//
//  GYHSHealthViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/8/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSHealthViewController.h"
#import "GYHSLableTextFileTableViewCell.h"
#import "GYHSButtonCell.h"
#import "GYHSLabelTextViewButtonCell.h"
#import "GYAccidentPromptTableViewCell.h"


@interface GYHSHealthViewController ()<UITableViewDataSource,UITableViewDelegate,GYHSButtonCellDelegate,GYHSRealNameRegistrationCellDelegate>
@property(nonatomic,strong)UITableView *healthTableView;
@property(nonatomic,copy)NSMutableArray *healthDataArray;
@property(nonatomic,copy)NSString *healthCardNumber;
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSString *hospitalStr;
@property(nonatomic,copy)NSString *cityStr;

@end

@implementation GYHSHealthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  kDefaultVCBackgroundColor;
    [self.healthTableView registerNib:[UINib nibWithNibName:@"GYHSLabelTextViewButtonCell" bundle:nil] forCellReuseIdentifier:@"GYHSLabelTextViewButtonCell"];
    [self.healthTableView registerNib:[UINib nibWithNibName:@"GYHSButtonCell" bundle:nil] forCellReuseIdentifier:@"GYHSButtonCell"];
    [self.healthTableView registerNib:[UINib nibWithNibName:@"GYAccidentPromptTableViewCell" bundle:nil] forCellReuseIdentifier:@"GYAccidentPromptTableViewCell"];
}
#pragma mark -- GYHSButtonCellDelegate
- (void)nextBtn
{
   
}
#pragma mark -- cell中textView的代理
-(void)inputRealNameValue:(NSString *)value indexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark -- cell中选者时间按钮的代理
-(void)chooseSelectButton:(NSIndexPath *)indexPath
{
    
}
#pragma  mark -- UITableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSMutableDictionary* dic = self.healthDataArray[indexPath.section][indexPath.row];
    if (indexPath.section == 2) {
        GYHSButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSButtonCell" forIndexPath:indexPath];
        cell.btnDelegate = self;
        [cell.btnTitle setTitle:kLocalized(@"GYHS_BP_Next_Step") forState:UIControlStateNormal];
        return cell;
    }else if (indexPath.section == 3){
        GYAccidentPromptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYAccidentPromptTableViewCell" forIndexPath:indexPath];
        
        return cell;
    }else{
        GYHSLabelTextViewButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLabelTextViewButtonCell" forIndexPath:indexPath];
        [self setCellValues:cell dataDic:dic indexPath:indexPath];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}
- (void)setCellValues:(GYHSLabelTextViewButtonCell*)cell
              dataDic:(NSDictionary*)dataDic
            indexPath:(NSIndexPath*)indexPath
{
    NSString* name = [dataDic valueForKey:@"Name"];
    NSString* value2 = [dataDic valueForKey:@"Value"];
    NSString* placeHolder = [dataDic valueForKey:@"placeHolder"];
    BOOL showSmsBtn = [[dataDic valueForKey:@"showSmsBtn"] boolValue];
    BOOL showtextViewClick = [[dataDic valueForKey:@"textViewClick"] boolValue];
    [cell LicenceLbLeftlabel:name tfTextView:value2 Lbplaceholder:placeHolder setBackgroundImageSelectButton:@"hs_down_cell_btn_menu4" tag:indexPath showSelectButton:showSmsBtn textViewClick:showtextViewClick];
    cell.realNameDelegate = self;
}
#pragma mark -- 懒加载
-(UITableView*)healthTableView
{
    if (_healthTableView == nil) {
        _healthTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
        _healthTableView.dataSource = self;
        _healthTableView.delegate = self;
        [self.view addSubview:_healthTableView];
    }
    return _healthTableView;
}
-(NSMutableArray*)healthDataArray
{
    if (_healthTableView == nil) {
        NSArray *keyAry = @[@"Name", @"Value", @"placeHolder",@"showSmsBtn",@"textViewClick"];
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        NSMutableArray *array2 = [[NSMutableArray alloc] init];
        
        NSArray *valueAry = @[kLocalized(@"医保卡号"),
                              @"",
                              kLocalized(@"输入医保号码"),
                              [NSNumber numberWithBool:NO],
                              [NSNumber numberWithBool:NO]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"诊疗起始日期"),
                     @"",
                     @"",
                     [NSNumber numberWithBool:YES],
                     [NSNumber numberWithBool:YES]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        
        valueAry = @[kLocalized(@"诊疗结束日期"),
                     @"",
                     @"",
                     [NSNumber numberWithBool:YES],
                     [NSNumber numberWithBool:YES]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        
        valueAry = @[kLocalized(@"所在城市"),
                     @"",
                     kLocalized(@"输入城市名"),
                     [NSNumber numberWithBool:NO],
                     [NSNumber numberWithBool:NO]];
        [array2 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        
        valueAry = @[kLocalized(@"所在医院"),
                     @"",
                     kLocalized(@"输入医院名"),
                     [NSNumber numberWithBool:NO],
                     [NSNumber numberWithBool:NO]];
        [array2  addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        _healthDataArray = [[NSMutableArray alloc] initWithObjects:array1,array2, nil];
    }
    return _healthDataArray;
}
@end
