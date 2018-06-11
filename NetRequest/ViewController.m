//
//  ViewController.m
//  NetRequest
//
//  Created by Mac on 2018/4/9.
//  Copyright © 2018年 saint. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [SXNetworkManager sendRequestMethod:POST apiPath:@"api" parameters:@{} resultBlock:^(NSDictionary * _Nullable dict, NSString *errorStr) {
        if (!errorStr) {
            NSLog(@"\n");
        }else {
            NSLog(@"\n error = %@",errorStr);
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
