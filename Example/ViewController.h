//
//  ViewController.h
//  Example
//
//  Created by Makoto Mitsui on 2013/06/04.
//  Copyright (c) 2013年 Makoto Mitsui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableViewCell *paymentCell;

@end
