//
//  ViewController.h
//  hackPrincton
//
//  Created by Robert mannuzza on 11/8/13.
//  Copyright (c) 2013 Robert mannuzza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

-(IBAction)doneButtonPressed:(id)sender;
-(IBAction)sliderDidChange:(id)sender;
-(IBAction)switchChanged:(id)sender;
@property (strong,nonatomic) UIColor *imagecolor;
@property (strong,nonatomic) IBOutlet UITableView *tableView;
@end
