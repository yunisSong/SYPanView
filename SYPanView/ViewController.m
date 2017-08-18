//
//  ViewController.m
//  SYPanView
//
//  Created by Yunis on 2017/8/18.
//  Copyright © 2017年 Yunis. All rights reserved.
//

#import "ViewController.h"
#import "SYPaneView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    SYPaneView *pan = [[SYPaneView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 220)];
    
    pan.backgroundColor = [UIColor colorWithRed:0.992 green:0.561 blue:0.145 alpha:1.00];
    pan.allTaskCount = 100;
    pan.todoTask = 50;
    
    [self.view addSubview:pan];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        pan.allTaskCount = 100;
        pan.todoTask = 20;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        pan.allTaskCount = 100;
        pan.todoTask = 80;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        pan.allTaskCount = 100;
        pan.todoTask = 40;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        pan.allTaskCount = 0;
        pan.todoTask = 0;
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
