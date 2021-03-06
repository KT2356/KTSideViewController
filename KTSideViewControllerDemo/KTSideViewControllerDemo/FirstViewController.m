//
//  FirstViewController.m
//  KTSideViewControllerDemo
//
//  Created by KT on 15/12/11.
//  Copyright © 2015年 KT. All rights reserved.
//

#import "FirstViewController.h"
#import "KTSideViewController.h"

@interface FirstViewController ()
- (IBAction)btnAction:(id)sender;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    UITapGestureRecognizer *tapp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapped)];
    [self.headerView addGestureRecognizer:tapp];
}

- (void)handleTapped {
    [self.delegate showBackViewController];
}


- (IBAction)btnAction:(id)sender {
    NSLog(@"first page button");
}
@end
