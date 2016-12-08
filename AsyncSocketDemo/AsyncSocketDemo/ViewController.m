//
//  ViewController.m
//  AsyncSocketDemo
//
//  Created by lixiaohu on 16/12/8.
//  Copyright © 2016年 lixiaohu. All rights reserved.
//

#import "ViewController.h"
#import "ServerViewController.h"
#import "ClientViewController.h"
#import "STConfig.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *serverView;

@property (weak, nonatomic) IBOutlet UIView *clientView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ClientViewController *clinetVC = [[ClientViewController alloc] init];
    ServerViewController *serverVC = [[ServerViewController alloc] init];
    
    UIView *c = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2)];
    c.backgroundColor = [UIColor greenColor];
    [self.view addSubview:c];
    
    [c addSubview:clinetVC.view];
    self.clientView = clinetVC.view;
    
    NSString *address = [STConfig getIPAddress];
    NSLog(@"%@", address);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
