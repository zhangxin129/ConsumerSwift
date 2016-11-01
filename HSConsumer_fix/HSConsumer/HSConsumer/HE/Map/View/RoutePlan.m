//
//
#import "RoutePlan.h"
#import "QuartzCore/QuartzCore.h"
#import "GYBusLineMod.h"
#define HEIGHT 200
#define MARGIN 10

@interface RoutePlan () {
    UITableView* _table;
    id<RouteDelegate> _delegate;
    NSMutableArray* _result;
}
@end

@implementation RoutePlan

- (RoutePlan*)initWithData:(NSMutableArray*)result parentView:(UIView*)view delegate:(id)dele
{
    if (result == nil)
        return nil;
    _result = result;
    _delegate = dele;

    //    CGRect frame = [[UIScreen mainScreen] bounds];
    CGRect frame = view.frame;
    self = [self initWithFrame:frame];
    frame.origin.x = MARGIN;
    frame.size.width -= MARGIN * 2;
    frame.origin.y = frame.size.height - frame.origin.y - HEIGHT - MARGIN;
    frame.size.height = HEIGHT;

    _table = [[UITableView alloc] initWithFrame:frame];
    _table.delegate = self;
    _table.dataSource = self;
    _table.layer.cornerRadius = 8;
    _table.layer.opacity = 0.8;

    [self addSubview:_table];
    [view addSubview:self];

    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    int row = indexPath.row;
    //    NSMutableArray  *marr = [_result objectAtIndex:row];
    GYBusLineMod* mod = [_result objectAtIndex:row];
    int size = [mod.marrSteps count];
    //    DDLogDebug(@"heightForRowAtIndexPath:%d %d",row,size);
    return size * 30;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_result count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    int row = indexPath.row;
    NSString* CellIdentifier = [NSString stringWithFormat:@"CELL_%d", row];

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 25)];
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = [UIColor blueColor];

        GYBusLineMod* mod = [_result objectAtIndex:indexPath.row];
        [label setText:mod.title];

        [cell addSubview:label];
        int size = [mod.marrSteps count];

        int y = 26;
        for (int i = 0; i < size; i++) {
            NSString* tempString = mod.marrSteps[i];
            label = [[UILabel alloc] initWithFrame:CGRectMake(40, y, 300, 20)];
            label.font = [UIFont systemFontOfSize:12.0];
            label.textColor = [UIColor blackColor];
            [label setText:tempString];

            [cell addSubview:label];
            y += 20;
        }
    }
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [_delegate showTransitRoute:indexPath.row];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event//it will not be called if three buttons click.
//{
//    [_delegate showTransitRoute:-1];
//}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    DDLogDebug(@"pointInside");
    if (CGRectContainsPoint(_table.frame, point) == NO) {
        [self removeFromSuperview];
        [_delegate showTransitRoute:-1];
    }
    return YES;
}

@end
