//
//  WebPayView.h
//  Stripe
//
//  Created by Makoto Mitsui on 2013/06/01.
//
//

#import <Foundation/Foundation.h>
#import "STPView.h"
#import "WebPay.h"

@interface WebPayView : STPView

@property (readonly) BOOL pending;
- (void)createToken:(NSString *)signature withComplete:(STPTokenBlock)block;

@end
