//
//  iShowcaseExampleViewController.m
//  iShowcaseExample
//
//  Created by Rahul Iyer on 20/06/14.
//  Copyright (c) 2014 rahuliyer95. All rights reserved.
//

#import "iShowcaseExampleViewController.h"

@interface iShowcaseExampleViewController ()

@property (nonatomic) iShowcase* showcase;
@property (nonatomic) NSArray* tableData;
@end

@implementation iShowcaseExampleViewController

@synthesize tv_backgroundColor;
@synthesize tv_detailsColor;
@synthesize tv_titleColor;
@synthesize btn_custom;
@synthesize btn_default;
@synthesize btn_multiple;
@synthesize btn_table;
@synthesize tableView;
@synthesize tableData;

@synthesize showcase;

bool multiple = false;
bool custom = false;

- (void)viewDidLoad
{
    [super viewDidLoad];
    tableData = [NSArray arrayWithObjects:@"Item 1", @"Item 2", @"Item 3", @"Item 4", nil];
    tv_backgroundColor.delegate = self;
    tv_detailsColor.delegate = self;
    tv_titleColor.delegate = self;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self setupShowcase];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) setupShowcase
{
    showcase = [[iShowcase alloc] init];
    showcase.delegate = self;
    [showcase setContainerView:self.view];
}

- (IBAction)custom:(id)sender
{
    if ([[tv_backgroundColor text] rangeOfString:@"#"].location != NSNotFound)
    {
        [showcase setBackgroundColor:[iShowcase colorFromHexString:[tv_backgroundColor text]]];
    }
    
    if ([[tv_titleColor text] rangeOfString:@"#"].location != NSNotFound)
    {
        [showcase setTitleColor:[iShowcase colorFromHexString:[tv_titleColor text]]];
    }
    
    if ([[tv_detailsColor text] rangeOfString:@"#"].location != NSNotFound)
    {
        [showcase setDetailsColor:[iShowcase colorFromHexString:[tv_detailsColor text]]];
    }
    
    custom = true;
    [showcase setupShowcaseForTarget:btn_custom title:@"Custom" details:@"This is custom iShowcase"];
    [showcase show];
}

- (IBAction)defaultShowcase:(id)sender
{
    [showcase setupShowcaseForTarget:btn_default title:@"Default" details:@"This is Default iShowcase"];
    [showcase show];
}

- (IBAction)multiple:(id)sender
{
    multiple = true;
    [self defaultShowcase:nil];
}

- (IBAction)table:(id)sender
{
    CGRect tableRow = [tableView convertRect:[tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] toView:[tableView superview]];
    [showcase setupShowcaseForLocation:tableRow title:@"UITableView" details:@"This is Custom Position Example"];
    [showcase show];
}

- (void) iShowcaseShown{}

- (void) iShowcaseDismissed
{
    if (multiple)
    {
        [showcase setupShowcaseForTarget:btn_multiple title:@"Multiple" details:@"This is Multiple iShowcase"];
        [showcase show];
        multiple = false;
    }
    
    if (custom)
    {
        showcase = nil;
        [self setupShowcase];
        custom = false;
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [textField.text length] + [string length] - range.length >= 8 ? NO : YES;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}

@end
