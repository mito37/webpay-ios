//
//  WebPay.m
//  WebPay
//
//  Created by Makoto Mitsui on 2013/06/03.
//  Copyright (c) 2013年 Makoto Mitsui. All rights reserved.
//

#import "WebPay.h"

@interface WebPay()
+ (NSString *)URLEncodedString:(NSString *)string;
+ (NSString *)camelCaseFromUnderscoredString:(NSString *)string;
+ (NSDictionary *)requestPropertiesFromCard:(STPCard *)card;
+ (NSData *)formEncodedDataFromCard:(STPCard *)card;
+ (void)validateKey:(NSString *)publishableKey;
+ (NSError *)errorFromStripeResponse:(NSDictionary *)jsonDictionary;
+ (NSDictionary *)camelCasedResponseFromStripeResponse:(NSDictionary *)jsonDictionary;
+ (NSDictionary *)dictionaryFromJSONData:(NSData *)data error:(NSError **)outError;
+ (void)handleTokenResponse:(NSURLResponse *)response body:(NSData *)body error:(NSError *)requestError completion:(STPCompletionBlock)handler;
+ (NSURL *)apiURLWithPublishableKey:(NSString *)publishableKey;
@end

@implementation WebPay
static NSString * const apiURLBase = @"api.webpay.jp";
static NSString * const apiVersion = @"v1";
static NSString * const tokenEndpoint = @"tokens";
#pragma mark Private Helpers
+ (NSURL *)apiURLWithPublishableKey:(NSString *)publishableKey
{
    NSURL *url = [[[NSURL URLWithString:
                    [NSString stringWithFormat:@"https://%@:@%@", [self URLEncodedString:publishableKey], apiURLBase]]
                   URLByAppendingPathComponent:apiVersion]
                  URLByAppendingPathComponent:tokenEndpoint];
    return url;
}
+ (void)handleTokenResponse:(NSURLResponse *)response body:(NSData *)body error:(NSError *)requestError completion:(STPCompletionBlock)handler
{
    if (requestError)
    {
        // If this is an error that Stripe returned, let's handle it as a StripeDomain error
        NSDictionary *jsonDictionary = nil;
        if (body && (jsonDictionary = [self dictionaryFromJSONData:body error:nil]) && [jsonDictionary valueForKey:@"error"] != nil)
        {
            handler(nil, [self errorFromStripeResponse:jsonDictionary]);
        }
        // Otherwise, return the raw NSURLError error
        else
            handler(nil, requestError);
    }
    else
    {
        NSError *parseError;
        NSDictionary *jsonDictionary = [self dictionaryFromJSONData:body error:&parseError];
        
        if (jsonDictionary == nil)
            handler(nil, parseError);
        else if ([(NSHTTPURLResponse *)response statusCode] == 201)
            handler([[STPToken alloc] initWithAttributeDictionary:[self camelCasedResponseFromStripeResponse:jsonDictionary]], nil);
        else
            handler(nil, [self errorFromStripeResponse:jsonDictionary]);
    }
}

#pragma mark Public Interface
+ (void)createTokenWithCard:(STPCard *)card publishableKey:(NSString *)publishableKey operationQueue:(NSOperationQueue *)queue completion:(STPCompletionBlock)handler
{
    if (card == nil)
        [NSException raise:@"RequiredParameter" format:@"'card' is required to create a token"];
    
    if (handler == nil)
        [NSException raise:@"RequiredParameter" format:@"'handler' is required to use the token that is created"];
    
    [self validateKey:publishableKey];
    
    NSURL *url = [self apiURLWithPublishableKey:publishableKey];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:[NSString stringWithFormat:@"Bearer %@", publishableKey] forHTTPHeaderField:@"Authorization"];
    request.HTTPBody = [self formEncodedDataFromCard:card];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *body, NSError *requestError)
     {
         [self handleTokenResponse:response body:body error:requestError completion:handler];
     }];
}


+ (void)createTokenWithCard:(STPCard *)card publishableKey:(NSString *)publishableKey completion:(STPCompletionBlock)handler
{
    [self createTokenWithCard:card publishableKey:publishableKey operationQueue:[NSOperationQueue mainQueue] completion:handler];
}


@end
