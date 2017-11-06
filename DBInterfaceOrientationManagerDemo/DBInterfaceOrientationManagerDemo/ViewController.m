//
//  ViewController.m
//  DBInterfaceOrientationManagerDemo
//
//  Created by 徐梦童 on 2017/11/7.
//  Copyright © 2017年 徐梦童. All rights reserved.
//

#import "ViewController.h"
#import "DBInterfaceOrientationManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    switchButton.frame = CGRectMake(100, 100, 150, 50);
    switchButton.backgroundColor = [UIColor blackColor];
    [switchButton setTitle:@"我不可以转屏" forState:UIControlStateNormal];
    [switchButton setTitle:@"我可以转屏" forState:UIControlStateSelected];
    [self.view addSubview:switchButton];
    
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *rotateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rotateButton.frame = CGRectMake(100, 300, 150, 50);
    rotateButton.backgroundColor = [UIColor blackColor];
    [rotateButton setTitle:@"强制恢复竖屏" forState:UIControlStateNormal];
    [self.view addSubview:rotateButton];
    
    [rotateButton addTarget:self action:@selector(rotateAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)switchAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    [DBInterfaceOrientationManager allowRotation:sender.selected];
}

- (void)rotateAction:(UIButton *)sender{
    [DBInterfaceOrientationManager forceInterfaceOrientation:UIInterfaceOrientationPortrait];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
