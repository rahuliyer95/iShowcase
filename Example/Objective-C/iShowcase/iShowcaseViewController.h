//
//  iShowcaseExampleViewController.h
//  iShowcaseExample
//
//  Created by Rahul Iyer on 20/06/14.
//  Copyright (c) 2015 rahuliyer95. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iShowcase.h"

@interface iShowcaseViewController
    : UIViewController <UITextFieldDelegate, UITableViewDataSource,
                        UITableViewDelegate, iShowcaseDelegate>

@property(weak, nonatomic) IBOutlet UITextField *tv_backgroundColor;
@property(weak, nonatomic) IBOutlet UITextField *tv_titleColor;
@property(weak, nonatomic) IBOutlet UITextField *tv_detailsColor;
@property(weak, nonatomic) IBOutlet UITextField *tv_highlightColor;

@property(weak, nonatomic) IBOutlet UIButton *btn_default;
@property(weak, nonatomic) IBOutlet UIButton *btn_multiple;
@property(weak, nonatomic) IBOutlet UIButton *btn_table;
@property(weak, nonatomic) IBOutlet UIButton *btn_custom;

@property(strong, nonatomic) IBOutlet UITableView *tableView;

@property(weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

@end
