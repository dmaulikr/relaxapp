//
//  TimerView.m
//  RelaxApp
//
//  Created by JoJo on 9/30/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "TimerView.h"
#import "Define.h"
#import "TimerCell.h"
#import "CreaterTimer.h"
static NSString *identifierSection1 = @"MyTableViewCell1";

@implementation TimerView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.vContent.backgroundColor = UIColorFromRGB(COLOR_BACKGROUND_FAVORITE);
    self.vViewNav.backgroundColor = UIColorFromRGB(COLOR_NAVIGATION_FAVORITE);
    [self.tableControl registerNib:[UINib nibWithNibName:@"TimerCell" bundle:nil] forCellReuseIdentifier:identifierSection1];
    self.tableControl.estimatedRowHeight = 60;
    self.tableControl.allowsSelectionDuringEditing = YES;
    _dataSource = [NSMutableArray new];
    NSDictionary *dic = @{@"name": @"I think i'm sleeping",@"description": @"Countdown",@"timer": @"00 : 30"};
    NSDictionary *dic2 = @{@"name": @"Turn off phone and wake around",@"description": @"Timer",@"timer": @"19 : 30"};
    NSDictionary *dic3 = @{@"name": @"Now is baby's time",@"description": @"Timer/For my baby sleep",@"timer": @"20 : 30"};
    [_dataSource addObject:dic];
    [_dataSource addObject:dic2];
    [_dataSource addObject:dic3];


}
-(IBAction)addTimerAction:(id)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Choose Timer Type" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped do nothing.
        
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Countdown" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self createrTimerWithType:TIMER_COUNTDOWN];
    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Clock" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self createrTimerWithType:TIMER_CLOCK];
        
    }]];
    [self.parent presentViewController:actionSheet animated:YES completion:nil];
}
-(void)createrTimerWithType:(TIMER_TYPE)type
{
    CreaterTimer *viewController1 = [[CreaterTimer alloc] initWithNibName:@"CreaterTimer" bundle:nil];
    [self.parent presentViewController:viewController1 animated:YES completion:nil];

}
-(IBAction)editingTableViewAction:(id)sender
{
    [self.tableControl setEditing: !self.tableControl.editing animated: YES];
}
//section Mes...Mes_groupes
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TimerCell *cell = nil;
    
    cell = (TimerCell *)[self.tableControl dequeueReusableCellWithIdentifier:identifierSection1 forIndexPath:indexPath];
    
    NSDictionary *dic = _dataSource[indexPath.row];
    cell.lbNameTimer.text = dic[@"name"];
    cell.lbValueTimer.text = dic[@"timer"];
    cell.lbDescription.text = dic[@"description"];
//
//    [cell fnSetDataWithDicMusic:dicMusic];
//    cell.btnSelect.tag=indexPath.row;
//    [cell.btnSelect addTarget:self action:@selector(selectCell:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.backgroundColor=[UIColor clearColor];
    cell.tintColor = [UIColor blueColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [_dataSource removeObjectAtIndex:indexPath.row];
        [self.tableControl reloadData];
    }
}
@end
