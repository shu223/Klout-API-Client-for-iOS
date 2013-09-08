//
//  ViewController.m
//  KloutAPIClientDemo
//
//  Created by shuichi on 9/7/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "ViewController.h"
#import "KloutAPIClient.h"
#import "SVProgressHUD.h"


@interface ViewController ()
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [KloutAPIClient scoreWithTwitterScreenName:@"shu223"
                                       handler:
     ^(NSDictionary *result, NSError *error) {
         
         if (error) {
             
             [SVProgressHUD showErrorWithStatus:error.localizedDescription];
         }
         else {

             NSLog(@"result:%@", result);
             
             CGFloat score = [KloutAPIClient scoreFromScoreResult:result];
             
             NSLog(@"score:%f", score);
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
