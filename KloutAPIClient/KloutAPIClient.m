//
//  KloutAPIClient.m
//  KloutAPIClientDemo
//
//  Created by shuichi on 9/7/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "KloutAPIClient.h"
#import "AFJSONRequestOperation.h"


#define API_BASE_URL      @"http://api.klout.com/v2/"


@interface KloutAPIClient ()
@property (nonatomic) NSString *APIKey;
@end


@implementation KloutAPIClient

+ (KloutAPIClient *)sharedClient
{
    static KloutAPIClient *sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[KloutAPIClient alloc] initWithBaseURL:[NSURL URLWithString:API_BASE_URL]];
    });
    
    return sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url]) {
        
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setParameterEncoding:AFJSONParameterEncoding];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return self;
}


// =============================================================================
#pragma mark - Private

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters
{
    NSAssert(self.APIKey, @"API Key has not been set.\n\n");
    
    path = [path stringByAppendingFormat:@"?key=%@", self.APIKey];
    
    if ([parameters count]) {
        
        for (NSString *key in [parameters keyEnumerator]) {
            
            NSString *value = [NSString stringWithFormat:@"%@",
                               [parameters valueForKey:key]];
            
            NSAssert2([key length] && [value length],
                      @"invalid param! key:%@: value:%@", key, value);
            
            path = [path stringByAppendingFormat:@"&%@=%@", key, value];
        }
    }
    
    NSMutableURLRequest *req = [super requestWithMethod:method
                                                   path:path
                                             parameters:nil];
    
    return req;
}

- (void)kloutIdWithTwitterScreenName:(NSString *)screenName
                             handler:(void (^)(NSDictionary *result, NSError *error))handler
{
    NSAssert([screenName length], @"screenName is required");
    
    __weak KloutAPIClient *weakSelf = self;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        NSString *path = @"identity.json/twitter";
        NSDictionary *params = @{@"screenName": screenName};
        
        [weakSelf getPath:path
               parameters:params
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          handler(responseObject, nil);
                      });
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          handler(nil, error);
                      });
                  }];
    });
}

- (void)scoreWithKloutId:(NSString *)kloutId
                 handler:(void (^)(NSDictionary *result, NSError *error))handler
{
    NSAssert([kloutId length], @"kloutId is required");
    
    __weak KloutAPIClient *weakSelf = self;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        NSString *path = [NSString stringWithFormat:@"user.json/%@", kloutId];
        
        [weakSelf getPath:path
               parameters:nil
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          handler(responseObject, nil);
                      });
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          handler(nil, error);
                      });
                  }];
    });
}


// =============================================================================
#pragma mark - Public

+ (void)setAPIKey:(NSString *)APIKey {
    
    [[KloutAPIClient sharedClient] setAPIKey:APIKey];
}

+ (void)kloutIdWithTwitterScreenName:(NSString *)screenName
                             handler:(void (^)(NSDictionary *result, NSError *error))handler
{
    [[KloutAPIClient sharedClient] kloutIdWithTwitterScreenName:screenName
                                                        handler:handler];
}

+ (void)scoreWithKloutId:(NSString *)kloutId
                 handler:(void (^)(NSDictionary *result, NSError *error))handler
{
    [[KloutAPIClient sharedClient] scoreWithKloutId:kloutId
                                            handler:handler];
}

+ (void)scoreWithTwitterScreenName:(NSString *)screenName
                 handler:(void (^)(NSDictionary *result, NSError *error))handler
{
    [KloutAPIClient kloutIdWithTwitterScreenName:screenName
                                          handler:
     ^(NSDictionary *result, NSError *error) {
         
         if (error) {
             handler(nil, error);
             return;
         }
         
         NSString *identity = result[@"id"];
         
         [KloutAPIClient scoreWithKloutId:identity
                                  handler:
          ^(NSDictionary *result, NSError *error) {
              
              handler(result, error);
          }];
     }];
}

+ (CGFloat)scoreFromScoreResult:(NSDictionary *)scoreResult
{
    NSDictionary *scoreDic = scoreResult[@"score"];
    NSString *scoreStr = scoreDic[@"score"];

    return [scoreStr floatValue];
}

@end
