//
//  ViewController.m
//  教授播放器
//
//  Created by 董招兵 on 16/7/3.
//  Copyright © 2016年 上海触影文化传播有限公司. All rights reserved.
//

#import "ViewController.h"
#import "CYMovieViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playButtonClick:(id)sender {
    
    [self presentViewController:[[CYMovieViewController alloc] init] animated:YES completion:nil];
    
}
@end
