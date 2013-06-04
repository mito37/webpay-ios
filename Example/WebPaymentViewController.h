//
//  WebPaymentViewController.h
//  WebPay
//
//  Created by Makoto Mitsui on 2013/06/01.
//  Copyright (c) 2013年 Makoto Mitsui. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "WebPayView.h"

@interface WebPaymentViewController : UIViewController <STPViewDelegate>

@property WebPayView *checkoutView;
@property UITextField *signatureText;

- (void)save:(id)sender;

@end
