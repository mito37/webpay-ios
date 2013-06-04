//
//  WebPaymentViewController.m
//  WebPay
//
//  Created by Makoto Mitsui on 2013/06/01.
//  Copyright (c) 2013年 Makoto Mitsui. All rights reserved.
//

#import "WebPaymentViewController.h"
#import "MBProgressHUD.h"
#define WEBPAY_PUBLISHABLE_KEY @"test_public_aKh1UXbIUbLl1ZodCN5PH1vl"

@interface WebPaymentViewController ()
- (void)hasError:(NSError *)error;
- (void)hasToken:(STPToken *)token;
@end

@implementation WebPaymentViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Add Card";
    
    // Setup save button
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:0 target:self action:@selector(save:)];
    saveButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = saveButton;
    
    // Setup checkout
    self.checkoutView = [[WebPayView alloc] initWithFrame:CGRectMake(15,20,290,55) andKey:WEBPAY_PUBLISHABLE_KEY];
    self.checkoutView.delegate = self;
    
    self.signatureText = [[UITextField alloc] initWithFrame:CGRectMake(15, 90, 290, 30)];
    [self.signatureText setBorderStyle:UITextBorderStyleRoundedRect];
    [self.signatureText setPlaceholder:@"Your Signature"];
    [self.signatureText setFont:[UIFont fontWithName:@"Helvetica" size:16.0f]];
    [self.view addSubview:self.signatureText];
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.checkoutView];
}
- (void)stripeView:(STPView *)view withCard:(PKCard *)card isValid:(BOOL)valid
{
    // Enable save button if the Checkout is valid
    self.navigationItem.rightBarButtonItem.enabled = valid;
}

- (IBAction)save:(id)sender
{
    [self.checkoutView createToken:self.signatureText.text withComplete:^(STPToken *token, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (error) {
            [self hasError:error];
        } else {
            [self hasToken:token];
        }
    }];
}

- (void)hasError:(NSError *)error
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}

- (void)hasToken:(STPToken *)token
{
    NSLog(@"Received token %@", token.tokenId);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://example.com"]];
    request.HTTPMethod = @"POST";
    NSString *body     = [NSString stringWithFormat:@"stripeToken=%@", token.tokenId];
    request.HTTPBody   = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                               
                               //                               if (error) {
                               //                                   [self hasError:error];
                               //                               } else {
                               [self.navigationController popViewControllerAnimated:YES];
                               //                               }
                           }];
}

@end
