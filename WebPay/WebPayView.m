//
//  WebPayView.m
//  Stripe
//
//  Created by Makoto Mitsui on 2013/06/01.
//
//

#import "WebPayView.h"

@implementation WebPayView

@synthesize pending;

- (void)createToken:(NSString *)signature withComplete:(STPTokenBlock)block
{
    if ( super.pending ) return;
    
    if ( ![self.paymentView isValid] ) {
        NSError* error = [[NSError alloc] initWithDomain:StripeDomain
                                                    code:STPCardError
                                                userInfo:@{NSLocalizedDescriptionKey: STPCardErrorUserMessage}];
        
        block(nil, error);
        return;
    }
    
    [self endEditing:YES];
    
    PKCard* card = self.paymentView.card;
    STPCard* scard = [[STPCard alloc] init];
    
    scard.number = card.number;
    scard.expMonth = card.expMonth;
    scard.expYear = card.expYear;
    scard.cvc = card.cvc;
    scard.name = signature;
    
    [self pendingHandler:YES];
    /*
    [Stripe createTokenWithCard:scard
                 publishableKey:self.key
                     completion:^(STPToken *token, NSError *error) {
                         [self pendingHandler:NO];
                         block(token, error);
                     }];
     */
    [WebPay createTokenWithCard:scard
                 publishableKey:self.key
                     completion:^(STPToken *token, NSError *error) {
                         [self pendingHandler:NO];
                         block(token, error);
                     }];
    
}

- (void)pendingHandler:(BOOL)isPending
{
    pending = isPending;
    self.userInteractionEnabled = !pending;
}

@end
