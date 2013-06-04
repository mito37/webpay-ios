//
//  ViewController.m
//  Example
//
//  Created by Makoto Mitsui on 2013/06/04.
//  Copyright (c) 2013年 Makoto Mitsui. All rights reserved.
//

#import "ViewController.h"
#import "WebPaymentViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"WebpPayExample";
}

- (void)changeCard
{
    WebPaymentViewController *viewController = [[WebPaymentViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) return self.paymentCell;
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isEqual:self.paymentCell]) [self changeCard];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
