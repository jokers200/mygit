//
//  ViewController.m
//  RoundPanel
//
//  Created by LiuGang on 16/3/10.
//  Copyright © 2016年 test. All rights reserved.
//

#import "ViewController.h"
#import "DrawView.h"

@interface ViewController ()
@property (nonatomic, strong) DrawView* drawView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.drawView = [[DrawView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.drawView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
