//
//  KloutAPIClient.h
//  KloutAPIClientDemo
//
//  Created by shuichi on 9/7/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "AFHTTPClient.h"

@interface KloutAPIClient : AFHTTPClient

+ (void)setAPIKey:(NSString *)APIKey;

+ (void)kloutIdWithTwitterScreenName:(NSString *)screenName
                              handler:(void (^)(NSDictionary *result, NSError *error))handler;

+ (void)scoreWithKloutId:(NSString *)kloutId
                 handler:(void (^)(NSDictionary *result, NSError *error))handler;

+ (void)scoreWithTwitterScreenName:(NSString *)screenName
                           handler:(void (^)(NSDictionary *result, NSError *error))handler;

+ (CGFloat)scoreFromScoreResult:(NSDictionary *)scoreResult;

@end
