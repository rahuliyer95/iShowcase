//
//  iShowcaseExampleViewController.m
//  iShowcaseExample
//
//  Created by Rahul Iyer on 20/06/14.
//  Copyright (c) 2015 rahuliyer95. All rights reserved.
//

#import "iShowcaseViewController.h"

@interface iShowcaseViewController ()

@property(nonatomic) iShowcase *showcase;
@property(nonatomic) NSArray *tableData;
@end

@implementation iShowcaseViewController

@synthesize tv_backgroundColor;
@synthesize tv_detailsColor;
@synthesize tv_titleColor;
@synthesize tv_highlightColor;
@synthesize btn_custom;
@synthesize btn_default;
@synthesize btn_multiple;
@synthesize btn_table;
@synthesize tableView;
@synthesize tableData;
@synthesize barButton;

@synthesize showcase;

bool multiple = false;
bool custom = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    tableData = [NSArray arrayWithObjects:@"Item 1", @"Item 2", @"Item 3",
                                          @"Item 4", @"Item 5", nil];
    tv_backgroundColor.delegate = self;
    tv_detailsColor.delegate = self;
    tv_titleColor.delegate = self;
    tv_highlightColor.delegate = self;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self setupShowcase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupShowcase {
    showcase = [[iShowcase alloc] init];
    showcase.delegate = self;
}

- (IBAction)custom:(id)sender {
    iShowcase *test = [[iShowcase alloc] init];
    if ([[tv_backgroundColor text] length] > 0) {
        [test setBackgroundColor:
                  [iShowcase colorFromHexString:[tv_backgroundColor text]]];
    }

    if ([[tv_titleColor text] length] > 0) {
        [test
            setTitleColor:[iShowcase colorFromHexString:[tv_titleColor text]]];
    }

    if ([[tv_detailsColor text] length] > 0) {
        [test setDetailsColor:[iShowcase
                                  colorFromHexString:[tv_detailsColor text]]];
    }

    if ([[tv_highlightColor text] length] > 0) {
        [test
            setHighlightColor:[iShowcase
                                  colorFromHexString:[tv_highlightColor text]]];
    }

    custom = true;
    [test setIType:TYPE_CIRCLE];
    [test setupShowcaseForView:btn_custom
                     withTitle:@"Custom"
                       details:@"This is custom iShowcase"];

    // Will be shown only once
    // Comment this to show the showcase after 1st run
    [test setSingleShotId:47];
    [test show];
}

- (IBAction)defaultShowcase:(id)sender {
    [showcase setupShowcaseForView:btn_default
                         withTitle:@"Default"
                           details:@"This is Default iShowcase"];
    [showcase show];
}

- (IBAction)multiple:(id)sender {
    multiple = true;
    [self defaultShowcase:nil];
}

- (IBAction)table:(id)sender {
    [showcase setupShowcaseForTableView:tableView
                        withIndexOfItem:1
                          sectionOfItem:0
                                  title:@"UITableView"
                                details:@"This is Custom Position Example"];
    [showcase show];
}

- (IBAction)barButtonExample:(id)sender {
    [showcase setupShowcaseForBarButtonItem:barButton
                                  withTitle:@"Bar Button Example"
                                    details:@"This example highlights the "
                                    @"UIBarButtonItem"];
    [showcase show];
}

#pragma mark iShowcase delegate

- (void)iShowcaseShown:(iShowcase *)showcase {
    // Method called when iShowcase is shown
}

- (void)iShowcaseDismissed:(iShowcase *)showcase2 {
    if (multiple) {
        [showcase setupShowcaseForView:btn_multiple
                             withTitle:@"Multiple"
                               details:@"This is Multiple iShowcase"];
        [showcase show];
        multiple = false;
    }

    if (custom) {
        showcase2 = nil;
        custom = false;
    }
}

#pragma mark UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
    if ([textField.text length] + [string length] - range.length >= 7)
        return NO;
    else {
        for (int i = 0; i < textField.text.length; i++) {
            unichar c = [textField.text characterAtIndex:i];
            if (![[NSCharacterSet alphanumericCharacterSet]
                    characterIsMember:c]) {
                textField.text = [textField.text
                    stringByTrimmingCharactersInSet:
                        [NSCharacterSet
                            characterSetWithCharactersInString:
                                [NSString stringWithFormat:
                                              @"%c", [textField.text
                                                         characterAtIndex:i]]]];
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";

    UITableViewCell *cell = [self.tableView
        dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell =
            [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:simpleTableIdentifier];
    }

    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}

@end
